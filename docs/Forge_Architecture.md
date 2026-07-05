# ForgeAI Architecture Specification

Version: 0.1

Author: Daniel Simpson

Status: Draft

---

# Vision

ForgeAI is a programmable parallel compute accelerator designed from first principles.

Unlike fixed-function AI accelerators, ForgeAI is intended to accelerate a broad range of highly parallel numerical workloads including:

- Artificial Intelligence
- Matrix Mathematics
- Scientific Computing
- Image Processing
- Signal Processing
- Simulation
- Automation Algorithms

ForgeAI emphasizes:

- Simplicity
- Scalability
- Modularity
- Educational Value
- High Performance

---

# Design Philosophy

ForgeAI is not intended to compete directly with commercial GPUs.

Instead, ForgeAI exists to explore modern accelerator architecture while remaining understandable and extensible.

Every hardware block shall be:

- Modular
- Parameterized
- Verified
- Documented

No black-box IP shall be used unless specifically approved.

# System Hierarchy
Computer

↓

PCIe Interface

↓

Command Processor

↓

Forge Cores

↓

Execution Lanes

↓

Arithmetic Units

↓

Registers

# ForgeCore

├── Register File

├── Execution Lane

├── Instruction Decoder

├── Control FSM

├── Local Scratch Memory

└── Result Interface

# Execution Lane

Activation Register

Weight Register

MAC

Integer ALU

Output Register

# Register File
32 Registers

32-bit signed

R0-R31

# Instruction Format
31........24

Opcode

23........16

Destination

15.........8

Source A

7..........0

Source B

# Future Execution Units
Integer ALU

MAC

Divider

Activation Unit

Shift Unit

Reduction Unit

Vector Unit

# Memory Hierarchy
Registers

↓

Scratch RAM

↓

Tile Memory

↓

DDR

↓

Host Memory

# Long Term Goals
Version 1

Single Execution Lane

↓

Version 2

Single ForgeCore

↓

Version 3

Multiple ForgeCores

↓

Version 4

PCIe Accelerator

↓

Version 5

Multi-FPGA Board

↓

Version 6

Custom ASIC


