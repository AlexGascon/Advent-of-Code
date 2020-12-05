import java.io.File
import kotlin.test.assertEquals
import kotlin.test.assertTrue

val FILENAME_TEST = "src/main/kotlin/day03/input-test.txt"
val FILENAME = "src/main/kotlin/day03/input.txt"
val MOVEMENT_RIGHT = 3
val MOVEMENT_DOWN = 1
val SLOPES = listOf(Pair(1, 1), Pair(1, 3), Pair(1, 5), Pair(1, 7), Pair(2, 1))

class TreeMapFactory(val filename: String) {
    companion object {
        const val TREE_SYMBOL = '#'
    }

    fun create(): TreeMap {
        val fileContent: List<String> = File(filename).readLines()
        val size: Pair<Int, Int> = Pair(fileContent.size, fileContent.get(0).length)

        var treeLocations: MutableSet<Pair<Int, Int>> = mutableSetOf()

        fileContent.forEachIndexed { lineNumber, line ->
            line.forEachIndexed { columnNumber, c ->
                when {
                    c.equals(TREE_SYMBOL) -> treeLocations.add(Pair(lineNumber, columnNumber))
                }
            }
        }

        return TreeMap(size, treeLocations)
    }
}

class TreeMap(val size: Pair<Int, Int>, val treeLocations: Set<Pair<Int, Int>>) {
    fun hasTree(position: Pair<Int, Int>): Boolean {
        val relativePosition = Pair(position.first, position.second % size.second)
        return treeLocations.contains(relativePosition)
    }

    fun countTrees(slope: Pair<Int, Int>): Int {
        val movementDown = slope.first
        val movementRight = slope.second

        var currentPosition = Pair(0, 0)
        var treeCount = 0

        while(currentPosition.first < size.first) {
            if(hasTree(currentPosition)) {
                treeCount++
            }

            currentPosition = Pair(currentPosition.first + movementDown, currentPosition.second + movementRight)
        }

        return treeCount
    }
}

fun test() {
    val testMap = TreeMapFactory(FILENAME_TEST).create()
    assertEquals(Pair(11, 11), testMap.size)
    assertTrue(testMap.hasTree(Pair(0, 2)))
    assertTrue(testMap.hasTree(Pair(0, 3)))
    assertTrue(testMap.hasTree(Pair(10, 10)))
    assertTrue(testMap.hasTree(Pair(0, 13)))
    assertTrue(testMap.hasTree(Pair(0, 14)))
    assertTrue(testMap.hasTree(Pair(10, 21)))
    assertEquals(7, testMap.countTrees(Pair(1, 3)))
}

fun partOne() {
    val map = TreeMapFactory(FILENAME).create()
    println("Trees: ${map.countTrees(Pair(1, 3))}")
}

fun testTwo() {
    val testMap = TreeMapFactory(FILENAME_TEST).create()

    val result = SLOPES.map { testMap.countTrees(it) }.reduce { total, count -> total * count }
    println("Test result: ${result}")
}

fun partTwo() {
    val treeMap = TreeMapFactory(FILENAME).create()

    val result = SLOPES.map { treeMap.countTrees(it) }.reduce { total, count -> total * count }
    println("Result: ${result}")
}


//test()
//partOne()
testTwo()
partTwo()