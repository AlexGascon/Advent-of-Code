import java.io.File
import java.io.InvalidObjectException
import kotlin.math.abs

val FILENAME = "src/main/kotlin/day12/input.txt"
val FILENAME_TEST = "src/main/kotlin/day12/input-test.txt"

data class Position(val row: Int, val col: Int) {
    fun manhattanDistance() : Int {
        return abs(row) + abs(col)
    }
}

data class Navigator(val ship: Navigable, val waypoint: Navigable) {
    fun navigate(instruction: NavigationInstruction) {
        when(instruction.type) {
            InstructionType.NORTH -> waypoint.move(instruction.amount, 0)
            InstructionType.EAST -> waypoint.move(0, instruction.amount)
            InstructionType.SOUTH -> waypoint.move(-instruction.amount, 0)
            InstructionType.WEST -> waypoint.move(0, -instruction.amount)
            InstructionType.FORWARD -> ship.move(instruction.amount * waypoint.position.row, instruction.amount * waypoint.position.col)
            InstructionType.LEFT -> waypoint.rotateLeft(instruction.amount)
            InstructionType.RIGHT -> waypoint.rotateRight(instruction.amount)
        }
    }
}

data class Navigable(var position: Position, var orientation: Int) {
    fun move(up: Int, right: Int) {
        val newPosition = Position(position.row + up, position.col + right)
        position = newPosition
    }

    fun rotateLeft(degrees: Int) {
        val timesToRotate : Int = degrees / 90

        IntRange(1, timesToRotate).forEach { _ ->
            position = Position(position.col, -position.row)
        }
    }

    fun rotateRight(degrees: Int) {
        rotateLeft(360 - (degrees % 360))
    }

    private fun moveForward(amount: Int) {
        when {
            isFacingNorth() -> move(amount, 0)
            isFacingEast() -> move(0, amount)
            isFacingSouth() -> move(-amount, 0)
            isFacingWest() -> move(0, -amount)
        }
    }

    private fun turnLeft(amount: Int) {
        val newOrientation = ((orientation + amount) % 360)
        orientation = newOrientation
    }

    private fun turnRight(amount: Int) {
        turnLeft(360 - amount)
    }

    private fun isFacingNorth() : Boolean {
        return orientation == 90
    }

    private fun isFacingEast() : Boolean {
        return orientation == 0
    }

    private fun isFacingSouth() : Boolean {
        return orientation == 270
    }

    private fun isFacingWest() : Boolean {
        return orientation == 180
    }
}

data class NavigationInstruction(val type: InstructionType, val amount: Int) {

    companion object {
        fun createFromText(instructionText: String) : NavigationInstruction {
            return NavigationInstruction(
                InstructionType.getFromChar(instructionText.first()),
                instructionText.drop(1).toInt()
            )
        }
    }
}

enum class InstructionType {
    NORTH, EAST, SOUTH, WEST, RIGHT, LEFT, FORWARD;

    companion object {
        fun getFromChar(instructionChar: Char) : InstructionType {
            return when(instructionChar) {
                'N' -> NORTH
                'E' -> EAST
                'S' -> SOUTH
                'W' -> WEST
                'R' -> RIGHT
                'L' -> LEFT
                'F' -> FORWARD
                else -> throw InvalidObjectException("$instructionChar is not a valid instruction type")
            }
        }
    }
}

fun test() {
    val ship = Navigable(Position(0, 0), 0)
    val waypoint = Navigable(Position(1, 10), 0)
    val navigator = Navigator(ship, waypoint)
    val instructions = File(FILENAME_TEST).readLines().map((NavigationInstruction)::createFromText)

    instructions.forEach(navigator::navigate)

    println(ship.position)
    println("Test - Distance = ${ship.position.manhattanDistance()}")
}

fun partTwo() {
    val ship = Navigable(Position(0, 0), 0)
    val waypoint = Navigable(Position(1, 10), 0)
    val navigator = Navigator(ship, waypoint)
    val instructions = File(FILENAME).readLines().map((NavigationInstruction)::createFromText)

    instructions.forEach(navigator::navigate)

    println(ship.position)
    println("Distance = ${ship.position.manhattanDistance()}")
}

test()
println("-----------------------------------------------------")
println("-----------------------------------------------------")
println("-----------------------------------------------------")
println("-----------------------------------------------------")
partTwo()

