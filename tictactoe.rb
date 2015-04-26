require 'pry'

  WINNING_LINES = [[1,2,3], [4,5,6], [7,8,9], [1,4,7], [2,5,8], [3,6,9], [1,5,9], [3,5,7]]

def initialize_board
  b= {}
  (1..9).each {|position| b[position] = ' '}
  b
end

def draw_board(b)
  system 'clear'
  puts "#{b[1]} | #{b[2]} | #{b[3]}"
  puts "--+---+--"
  puts "#{b[4]} | #{b[5]} | #{b[6]}"
  puts "--+---+--"
  puts "#{b[7]} | #{b[8]} | #{b[9]}"
end

def empty_positions(b)
  b.select {|k,v| b[k] == " "}.keys
end

def valid_position?(selection, b)
  empty_positions(b).include?(selection)
end

def player_picks_square(b)
  # Gather position selection from player and re-prompt if not a valid, empty position
  begin
    puts "Available positions:  #{empty_positions(b)}"
    puts "Pick a square (1 - 9):"
    position = gets.chomp.to_i
    puts "Please select a valid position!\n\n" if valid_position?(position,b) == false
  end until valid_position?(position, b)

  b[position] = "X"
end

def computer_picks_square(b)
  if two_x_in_a_row(b)
    position = two_x_in_a_row(b)
  else
    position = empty_positions(b).sample
  end
  b[position] = "O"
end


def two_x_in_a_row(b)
  x_in_a_row, position = 0

  WINNING_LINES.each do |line|
    # Re-initialize count and position for each winning line.
    x_in_a_row, position = 0

    # Return position of blank if winning line contains two "X" and one " "
    line.each do |p|
      if b[p] == "O"
        in_a_row = 0
        break
      end
      x_in_a_row += 1 if b[p] == "X"
      position = p if b[p] == " "
    end
    return position if x_in_a_row == 2
  end

  return nil
end

def check_winner(b)
  winner = nil

  WINNING_LINES.each do |line|
    if b[line[0]] == "X" && b[line[1]] == "X" && b[line[2]] == "X"
      return winner = "Player"
    elsif b[line[0]] == "O" && b[line[1]] == "O" && b[line[2]] == "O"
      return winner = "Computer"
    else
      winner = nil
    end
  end

  winner
end

board = initialize_board
draw_board(board)

# Game loop
begin
  # Player turn
  player_picks_square(board)
  draw_board(board)
  winner = check_winner(board)

  # Prevent drawing next Computer move if Player wins
  if winner
    break
  end

  # Computer Turn
  computer_picks_square(board)
  draw_board(board)
  winner = check_winner(board)
end until winner || empty_positions(board).empty?

# Display winner at end of game
if winner
  puts "#{winner} won!"
else
  puts "It's a tie!"
end
