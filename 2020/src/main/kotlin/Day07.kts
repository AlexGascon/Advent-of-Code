import java.io.File
import kotlin.test.assertEquals
import kotlin.test.assertTrue

val FILENAME_TEST = "src/main/kotlin/day07/input-test.txt"
val FILENAME = "src/main/kotlin/day07/input.txt"
val WANTED_BAG = "shiny gold"


data class Node(val value : String, val parents : MutableList<Node>, val children : MutableList<Node>) {
    fun addChildren(node : Node) {
        children.add(node)
    }

    fun addParent(node : Node) {
        parents.add(node)
    }

    override fun toString() : String {
        return "Node(${value}, parents: ${parents.map { it.value }}, children: ${children.map { it.value }}"
    }

    fun getAncestors() : Set<String> {
        val nodeAncestors = mutableSetOf<String>()
        val nodeParents = parents.map { it.value }.toSet()
        val olderAncestors = parents.map { it.getAncestors() }

        nodeAncestors.addAll(nodeParents)
        olderAncestors.forEach { nodeAncestors.addAll(it) }

        return nodeAncestors
    }
}

data class LuggageRuleCollection(val luggageMap: MutableMap<String, Node>) {

    companion object {
        fun createEmpty() : LuggageRuleCollection {
            return LuggageRuleCollection(mutableMapOf())
        }
    }

    fun fillFromListOfRules(luggageRules: List<LuggageRule>) : LuggageRuleCollection {
        luggageRules.forEach { luggageRule ->
            val currentRuleNode = getNodeOrDefault(luggageRule.bagPattern)

            // Add the children and parents
            luggageRule.allowedBags.forEach { bagPattern, _ ->
                val allowedBagNode = getNodeOrDefault(bagPattern)

                currentRuleNode.addChildren(allowedBagNode)
                allowedBagNode.addParent(currentRuleNode)
            }
        }

        return this
    }

    fun getNodeOrDefault(bagPattern : String) : Node {
        return luggageMap.getOrPut(
            bagPattern,
            { -> Node(bagPattern, mutableListOf(), mutableListOf()) }
        )
    }

    fun getContainerCountFor(bagPattern : String) : Int {
        return getNodeOrDefault(bagPattern).getAncestors().size
    }
}


data class LuggageRule(val bagPattern: String, val allowedBags: Map<String, Int>) {
    companion object {
        fun parseFromText(writtenRule: String) : LuggageRule {
            val writtenRule = writtenRule.dropLast(1) // Dropping the dot at the end of the sentence
            val parsedPattern = extractBagPattern(writtenRule)
            val allowedBags = extractAllowedBags(writtenRule)

            return LuggageRule(parsedPattern, allowedBags)
        }

        private fun extractBagPattern(writtenRule : String) : String {
            return writtenRule.split(" bags").first()
        }

        private fun extractAllowedBags(writtenRule: String) : Map<String, Int> {
            val allowedBagsSection = writtenRule.split("contain ").last()
            val allowedBagsList = allowedBagsSection.split(", ")

            return allowedBagsList.map { extractBagPatternAndAmount(it) }.filterNotNull().toMap()
        }

        private fun extractBagPatternAndAmount(allowedBagText: String) : Pair<String, Int>? {
            if(allowedBagText.startsWith("no other")) {
                return null
            }

            val amount = allowedBagText.first().toString().toInt()
            val bagPattern = allowedBagText.split(" ").subList(1, 3).joinToString(" ")

            return Pair(bagPattern, amount)
        }
    }
}

fun readRules(filename : String) : List<LuggageRule>{
    return File(filename).readLines().map { LuggageRule.parseFromText(it) }
}

fun test() {
    val textRule = "light red bags contain 1 bright white bag, 2 muted yellow bags."
    val luggageRule = LuggageRule.parseFromText(textRule)
    println(luggageRule)

    assertEquals("light red", luggageRule.bagPattern)
    assertEquals(2, luggageRule.allowedBags.size)

    val allowedBags = luggageRule.allowedBags
    assertTrue { allowedBags.containsKey("bright white") }
    assertTrue { allowedBags.containsKey("muted yellow") }
    assertEquals(1, allowedBags["bright white"])
    assertEquals(2, allowedBags["muted yellow"])

    val luggageRules = readRules(FILENAME_TEST)
    println(luggageRules)

    val luggageRuleCollection = LuggageRuleCollection.createEmpty().fillFromListOfRules(luggageRules)
    println(luggageRuleCollection)

    println(luggageRuleCollection.getNodeOrDefault("muted yellow"))

    val solution = luggageRuleCollection.getContainerCountFor(WANTED_BAG)

    println("TEST - Shiny gold bag containers: ${solution}")
}

fun partOne() {
    val luggageRules = readRules(FILENAME)
    val luggageRuleCollection = LuggageRuleCollection.createEmpty().fillFromListOfRules(luggageRules)

    val solution = luggageRuleCollection.getContainerCountFor(WANTED_BAG)
    println("Shiny gold bag containers: ${solution}")
}

test()
partOne()