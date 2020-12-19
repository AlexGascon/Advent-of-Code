import java.io.File

val FILENAME = "src/main/kotlin/day13/input.txt"
val FILENAME_TEST = "src/main/kotlin/day13/input-test.txt"
val FILENAME_TEST_ADDITIONAL = "src/main/kotlin/day13/input-test-additional.txt"
val FILENAME_TEST_SIMPLE = "src/main/kotlin/day13/input-test-simple.txt"

data class BusRequirement(val busLine: Long, val timeOffset: Long)

fun parseInput(filename: String): List<BusRequirement> {
    val (_, busList) = File(filename).readLines()

    return busList
        .split(",")
        .mapIndexed { index, busLineString ->
            if (busLineString == "x") return@mapIndexed null

            val busLine = busLineString.toLong()
            val timeOffset = if (index == 0) 0 else busLine - index
            BusRequirement(busLine, timeOffset)
        }
        .filterNotNull()
}

fun chineseRemainderTheorem(remaindersAndModulos: List<BusRequirement>): Long {
    val remainders = remaindersAndModulos.map(BusRequirement::timeOffset)
    val modulus = remaindersAndModulos.map(BusRequirement::busLine)
    val modulosProduct = modulus.fold(1L) { acc, l -> acc * l }

    var totalSum = 0L

    for (i in remaindersAndModulos.indices) {
        val wantedRemainder = remainders[i]
        val currentModulo = modulus[i]

        var currentSummand = (modulosProduct / currentModulo)
        val currentRemainder = currentSummand % currentModulo
        if (currentRemainder != wantedRemainder) {
            currentSummand *= wantedRemainder * moduloInverse(currentRemainder, currentModulo)
        }

        totalSum += currentSummand
    }

    return (totalSum % modulosProduct)
}

fun moduloInverse(number: Long, modulo: Long): Long {
    if (number == 0L) {
        // In this case, we don't care
        return 0L
    }

    var numerator = 1L
    var denominator = number

    while (true) {
        // First number that makes the denominator higher than the modulo
        var multiplier: Long = modulo.div(denominator) + 1L

        // Fraction reduction:
        // We multiply numerator and denominator by the same number, so result is the same
        // As we are working in modulo, numerator and denominator have to be reduced
        numerator = (numerator * multiplier) % modulo
        denominator = (denominator * multiplier) % modulo

        // When we make the denominator reach 1, the numerator is the inverse
        if (denominator == 1L) {
            return numerator
        }
    }
}

fun findSolution(busesAndOffsets: List<BusRequirement>): Long {
    return chineseRemainderTheorem(busesAndOffsets)
}

fun test() {
    val busesAndOffsets = parseInput(FILENAME_TEST_ADDITIONAL)
    println("INPUTS = $busesAndOffsets")
    val solution = findSolution(busesAndOffsets)
    println("SOLUTION = $solution")
}

fun testTwo() {
    val busesAndOffsets = parseInput(FILENAME_TEST)
    println("INPUTS = $busesAndOffsets")
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