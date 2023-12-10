# --- Day 5: If You Give A Seed A Fertilizer ---
# You take the boat and find the gardener right where you were told he would be: managing a giant "garden" that looks more to you like a farm.
#
# "A water source? Island Island is the water source!" You point out that Snow Island isn't receiving any water.
#
# "Oh, we had to stop the water because we ran out of sand to filter it with! Can't make snow with dirty water. Don't worry, I'm sure we'll get more sand soon; we only turned off the water a few days... weeks... oh no." His face sinks into a look of horrified realization.
#
# "I've been so busy making sure everyone here has food that I completely forgot to check why we stopped getting more sand! There's a ferry leaving soon that is headed over in that direction - it's much faster than your boat. Could you please go check it out?"
#
# You barely have time to agree to this request when he brings up another. "While you wait for the ferry, maybe you can help us with our food production problem. The latest Island Island Almanac just arrived and we're having trouble making sense of it."
#
# The almanac (your puzzle input) lists all of the seeds that need to be planted. It also lists what type of soil to use with each kind of seed, what type of fertilizer to use with each kind of soil, what type of water to use with each kind of fertilizer, and so on. Every type of seed, soil, fertilizer and so on is identified with a number, but numbers are reused by each category - that is, soil 123 and fertilizer 123 aren't necessarily related to each other.
#
# For example:
#
# seeds: 79 14 55 13
#
# seed-to-soil map:
# 50 98 2
# 52 50 48
#
# soil-to-fertilizer map:
# 0 15 37
# 37 52 2
# 39 0 15
#
# fertilizer-to-water map:
# 49 53 8
# 0 11 42
# 42 0 7
# 57 7 4
#
# water-to-light map:
# 88 18 7
# 18 25 70
#
# light-to-temperature map:
# 45 77 23
# 81 45 19
# 68 64 13
#
# temperature-to-humidity map:
# 0 69 1
# 1 0 69
#
# humidity-to-location map:
# 60 56 37
# 56 93 4
# The almanac starts by listing which seeds need to be planted: seeds 79, 14, 55, and 13.
#
# The rest of the almanac contains a list of maps which describe how to convert numbers from a source category into numbers in a destination category. That is, the section that starts with seed-to-soil map: describes how to convert a seed number (the source) to a soil number (the destination). This lets the gardener and his team know which soil to use with which seeds, which water to use with which fertilizer, and so on.
#
# Rather than list every source number and its corresponding destination number one by one, the maps describe entire ranges of numbers that can be converted. Each line within a map contains three numbers: the destination range start, the source range start, and the range length.
#
# Consider again the example seed-to-soil map:
#
# 50 98 2
# 52 50 48
# The first line has a destination range start of 50, a source range start of 98, and a range length of 2. This line means that the source range starts at 98 and contains two values: 98 and 99. The destination range is the same length, but it starts at 50, so its two values are 50 and 51. With this information, you know that seed number 98 corresponds to soil number 50 and that seed number 99 corresponds to soil number 51.
#
# The second line means that the source range starts at 50 and contains 48 values: 50, 51, ..., 96, 97. This corresponds to a destination range starting at 52 and also containing 48 values: 52, 53, ..., 98, 99. So, seed number 53 corresponds to soil number 55.
#
# Any source numbers that aren't mapped correspond to the same destination number. So, seed number 10 corresponds to soil number 10.
#
# So, the entire list of seed numbers and their corresponding soil numbers looks like this:
#
# seed  soil
# 0     0
# 1     1
# ...   ...
# 48    48
# 49    49
# 50    52
# 51    53
# ...   ...
# 96    98
# 97    99
# 98    50
# 99    51
# With this map, you can look up the soil number required for each initial seed number:
#
# Seed number 79 corresponds to soil number 81.
# Seed number 14 corresponds to soil number 14.
# Seed number 55 corresponds to soil number 57.
# Seed number 13 corresponds to soil number 13.
# The gardener and his team want to get started as soon as possible, so they'd like to know the closest location that needs a seed. Using these maps, find the lowest location number that corresponds to any of the initial seeds. To do this, you'll need to convert each seed number through other categories until you can find its corresponding location number. In this example, the corresponding types are:
#
# Seed 79, soil 81, fertilizer 81, water 81, light 74, temperature 78, humidity 78, location 82.
# Seed 14, soil 14, fertilizer 53, water 49, light 42, temperature 42, humidity 43, location 43.
# Seed 55, soil 57, fertilizer 57, water 53, light 46, temperature 82, humidity 82, location 86.
# Seed 13, soil 13, fertilizer 52, water 41, light 34, temperature 34, humidity 35, location 35.
# So, the lowest location number in this example is 35.
#
# What is the lowest location number that corresponds to any of the initial seed numbers?

