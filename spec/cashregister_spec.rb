require 'spec_helper'
require 'cashregister'

describe CashRegister do
  describe "#new" do
    subject(:cash_register) { CashRegister.new }
    let(:bad_argument) { 'A' }
    let(:bad_array_argument) { [10, 5, 'A', 'B', 'C'] }

    it "should instantiate" do
      expect { CashRegister.new }.to_not raise_exception
    end
    it 'should default to 25,10,5,1' do
      CashRegister.new.coins.should eq([25,10,5,1])
    end
    it 'should reset the coins without reinitialization' do
      cash_register = CashRegister.new
      cash_register.coins = [10,5]
      cash_register.coins.should eq([10,5])
    end
    it 'should take an Array of Integers as an argument' do
      expect { CashRegister.new([25,10,5,1]) }.to_not raise_exception
    end
    it 'should throw an error with a bad argument' do
      expect { CashRegister.new(bad_argument) }.to raise_exception
    end
    it 'should throw an error with a bad array argument' do
      expect { CashRegister.new(bad_array_argument) }.to raise_exception
    end
  end

  describe '.make_change()' do
    subject(:make_change) { cash_register.make_change(amount) }
    let(:cash_register) { CashRegister.new(coins) }
    let(:coins) { [25,10,5,1] }
    let(:amount) { 123 }

    it { should eq({'25' => 4, '10' => 2, '5' => 0, '1' => 3}) }

    context 'crazy foreign coins' do
      let(:coins) { [10,7,1] }
      let(:amount) { 14 }

      it { should eq({'10' => 0, '7' => 2, '1' => 0}) }
    end

    context 'memoized zero case' do
      let(:amount) { 0 }

      it { should eq({'25' => 0, '10' => 0, '5' => 0, '1' => 0}) }
    end

    context 'memoized base case' do
      let(:amount) { 5 }

      it { should eq({'25' => 0, '10' => 0, '5' => 1, '1' => 0}) }
    end
    context 'memoized base case' do
      let(:amount) { 6 }

      it { should eq({'25' => 0, '10' => 0, '5' => 1, '1' => 1}) }
    end
 end
end

describe Change do
  subject!(:change) { Change.new(coins) }
  let(:coins) { [25,10,5,1] }

  describe '#new' do

    it 'should instantiate' do
      expect { change }.to_not raise_exception
    end
    it { should eq({'25' => 0, '10' => 0, '5' => 0, '1' => 0}) }
  end

  describe '.add' do
    it 'adds coins to the Hash' do
      change.add(25).should eq({'25' => 1, '10' => 0, '5' => 0, '1' => 0})
    end
  end

  describe '.value' do
    its(:value) { should eq(0) }

    it 'is 25 when there is one quarter' do
      change.add(25).value.should eq(25)
    end
  end

  describe '.count' do
    its(:count) { should eq(0) }

    it 'counts the number of coins' do
      change.add(25).count.should eq(1)
      change.add(25).add(10).count.should eq(2)
    end
  end
end
