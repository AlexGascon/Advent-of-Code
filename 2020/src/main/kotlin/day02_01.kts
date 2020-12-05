import java.io.File

data class PasswordCandidate(val desiredFrequency: IntRange, val desiredLetter: Char, val password: String)

val FILENAME = "src/main/kotlin/day02/input.txt"
val FILENAME_TEST = "src/main/kotlin/day02/input-test.txt"

// 1-3 b: cdefg
fun parsePassword(line: String): PasswordCandidate {
    val parts: List<String> = line.split(" ")

    val rangeLimits: List<Int> = parts.get(0).split("-").map { it.toInt() }
    val desiredFrequency = IntRange(rangeLimits[0], rangeLimits[1])
    val desiredLetter = parts.get(1).get(0).toChar()
    val password = parts.get(2)

    return PasswordCandidate(desiredFrequency, desiredLetter, password)
}

fun validatePassword(passwordCandidate: PasswordCandidate): Boolean {
    val realFrequency: Int = passwordCandidate.password.count { char -> char == passwordCandidate.desiredLetter }

    return passwordCandidate.desiredFrequency.contains(realFrequency)
}

fun test() {
    val lines: List<String> = File(FILENAME_TEST).readLines()

    val validPasswordsCount: Int = lines.map { parsePassword(it) }.count { validatePassword(it) }
    println("TEST - Valid passwords: ${validPasswordsCount}")
}

fun partOne() {
    val lines: List<String> = File(FILENAME).readLines()

    val validPasswordsCount: Int = lines.map { parsePassword(it) }.count { validatePassword(it) }
    println("PART 1 - Valid passwords: ${validPasswordsCount}")
}

test()
partOne()
