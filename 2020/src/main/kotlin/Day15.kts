val TURN_WANTED_PART_ONE = 2020
val TURN_WANTED_PART_TWO = 30000000
val INPUT = listOf(9,6,0,10,18,2,1)
val INPUT_TEST = listOf(0, 3, 6)

class MemoryGame {
    var currentTurn: Int = 1
    var lastNumber: Int = 0
    var currentNumber: Int = 0
    var lastTurnSeen = mutableMapOf<Int, Int>()

    fun playTurn() {
        if (wasFirstAppearance(lastNumber)) {
            currentNumber = 0
        } else {
            currentNumber = (currentTurn-1) - lastTurnSeen[lastNumber]!!
        }

        lastTurnSeen[lastNumber] = currentTurn - 1

        lastNumber = currentNumber
        currentTurn++
    }

    private fun wasFirstAppearance(number: Int): Boolean {
        return !(number in lastTurnSeen) || (lastTurnSeen[number]!! == currentTurn - 1)
    }

    companion object {
        fun start(startingSequence: List<Int>): MemoryGame {
            val game = MemoryGame()
            startingSequence.forEachIndexed { index, number ->
                game.lastTurnSeen[number] = index + 1
                game.currentTurn++
                game.lastNumber = number
            }

            return game
        }
    }

    override fun toString(): String {
        return "MemoryGame(currentTurn = $currentTurn, currentNumber = $currentNumber, lastTurnSeen = $lastTurnSeen)"
    }
}

fun completeGame(startingNumbers: List<Int>, turnWanted: Int) {
    val game = MemoryGame.start(startingNumbers)
    while (game.currentTurn <= turnWanted) {
        game.playTurn()
    }

    println("SOLUTION - ${game.currentNumber}")
}

completeGame(INPUT_TEST, TURN_WANTED_PART_ONE)
completeGame(INPUT, TURN_WANTED_PART_ONE)
completeGame(INPUT, TURN_WANTED_PART_TWO)

