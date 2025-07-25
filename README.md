# MIPS-like Processor on FPGA

## Overview

This repository contains the Verilog HDL implementation of a 32-bit MIPS-like processor designed for deployment on an FPGA. The project covers the full design cycle, from defining the architecture and instruction set to implementing core modules and integrating them into a functional system. The processor is capable of executing a variety of instructions, including arithmetic, logical, data transfer, control flow, and stack operations, and interacts with external I/O peripherals.

## Features

* [cite_start]**MIPS-like Architecture (RISC Principles)**: Designed for simplicity and efficiency in instruction execution. [cite: 2]
* **32-bit Fixed Instruction Size**: Uniform instruction format for simplified decoding and pipelining.
* **64 General-Purpose Registers**: Including dedicated registers for zero (`$zero`), return address (`$ra`), and stack pointer (`$rp`).
* **Harvard Architecture**: Separate instruction and data memories for simultaneous access, enhancing efficiency.
* **Monocycle Datapath**: Each instruction completes within a single clock cycle.
* **SISD (Single Instruction, Single Data)**: Processes one instruction and one data stream at a time.
* [cite_start]**36 Distinct Instructions**: Covering a wide range of operations (arithmetic, logical, data transfer, conditional/unconditional jumps, stack operations, I/O). [cite: 2]
* [cite_start]**6 Instruction Formats**: Optimized for various operation types, including register-to-register, immediate, and jump instructions. [cite: 2]
* [cite_start]**3 Addressing Modes**: Supports Direct, Register Indirect, and Base-Displacement addressing for memory access. [cite: 2]
* [cite_start]**FPGA Implementation**: Designed and tested on an Altera DE2-115 Cyclone IV FPGA. [cite: 2]

## Repository Contents

This repository is organized as follows:

* `.v` files: Contains all Verilog HDL modules that make up the processor.
* `.txt` files: Contains machine code for testing the processor's functionality.
* `Imagens/` (Directory): Contains diagrams and waveforms illustrating the processor's architecture and simulation results.

### Verilog Modules (`.v` files)

The following core modules are implemented in Verilog HDL:

* `ULA.v`: Arithmetic Logic Unit, performing all arithmetic and logical operations.
* `BancoRegistradores.v`: Register File, managing 64 general-purpose registers and special registers.
* `MemoriaDados.v`: Data Memory (RAM), for run-time data storage and retrieval.
* `MemoriaInstrucoes.v`: Instruction Memory (ROM), pre-loaded with program instructions.
* `PC.v`: Program Counter, managing the address of the current instruction.
* `mux.v`: Generic 2-to-1 Multiplexer.
* `Adder.v`: 32-bit Adder module, used for PC increment and address calculations.
* `Extensor.v`: Bit Extender, for sign/zero extending immediate values.
* `UnidadeControle.v`: Control Unit, decodes instructions and generates control signals for the entire datapath.
* `UC_Pilha.v`: Stack Control Unit, manages stack pointer updates for PUSH/POP operations.
* `Divisor_Freq.v`: Clock Frequency Divider, to generate a slower clock for the processor logic from the FPGA's high-frequency clock.
* `DBounce.v`: Debouncer, to filter mechanical noise from physical button inputs.
* `BinToBcdConverter.v`: Converts binary values to Binary-Coded Decimal for display.
* `BcdTo7SegmentDecoder.v`: Decodes BCD digits to 7-segment display patterns.
* `ModuloEntradaSaida.v`: I/O module, handles input from switches and output to 7-segment displays.
* `Processador_Jonas.v`: Top-level module integrating all components to form the complete processor system.

### Test Codes (`.txt` files)

* `codigo_teste.txt`: Contains the machine code (binary instructions) that the `MemoriaInstrucoes` module loads and the processor executes. This file is dynamically updated with different test programs.
    * Examples of test programs included:
        * **Fibonacci Sequence**: Calculates Fibonacci numbers for a given input position.
        * **JR and JAL Test**: Demonstrates the functionality of Jump Register and Jump and Link instructions.

## Getting Started

To simulate or deploy this processor, you will need:

### Prerequisites

