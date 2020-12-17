import java.io.File
import java.io.InvalidObjectException
import kotlin.math.abs

val FILENAME = "src/main/kotlin/day13/input.txt"
val FILENAME_TEST = "src/main/kotlin/day13/input-test.txt"

fun parseInput(filename: String) : Pair<Int, List<Int>> {
    val input = File(filename).readLines()
    val earliestDeparture = input.first().toInt()
    val availableBuses = input[1]
        .split(",")
        .filterNot { it == "x" }
        .map(String::toInt)

    return Pair(earliestDeparture, availableBuses)
}

fun timeUntilNextBus(currentTime: Int, busNumber: Int): Pair<Int, Int> {
    val lastBusTime = (currentTime / busNumber) * busNumber
    val nextBusTime = lastBusTime + busNumber

    return Pair(busNumber, nextBusTime - currentTime)
}

fun test() {
    val (earliestDeparture, availableBuses) = parseInput(FILENAME_TEST)
    println("INPUTS - Earliest departure: $earliestDeparture - Available buses: $availableBuses")

    val (busNumber, timeUntilDeparture) = availableBuses
        .map { timeUntilNextBus(earliestDeparture, it) }
        .minBy { it.second }!!

    val solution = timeUntilDeparture * busNumber
    println("SOLUTION = $solution - Departure = $timeUntilDeparture - BUS = $busNumber")
}

fun partOne() {
    val (earliestDeparture, availableBuses) = parseInput(FILENAME)

    val (busNumber, timeUntilDeparture) = availableBuses
        .map { timeUntilNextBus(earliestDeparture, it) }
        .minBy { it.second }!!

    val solution = timeUntilDeparture * busNumber
    println("SOLUTION = $solution - Departure = $timeUntilDeparture - BUS = $busNumber")
}

test()
partOne()