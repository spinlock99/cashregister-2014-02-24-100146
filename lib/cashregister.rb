class CashRegister
  attr_reader :coins

  def coins=(coins=[25,10,5,1])
    raise Exception if coins.class != Array
    raise Exception if coins.map { |coin| coin.class.ancestors.include?(Integer) }.include?(false)

    @optimal_change = Hash.new do |hash, key|
      if (key < coins.min)
        hash[key] = Change.new(@coins)
      elsif (coins.include?(key))
        hash[key] = Change.new(@coins).add(key)
      else
        hash[key] = coins.map do |coin|
          hash[key - coin].add(coin)
        end.reject do |change|
          change.value != key
        end.min { |a,b| a.count <=> b.count }
      end
    end

    @coins = coins
  end

  alias :initialize :coins=

  def make_change(amount)
    return(@optimal_change[amount])
  end
end

class Change < Hash
  def initialize(coins)
    coins.map do |coin|
      self.merge!({coin.to_s => 0})
    end
  end

  def add(coin)
    self.merge({coin.to_s => self[coin.to_s] + 1})
  end

  def value
    self.map do |key, value|
      key.to_i * value
    end.reduce(:+)
  end

  def count
    self.values.reduce(:+)
  end
end
