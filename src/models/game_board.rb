class GameBoard
    # @max_row is an `Integer`
    # @max_column is an `Integer`
    attr_reader :max_row, :max_column

    def initialize(max_row, max_column)
        @max_row = max_row
        @max_column = max_column
        # Game board initialized with "-, -"
        # "B, -"  for battleship
        # "B, A" for successful attack on battleship
        # "-, A" for unsuccessful attack on battleship
        @arr = Array.new(max_row){Array.new(max_column, "-, -")}
        @numSuccessfulAttacks = 0

    end

    # adds a Ship object to the GameBoard
    # returns Boolean
    # Returns true on successfully added the ship, false otherwise
    # Note that Position pair starts from 1 to max_row/max_column
    def add_ship(ship)
        sizeOfShip = ship.size - 1

        if ship.orientation == "Up" then
            # Up = decreasing rows
            if ship.start_position.row - sizeOfShip < 1 || ship.start_position.row > @max_row ||  ship.start_position.column > @max_column || ship.start_position.column < 1 then
                return false
            end
            # Make sure there are no battle ships in any of the positions 
            # where you plan to add this ship
            for i in (ship.start_position.row - 1).downto(ship.start_position.row - 1 - sizeOfShip)
                if @arr[i][ship.start_position.column - 1] =~ /[B]/ then
                    return false
                end
            end
            # Start placing the ship onto the board
            for i in (ship.start_position.row - 1).downto(ship.start_position.row - 1 - sizeOfShip)
                @arr[i][ship.start_position.column - 1] = "B, -"
            end
            return true
        end

        if ship.orientation == "Down" then
            # Down = increasing rows
            if ship.start_position.row  + sizeOfShip > @max_row || ship.start_position.row < 1 || ship.start_position.column  > @max_column || ship.start_position.column < 1 then
                return false
            end
            for i in (ship.start_position.row - 1).upto(ship.start_position.row - 1 + sizeOfShip)
                if @arr[i][ship.start_position.column - 1] =~ /[B]/ then
                    return false
                end
            end
            for i in (ship.start_position.row - 1).upto(ship.start_position.row - 1 + sizeOfShip)
                @arr[i][ship.start_position.column - 1] = "B, -"
            end
            return true
        end

        if ship.orientation == "Left" then
            # Left = decreasing columns
            if ship.start_position.column - sizeOfShip < 1 ||ship.start_position.row > @max_row || ship.start_position.row < 1 || ship.start_position.column > @max_column then
                return false
            end
            for i in (ship.start_position.column - 1).downto(ship.start_position.column - 1 - sizeOfShip)
                if @arr[ship.start_position.row - 1][i] =~ /[B]/ then
                    return false
                end
            end
            for i in (ship.start_position.column - 1).downto(ship.start_position.column - 1 - sizeOfShip)
                @arr[ship.start_position.row - 1][i] = "B, -"
            end
            return true
        end

        if ship.orientation == "Right" then
            # Right = increasing columns
            if ship.start_position.column + sizeOfShip > @max_column || ship.start_position.row > @max_row || ship.start_position.row < 1 || ship.start_position.column < 1 then
                return false
            end
            for i in (ship.start_position.column - 1).upto(ship.start_position.column - 1 + sizeOfShip)
                if @arr[ship.start_position.row - 1][i] =~ /[B]/ then
                    return false
                end
            end
            for i in (ship.start_position.column - 1).upto(ship.start_position.column - 1 + sizeOfShip)
                @arr[ship.start_position.row - 1][i] = "B, -"
            end
            return true
        end
        
        return false
    end

    # return Boolean on whether attack was successful or not (hit a ship?)
    # return nil if Position is invalid (out of the boundary defined)
    def attack_pos(position)
        # determines if the position is invalid
        if position.row > max_row || position.column > max_column || position.row < 1 || position.column < 1 then
            return nil
        end
        # if there is a battleship and it was attacked, update the gameboard
        if @arr[position.row - 1][position.column - 1] =~ /[B], \-/ then
            @arr[position.row - 1][position.column - 1] = "B, A"
            @numSuccessfulAttacks = @numSuccessfulAttacks + 1
        else
            @arr[position.row - 1][position.column - 1] = "-, A"
        end
        # return Boolean on whether attack was successful or not (hit a ship?)
        if @arr[position.row - 1][position.column - 1] =~ /[B]/ then
            return true
        else
            return false
        end
    end

    # Number of successful attacks made by the "opponent" on this player GameBoard
    def num_successful_attacks
        return @numSuccessfulAttacks
    end

    # returns Boolean
    # returns True if all the ships are sunk.
    # Return false if at least one ship hasn't sunk.
    def all_sunk?
        for i in (0).upto(@max_row - 1)
            for j in (0).upto(@max_column - 1)
                if @arr[i][j] =~ /[B], \-/ then
                    return false
                end
            end
        end

        return true
    end

    # String representation of GameBoard (optional but recommended)
    def to_s
        @arr.each {|i| puts i.to_s}
    end
end
