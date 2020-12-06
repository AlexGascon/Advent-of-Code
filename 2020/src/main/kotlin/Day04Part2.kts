import Day04_02.Height.isHeight
import org.valiktor.Constraint
import org.valiktor.ConstraintViolationException
import org.valiktor.Validator
import org.valiktor.functions.*
import java.io.File
import org.valiktor.validate

val FILENAME_TEST = "src/main/kotlin/day04/input-test.txt"
val FILENAME = "src/main/kotlin/day04/input.txt"

data class Passport(
    val birthYear: Int? = null,
    val countryId: String? = null,
    val expirationYear: Int? = null,
    val eyeColor: String? = null,
    val hairColor: String? = null,
    val height: String? = null,
    val issueYear: Int? = null,
    val passportId: String? = null
) {
    fun isValid(): Boolean {
        try {
            validate(this) {
                validate(Passport::birthYear).isNotNull().isBetween(1920, 2002)
                validate(Passport::expirationYear).isNotNull().isBetween(2020, 2030)
                validate(Passport::eyeColor).isNotNull().isIn(setOf("amb", "blu", "brn", "gry", "grn", "hzl", "oth"))
                validate(Passport::hairColor).isNotNull().matches("^#[a-z0-9]{6}$".toRegex())
                validate(Passport::height).isNotNull().isHeight()
                validate(Passport::issueYear).isNotNull().isBetween(2010, 2020)
                validate(Passport::passportId).isNotNull().matches("^[0-9]{9}$".toRegex())
            }
        } catch(e: ConstraintViolationException) {
            println(this)
            return false
        }

        return true
    }
}

object Height : Constraint {
    fun <Passport> Validator<Passport>.Property<String?>.isHeight() {
        this.validate(Height) { height ->
            if (height == null) {
                return@validate false
            }
            val unit: String = height.takeLast(2)
            val validUnit: Boolean = unit.matches("cm|in".toRegex())

            if (!validUnit) {
                return@validate false
            }

            if (unit == "cm") {
                return@validate height.length == 5 && IntRange(150, 193).contains(height.take(3).toInt())
            } else {
                return@validate height.length == 4 && IntRange(59, 76).contains(height.take(2).toInt())
            }
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
            birthYear = passportFields[FIELD_BIRTH_YEAR]?.toInt(),
            countryId = passportFields[FIELD_COUNTRY_ID],
            expirationYear = passportFields[FIELD_EXPIRATION_YEAR]?.toInt(),
            eyeColor = passportFields[FIELD_EYE_COLOR],
            hairColor = passportFields[FIELD_HAIR_COLOR],
            height = passportFields[FIELD_HEIGHT],
            issueYear = passportFields[FIELD_ISSUE_YEAR]?.toInt(),
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

fun partTwo() {
    val passportsData: List<String> = File(FILENAME).readText().split("\n\n").filter { it.isNotBlank() }

    val validPassportsCount: Int = passportsData
        .map { passportData -> PassportFactory().createPassport(passportData) }
        .count { passport -> passport.isValid() }

    println("Valid passports: ${validPassportsCount}")
}

test()
partTwo()
