import java.io.File

val FILENAME_TEST = "src/main/kotlin/day08/input-test.txt"
val FILENAME = "src/main/kotlin/day08/input.txt"

enum class InstructionType { ACC, NOP, JMP }

data class Instruction(val type : InstructionType, val value : Int) {
    companion object {
        fun createFromText(instructionText : String) : Instruction{
            val (type, value) = instructionText.split(" ")

            return Instruction(InstructionType.valueOf(type.toUpperCase()), value.toInt())
        }
    }
}

class CodeExecutor {
    var accumulator : Int = 0
    var instructionPosition : Int = 0
    var instructionSet = mutableSetOf<Int>()
    var jmpPositions = mutableListOf<Int>()
    var isSuccessfulExecution = false

    fun reset() {
        accumulator = 0
        instructionPosition = 0
        instructionSet = mutableSetOf<Int>()
        jmpPositions = mutableListOf<Int>()
        isSuccessfulExecution = false
    }

    fun runInstructions(instructions : List<Instruction>) {
        while (true) {
            if (isRepeatedInstruction()) {
                println("Hit a repeated instruction! - ${instructionPosition}")
                return
            }

            if (isLastInstructionExecuted(instructions)) {
                println("Executed all the instructions!")
                isSuccessfulExecution = true
                return
            }

            instructionSet.add(instructionPosition)
            runInstruction(instructions[instructionPosition])
        }
    }

    fun runInstruction(instruction : Instruction) {
        when(instruction.type) {
            InstructionType.ACC -> runAcc(instruction)
            InstructionType.JMP -> runJmp(instruction)
            InstructionType.NOP -> runNop(instruction)
        }
    }

    fun runAcc(instruction: Instruction) {
        accumulator += instruction.value
        instructionPosition += 1
    }

    fun runJmp(instruction: Instruction) {
        jmpPositions.add(instructionPosition)
        instructionPosition += instruction.value
    }

    fun runNop(_instruction : Instruction) {
        instructionPosition += 1
    }

    private fun isRepeatedInstruction() : Boolean {
        return instructionSet.contains(instructionPosition)
    }

    private fun isLastInstructionExecuted(instructions: List<Instruction>) : Boolean {
        return instructionPosition >= instructions.size
    }
}

fun partOne() {
    val instructions : List<Instruction> = File(FILENAME).readLines().map((Instruction)::createFromText)
    val codeExecutor = CodeExecutor()

    codeExecutor.runInstructions(instructions)

    println("SOLUTION = ${codeExecutor.accumulator}")
}

fun partTwo() {
    var instructions : MutableList<Instruction> = File(FILENAME).readLines().map((Instruction)::createFromText).toMutableList()
    val codeExecutor = CodeExecutor()
    codeExecutor.runInstructions(instructions)

    val jmpPositions = codeExecutor.jmpPositions
    var currentModifiedJmp = 0

    while(!codeExecutor.isSuccessfulExecution && currentModifiedJmp < jmpPositions.size) {
        val jmpPosition = jmpPositions[currentModifiedJmp]
        val modifiedInstructions = instructions.toMutableList()
        // We don't care about the value as it's a NOP
        modifiedInstructions[jmpPosition] = Instruction(InstructionType.NOP, +1)

        codeExecutor.reset()
        codeExecutor.runInstructions(modifiedInstructions)

        if(codeExecutor.isSuccessfulExecution) {
            println("Modified jmp: ${jmpPosition}")
        }

        currentModifiedJmp += 1
    }

    println("SOLUTION = ${codeExecutor.accumulator}")
}

//partOne()
partTwo()