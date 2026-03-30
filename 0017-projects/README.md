# 0017 - Projects

## Goal

Apply everything you have learned. Choose a project based on your track.

## Math Track Projects

### Project M1: Bezout's Identity

Prove that for any integers a, b, there exist integers x, y such that
gcd(a, b) = a * x + b * y.

### Project M2: Fundamental Theorem of Arithmetic

Prove that every natural number > 1 has a unique prime factorization
(up to ordering).

### Project M3: Lagrange's Theorem (Group Theory)

Prove that the order of a subgroup divides the order of the group
(for finite groups).

### Project M4: Fermat's Little Theorem

Prove that if p is prime and gcd(a, p) = 1, then a^(p-1) = 1 (mod p).

## CS Track Projects

### Project C1: Verified Sorting

Implement merge sort and prove:
1. The output is sorted
2. The output is a permutation of the input

### Project C2: Red-Black Trees

Implement red-black trees with insert and lookup. Prove the BST
invariant is maintained and the tree is balanced.

### Project C3: Simple Interpreter

Build an interpreter for a small language with:
- Integer arithmetic
- Variables and let-bindings
- If-then-else expressions

Prove type soundness.

### Project C4: Parser Combinators

Build a parser combinator library. Prove that parsers that consume
input always terminate.

## Getting Started

1. Create a new Lake project: `lake init my_project`
2. Add dependencies (Mathlib if needed) in `lakefile.lean`
3. Start with definitions, then state theorems, then prove them
4. Use `sorry` as placeholder and fill in proofs incrementally

## Tips

- Start small: prove easy lemmas first
- Use `#check` liberally to find library lemmas
- Use `exact?` and `apply?` when stuck
- Read Mathlib source code for patterns
- Ask on Zulip (leanprover.zulipchat.com) if truly stuck
