import java.io.File

data class PasswordCandidate(val firstPosition: Int, val secondPosition: Int, val desiredLetter: Char, val password: String) {
    fun validate(): Boolean {
        val firstPositionMatch = password[firstPosition - 1] == desiredLetter
        val secondPositionMatch = password[secondPosition - 1] == desiredLetter

        return firstPositionMatch.xor(secondPositionMatch)
    }
}

val FILENAME = "src/main/kotlin/day02/input.txt"
val FILENAME_TEST = "src/main/kotlin/day02/input-test.txt"

// 1-3 b: cdefg
fun parsePassword(line: String): PasswordCandidate {
    val parts: List<String> = line.split(" ")

    val positions: List<Int> = parts.get(0).split("-").map { it.toInt() }
    val desiredLetter = parts.get(1).get(0).toChar()
    val password = parts.get(2)

    return PasswordCandidate(positions[0], positions[1], desiredLetter, password)
}

fun test() {
    val lines: List<String> = File(FILENAME_TEST).readLines()

    val validPasswordsCount: Int = lines.map { parsePassword(it) }.count { passwordCandidate -> passwordCandidate.validate() }
    println("TEST - Valid passwords: ${validPasswordsCount}")
}

fun partTwo() {
    val lines: List<String> = File(FILENAME).readLines()

    val validPasswordsCount: Int = lines.map { parsePassword(it) }.count { passwordCandidate -> passwordCandidate.validate() }
    println("PART 2 - Valid passwords: ${validPasswordsCount}")
}

test()
partTwo()
