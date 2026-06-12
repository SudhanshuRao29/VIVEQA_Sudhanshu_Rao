# Number System & Codes – Simplified Notes

## 1. Number Systems

A number system is a way of representing numbers using a set of digits.

| Number System | Base (Radix) | Digits Used |
| ------------- | ------------ | ----------- |
| Binary        | 2            | 0, 1        |
| Octal         | 8            | 0–7         |
| Decimal       | 10           | 0–9         |
| Hexadecimal   | 16           | 0–9, A–F    |

---

## 2. Number System Conversion

### Any Radix to Decimal

Multiply each digit by its radix raised to the position power and add all values.

Formula:

D=\sum d_i r^i

Where:

* **D** = Decimal value
* **dᵢ** = Digit value
* **r** = Radix/Base
* **i** = Position index

### Example

Binary number:

1010.01₂

Decimal value:

= 1×2³ + 0×2² + 1×2¹ + 0×2⁰ + 0×2⁻¹ + 1×2⁻²

= **10.25₁₀**

---

## 3. Decimal to Other Number Systems

### Integer Part Conversion

* Repeatedly divide by the required base.
* Write remainders.
* Read remainders from bottom to top.

**Example:**
125₁₀ = 1111101₂

### Fractional Part Conversion

* Repeatedly multiply by the required base.
* Record integer parts obtained.
* Read results from top to bottom.

**Example:**
0.7₁₀ ≈ 0.101100₂

---

## 4. Binary ↔ Octal Conversion

### Binary to Octal

1. Group binary digits in sets of 3.
2. Replace each group with its octal equivalent.

Example:

11101.011₂ = 35.3₈

### Octal to Binary

Replace each octal digit with its 3-bit binary equivalent.

Example:

476.543₈ = 100111110.101100011₂

---

## 5. Binary ↔ Hexadecimal Conversion

### Binary to Hexadecimal

1. Group binary digits in sets of 4.
2. Replace each group with hexadecimal equivalent.

Example:

11101.011₂ = 1D.6₁₆

### Hexadecimal to Binary

Replace each hexadecimal digit with its 4-bit binary equivalent.

Example:

ADE.54C₁₆ = 101011011110.010101001100₂

---

# 6. Signed Number Representation

Used to represent positive and negative numbers.

### Methods

1. Sign-Magnitude Representation
2. Complement Representation

---

## 7. Sign-Magnitude Representation

* MSB (Most Significant Bit) represents sign.
* 0 → Positive
* 1 → Negative

Examples:

* 01111₂ = +15
* 11111₂ = −15

### Drawbacks

* Arithmetic is complicated.
* Two representations for zero:

  * +0 = 00000
  * −0 = 10000

---

## 8. Complement Representation

### 1's Complement

Invert all bits.

Example:

+15 = 00001111

−15 = 11110000

### 2's Complement

1. Find 1's complement.
2. Add 1.

Example:

00001111

→ 11110000

→ 11110001 (2's complement)

### Shortcut Method

Start from LSB:

* Copy bits up to first '1'.
* Complement all remaining bits.

---

## 9. Binary Arithmetic Using 2's Complement

### Addition

Perform normal binary addition.

Example:

7 + 4 = 11

### Subtraction

A − B = A + (2's complement of B)

Benefits:

* Same hardware for addition and subtraction.
* Widely used in digital systems.

---

## 10. Complement Systems

| Number System | Base | Complements            |
| ------------- | ---- | ---------------------- |
| Binary        | 2    | 1's & 2's complement   |
| Octal         | 8    | 7's & 8's complement   |
| Decimal       | 10   | 9's & 10's complement  |
| Hexadecimal   | 16   | 15's & 16's complement |

### Rule

* (r−1)'s complement: subtract each digit from (r−1)
* r's complement: add 1 to (r−1)'s complement

---

# 11. Codes

Codes are symbolic representations of data.

### Types of Codes

* Weighted Binary Codes
* Non-Weighted Codes
* Alphanumeric Codes
* Error Detecting Codes

---

## 12. Weighted Binary Codes

Each bit position has a fixed weight.

### Common Weighted Codes

* 8421 BCD
* 5421
* 2421

### BCD (8421)

Each decimal digit is represented by 4 bits.

Example:

874₁₀

= 1000 0111 0100 (BCD)

---

## 13. Non-Weighted Codes

No positional weights are assigned.

### Examples

* Excess-3 Code
* Gray Code

---

## 14. Gray Code

### Features

* Adjacent numbers differ by only one bit.
* Reduces transition errors.
* Used in encoders and low-power applications.

### Binary → Gray Conversion

* First bit remains same.
* Remaining bits = XOR of adjacent binary bits.

Example:

10110₂ → 11101₍Gray₎

### Gray → Binary Conversion

* First bit remains same.
* Each next binary bit = previous binary bit XOR current Gray bit.

Example:

10110₍Gray₎ → 11011₂

---

## 15. ASCII Code

**ASCII** = American Standard Code for Information Interchange.

### Features

* Uses 7 bits.
* Represents 128 characters.
* Includes letters, digits, symbols, and control characters.

Examples:

* A = 65
* B = 66
* a = 97

---

## 16. Other Important Codes

### Parity Code

* Used for error detection.
* Adds an extra parity bit.

### Hamming Code

* Used for error detection and correction.

### Hollerith Code

* Early data representation code.

### EBCDIC

* Extended Binary Coded Decimal Interchange Code.
* Uses 8 bits.

### Extended ASCII

* Uses 8 bits.
* Supports 256 characters.

---

