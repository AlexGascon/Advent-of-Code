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
    val instructionSet = mutableSetOf<Int>()

    fun runInstructions(instructions : List<Instruction>) {
        while (true) {
            if (instructionSet.contains(instructionPosition)) {
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
        instructionPosition += instruction.value
    }

    fun runNop(_instruction : Instruction) {
        instructionPosition += 1
    }
}

fun test() {
    val instructions : List<Instruction> = File(FILENAME).readLines().map((Instruction)::createFromText)
    val codeExecutor = CodeExecutor()

    codeExecutor.runInstructions(instructions)

    println("TEST SOLUTION = ${codeExecutor.accumulator}")
}

test()
