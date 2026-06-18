# Day 2 - Concepts 2

## Combinational Logic

### Definition

A combinational circuit:

* Has no memory.
* Has no feedback path.
* Output depends only on current inputs.

### Examples

* Adders
* Subtractors
* Encoders
* Decoders
* Multipliers

---

## Logic Circuit Representation

### Logic Diagram

Graphical representation using logic gates.

### Truth Table

Shows all possible input combinations and outputs.

### Boolean Expression

Mathematical representation of logic behavior.

---

## Boolean Expressions

### Literal

A variable or its complement.

Examples:

```text
A
B'
```

### Product Term

AND operation of literals.

Examples:

```text
AB
A'BC
```

### Sum Term

OR operation of literals.

Examples:

```text
A+B
A'+B+C
```

---

## SOP and POS Forms

### SOP (Sum of Products)

OR combination of product terms.

Example:

```text
AB + A'C + BC
```

### POS (Product of Sums)

AND combination of sum terms.

Example:

```text
(A+B)(A'+C)
```

---

## Minterms

### Definition

* Product term containing all variables exactly once.
* True for only one input combination.

For n variables:

```text
Number of Minterms = 2^n
```

Example:

```text
m0 = A'B'C'
m1 = A'B'C
m2 = A'BC'
...
```

### Sum of Minterms

Used to represent output conditions where F = 1.

Example:

```text
F(A,B,C) = Σm(0,1,2,3,6)
```

---

## Maxterms

### Definition

* Sum term containing all variables exactly once.
* False for only one input combination.

For n variables:

```text
Number of Maxterms = 2^n
```

Example:

```text
M0 = A+B+C
M1 = A+B+C'
...
```

### Product of Maxterms

Used to represent output conditions where F = 0.

Example:

```text
F(A,B,C) = ΠM(4,5,7)
```

---

## Relation Between Minterms and Maxterms

Each minterm is the complement of its corresponding maxterm.

```text
m0 = (M0)'
m1 = (M1)'
```

---

## Canonical Forms

### Canonical SOP

* Complete set of minterms.
* Represents output conditions for logic 1.

### Canonical POS

* Complete set of maxterms.
* Represents output conditions for logic 0.

---

## Conversion to Canonical Form

### SOP to Canonical SOP

1. Identify missing variables.
2. Add variable and complement.
3. Expand expression.

### POS to Canonical POS

1. Identify missing variables.
2. Add variable and complement.
3. Expand expression.

---

## Karnaugh Maps (K-Maps)

### Purpose

Used to simplify Boolean expressions.

### Benefits

* Fewer logic gates
* Reduced hardware complexity
* Easier implementation

### Prime Implicant (PI)

Largest possible grouping of adjacent 1s.

### Essential Prime Implicant (EPI)

Prime implicant containing at least one unique minterm.

---

## Logic Design Procedure

1. Understand the problem.
2. Create the truth table.
3. Write the Boolean expression.
4. Convert to SOP/POS form.
5. Simplify using K-map.
6. Draw the logic diagram.
7. Implement the circuit.

---

