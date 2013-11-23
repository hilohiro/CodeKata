=begin
# Kata Nine: Back to the CheckOut

Back to the supermarket. This week, we’ll implement the code for a checkout system that handles pricing schemes such as "apples cost 50 cents, three apples cost $1.30."

Way back in KataOne we thought about how to model the various options for supermarket pricing. We looked at things such as "three for a dollar," "$1.99 per pound," and "buy two, get one free."

This week, let’s implement the code for a supermarket checkout that calculates the total price of a number of items. In a normal supermarket, things are identified using Stock Keeping Units, or SKUs. In our store, we’ll use individual letters of the alphabet (A, B, C, and so on). Our goods are priced individually. In addition, some items are multipriced: buy n of them, and they’ll cost you y cents. For example, item ‘A’ might cost 50 cents individually, but this week we have a special offer: buy three ‘A’s and they’ll cost you $1.30. In fact this week’s prices are:

  Item   Unit      Special
         Price     Price
  --------------------------
    A     50       3 for 130
    B     30       2 for 45
    C     20
    D     15
Our checkout accepts items in any order, so that if we scan a B, an A, and another B, we’ll recognize the two B’s and price them at 45 (for a total price so far of 95). Because the pricing changes frequently, we need to be able to pass in a set of pricing rules each time we start handling a checkout transaction.

The interface to the checkout should look like:

   co = CheckOut.new(pricing_rules)
   co.scan(item)
   co.scan(item)
       :    :
   price = co.total
Here’s a set of unit tests for a Ruby implementation. The helper method price lets you specify a sequence of items using a string, calling the checkout’s scan method on each item in turn before finally returning the total price.

=end

class CheckOut
    class PricingRule
        attr_reader :name, :unit_price

        def initialize(pricing_rule)
            raise ArgumentError.new("There are neither item name nor unit price.") unless /^\s*(\w+)\s+(\d+)(?:\s+(.+))?$/ =~ pricing_rule
            @name = $1
            @unit_price = $2.to_i
            @special_prices = Hash[*(($3 || '').split(/\s*,\s*/).map { |rule| /(\d+)\s*for\s*(\d+)/ =~ rule; [$1.to_i, $2.to_i] }.flatten(1))]
            @special_units = @special_prices.keys.sort {|a, b| b <=> a}
        end

        def to_s
            inspect.to_s
        end

        def inspect
            [@name, @unit_price, @special_prices, @special_units]
        end

        def price(count)
            discounted = @special_units.find {|size| count >= size}
            discounted.nil? ? @unit_price * count : @special_prices[discounted] + price(count - discounted)
        end

    end

    def initialize(pricing_rules)
        @rules = Hash[*(parse_rules(pricing_rules).map {|rule| [rule.name, rule]}.flatten(1))]
        @items = Hash.new(0)
    end

    def inspect
        @rules.values.map(&:inspect)
    end

    def scan(item)
        raise ArgumentError.new("There is no rule for item \"#{item}\".") unless @rules.has_key?(item)
        @items[item] += 1
    end

    def total
        @items.map {|item, count| @rules[item].price(count)}.inject(0, &:+)
    end

    private

    def parse_rules(pricing_rules)
        pricing_rules.each_line.map { |rule| PricingRule.new(rule) }
    end
end
