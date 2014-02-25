class CashRegister
  attr_reader :coins

  def coins=(coins=[25,10,5,1])
    if (
        coins.class != Array ||
        coins.map { |coin| coin.class.ancestors.include?(Integer) }.include?(false)
      )
      raise Exception
    end

    @optimal_change = Hash.new do |hash, key|
      hash[key] =
        if (key < coins.min)
          Change.new(coins)
        elsif (coins.include?(key))
          Change.new(coins).add(key)
        else
          coins.map do |coin|
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
      self.merge!({coin => 0})
    end
  end

  def add(coin)
    self.merge({coin => self[coin] + 1})
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
