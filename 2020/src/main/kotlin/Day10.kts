import java.io.File
import java.lang.Integer.min

val FILENAME = "src/main/kotlin/day10/input.txt"
val FILENAME_TEST = "src/main/kotlin/day10/input-test.txt"
val FILENAME_TEST_SIMPLE = "src/main/kotlin/day10/input-test-simple.txt"

data class AdapterCollection(val sortedAdapters: List<Int>) {
    private val adapterPositions : Map<Int, Int> = sortedAdapters.mapIndexed { index, i -> Pair(i, index) }.toMap()
    private val memoizedPaths : MutableMap<Int, Long> = mutableMapOf()

    companion object {
        const val MAX_ADAPTER_DIFFERENCE = 3
    }

    fun pathsFrom(adapter: Int): Long {
        if (memoizedPaths.containsKey(adapter)) {
            return memoizedPaths[adapter]!!
        }

        return computePathsFrom(adapter)
    }

    private fun computePathsFrom(adapter: Int) : Long {
        if (adapter == sortedAdapters.last()) {
            memoizedPaths[adapter] = 1
            return 1
        }

        val totalPaths = getPossiblePathsFrom(adapter)
            //.also { println("POSSIBLE PATHS FOR $adapter: $it")}
            .map(::pathsFrom)
            .sum()

        memoizedPaths[adapter] = totalPaths
        return totalPaths
    }

    private fun getPossiblePathsFrom(adapter: Int): List<Int> {
        val adapterPosition = adapterPositions[adapter]!!
        val lastPossiblePathPosition = min(adapterPosition + 4, sortedAdapters.size)

        return sortedAdapters
            .subList(adapterPosition + 1, lastPossiblePathPosition)
            .filter { secondAdapter -> (secondAdapter - adapter) <= MAX_ADAPTER_DIFFERENCE }
    }
}


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

    println("PART 1 - $solution")
}

fun testTwo() {
    val joltages : MutableList<Int> = sortedJoltagesFromFile(FILENAME_TEST)
    // Adding the joltage of the seat and my device
    joltages.add(0, 0)
    joltages.add(joltages.size, joltages.last() + 3)

    val adapters = AdapterCollection(joltages)
    val paths = adapters.pathsFrom(joltages.first())

    println("TEST PATHS: $paths")
}

fun partTwo() {
    val joltages : MutableList<Int> = sortedJoltagesFromFile(FILENAME)
    // Adding the joltage of the seat and my device
    joltages.add(0, 0)
    joltages.add(joltages.size, joltages.last() + 3)

    val adapters = AdapterCollection(joltages)
    val paths = adapters.pathsFrom(joltages.first())

    println("PATHS: $paths")
}

partOne()
testTwo()
partTwo()