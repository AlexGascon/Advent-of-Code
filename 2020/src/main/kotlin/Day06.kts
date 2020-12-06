import java.io.File
import java.io.FileNotFoundException

val FILENAME_TEST = "src/main/kotlin/day06/input-test.txt"
val FILENAME = "src/main/kotlin/day06/input.txt"

fun extractGroupAnswers(filename: String) : List<String>{
    return File(filename)
        .readText()
        .split("\n\n")
}

fun combinedUniqueAnswers(answersPerGroup: List<String>) : Int {
    return answersPerGroup
        .map { uniqueAnswersCount(it) }
        .sum()
}

fun uniqueAnswersCount(groupAnswers: String) : Int {
    return groupAnswers
        .split("\\s".toRegex())
        .joinToString("")
        .toSet()
        .size
}

fun combinedAllYesAnswers(answersPerGroup: List<String>) : Int {
    return answersPerGroup
        .map { allYesAnswersCount(it) }
        .sum()
}

fun allYesAnswersCount(groupAnswers: String) : Int {
    val answersPerPerson = groupAnswers.split("\n")

    return answersPerPerson
        .map { it.toSet() }
        .reduce { acc, set -> acc.intersect(set) }
        .size
}

fun testPartOne() {
    val testSolution = combinedUniqueAnswers(extractGroupAnswers(FILENAME_TEST))
    println("TEST - Total unique answers: ${testSolution}")
}

fun partOne() {
    val partOneSolution = combinedUniqueAnswers(extractGroupAnswers(FILENAME))
    println("Total unique answers: ${partOneSolution}")
}

fun testPartTwo() {
    val testSolution = combinedAllYesAnswers(extractGroupAnswers(FILENAME_TEST))
    println("TEST - Count of answers to which everyone in a group answered yes: ${testSolution}")
}

fun partTwo() {
    val solution = combinedAllYesAnswers(extractGroupAnswers(FILENAME))
    println("Count of answers to which everyone in a group answered yes: ${solution}")
}

testPartOne()
partOne()
testPartTwo()
partTwo()
