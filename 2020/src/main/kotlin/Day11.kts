import java.io.File

val FILENAME = "src/main/kotlin/day11/input.txt"
val FILENAME_TEST = "src/main/kotlin/day11/input-test.txt"

enum class SeatType(val char: Char) {
    FLOOR('.'),
    EMPTY('L'),
    OCCUPIED('#')

}

data class Seat(val type : SeatType) {
    companion object {
        fun create(seatChar: Char) : Seat {
            return when(seatChar) {
                SeatType.FLOOR.char -> Seat(SeatType.FLOOR)
                SeatType.EMPTY.char -> Seat(SeatType.EMPTY)
                else                -> Seat(SeatType.OCCUPIED)
            }
        }
    }

    fun equals(otherSeat : Seat) : Boolean {
        return type == otherSeat.type
    }

    override fun toString() : String {
        return type.char.toString()
    }

    fun isEmpty() : Boolean {
        return type == SeatType.EMPTY
    }

    fun isOccupied() : Boolean {
        return type == SeatType.OCCUPIED
    }

    fun isFloor() : Boolean {
        return type == SeatType.FLOOR
    }
}

data class Position(val row : Int, val col : Int) {
    fun up() : Position = Position(row - 1, col)
    fun down() : Position = Position(row + 1, col)
    fun left() : Position = Position(row, col - 1)
    fun right() : Position = Position(row, col + 1)
    fun topLeft() : Position = Position(row - 1, col - 1)
    fun topRight() : Position = Position(row - 1, col + 1)
    fun bottomLeft() : Position = Position(row + 1, col - 1)
    fun bottomRight() : Position = Position(row + 1, col + 1)
}

data class SeatGrid(val seats: Map<Position, Seat>) {
    private val MAX_ROW : Int = seats.keys.map(Position::row).max()!!
    private val MAX_COL : Int = seats.keys.map(Position::col).max()!!

    companion object {
        fun fromSeatList(seatCharList: List<String>) : SeatGrid {
            val seats = mutableMapOf<Position, Seat>()

            seatCharList.forEachIndexed { rowNumber, seatRow ->
                seatRow.forEachIndexed { columnNumber, seatValue ->
                    seats[Position(rowNumber, columnNumber)] = Seat.create(seatValue)
                }
            }

            return SeatGrid(seats)
        }
    }

    fun equals(otherGrid : SeatGrid): Boolean {
        return seats.all {
            val position = it.key
            val seat = it.value
            (otherGrid.seats[position]!! == seat)
        }
    }

    override fun toString() : String {
        val stringBuilder = StringBuilder()
        IntRange(0, MAX_ROW).forEach { row ->
            IntRange(0, MAX_COL).forEach { col ->
                val currentPosition = Position(row, col)
                val seat = seats[currentPosition]
                stringBuilder.append(seat.toString())
            }
            stringBuilder.append("\n")
        }

        return stringBuilder.toString()
    }

    fun transition() : SeatGrid {
        val newSeats : Map<Position, Seat> = seats.map { (position, seat) ->
            Pair(position, transitionSeat(seat, position))
        }.toMap()

        return SeatGrid(newSeats)
    }

    private fun transitionSeat(currentSeat: Seat, position: Position) : Seat {
        return when(currentSeat.type) {
            SeatType.EMPTY -> transitionEmptySeat(position)
            SeatType.OCCUPIED -> transitionOccupiedSeat(position)
            SeatType.FLOOR -> Seat(SeatType.FLOOR)
        }
    }

    private fun transitionEmptySeat(position: Position) : Seat {
        if (adjacentSeats(position).any(Seat::isOccupied)) {
            return Seat(SeatType.EMPTY)
        } else {
            return Seat(SeatType.OCCUPIED)
        }
    }

    private fun transitionOccupiedSeat(position: Position) : Seat {
        if (adjacentSeats(position).count(Seat::isOccupied) >= 4) {
            return Seat(SeatType.EMPTY)
        } else {
            return Seat(SeatType.OCCUPIED)
        }
    }

    private fun adjacentSeats(position: Position) : List<Seat> {
        val adjacentSeats  = mutableListOf<Seat>()

        if (!inTopRow(position)) {
            adjacentSeats.add(seats[position.up()]!!)

            if (!inLeftSide(position)) {
                adjacentSeats.add(seats[position.topLeft()]!!)
            }

            if (!inRightSide(position)) {
                adjacentSeats.add(seats[position.topRight()]!!)
            }
        }

        if (!inBottomRow(position)) {
            adjacentSeats.add(seats[position.down()]!!)

            if (!inLeftSide(position)) {
                adjacentSeats.add(seats[position.bottomLeft()]!!)
            }

            if (!inRightSide(position)) {
                adjacentSeats.add(seats[position.bottomRight()]!!)
            }
        }

        if (!inLeftSide(position)) {
            adjacentSeats.add(seats[position.left()]!!)
        }

        if (!inRightSide(position)) {
            adjacentSeats.add(seats[position.right()]!!)
        }

        return adjacentSeats
    }

    private fun inTopRow(position: Position) : Boolean {
        return position.row == 0
    }

    private fun inBottomRow(position: Position) : Boolean {
        return position.row == MAX_ROW
    }

    private fun inLeftSide(position: Position) : Boolean {
        return position.col == 0
    }

    private fun inRightSide(position: Position) : Boolean {
        return position.col == MAX_COL
    }
}

fun stabilizeTransitions(startingSeatGrid: SeatGrid) : SeatGrid {
    var previousSeatGrid = startingSeatGrid
    var seatGrid = startingSeatGrid.transition()

    while (!seatGrid.equals(previousSeatGrid)) {
        previousSeatGrid = seatGrid
        seatGrid = seatGrid.transition()
    }

    return seatGrid
}

fun test() {
    val seatGrid = SeatGrid.fromSeatList(File(FILENAME_TEST).readLines())
    val stableSeatGrid = stabilizeTransitions(seatGrid)
    val occupiedSeats : Int = stableSeatGrid.seats.values.count(Seat::isOccupied)

    println("TEST - Occupied seats: ${occupiedSeats}")
}

fun partOne() {
    val seatGrid = SeatGrid.fromSeatList(File(FILENAME).readLines())
    val stableSeatGrid = stabilizeTransitions(seatGrid)
    val occupiedSeats : Int = stableSeatGrid.seats.values.count(Seat::isOccupied)

    println("Occupied seats: ${occupiedSeats}")
}

test()
partOne()