# frozen_string_literal: true

# rubocop:disable Metrics/MethodLength
# rubocop:disable Metrics/AbcSize
module Day5
  class AlmanacParser
    SEEDS_REGEX = /^seeds:/
    MAP_REGEX = /map:$/
    BLANK_LINE_REGEX = /^\s*$/

    attr_accessor :map_started, :mappings, :seeds, :title_line

    def parse(text, reversed=false)
      @maps = {}
      @map_started = false
      @title_line = nil
      @mappings = []

      text.each do |line|
        @seeds = extract_seeds(line) if SEEDS_REGEX.match(line)

        if MAP_REGEX.match(line)
          @map_started = true
          @mappings = []
          @title_line = line
          next
        end

        if BLANK_LINE_REGEX.match(line) && @map_started
          @map_started = false
          almanac_map =
            reversed ? AlmanacMapReversed.new(@title_line, @mappings) : AlmanacMap.new(@title_line, @mappings)
          @maps[almanac_map.source] = almanac_map
          next
        end

        if map_started
          @mappings.append(line.strip)
        end
      end

      Almanac.new(@seeds, @maps)
    end

    def extract_seeds(line)
      # Part 1
      # line.split(':')[1].strip.split.map(&:to_i)
    
      line.split(':')[1].strip.split.map(&:to_i).each_slice(2).map do |start_seed, range_length|
        Range.new(start_seed, start_seed + range_length)
      end.flatten
    end
  end

  class AlmanacMap
    attr_accessor :source, :destination, :mapping

    def initialize(title_line, mappings)
      self.source, _, self.destination = title_line.strip.split('-').map(&:split).flatten

      mapping_pairs = mappings.map do |mapping|
        destination_start, source_start, range_length = mapping.split.map(&:to_i)

        source_range = Range.new(source_start, source_start + range_length)
        destination_function = ->(source) { destination_start - source_start + source }

        [source_range, destination_function]
      end

      self.mapping = mapping_pairs.to_h
    end

    def convert(source)
      result = mapping
               .find(-> { [nil, nil] }) { |range, _| range.include?(source) }
               .then { |_, fun| fun&.call(source) }

      result || source
    end
  end

  class AlmanacMapReversed
    attr_accessor :source, :destination, :mapping

    def initialize(title_line, mappings)
      self.destination, _, self.source = title_line.strip.split('-').map(&:split).flatten

      mapping_pairs = mappings.map do |mapping|
        destination_start, source_start, range_length = mapping.split.map(&:to_i)

        destination_range = Range.new(destination_start, destination_start + range_length)
        source_function = ->(destination) { destination - destination_start + source_start }

        [destination_range, source_function]
      end

      self.mapping = mapping_pairs.to_h
    end

    def convert(destination)
      result = mapping
               .find(-> { [nil, nil] }) { |range, _| range.include?(destination) }
               .then { |_range, fun| fun&.call(destination) }

      result || destination
    end
  end

  class Almanac
    attr_accessor :seeds, :maps

    def initialize(seeds, maps)
      @seeds = seeds
      @maps = maps
    end
  end

  def self.part1(filename)
    text = File.open(filename).readlines
    almanac = Day5::AlmanacParser.new.parse(text)

    locations = almanac.seeds.map do |seed|
      current_value = seed
      almanac.maps.each do |_destination, al_map|
        current_value = al_map.convert(current_value)
      end

      current_value
    end

    locations
  end

  # For some reason this works on the test input but not on the real one, which is off by 1
  # (for my dataset, outputs 9622623 instead of the correct 9622622). I'm not really sure
  # what might be wrong even after multiple checks, so I'll just push with this comment as
  # a disclaimer for everyone
  def self.part2(filename)
    text = File.open(filename).readlines
    almanac = Day5::AlmanacParser.new.parse(text, true)
    puts 'Parsing complete!'

    current_location = 0

    loop do
      current_value = current_location
      almanac.maps.reverse_each do |source, al_map|
        current_value = al_map.convert(current_value)
      end

      if almanac.seeds.any? { |seed_range| seed_range.include?(current_value) }
        puts "FOUND! Seed = #{current_value}, Location = #{current_location}"
        break
      else
        current_location += 1
      end

      puts "Location: #{current_location}" if (current_location % 1_000_000).zero?
    end

    current_location
  end
end
