# Registers
R0 - R31
// 32 General Purpose signed 32-bit registers

# Dat Types
INT8
INT16
INT32

# Core Instructions
| Opcode | Mnemonic | Description         |
| ------ | -------- | ------------------- |
| 0x00   | NOP      | Do nothing          |
| 0x01   | LOAD     | Load register       |
| 0x02   | STORE    | Store register      |
| 0x03   | MOV      | Copy register       |
| 0x10   | ADD      | Integer add         |
| 0x11   | SUB      | Integer subtract    |
| 0x12   | MUL      | Integer multiply    |
| 0x13   | MAC      | Multiply accumulate |
| 0x14   | MAX      | Maximum             |
| 0x15   | MIN      | Minimum             |
| 0x16   | ABS      | Absolute value      |
| 0x20   | SHL      | Shift left          |
| 0x21   | SHR      | Shift right         |
