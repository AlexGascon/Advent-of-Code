import java.io.File

val FILENAME = "src/main/kotlin/day09/input.txt"
val FILENAME_TEST = "src/main/kotlin/day09/input-test.txt"

val WINDOW_SIZE = 25
val WINDOW_SIZE_TEST = 5

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

test()
partOne()