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
        def initialize(pricing_rule)
            /^\s*(\w+)\s+(\d+)(?:\s+(.+))?$/ =~ pricing_rule
            @name = $1
            @unit_price = $2.to_i
            @special_prices = Hash[*(($3 || '').split(/\s*,\s*/).map { |rule| /(\d+)\s*for\s*(\d+)/ =~ rule; [$1, $2] }.flatten(1))]
        end

        def to_s
            [@name, @unit_price, @special_prices].to_s
        end

        def inspect
            [@name, @unit_price, @special_prices].to_s
        end
    end

    def initialize(pricing_rules)
        @rules = parse_rules(pricing_rules)
        p @rules
    end

    def scan(item)
    end

    def total
    end

    private

    def parse_rules(pricing_rules)
        pricing_rules.each_line.map { |rule| PricingRule.new(rule) }
    end
end
