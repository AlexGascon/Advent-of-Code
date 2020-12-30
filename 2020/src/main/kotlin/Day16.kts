import java.io.File

val FILENAME = "src/main/kotlin/day16/input.txt"
val FILENAME_TEST = "src/main/kotlin/day16/input-test.txt"
val FILENAME_TEST_PART_TWO = "src/main/kotlin/day16/input-test-part-2.txt"

val WANTED_FIELDS_TEST = listOf("class", "row", "seat")
val WANTED_FIELDS = listOf(
    "departure location", "departure station", "departure platform",
    "departure track", "departure date", "departure time"
)

val OWN_TICKET = "109,101,79,127,71,59,67,61,173,157,163,103,83,97,73,167,53,107,89,131"
val OWN_TICKET_TEST = "11,12,13"

data class TicketRules(val ticketFields: Map<String, Collection<Int>>) {
    fun validRanges(): Collection<Int> {
        return ticketFields.values.reduce { acc, range -> acc.union(range) }
    }

    fun isValid(ticket: Ticket): Boolean {
        return ticket.values.all(validRanges()::contains)
    }
}

class TicketRulesFactory(val input: List<String>) {
    companion object {
        val RANGE_REGEX = "\\d+-\\d+".toRegex()
        val RULE_NAME_SEPARATOR = ":"
    }

    fun createRules(): TicketRules {
        val rulesPortion: List<String> = extractRulesPortion(input)

        val validValues: Map<String, Collection<Int>> = rulesPortion
            .map(this::extractRule)
            .toMap()

        return TicketRules(validValues)
    }

    private fun extractRulesPortion(textLines: List<String>): List<String> {
        val lastRulesLine = textLines.find(String::isBlank)
        return textLines.subList(0, textLines.indexOf(lastRulesLine))
    }

    private fun extractRule(ruleText: String): Pair<String, Collection<Int>> {
        val ruleName = extractRuleName(ruleText)
        val ruleRanges = extractRuleRanges(ruleText)
        val validValuesForRule = combineRanges(ruleRanges)

        return ruleName to validValuesForRule
    }

    private fun extractRuleName(ruleText: String): String {
        return ruleText.split(RULE_NAME_SEPARATOR).first()
    }

    private fun extractRuleRanges(ruleText: String): List<IntRange> {
        return ruleText
            .split(" ")
            .filter(RANGE_REGEX::matches)
            .map (this::extractRangeLimits)
            .map { IntRange(it.first(), it.last()) }
    }

    private fun combineRanges(ranges: List<IntRange>): Set<Int> {
        return ranges.fold(mutableSetOf()) { acc, intRange -> acc.union(intRange).toMutableSet() }
    }

    private fun extractRangeLimits(rangeText: String): List<Int> {
        return rangeText.split("-").map(String::toInt)
    }

}

class TicketFactory() {
    companion object {
        const val VALUE_SEPARATOR = ","
        val TICKET_REGEX = "(\\d+$VALUE_SEPARATOR)+\\d+".toRegex()

        fun createTickets(input: List<String>): List<Ticket> {
            return input
                .filter(TICKET_REGEX::matches)
                .map(this::createTicket)
        }

        fun createTicket(ticketLine: String): Ticket {
            val ticketValues = ticketLine
                .split(VALUE_SEPARATOR)
                .map(String::toInt)

            return Ticket(ticketValues)
        }
    }
}

data class Ticket(val values: List<Int>)

fun parseInput(filename: String): Pair<TicketRules, List<Ticket>> {
    val inputText = File(filename).readLines()
    val ticketRules = TicketRulesFactory(inputText).createRules()
    val tickets = TicketFactory.createTickets(inputText)

    return Pair(ticketRules, tickets)
}

fun findFieldPosition(fieldName: String, validValues: Collection<Int>, tickets: List<Ticket>): Int {
    val ticket = tickets.random()
    val totalFields = ticket.values.size

    val possiblePositions = mutableListOf<Int>()
    for (i in 0 until totalFields) {
        if (tickets.all { ticket -> validValues.contains(ticket.values[i]) }) {
            possiblePositions.add(i)
        }
    }

    println("$fieldName: $possiblePositions")
    return possiblePositions.first()

}

fun solvePartOne(filename: String): Int {
    val (ticketRules, tickets) = parseInput(filename)

    val invalidTickets = tickets.filterNot(ticketRules::isValid)
    val invalidNumbers = invalidTickets
        .map(Ticket::values)
        .flatten()
        .filterNot { ticketRules.validRanges().contains(it) }

    return invalidNumbers.sum()
}

fun solvePartTwo(filename: String, wantedFields: List<String>, ownTicket: Ticket): Int {
    val (ticketRules, tickets) = parseInput(filename)
    val validTickets = tickets.filter(ticketRules::isValid)

    val wantedFieldsRanges = ticketRules
        .ticketFields
        .values

    val wantedPositions: List<Int> = ticketRules
        .ticketFields
        .map { (fieldName, fieldRange) -> findFieldPosition(fieldName, fieldRange, validTickets) }
    val valuesOnMyTicket = wantedPositions.map { ownTicket.values.get(it) }
    return valuesOnMyTicket.reduce { acc, i -> acc * i }
}

fun test() {
    println(solvePartOne(FILENAME_TEST))
}

fun partOne() {
    println(solvePartOne(FILENAME))
}

fun testPartTwo() {
    val ownTicket = TicketFactory.createTicket(OWN_TICKET_TEST)
    println(solvePartTwo(FILENAME_TEST_PART_TWO, WANTED_FIELDS_TEST, ownTicket))
}

fun partTwo() {
    val ownTicket = TicketFactory.createTicket(OWN_TICKET)
    println(solvePartTwo(FILENAME, WANTED_FIELDS, ownTicket))
}

test()
partOne()
testPartTwo()
partTwo()