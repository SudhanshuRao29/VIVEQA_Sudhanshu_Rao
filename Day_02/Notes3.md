# Day 2 - Logic Circuits

## Topics Covered

* Logic Gates
* Boolean Algebra
* NAND and NOR Circuits
* Logic Minimization
* SOP and POS Forms

---

# Logic Gates

## NOT Gate (Inverter)

* Produces the complement of the input.
* If input is 0, output is 1.
* If input is 1, output is 0.

**Boolean Expression**

```text
Y = A'
```

---

## AND Gate

* Output is 1 only when all inputs are 1.

**Boolean Expression**

```text
Y = A.B
```

### Truth Table

| A | B | Y |
| - | - | - |
| 0 | 0 | 0 |
| 0 | 1 | 0 |
| 1 | 0 | 0 |
| 1 | 1 | 1 |

---

## OR Gate

* Output is 1 when at least one input is 1.

**Boolean Expression**

```text
Y = A + B
```

### Truth Table

| A | B | Y |
| - | - | - |
| 0 | 0 | 0 |
| 0 | 1 | 1 |
| 1 | 0 | 1 |
| 1 | 1 | 1 |

---

## NOR Gate

* Complement of OR gate.
* Output is 1 only when all inputs are 0.

**Boolean Expression**

```text
Y = (A + B)'
```

### Truth Table

| A | B | Y |
| - | - | - |
| 0 | 0 | 1 |
| 0 | 1 | 0 |
| 1 | 0 | 0 |
| 1 | 1 | 0 |

---

## XOR Gate

* Output is 1 when inputs are different.

**Boolean Expression**

```text
Y = A ⊕ B
```

Equivalent form:

```text
Y = A'B + AB'
```

### Truth Table

| A | B | Y |
| - | - | - |
| 0 | 0 | 0 |
| 0 | 1 | 1 |
| 1 | 0 | 1 |
| 1 | 1 | 0 |

### Properties of XOR

* If one input is 0, output equals the other input.
* If one input is 1, output equals complement of the other input.
* Used as:

  * Odd parity detector
  * Even parity generator

---

## XNOR Gate

* Output is 1 when inputs are equal.
* Also called Equality Gate.
* Complement of XOR.

**Boolean Expression**

```text
Y = AB + A'B'
```

### Truth Table

| A | B | Y |
| - | - | - |
| 0 | 0 | 1 |
| 0 | 1 | 0 |
| 1 | 0 | 0 |
| 1 | 1 | 1 |

---

# Boolean Algebra

## Basic Laws

### Identity Laws

```text
X + 0 = X
X . 1 = X
```

### Null Laws

```text
X + 1 = 1
X . 0 = 0
```

### Idempotent Laws

```text
X + X = X
X . X = X
```

### Complement Laws

```text
X + X' = 1
X . X' = 0
```

### Involution Law

```text
(X')' = X
```

### Commutative Laws

```text
X + Y = Y + X
X . Y = Y . X
```

### Associative Laws

```text
X + (Y + Z) = (X + Y) + Z
X . (Y . Z) = (X . Y) . Z
```

### Distributive Laws

```text
X(Y + Z) = XY + XZ
(X + Y)(X + Z) = X + YZ
```

---

# Consensus Theorem

Used to simplify Boolean expressions.

```text
AB + AC + BC = AB + AC
```

The term BC is redundant and can be removed.

### Example

```text
AB + AC + BC
= AB + AC
```

This reduces hardware complexity.

---

# DeMorgan's Theorems

### First Theorem

```text
(A.B)' = A' + B'
```

### Second Theorem

```text
(A + B)' = A'.B'
```

Used extensively in NAND and NOR implementations.

---

# Complement of Boolean Functions

To find the complement of a Boolean function:

### Example

Given:

```text
F = AB + BD + AD
```

Apply duality and DeMorgan's theorem:

```text
F' = (A + B)(B + D)(A + D)
```

---

# Logic Circuit from Boolean Function

### Example

Given:

```text
Y = AB + CD
```

Steps:

1. Generate AB using an AND gate.
2. Generate CD using another AND gate.
3. Combine both outputs using an OR gate.

Result:

```text
Y = AB + CD
```

---

# Boolean Function from Logic Circuit

Procedure:

1. Start from the input side.
2. Determine output of each gate.
3. Continue stage by stage.
4. Write final Boolean expression.

This method helps analyze complex circuits easily.

---

# SOP and POS Forms

## SOP (Sum of Products)

* OR combination of product terms.
* Derived from minterms.

### Example

```text
F = AB + AC + BC
```

### Canonical SOP

```text
F = Σm(...)
```

---

## POS (Product of Sums)

* AND combination of sum terms.
* Derived from maxterms.

### Example

```text
F = (A + C)(B + C)(A + B)
```

### Canonical POS

```text
F = ΠM(...)
```

---

# Logic Minimization

## Purpose

Reduce:

* Number of gates
* Hardware cost
* Power consumption
* Circuit complexity

## Methods

### Boolean Algebra

Use laws and theorems to simplify expressions.

### K-Map (Karnaugh Map)

Group adjacent cells to obtain minimal expressions.

### Consensus Theorem

Remove redundant terms.

---

