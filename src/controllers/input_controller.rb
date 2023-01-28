require_relative '../models/game_board'
require_relative '../models/ship'
require_relative '../models/position'

# return a populated GameBoard or nil
# Return nil on any error (validation error or file opening error)
# If 5 valid ships added, return GameBoard; return nil otherwise
def read_ships_file(path)
    currGameboard = GameBoard.new 10, 10
    shipCounter = 0
    if read_file_lines(path) == false then
        return nil
    end
    # Example: (2,2), Right, 3
    # 4 possible orientations and the ship's size ranges from 1-5
    # (Any digit, Any digit). Use escape sequence for the parentheses 
    read_file_lines(path) { |line|
        if line =~ /^\((\d+),(\d+)\), (Up|Down|Left|Right), ([1-5])$/ then
            row = $1.to_i
            column = $2.to_i
            orientation = $3
            size = $4.to_i
            shipPosition = Position.new(row, column)
            shipToAdd = Ship.new(shipPosition, orientation, size)
            if currGameboard.add_ship(shipToAdd) == true then
                shipCounter = shipCounter + 1
            end
        end
    }

        if shipCounter == 5 then
            return currGameboard
        end
        return nil
end





# return Array of Position or nil
# Returns nil on file open error
def read_attacks_file(path)
    positionArray = Array.new
    if read_file_lines(path) == false then
        return nil
    end
    # Example: (2,2)
    read_file_lines(path) { |line|
        if line =~ /^\((\d+),(\d+)\)$/ then
            row = $1.to_i
            column = $2.to_i
            positionArray.push(Position.new(row,column))
        end
    }
    return positionArray


    # [Position.new(1, 1)]
end


# ===========================================
# =====DON'T modify the following code=======
# ===========================================
# Use this code for reading files
# Pass a code block that would accept a file line
# and does something with it
# Returns True on successfully opening the file
# Returns False if file doesn't exist
def read_file_lines(path)
    return false unless File.exist? path
    if block_given?
        File.open(path).each do |line|
            yield line
        end
    end

    true
end
