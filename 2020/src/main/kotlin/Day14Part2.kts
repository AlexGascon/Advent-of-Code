import java.io.File

val FILENAME = "src/main/kotlin/day14/input.txt"
val FILENAME_TEST = "src/main/kotlin/day14/input-test-2.txt"


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

data class Program(var mask: String = "", val memory: MutableMap<Long, Long> = mutableMapOf()) {
    companion object {
        const val BINARY_RADIX: Int = 2
        const val X_BIT = 'X'
    }

    fun execute(instruction: Instruction) {
        when (instruction.type) {
            InstructionType.MASK -> mask = instruction.data as String
            InstructionType.MEM -> storeData(instruction)
        }
    }

    fun totalData(): Long = memory.values.sum()

    private fun storeData(instruction: Instruction) {
        val (address, value) = instruction.data as Pair<Long, Long>

        val memoryAddresses = applyMask(address)
        memoryAddresses.forEach { memoryAddress ->
            memory[memoryAddress] = value
        }
    }

    private fun applyMask(address: Long): List<Long> {
        val binaryAddress = address.toString(radix = BINARY_RADIX).padStart(mask.length, '0')
        val maskedAddress = maskAddress(binaryAddress)

        return getAddressPossibilities(maskedAddress).map { it.toLong(BINARY_RADIX) }
    }

    private fun maskAddress(binaryAddress: String): String {
        return binaryAddress
            .foldIndexed(mutableListOf<Char>()) { index, acc, c ->
                when (mask[index]) {
                    '1' -> acc.also { it.add('1') }
                    X_BIT -> acc.also { it.add(X_BIT) }
                    else -> acc.also { it.add(c) }
                }
            }
            .joinToString("")
    }

    private fun getAddressPossibilities(maskedAddress: String): List<String> {
        if (!maskedAddress.contains(X_BIT)) {
            return mutableListOf(maskedAddress)
        }

        val addressPossibilities = mutableListOf(maskedAddress.toString().replaceFirst(X_BIT, '0'), maskedAddress.toString().replaceFirst(X_BIT, '1'))
        return addressPossibilities.map(this::getAddressPossibilities).flatten()
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