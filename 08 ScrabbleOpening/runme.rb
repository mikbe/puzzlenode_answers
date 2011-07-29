require './json'

# Calculates the best opening move using the
# tile set and scrabble board specified in the
# input JSON file.
# The result is then printed to the output file.
# 
class Scrabble

  def self.best_opening(game_file="INPUT.json", solution_file="solution.txt")
    Scrabble.new(game_file, solution_file)
  end

  def initialize(game_file="INPUT.json", solution_file="solution.txt")
    load_puzzle(game_file) 
    write_solution(solution_file)
  end

  private

  def load_puzzle(game_file)
    @game_data = load_json(game_file)
  end
  
  def write_solution(solution_file)
    max = find_max_score
    transcribe_grid(max, solution_file)
  end
  
  def load_json(file_name)
    content = File.read(file_name)
    JSON.parse(content)
  end

  def viable_words
    @game_data["dictionary"].collect do |word|
      tiles = tiles_to_letters
      word.each_char do |char|
        break unless tiles.sub!(char, '')
      end
    end.compact
  end

  def tiles_to_letters
    (@tile_letters ||= @game_data["tiles"].collect {|tile| tile[0]}.join).clone
  end

  def letter_value(letter)
    @letter_values ||= @game_data["tiles"].each_with_object({}) do |tile, letters| 
      letters.merge!(tile[0] => tile[1..-1].to_i)
    end
    @letter_values[letter]
  end

  def game_board_array
    @game_board_array ||= @game_data["board"].collect { |row| row.split.collect {|col| col.to_i} }
  end

  def multiply_word_by_grid(word, row, col)
    # horizontal
    h_total, v_total = 0, 0
    if col + word.length < game_board_array[0].length
      h_total = (col..col+(word.length-1)).inject(0) do |total, position|
        total += game_board_array[row][position] * letter_value(word[position-col])
      end
    end
    #vertical
    if row + word.length < game_board_array.length
      v_total = (row..row+(word.length-1)).inject(0) do |total, position|
        total += game_board_array[position][col] * letter_value(word[position-row])
      end
    end
    {score: [h_total, v_total].max, horizontal: h_total > v_total}
  end

  def find_max_score
    max_score = {word: "", score: 0, row: nil, col: nil, horizontal: nil}
    viable_words.each do |word|
      (0..game_board_array.length-1).each do |row|
        (0..game_board_array[0].length-1).each do |col|
          score = multiply_word_by_grid(word, row, col)
          max_score = {
            word:       word, 
            score:      score[:score], 
            row:        row, 
            col:        col, 
            horizontal: score[:horizontal]
          } if score[:score] > max_score[:score]
        end
      end
    end
    max_score
  end

  def transcribe_grid(max_score, output_file)
    
    grid  = game_board_array
    word  = max_score[:word]
    row   = max_score[:row]
    col   = max_score[:col]
    
    word.each_char do |char|
      grid[row][col] = char
      max_score[:horizontal] ? col += 1 : row += 1
    end
    
    File.open(output_file, "w") do |file|
      grid.each {|line| file.puts line.join(" ") }
    end

  end
end

Scrabble.best_opening *ARGV
