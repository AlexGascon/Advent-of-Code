import java.io.File
import kotlin.test.assertEquals

val FILENAME_TEST = "src/main/kotlin/day05/input-test.txt"
val FILENAME = "src/main/kotlin/day05/input"

class Seat(val id: Int, val position: Pair<Int, Int>)

class SeatFactory {
   companion object {
       private const val ROW_ID_SIZE = 7

       fun createSeat(boardingId: String): Seat {
           val (rowId, colId) = boardingId.chunked(ROW_ID_SIZE)
           val row = rowId.replace("F", "0").replace("B", "1").toInt(2)
           val col = colId.replace("L", "0").replace("R", "1").toInt(2)
           val seatId = row*8 + col

           return Seat(seatId, Pair(row, col))
       }
   }
}

fun getSeatIds(filename: String): List<Int> {
    val boardingIds = File(filename).readLines()

    return boardingIds
        .map { SeatFactory.createSeat(it) }
        .map { seat -> seat.id }
}

fun highestSeatId(filename: String) : Int {
    return getSeatIds(filename).max()!!
}

fun findYourSeatId(filename: String) : Int {
    val seatIds = getSeatIds(filename).sorted()

    var previousSeatId = seatIds.first()
    seatIds.drop(1).forEach { seatId ->
        var seatDifference = seatId - previousSeatId

        when {
            seatDifference == 2 -> return (seatId - 1)
            else -> previousSeatId = seatId
        }
    }

    return -1
}

fun test() {
    assertEquals(SeatFactory.createSeat("FBFBBFFRLR").id, 357)
    println(highestSeatId(FILENAME_TEST))
}

fun partOne() {
    println("The highest seat ID is: ${highestSeatId(FILENAME)}")
}

fun partTwo() {
    println("Your seat is: ${findYourSeatId(FILENAME)}")
}

test()
partOne()
partTwo()