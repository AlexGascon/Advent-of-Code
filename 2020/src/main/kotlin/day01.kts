import java.io.File

val TARGET_NUMBER = 2020
val FILENAME_TEST = "src/main/kotlin/day01/input-test.txt"
val FILENAME = "src/main/kotlin/day01/input.txt"

fun findTarget(target: Int, sortedList: List<Int>, startingIndex: Int): Int? {
    val position: Int = sortedList.binarySearch(target, startingIndex)

    when {
        position >= 0 ->
            return sortedList[position]
        else ->
            return null
    }
}

fun partOne() {
    var sortedNumbers = File(FILENAME).readLines().map { it.toInt() }.sorted()

    sortedNumbers.forEachIndexed { index, currentNumber ->
        var currentTarget = TARGET_NUMBER - currentNumber
        var startingIndex = index + 1
        var complement: Int? = findTarget(currentTarget, sortedNumbers, startingIndex)

        if (complement is Int && complement > 0) {
            println("Numbers: ${currentNumber}, ${complement} - Solution: ${currentNumber * complement}")
            return
        }
    }
}

fun partTwo() {
    var sortedNumbers = File(FILENAME).readLines().map { it.toInt() }.sorted()
    var numbersSet: Set<Int> = sortedNumbers.toSet()
    var listLength = sortedNumbers.size

    sortedNumbers.forEachIndexed { i, firstNumber ->
        var remainingNumbers = sortedNumbers.subList(i + 1, listLength)

        remainingNumbers.forEachIndexed { _, secondNumber ->
            var currentTarget = TARGET_NUMBER - firstNumber - secondNumber

            if (numbersSet.contains(currentTarget)) {
                var result = firstNumber * secondNumber * currentTarget
                println("Numbers: ${firstNumber}, ${secondNumber}, ${currentTarget} - Solution: ${result}")
                return
            }
        }
    }
}

partOne()
partTwo()