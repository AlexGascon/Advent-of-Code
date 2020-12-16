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
        if (visibleSeats(position).any(Seat::isOccupied)) {
            return Seat(SeatType.EMPTY)
        } else {
            return Seat(SeatType.OCCUPIED)
        }
    }

    private fun transitionOccupiedSeat(position: Position) : Seat {
        if (visibleSeats(position).count(Seat::isOccupied) >= 5) {
            return Seat(SeatType.EMPTY)
        } else {
            return Seat(SeatType.OCCUPIED)
        }
    }

    private fun visibleSeats(position: Position) : List<Seat> {
        val visibleSeats = mutableListOf<Seat?>()

        visibleSeats.add(visibleSeatUp(position))
        visibleSeats.add(visibleSeatDown(position))
        visibleSeats.add(visibleSeatLeft(position))
        visibleSeats.add(visibleSeatRight(position))
        visibleSeats.add(visibleSeatTopLeft(position))
        visibleSeats.add(visibleSeatTopRight(position))
        visibleSeats.add(visibleSeatBottomLeft(position))
        visibleSeats.add(visibleSeatBottomRight(position))

        return visibleSeats.filterNotNull()
    }

    private fun visibleSeatUp(position: Position) : Seat? {
        val directionFunction = { p: Position -> p.up() }

        return visibleSeatInDirection(position, directionFunction)
    }

    private fun visibleSeatDown(position: Position) : Seat? {
        val directionFunction = { p: Position -> p.down() }

        return visibleSeatInDirection(position, directionFunction)
    }

    private fun visibleSeatLeft(position: Position) : Seat? {
        return visibleSeatInDirection(position) { p: Position -> p.left() }
    }

    private fun visibleSeatRight(position: Position) : Seat? {
        return visibleSeatInDirection(position) { p: Position -> p.right() }
    }

    private fun visibleSeatTopLeft(position: Position) : Seat? {
        return visibleSeatInDirection(position) { p: Position -> p.topLeft() }
    }

    private fun visibleSeatTopRight(position: Position) : Seat? {
        return visibleSeatInDirection(position) { p: Position -> p.topRight() }
    }

    private fun visibleSeatBottomLeft(position: Position) : Seat? {
        return visibleSeatInDirection(position) { p: Position -> p.bottomLeft() }
    }

    private fun visibleSeatBottomRight(position: Position) : Seat? {
        return visibleSeatInDirection(position) { p: Position -> p.bottomRight() }
    }

    private fun visibleSeatInDirection(position: Position, directionFunction: (Position) -> Position) : Seat? {
        val positionToLook = directionFunction(position)

        if (isOutOfBounds(positionToLook)) {
            return null
        }

        val possibleSeat = seats[positionToLook]!!
        return if (possibleSeat.isFloor()) visibleSeatInDirection(positionToLook, directionFunction) else possibleSeat
    }

    private fun isOutOfBounds(position: Position) : Boolean {
        return (position.row < 0) ||
                (position.row > MAX_ROW) ||
                (position.col < 0) ||
                (position.col > MAX_COL)
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
    val occupiedSeats : List<Seat> = stableSeatGrid.seats.values.filter(Seat::isOccupied)

    println("TEST - Occupied seats count: ${occupiedSeats.size}")
    println("\nSEAT GRID:")
    println(stableSeatGrid)
}

fun partTwo() {
    val seatGrid = SeatGrid.fromSeatList(File(FILENAME).readLines())
    val stableSeatGrid = stabilizeTransitions(seatGrid)
    val occupiedSeats : List<Seat> = stableSeatGrid.seats.values.filter(Seat::isOccupied)

    println("Occupied seats: ${occupiedSeats.size}")
}

test()
partTwo()
