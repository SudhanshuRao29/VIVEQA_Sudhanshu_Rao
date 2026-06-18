# Combinational Circuits - II 

## Topics Covered

* Encoders
* Priority Encoders
* Decoders
* Multiplexers (MUX)
* Demultiplexers (DeMUX)
* Tri-State Buffers

---

# 1. Encoders

## Definition

An Encoder converts multiple input lines into a smaller number of binary output lines.

### Key Points

* Converts human-understandable information into machine-readable binary code.
* Only one input should be active at a time.
* For `2ⁿ` inputs, there are `n` output bits.
* Also called a **One-Hot to Binary Converter**.

### Example: 4-to-2 Encoder

Inputs:

* D0, D1, D2, D3

Outputs:

* Y1, Y0

| Active Input | Output |
| ------------ | ------ |
| D0           | 00     |
| D1           | 01     |
| D2           | 10     |
| D3           | 11     |

---

# 2. Decimal to Binary Encoder

## Function

Converts decimal inputs (0–9) into a 4-bit binary number.

### Example

| Decimal Input | Binary Output |
| ------------- | ------------- |
| 0             | 0000          |
| 1             | 0001          |
| 2             | 0010          |
| 3             | 0011          |
| 4             | 0100          |
| 5             | 0101          |
| 6             | 0110          |
| 7             | 0111          |
| 8             | 1000          |
| 9             | 1001          |

### Problems

* What if multiple inputs are active?
* What if no input is active?

These problems are solved using **Priority Encoders**.

---

# 3. Priority Encoder

## Definition

A Priority Encoder assigns priority to inputs when multiple inputs are active simultaneously.

### Key Features

* Highest-priority input determines the output.
* Includes a **Valid (V)** signal.
* Valid signal indicates whether any input is active.

### Example: 8-to-3 Priority Encoder

Inputs:

* D0 to D7

Outputs:

* Y2, Y1, Y0

Priority:

```
D7 > D6 > D5 > D4 > D3 > D2 > D1 > D0
```

If D7 and D3 are both HIGH:

```
Output = Binary code of D7
```

---

# 4. ASCII Encoder

## ASCII

ASCII stands for:

```
American Standard Code for Information Interchange
```

### Features

* Uses 7 bits.
* Represents 128 unique characters.
* Used for:

  * Letters
  * Numbers
  * Symbols
  * Control characters

Example:

| Character | ASCII Binary |
| --------- | ------------ |
| A         | 1000001      |
| B         | 1000010      |
| a         | 1100001      |
| 0         | 0110000      |

---

# 5. Decoders

## Definition

A Decoder converts binary inputs into one active output line.

### Key Points

* Opposite of an Encoder.
* Converts machine code into human-understandable form.
* Converts `n` inputs into `2ⁿ` outputs.

### Applications

* Memory address decoding
* Seven-segment displays
* Data routing
* Demultiplexing

---

# 6. 2-to-4 Decoder

## Inputs

* D1
* D0

## Outputs

* Y0
* Y1
* Y2
* Y3

### Truth Table

| D1 | D0 | Active Output |
| -- | -- | ------------- |
| 0  | 0  | Y0            |
| 0  | 1  | Y1            |
| 1  | 0  | Y2            |
| 1  | 1  | Y3            |

### Equations

```text
Y0 = D1' D0'
Y1 = D1' D0
Y2 = D1 D0'
Y3 = D1 D0
```

These outputs represent all possible minterms.

---

# 7. Decoder with Enable Input

## Purpose

Enable pin controls whether decoder operates.

### Active HIGH Enable

| Enable | Operation        |
| ------ | ---------------- |
| 1      | Decoder Active   |
| 0      | Decoder Disabled |

### Active LOW Enable

| Enable | Operation        |
| ------ | ---------------- |
| 0      | Decoder Active   |
| 1      | Decoder Disabled |

---

# 8. BCD to Seven Segment Decoder

## Purpose

Converts a BCD number into signals required to drive a seven-segment display.

### Example

Input:

```
0101 (BCD 5)
```

Output:

* Segments required to display digit 5 are turned ON.

---

# 9. Implementing Logic Functions Using Decoders

### Important Concept

An `n-to-2ⁿ` decoder generates all possible minterms.

Therefore:

```text
Any Boolean function can be implemented
using a decoder and OR gates.
```

### Active HIGH Decoder

Uses:

```
Sum of Minterms (SOP)
```

### Active LOW Decoder

Uses:

```
Product of Maxterms (POS)
```

---

# 10. Full Adder Using Decoder

Given:

