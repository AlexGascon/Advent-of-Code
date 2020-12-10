import java.io.File
import kotlin.test.currentStackTrace

val FILENAME = "src/main/kotlin/day09/input.txt"
val FILENAME_TEST = "src/main/kotlin/day09/input-test.txt"

val WINDOW_SIZE = 25
val WINDOW_SIZE_TEST = 5

val SUMMANDS_TARGET : Long = 29221323
val SUMMANDS_TARGET_TEST : Long = 127

fun readNumbers(filename: String) : List<Long> {
    return File(filename).readLines().map { it.toLong() }
}

fun findFirstImpossibleSum(numbers: List<Long>, windowSize: Int) : Long {
    val currentNumbers = numbers.subList(0, windowSize).toMutableList()
    var nextToBeDropped = currentNumbers.first()

    numbers.subList(windowSize, numbers.size).forEach { targetNumber ->
        if (!isPossibleSum(targetNumber, currentNumbers)) {
            return targetNumber
        }

        currentNumbers.add(targetNumber)
        currentNumbers.remove(nextToBeDropped)
        nextToBeDropped = currentNumbers.first()
    }

    return -1
}

fun isPossibleSum(target: Long, numbers: List<Long>) : Boolean {
    var isPossible = false
    val numbersSize = numbers.size

    numbers.forEachIndexed { index, firstNumber ->
        if (index == (numbersSize - 1)) {
            return@forEachIndexed
        }

        numbers.subList(index + 1, numbersSize).forEach { secondNumber ->
            isPossible = isPossible || ((firstNumber + secondNumber) == target)
        }
    }

    return isPossible
}

fun findContiguousSummands(target: Long, numbers: List<Long>) : List<Long> {
    val currentSummands = mutableListOf<Long>()
    var currentPosition = 0

    while(true) {
        val number = numbers[currentPosition]
        val currentSum = currentSummands.sum()
        //println("SUMMANDS: ${currentSummands} - SUM: ${currentSum} - TARGET: ${target}")

        when {
            currentSum == target ->
                return currentSummands
            currentSum < target -> {
                currentSummands.add(number)
                currentPosition += 1
            }
            currentSum > target -> {
                currentSummands.removeAt(0)
            }
        }
    }
}

fun test() {
    val numbers = readNumbers(FILENAME_TEST)

    val solution = findFirstImpossibleSum(numbers, WINDOW_SIZE_TEST)

    println("TEST - Solution = ${solution}")
}

fun partOne() {
    val numbers = readNumbers(FILENAME)

    val solution = findFirstImpossibleSum(numbers, WINDOW_SIZE)

    println("Solution = ${solution}")
}

fun testTwo() {
    val numbers = readNumbers(FILENAME_TEST)

    val summands = findContiguousSummands(SUMMANDS_TARGET_TEST, numbers)
    val solution = summands.min()!!.plus(summands.max()!!)

    println("TEST - Solution = ${solution}")
}

fun partTwo() {
    val numbers = readNumbers(FILENAME)

    val summands = findContiguousSummands(SUMMANDS_TARGET, numbers)
    val solution = summands.min()!!.plus(summands.max()!!)

    println("Solution = ${solution}")
}

test()
partOne()
testTwo()
partTwo()