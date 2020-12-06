import java.io.File

val FILENAME_TEST = "src/main/kotlin/day04/input-test.txt"
val FILENAME = "src/main/kotlin/day04/input.txt"

data class Passport(
    val birthYear: String? = null,
    val countryId: String? = null,
    val expirationYear: String? = null,
    val eyeColor: String? = null,
    val hairColor: String? = null,
    val height: String? = null,
    val issueYear: String? = null,
    val passportId: String? = null
) {
    fun isValid(): Boolean {
        try {
            checkNotNull(birthYear) { "Birth year cannot be empty" }
            checkNotNull(expirationYear) { "Expiration year cannot be empty" }
            checkNotNull(eyeColor) { "Eye color cannot be empty"  }
            checkNotNull(hairColor) { "Hair color cannot be empty" }
            checkNotNull(height) { "Height cannot be empty" }
            checkNotNull(issueYear) { "Issue year cannot be empty" }
            checkNotNull(passportId) { "Passport ID cannot be empty" }
            return true
        } catch (e: IllegalStateException) {
            return false
        }
    }
}

class PassportFactory() {
    companion object {
        const val FIELD_BIRTH_YEAR = "byr"
        const val FIELD_COUNTRY_ID = "cid"
        const val FIELD_EXPIRATION_YEAR = "eyr"
        const val FIELD_EYE_COLOR = "ecl"
        const val FIELD_HAIR_COLOR = "hcl"
        const val FIELD_HEIGHT = "hgt"
        const val FIELD_ISSUE_YEAR = "iyr"
        const val FIELD_PASSPORT_ID = "pid"
    }
    fun createPassport(rawData: String): Passport {
        val passportFields = parseFields(rawData)

        return Passport(
            birthYear = passportFields[FIELD_BIRTH_YEAR],
            countryId = passportFields[FIELD_COUNTRY_ID],
            expirationYear = passportFields[FIELD_EXPIRATION_YEAR],
            eyeColor = passportFields[FIELD_EYE_COLOR],
            hairColor = passportFields[FIELD_HAIR_COLOR],
            height = passportFields[FIELD_HEIGHT],
            issueYear = passportFields[FIELD_ISSUE_YEAR],
            passportId = passportFields[FIELD_PASSPORT_ID]
        )
    }

    private fun parseFields(rawData: String): Map<String, String> {
        val fieldCollector = mutableMapOf<String, String>()
        return rawData
            .split("\\s".toRegex())
            .filter { it.isNotBlank() }
            .fold(fieldCollector) { fields, current ->
                val (key, value) = current.split(":")
                fields.apply { put(key, value.trim()) }
            }
    }
}

fun test() {
    val passportsData: List<String> = File(FILENAME_TEST).readText().split("\n\n").filter { it.isNotBlank() }

    val validPassportsCount: Int = passportsData
        .map { passportData -> PassportFactory().createPassport(passportData) }
        .count { passport -> passport.isValid() }

    println("TEST - Valid passports: ${validPassportsCount}")
}

fun partOne() {
    val passportsData: List<String> = File(FILENAME).readText().split("\n\n").filter { it.isNotBlank() }

    val validPassportsCount: Int = passportsData
        .map { passportData -> PassportFactory().createPassport(passportData) }
        .count { passport -> passport.isValid() }

    println("Valid passports: ${validPassportsCount}")
}

test()
partOne()
