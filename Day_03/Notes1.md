# Combinational Circuits - I 

## 1. Digital Logic Circuits

Digital logic circuits are classified into:

### A. Combinational Logic Circuits
- Output depends only on the present inputs.
- No memory element is used.
- Examples:
  - Adders
  - Subtractors
  - Multiplexers
  - Decoders

### B. Sequential Logic Circuits
- Output depends on:
  - Present inputs
  - Previous state (memory)
- Examples:
  - Flip-Flops
  - Counters
  - Registers

---

# 2. Combinational Logic Circuits

## Definition
A combinational circuit produces outputs based solely on the current combination of inputs.


### Design Procedure

1. Understand the problem statement.
2. Identify inputs and outputs.
3. Construct the truth table.
4. Simplify Boolean expressions.
5. Implement the logic circuit using gates.

---

# 3. Example: Function Selection Circuit

### Inputs
- Data Inputs:
  - X1
  - X2

- Control Inputs:
  - C1
  - C2

### Output
- Z

### Operations Selected

| C1 | C2 | Operation |
|----|----|-----------|
| 0 | 0 | OR |
| 0 | 1 | XOR |
| 1 | 0 | AND |
| 1 | 1 | XNOR |

The control signals decide which operation is performed on X1 and X2.

---

# 4. Delays in Combinational Circuits

## Propagation Delay (Tpd)

Time required for a change at the input to appear at the output.

### Important Points
- Every logic gate introduces delay.
- Total delay depends on the longest path from input to output.
- This longest path is called the **critical path**.

### Total Delay
Total Delay = Sum of delays along critical path


---

# 5. RTL Design Timing

For a synchronous system:


Clock Period (T)
= Hold Time + Propagation Delay + Setup Time


### Operating Frequency


Frequency = 1 / T


A smaller delay allows a higher clock frequency.

---

# 6. Half Adder

## Purpose
Adds two 1-bit binary numbers.

### Inputs
- A
- B

### Outputs
- Sum (S)
- Carry (C)

### Truth Table

| A | B | Sum | Carry |
|---|---|-----|--------|
| 0 | 0 | 0 | 0 |
| 0 | 1 | 1 | 0 |
| 1 | 0 | 1 | 0 |
| 1 | 1 | 0 | 1 |

### Boolean Expressions

#### Sum


S = A ⊕ B


#### Carry


C = A·B


### Implementation
- XOR gate → Sum
- AND gate → Carry

---

# 7. Full Adder

## Purpose
Adds three 1-bit inputs.

### Inputs
- A
- B
- Cin (Carry In)

### Outputs
- Sum
- Cout (Carry Out)

### Truth Table

| A | B | Cin | Sum | Cout |
|---|---|---|---|---|
| 0 | 0 | 0 | 0 | 0 |
| 0 | 0 | 1 | 1 | 0 |
| 0 | 1 | 0 | 1 | 0 |
| 0 | 1 | 1 | 0 | 1 |
| 1 | 0 | 0 | 1 | 0 |
| 1 | 0 | 1 | 0 | 1 |
| 1 | 1 | 0 | 0 | 1 |
| 1 | 1 | 1 | 1 | 1 |

### Boolean Expressions

#### Sum


Sum = A ⊕ B ⊕ Cin


#### Carry Out


Cout = AB + BCin + ACin


### Implementation
- XOR gates generate Sum.
- AND + OR gates generate Carry.

---

# 8. Full Adder Using Two Half Adders

### Step 1
First Half Adder:


S1 = A ⊕ B
C1 = AB


### Step 2
Second Half Adder:


Sum = S1 ⊕ Cin
C2 = S1·Cin


### Final Carry


Cout = C1 + C2


---

# 9. 4-Bit Ripple Carry Adder

## Purpose
Adds two 4-bit numbers.

### Construction
- Four Full Adders connected in series.
- Carry output of one stage becomes carry input of next stage.

### Example

1010
+0111

10001


### Advantage
- Simple design.

### Disadvantage
- Slow operation due to carry propagation.

---

# 10. Delay in Ripple Carry Adder

### Problem
Carry must travel through every Full Adder.


FA1 → FA2 → FA3 → FA4


### Result
Total delay increases with the number of stages.


Total Delay ≈ n × (Delay of one Full Adder)


Hence Ripple Carry Adders are relatively slow.

---

# 11. Carry Look Ahead Adder (CLA)

## Purpose
Increase addition speed.

### Key Idea
Instead of waiting for carry to ripple through all stages, generate carries in advance.

### Generate Signal (G)


G = A·B


A carry is generated when both inputs are 1.

### Propagate Signal (P)


P = A ⊕ B


A carry is propagated when either input allows an incoming carry to pass.

### Carry Equation


Ci+1 = Gi + PiCi


### Advantages
- Faster than Ripple Carry Adder.
- Reduces carry propagation delay.

### Disadvantage
- More hardware complexity.

---

# 12. Half Subtractor

## Purpose
Subtracts B from A.

### Inputs
- A
- B

### Outputs
- Difference (D)
- Borrow (B)

### Truth Table

| A | B | Diff | Borrow |
|---|---|---|---|
| 0 | 0 | 0 | 0 |
| 0 | 1 | 1 | 1 |
| 1 | 0 | 1 | 0 |
| 1 | 1 | 0 | 0 |

### Boolean Expressions

#### Difference


Diff = A ⊕ B


#### Borrow


Borrow = A'B


### Implementation
- XOR gate → Difference
- AND gate with A complemented → Borrow

---

# 13. Full Subtractor

## Purpose
Subtracts B and Borrow-in from A.

### Inputs
- A
- B
- Bin

### Outputs
- Diff
- Borrow

### Boolean Expressions

#### Difference


Diff = A ⊕ B ⊕ Bin


#### Borrow


Borrow = A'B + A'Bin + BBin


### Implementation
Can be built using:
- Two Half Subtractors
- One OR gate

---

# 14. Full Subtractor Using Two Half Subtractors

### First Half Subtractor


D1 = A ⊕ B
B1 = A'B


### Second Half Subtractor


Diff = D1 ⊕ Bin
B2 = D1'Bin


### Final Borrow


Borrow = B1 + B2


---

# 15. Adder-Subtractor Circuit

## Purpose
Perform both addition and subtraction using the same hardware.

### Mode Control (M)

#### Addition Mode


M = 0

Output = A + B


#### Subtraction Mode


M = 1

Output = A + B' + 1


This uses the 2's complement method:


A - B = A + (2's complement of B)


### Advantages
- Single circuit performs both operations.
- Efficient hardware utilization.

---

# Quick Formula Sheet

## Half Adder


Sum = A ⊕ B
Carry = AB


## Full Adder


Sum = A ⊕ B ⊕ Cin
Cout = AB + BCin + ACin


## Half Subtractor


Diff = A ⊕ B
Borrow = A'B


## Full Subtractor


Diff = A ⊕ B ⊕ Bin
Borrow = A'B + A'Bin + BBin


## Carry Look Ahead Adder


P = A ⊕ B
G = AB

Ci+1 = Gi + PiCi


## RTL Timing


Clock Period = Thold + Tpd + Tsetup

Frequency = 1 / T
