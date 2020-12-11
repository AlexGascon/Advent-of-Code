import java.io.File

val FILENAME = "src/main/kotlin/day10/input.txt"
val FILENAME_TEST = "src/main/kotlin/day10/input-test.txt"


fun sortedJoltagesFromFile(filename: String) : MutableList<Int> {
    return File(filename)
        .readLines()
        .map(String::toInt)
        .sorted()
        .toMutableList()
}

fun joltageDifferenceFrequency(sortedJoltages: List<Int>): Map<Int, Int> {
    return sortedJoltages
        .zipWithNext { a, b -> b - a }
        .groupingBy { it }
        .eachCount()
}

fun partOne() {
    val joltages : MutableList<Int> = sortedJoltagesFromFile(FILENAME)

    // Adding the joltage of the seat and my device
    joltages.add(0, 0)
    joltages.add(joltages.size, joltages.last() + 3)

    val joltageDifferenceFrequency : Map<Int, Int> = joltageDifferenceFrequency(joltages)

    val solution = (joltageDifferenceFrequency[1]!! * joltageDifferenceFrequency[3]!!)

    println("SOLUTION - $solution")
}

partOne()