* A Verilog HDL simulator (e.g., ModelSim, QuestaSim).
* An FPGA development environment (e.g., Intel Quartus Prime for Altera FPGAs).
* An Altera DE2-115 Cyclone IV FPGA board (for hardware deployment).

### Simulation

1.  **Clone the repository**:
    ```bash
    git clone [https://github.com/your-username/your-repo-name.git](https://github.com/your-username/your-repo-name.git)
    cd your-repo-name
    ```
2.  **Open your Verilog simulator.**
3.  **Compile all `.v` files.** Ensure `Processador_Jonas.v` is the top-level entity.
4.  **Load `codigo_teste.txt` into the `MemoriaInstrucoes` module's initialization.** (This is handled by `$readmemb("codigo_teste.txt", rom);` in `MemoriaInstrucoes.v`).
5.  **Run the simulation.** Observe the waveforms for control signals, register values, memory access, and I/O. Expected waveforms and their analyses are provided in the `Imagens/` directory.

### FPGA Deployment

1.  **Open Intel Quartus Prime (or your preferred FPGA IDE).**
2.  **Create a new project** and add all `.v` files to it. Set `Processador_Jonas.v` as the top-level entity.
3.  **Configure pin assignments** according to your DE2-115 board's specific pinout for clock, reset, switches (`switches[9:0]`), confirm button (`confirm`), and 7-segment displays (`HEX[0-7]`).
4.  **Synthesize, Fit, and Assemble the design.**
5.  **Program the FPGA** with the generated `.sof` file.
6.  **Interact with the processor:**
    * Use the DIP switches to provide input values for instructions like `IN`.
    * Press the designated confirm button (connected to `confirm`) to validate input or advance paused execution (e.g., after an `IN` instruction).
    * Observe the results on the 7-segment displays (`OUT` instruction).

## Results and Verification

The processor's functionality has been rigorously validated through:

* **Extensive Module-Level Simulations**: Each individual Verilog module (ULA, Register File, Memories, PC, Control Unit, etc.) was simulated and verified for correct behavior. [cite_start]Waveforms and detailed analyses for key modules are available in the `Imagens/` directory. [cite: 2]
* [cite_start]**Integrated Datapath Simulations**: Simulations of the fully integrated processor confirmed the correct flow of data and control signals across all interconnected modules. [cite: 2]
* **Hardware Tests on FPGA**:
    * [cite_start]**Fibonacci Sequence Calculation**: Successfully demonstrated the processor's ability to handle loops, arithmetic operations, and memory access. [cite: 2]
    * [cite_start]**JR and JAL Instruction Test**: Verified the functionality of jump and link instructions, confirming correct subroutine calls and returns. [cite: 2]

## Difficulties Encountered and Future Work

During development, some challenges were faced:

* [cite_start]**Debugging**: Identifying and resolving issues in Verilog code when modules did not function as expected required careful debugging of waveforms. [cite: 2]
* [cite_start]**Datapath Logic Changes**: Adjustments to the initial Datapath logic were necessary, such as replacing a single I/O multiplexer with internal selection within the I/O module. [cite: 2]

Potential areas for future improvement and optimization include:

* [cite_start]**Memory Optimization**: Exploring techniques to optimize memory access times and compilation performance, which were slightly above expectations. [cite: 2]
* **Pipelining**: Implementing a deeper pipeline to enhance instruction throughput (currently monocycle).
* **Extended Instruction Set**: Adding more complex instructions or floating-point support.

## Contributing

Contributions are welcome! If you find any issues or have suggestions for improvements, please open an issue or submit a pull request.

## License

This project is licensed under the [MIT License](LICENSE) - see the `LICENSE` file for details.

## Acknowledgements

This project was developed as part of the "Laboratório de Sistemas Computacionais: Arquitetura e Organização de Computadores" course at the **Universidade Federal de São Paulo (UNIFESP)**, Campus São José dos Campos, Instituto de Ciência e Tecnologia. [cite_start]Special thanks to Prof. Dr. Sérgio Ronaldo Barros dos Santos for guidance and support. [cite: 1, 5]
