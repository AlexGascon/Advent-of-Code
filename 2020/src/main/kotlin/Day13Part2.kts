import java.io.File
import java.sql.Timestamp

val FILENAME = "src/main/kotlin/day13/input.txt"
val FILENAME_TEST = "src/main/kotlin/day13/input-test.txt"
val FILENAME_TEST_ADDITIONAL = "src/main/kotlin/day13/input-test-additional.txt"
val FILENAME_TEST_SIMPLE = "src/main/kotlin/day13/input-test-simple.txt"

fun parseInput(filename: String): List<Pair<Int, Int>> {
    val (_, busList) = File(filename).readLines()

    return busList
        .split(",")
        .mapIndexed { index, value -> Pair(value, index) }
        .filterNot { it.first == "x" }
        .map { pair -> Pair(pair.first.toInt(), pair.second) }
}

fun timeToNextBus(timestamp: Long, busNumber: Int, timeOffset: Int) : Long {
    val x = (timestamp + timeOffset) % busNumber
    return if (x == 0L) 0L else (busNumber - x)
}

fun findSolution(busesAndOffsets: List<Pair<Int,Int>>): Long {
    var currentTimestamp = 100000000000000L
    var isSolution = false

    while (!isSolution) {
        val maxDifference: Long = busesAndOffsets
            .map { (bus, offset) -> Pair(bus, timeToNextBus(currentTimestamp, bus, offset)) }
            .maxBy { it.second }!!
            .second

        if (maxDifference == 0L) {
            isSolution = true
        } else {
            currentTimestamp += maxDifference
        }
    }

    return currentTimestamp
}

fun test() {
    val busesAndOffsets = parseInput(FILENAME_TEST_ADDITIONAL)
    val solution = findSolution(busesAndOffsets)
    println("SOLUTION = $solution")
}

fun testTwo() {
    val busesAndOffsets = parseInput(FILENAME_TEST)
    val solution = findSolution(busesAndOffsets)
    println("SOLUTION = $solution")
}

fun partTwo() {
    val busesAndOffsets = parseInput(FILENAME)
    val solution = findSolution(busesAndOffsets)
    println("SOLUTION = $solution")
}

test()
testTwo()
partTwo()