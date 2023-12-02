# frozen_string_literal: true

=begin
--- Day 2: Cube Conundrum ---
You're launched high into the atmosphere! The apex of your trajectory just barely reaches the surface of a large island floating in the sky. You gently land in a fluffy pile of leaves. It's quite cold, but you don't see much snow. An Elf runs over to greet you.

The Elf explains that you've arrived at Snow Island and apologizes for the lack of snow. He'll be happy to explain the situation, but it's a bit of a walk, so you have some time. They don't get many visitors up here; would you like to play a game in the meantime?

As you walk, the Elf shows you a small bag and some cubes which are either red, green, or blue. Each time you play this game, he will hide a secret number of cubes of each color in the bag, and your goal is to figure out information about the number of cubes.

To get information, once a bag has been loaded with cubes, the Elf will reach into the bag, grab a handful of random cubes, show them to you, and then put them back in the bag. He'll do this a few times per game.

You play several games and record the information from each game (your puzzle input). Each game is listed with its ID number (like the 11 in Game 11: ...) followed by a semicolon-separated list of subsets of cubes that were revealed from the bag (like 3 red, 5 green, 4 blue).

For example, the record of a few games might look like this:

Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
In game 1, three sets of cubes are revealed from the bag (and then put back again). The first set is 3 blue cubes and 4 red cubes; the second set is 1 red cube, 2 green cubes, and 6 blue cubes; the third set is only 2 green cubes.

The Elf would first like to know which games would have been possible if the bag contained only 12 red cubes, 13 green cubes, and 14 blue cubes?

In the example above, games 1, 2, and 5 would have been possible if the bag had been loaded with that configuration. However, game 3 would have been impossible because at one point the Elf showed you 20 red cubes at once; similarly, game 4 would also have been impossible because the Elf showed you 15 blue cubes at once. If you add up the IDs of the games that would have been possible, you get 8.

Determine which games would have been possible if the bag had been loaded with only 12 red cubes, 13 green cubes, and 14 blue cubes. What is the sum of the IDs of those games?
=end

MAX_CUBES = {
  'blue': 14,
  'green': 13,
  'red': 12
}

class Game
  GAME_REGEX = /Game (?<id>\d+): (?<sets>.*)$/
  SET_SEPARATOR = ';'

  attr_accessor :id, :sets

  def self.from_line(game_line)
    regex_match = GAME_REGEX.match(game_line)

    id = regex_match['id']
    sets = regex_match['sets']
           .split(SET_SEPARATOR)
           .map { |set_text| CubeSet.parse(set_text) }

    Game.new(id: id, sets: sets)
  end

  def initialize(id:, sets:)
    @id = id.to_i
    @sets = sets
  end

  def inspect
    "Game(id: #{id}, sets: #{sets})"
  end

  def to_s
    inspect
  end
end

class CubeSet
  BALLS_SEPARATOR = ','

  attr_accessor :blue, :green, :red

  def self.parse(set_text)
    balls_count = set_text
                  .split(BALLS_SEPARATOR)
                  .map(&:split)
                  .map { |count_str, color| [color, count_str.to_i]}
                  .to_h

    blue = balls_count['blue']
    green = balls_count['green']
    red = balls_count['red']

    CubeSet.new(blue: blue, green: green, red: red)
  end

  def initialize(blue:, green:, red:)
    @blue = blue || 0
    @green = green || 0
    @red = red || 0
  end

  def inspect
    "CubeSet(blue: #{blue}, green: #{green}, red: #{red})"
  end

  def to_s
    inspect
  end
end

class Day2
  def valid_set(cube_set)
    cube_set.green <= MAX_CUBES[:green] && cube_set.blue <= MAX_CUBES[:blue] && cube_set.red <= MAX_CUBES[:red]
  end

  def part1
    File
      .open('inputs/day2.txt').readlines
      .map { |line| Game.from_line(line) }
      .filter { |game| game.sets.all? { |set| valid_set(set) } }
      .reduce(0) { |acc, game| acc + game.id }
  end
end

puts "PART 1: #{Day2.part1}"
