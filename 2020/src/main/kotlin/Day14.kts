import java.io.File

val FILENAME = "src/main/kotlin/day14/input.txt"
val FILENAME_TEST = "src/main/kotlin/day14/input-test.txt"


data class Instruction(val type: InstructionType, val data: Any) {
    companion object {
        const val MASK_PREFIX= "mask"
        const val MEM_PREFIX = "mem"
        const val MEMORY_START = "["
        const val MEMORY_END = "]"
        const val VALUE_SEPARATOR= " = "

        fun fromText(instructionText: String): Instruction {
            return when {
                isMask(instructionText) -> createMaskInstruction(instructionText)
                isMem(instructionText) -> createMemInstruction(instructionText)
                else -> throw Exception("Unknown instruction type")
            }
        }

        private fun isMask(instructionText: String) = instructionText.startsWith(MASK_PREFIX)
        private fun isMem(instructionText: String) = instructionText.startsWith(MEM_PREFIX)

        private fun createMaskInstruction(instructionText: String): Instruction {
            return Instruction(InstructionType.MASK, instructionText.split(VALUE_SEPARATOR).last())
        }

        private fun createMemInstruction(instructionText: String): Instruction {
            val position = instructionText
                .substring(instructionText.indexOf(MEMORY_START) + 1, instructionText.indexOf(MEMORY_END))
                .toInt()
            val value = instructionText.split(VALUE_SEPARATOR).last().toLong()

            return Instruction(InstructionType.MEM, Pair(position, value))
        }
    }
}

enum class InstructionType {
    MASK, MEM
}

data class Program(var mask: String = "", val memory: MutableMap<Int, Long> = mutableMapOf()) {
    companion object {
        val BINARY_RADIX: Int = 2
    }

    fun execute(instruction: Instruction) {
        when (instruction.type) {
            InstructionType.MASK -> mask = instruction.data as String
            InstructionType.MEM -> storeData(instruction)
        }
    }

    fun totalData(): Long = memory.values.sum()

    private fun storeData(instruction: Instruction) {
        val (position, value) = instruction.data as Pair<Int, Long>
        val valueToStore = applyMask(value)

        memory[position] = valueToStore
    }

    private fun applyMask(value: Long): Long {
        val binaryValue = value.toString(radix = BINARY_RADIX).padStart(mask.length, '0')
        val initialList = mutableListOf<Char>()
        val result = binaryValue.foldIndexed(initialList) { index, acc, c ->
            acc.apply {
                when (mask[index]) {
                    '1' -> add('1')
                    '0' -> add('0')
                    else -> add(c)
                }
            }
        }

        return result.joinToString("").toLong(BINARY_RADIX)
    }
}

fun solve(filename: String) {
    val program = Program()

    File(filename)
        .readLines()
        .map((Instruction)::fromText)
        .also(::println)
        .forEach(program::execute)

    println(program)
    println("SOLUTION - ${program.totalData()}")
    println()
}

solve(FILENAME_TEST)
solve(FILENAME)