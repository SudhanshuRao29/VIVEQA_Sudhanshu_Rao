# Day 2 - Concepts 1

## Digital Systems

* Digital systems operate using binary values: **0 and 1**.
* Inputs and outputs are represented using **HIGH** and **LOW** voltage levels.
* Advantages:

  * Reliable operation
  * High speed
  * Easy IC implementation
  * Low cost

### Logic Types

#### Positive Logic

* HIGH = 1
* LOW = 0

#### Negative Logic

* HIGH = 0
* LOW = 1

---

## Logic Gates

### AND Gate

Output is 1 only when all inputs are 1.

**Boolean Expression**

```text
Y = A.B
```

### OR Gate

Output is 1 when at least one input is 1.

**Boolean Expression**

```text
Y = A + B
```

### NOT Gate

Produces the complement of the input.

**Boolean Expression**

```text
Y = A'
```

### XOR Gate

Output is 1 when inputs are different.

**Boolean Expression**

```text
Y = A ⊕ B
```

### XNOR Gate

Output is 1 when inputs are the same.

**Boolean Expression**

```text
Y = A ⊙ B
```

### NAND Gate

Complement of AND gate.

**Boolean Expression**

```text
Y = (A.B)'
```

### NOR Gate

Complement of OR gate.

**Boolean Expression**

```text
Y = (A+B)'
```

---

## Universal Gates

* NAND and NOR are called **Universal Gates**.
* Any digital circuit can be implemented using only NAND gates or only NOR gates.

---

## DeMorgan's Theorems

### First Theorem

```text
(A.B)' = A' + B'
```

### Second Theorem

```text
(A+B)' = A'.B'
```

---

## Important Boolean Laws

### Identity Law

```text
A + 0 = A
A . 1 = A
```

### Null Law

```text
A + 1 = 1
A . 0 = 0
```

### Complement Law

```text
A + A' = 1
A . A' = 0
```

### Idempotent Law

```text
A + A = A
A . A = A
```

### Involution Law

```text
(A')' = A
```

### Commutative Law

```text
A+B = B+A
A.B = B.A
```

### Associative Law

```text
(A+B)+C = A+(B+C)
(A.B).C = A.(B.C)
```

### Distributive Law

```text
A(B+C) = AB+AC
A+BC = (A+B)(A+C)
```

---

