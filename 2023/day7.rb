=begin # rubocop:disable Style/BlockComments
--- Day 7: Camel Cards ---
Your all-expenses-paid trip turns out to be a one-way, five-minute ride in an airship. (At least it's a cool airship!) It drops you off at the edge of a vast desert and descends back to Island Island.

"Did you bring the parts?"

You turn around to see an Elf completely covered in white clothing, wearing goggles, and riding a large camel.

"Did you bring the parts?" she asks again, louder this time. You aren't sure what parts she's looking for; you're here to figure out why the sand stopped.

"The parts! For the sand, yes! Come with me; I will show you." She beckons you onto the camel.

After riding a bit across the sands of Desert Island, you can see what look like very large rocks covering half of the horizon. The Elf explains that the rocks are all along the part of Desert Island that is directly above Island Island, making it hard to even get there. Normally, they use big machines to move the rocks and filter the sand, but the machines have broken down because Desert Island recently stopped receiving the parts they need to fix the machines.

You've already assumed it'll be your job to figure out why the parts stopped when she asks if you can help. You agree automatically.

Because the journey will take a few days, she offers to teach you the game of Camel Cards. Camel Cards is sort of similar to poker except it's designed to be easier to play while riding a camel.

In Camel Cards, you get a list of hands, and your goal is to order them based on the strength of each hand. A hand consists of five cards labeled one of A, K, Q, J, T, 9, 8, 7, 6, 5, 4, 3, or 2. The relative strength of each card follows this order, where A is the highest and 2 is the lowest.

Every hand is exactly one type. From strongest to weakest, they are:

Five of a kind, where all five cards have the same label: AAAAA
Four of a kind, where four cards have the same label and one card has a different label: AA8AA
Full house, where three cards have the same label, and the remaining two cards share a different label: 23332
Three of a kind, where three cards have the same label, and the remaining two cards are each different from any other card in the hand: TTT98
Two pair, where two cards share one label, two other cards share a second label, and the remaining card has a third label: 23432
One pair, where two cards share one label, and the other three cards have a different label from the pair and each other: A23A4
High card, where all cards' labels are distinct: 23456

Hands are primarily ordered based on type; for example, every full house is stronger than any three of a kind.

If two hands have the same type, a second ordering rule takes effect. Start by comparing the first card in each hand. If these cards are different, the hand with the stronger first card is considered stronger. If the first card in each hand have the same label, however, then move on to considering the second card in each hand. If they differ, the hand with the higher second card wins; otherwise, continue with the third card in each hand, then the fourth, then the fifth.

So, 33332 and 2AAAA are both four of a kind hands, but 33332 is stronger because its first card is stronger. Similarly, 77888 and 77788 are both a full house, but 77888 is stronger because its third card is stronger (and both hands have the same first and second card).

To play Camel Cards, you are given a list of hands and their corresponding bid (your puzzle input). For example:

32T3K 765
T55J5 684
KK677 28
KTJJT 220
QQQJA 483
This example shows five hands; each hand is followed by its bid amount. Each hand wins an amount equal to its bid multiplied by its rank, where the weakest hand gets rank 1, the second-weakest hand gets rank 2, and so on up to the strongest hand. Because there are five hands in this example, the strongest hand will have rank 5 and its bid will be multiplied by 5.

So, the first step is to put the hands in order of strength:

32T3K is the only one pair and the other hands are all a stronger type, so it gets rank 1.
KK677 and KTJJT are both two pair. Their first cards both have the same label, but the second card of KK677 is stronger (K vs T), so KTJJT gets rank 2 and KK677 gets rank 3.
T55J5 and QQQJA are both three of a kind. QQQJA has a stronger first card, so it gets rank 5 and T55J5 gets rank 4.
Now, you can determine the total winnings of this set of hands by adding up the result of multiplying each hand's bid with its rank (765 * 1 + 220 * 2 + 28 * 3 + 684 * 4 + 483 * 5). So the total winnings in this example are 6440.

Find the rank of every hand in your set. What are the total winnings?

--- Part Two ---
To make things a little more interesting, the Elf introduces one additional rule. Now, J cards are jokers - wildcards that can act like whatever card would make the hand the strongest type possible.

To balance this, J cards are now the weakest individual cards, weaker even than 2. The other cards stay in the same order: A, K, Q, T, 9, 8, 7, 6, 5, 4, 3, 2, J.

J cards can pretend to be whatever card is best for the purpose of determining hand type; for example, QJJQ2 is now considered four of a kind. However, for the purpose of breaking ties between two hands of the same type, J is always treated as J, not the card it's pretending to be: JKKK2 is weaker than QQQQ2 because J is weaker than Q.

Now, the above example goes very differently:

32T3K 765
T55J5 684
KK677 28
KTJJT 220
QQQJA 483

32T3K is still the only one pair; it doesn't contain any jokers, so its strength doesn't increase.
KK677 is now the only two pair, making it the second-weakest hand.
T55J5, KTJJT, and QQQJA are now all four of a kind! T55J5 gets rank 3, QQQJA gets rank 4, and KTJJT gets rank 5.
With the new joker rule, the total winnings in this example are 5905.

Using the new joker rule, find the rank of every hand in your set. What are the new total winnings?

=end

module Day7
  HandType = Struct.new(:value, :name, :rule) do
    def matches?(hand)
      rule.call(hand)
    end
  end

  RULE_ORDER = [Five, Four, Full, Three, TwoPairs, Pair, HighCard].freeze

  # PART 1
  #
  # Five = HandType.new(7000000, 'Five', proc { |hand| hand.counts.any? { |_, count| count == 5 } })
  # Four = HandType.new(6000000, 'Four', proc { |hand| hand.counts.any? { |_, count| count == 4 } })
  # Full = HandType.new(5000000, 'Full', proc { |hand| hand.counts.any? { |_, count| count == 3 } && hand.counts.any? { |_, count| count == 2 } })
  # Three = HandType.new(4000000, 'Three', proc { |hand| hand.counts.any? { |_, count| count == 3 } })
  # TwoPairs = HandType.new(3000000, 'Two pairs', proc { |hand| hand.counts.select { |_, count| count == 2 }.size == 2 })
  # Pair = HandType.new(2000000, 'Pair', proc { |hand| hand.counts.any? { |_, count| count == 2 } })
  # HighCard = HandType.new(1000000, 'High card', proc { |hand| hand.counts.all? { |_, count| count == 1 } })
  #
  # CARD_VALUES = {
  #   'A' => 14,
  #   'K' => 13,
  #   'Q' => 12,
  #   'J' => 11,
  #   'T' => 10
  # }.freeze

  # PART 2
  Five = HandType.new(7000000, 'Five', proc { |hand| hand.counts.any? { |_, count| count == 5 } })
  Four = HandType.new(6000000, 'Four', proc { |hand| hand.counts_without_jokers.any? { |_, count| count == 4 } })
  # Full is now impossible, but leaving it here for simplicity
  Full = HandType.new(5000000, 'Full', proc { |hand| hand.counts_without_jokers.any? { |_, count| count == 3 } && hand.counts_without_jokers.any? { |_, count| count == 2 } })
  Three = HandType.new(4000000, 'Three', proc { |hand| hand.counts_without_jokers.any? { |_, count| count == 3 } })
  TwoPairs = HandType.new(3000000, 'Two pairs', proc { |hand| hand.counts_without_jokers.select { |_, count| count == 2 }.size == 2 })
  Pair = HandType.new(2000000, 'Pair', proc { |hand| hand.counts_without_jokers.any? { |_, count| count == 2 } })
  HighCard = HandType.new(1000000, 'High card', proc { |hand| hand.counts_without_jokers.all? { |_, count| count == 1 } })

  CARD_VALUES = {
    'A' => 14,
    'K' => 13,
    'Q' => 12,
    'T' => 10,
    'J' => 1
  }.freeze

  class Hand
    attr_accessor :text, :counts, :counts_without_jokers, :type, :bid

    def initialize(text, bid)
      @text = text
      @bid = bid
      @counts = text.chars.group_by(&:itself).transform_values(&:count)
      @counts_without_jokers = @counts.except('J')
      # PART 1
      # @type = RULE_ORDER.find { |rule| rule.matches? self }
      # PART 2
      @type = get_type
    end

    def get_type # rubocop:disable Metrics/CyclomaticComplexity,Metrics/MethodLength
      base_rule = RULE_ORDER.find { |rule| rule.matches? self }
      current_rule = base_rule
      number_of_jokers = counts['J'] || 0

      
      Range.new(0, number_of_jokers, true).each do |i|
        current_rule = Five if current_rule == Four
        current_rule = Four if current_rule == Three
        current_rule = Three if current_rule == Pair
        current_rule = Full if current_rule == TwoPairs
        current_rule = Pair if current_rule == HighCard
      end

      current_rule
    end

    def any?(&blk)
      text.each_char.any?(&blk)
    end

    def value
      return @value unless @value.nil?

      @value = text.each_char.each_with_index.map do |char, index|
        current_value = CARD_VALUES[char] || char.to_i
        current_value * 15**(5 - index - 1)
      end.sum + type.value

      @value
    end
  end

  def self.part1 # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
    ['inputs/day7.txt', 'inputs/test/day7.txt'].each do |filename|
      hands = []
      File.open(filename).readlines.each do |line|
        hand_text, bid = line.strip.split
        hand = Hand.new(hand_text, bid.to_i)
        hands.append(hand)
      end

      result = hands.sort_by(&:value).each_with_index.map { |hand, index| hand.bid * (index + 1) }.sum
      puts "RESULT = #{result}"
    end
  end

  def self.part2 # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
    ['inputs/day7.txt', 'inputs/test/day7.txt'].each do |filename|
      hands = []
      File.open(filename).readlines.each do |line|
        hand_text, bid = line.strip.split
        hand = Hand.new(hand_text, bid.to_i)
        hands.append(hand)
      end

      result = hands.sort_by(&:value).each_with_index.map { |hand, index| hand.bid * (index + 1) }.sum
      puts "RESULT = #{result}"
    end
  end
end