```text
Sum  = Σm(1,2,4,7)
Cout = Σm(3,5,6,7)
```

Using:

```
3-to-8 Decoder
```

Decoder generates all minterms.

Required minterms are combined using OR gates.

---

# 11. Multiplexer (MUX)

## Definition

A Multiplexer selects one input from many inputs and sends it to the output.

### Also Called

```
Data Selector
```

### Components

* Data Inputs
* Select Lines
* Single Output

---

# 12. 4-to-1 Multiplexer

## Inputs

```
I0, I1, I2, I3
```

## Select Lines

```
S1, S0
```

## Output

```
Y
```

### Selection Table

| S1 | S0 | Output |
| -- | -- | ------ |
| 0  | 0  | I0     |
| 0  | 1  | I1     |
| 1  | 0  | I2     |
| 1  | 1  | I3     |

### Output Equation

```text
Y = S1'S0'I0 +
    S1'S0 I1 +
    S1 S0'I2 +
    S1 S0 I3
```

---

# 13. MUX as Universal Logic

A Multiplexer can implement any Boolean function.

### Similar To

* NAND Gate
* NOR Gate

### Methods

1. Truth Table Method
2. Shannon Expansion Method

---

# 14. Logic Gates Using MUX

## NOT Gate

Using 2:1 MUX:

```text
I0 = 1
I1 = 0
Select = A

Output = A'
```

---

## AND Gate

Using 2:1 MUX:

```text
I0 = 0
I1 = B
Select = A

Output = AB
```

---

## NAND Gate

```text
Output = (AB)'
```

---

## NOR Gate

```text
Output = (A + B)'
```

---

# 15. Shannon Expansion

For a 2:1 MUX:

```text
Y = S'I0 + SI1
```

This equation is known as:

```text
Shannon Expansion Theorem
```

Used to implement complex Boolean functions using MUX.

---

# 16. Hierarchical Design

## Problem

Large multiplexers require:

* Too many gates
* High fan-in
* Complex wiring

## Solution

Build large circuits using smaller blocks.

Example:

```text
4:1 MUX using three 2:1 MUXs
```

Advantages:

* Easier design
* Modular structure
* Better scalability

---

# 17. 4:1 MUX Using 2:1 MUX

### Step 1

Use two 2:1 MUXs:

```text
MUX1 → Select between I0 and I1
MUX2 → Select between I2 and I3
```

### Step 2

Use another 2:1 MUX:

```text
Select between outputs of MUX1 and MUX2
```

Result:

```
4:1 Multiplexer
```

---

# 18. 8:1 MUX Using Smaller MUXs

Can be implemented using:

```text
Two 4:1 MUXs
+
One 2:1 MUX
```

This is called hierarchical implementation.

---

# 19. Demultiplexer (DeMUX)

## Definition

A Demultiplexer routes one input to one of many outputs.

### Opposite of MUX

```text
MUX    : Many Inputs → One Output
DeMUX  : One Input → Many Outputs
```

---

# 20. 1-to-4 DeMUX

## Inputs

* Data Input (I)
* Select Lines (S1, S0)

## Outputs

* Y0
* Y1
* Y2
* Y3

### Selection Table

| S1 | S0 | Active Output |
| -- | -- | ------------- |
| 0  | 0  | Y0            |
| 0  | 1  | Y1            |
| 1  | 0  | Y2            |
| 1  | 1  | Y3            |

---

# 21. Tri-State Buffer

## Definition

A buffer with three possible output states:

```text
0
1
Z (High Impedance)
```

### High Impedance (Z)

Output behaves like an open circuit.

---

## Active HIGH Tri-State Buffer

| Control | Output                  |
| ------- | ----------------------- |
| 1       | Input appears at output |
| 0       | Z                       |

---

## Active LOW Tri-State Buffer

| Control | Output                  |
| ------- | ----------------------- |
| 0       | Input appears at output |
| 1       | Z                       |

---

# Quick Revision Sheet

## Encoder

```text
2ⁿ Inputs → n Outputs
```

---

## Decoder

```text
n Inputs → 2ⁿ Outputs
```

---

## Priority Encoder

```text
Highest-priority active input wins.
```

---

## Multiplexer

```text
Many Inputs → One Output
```

---

## Demultiplexer

```text
One Input → Many Outputs
```

---

## Tri-State Buffer

```text
Outputs: 0, 1, Z
```

---

## Shannon Expansion

```text
Y = S'I0 + SI1
```

---

## Universal Logic Using MUX

Can implement:

* NOT
* AND
* OR
* NAND
* NOR
* Any Boolean Function

---


