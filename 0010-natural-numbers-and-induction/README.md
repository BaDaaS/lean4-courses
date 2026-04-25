# 0010 - Natural Numbers and Induction

## Goal

Prove properties of natural numbers using induction. Understand how
structural induction works in Lean.

## Induction on Nat

The induction principle for Nat:
- Base case: prove P(0)
- Inductive step: assume P(n), prove P(n+1)

```lean fromFile:Examples.lean#add_zero_induction
theorem add_zero (n : Nat) : n + 0 = n := by
  induction n with
  | zero => rfl
  | succ n ih => simp [Nat.succ_add, ih]
```

## Key Nat Lemmas

```lean
-- These are proved by induction in Lean's library:
-- Nat.zero_add : 0 + n = n
-- Nat.succ_add : (n + 1) + m = (n + m) + 1
-- Nat.add_comm : n + m = m + n
-- Nat.add_assoc : (n + m) + k = n + (m + k)
-- Nat.mul_comm : n * m = m * n
```

## Proof by Induction in Tactic Mode

```lean fromFile:Examples.lean#zero_add_induction
theorem zero_add (n : Nat) : 0 + n = n := by
  induction n with
  | zero => rfl
  | succ n ih =>
    -- ih : 0 + n = n
    -- goal : 0 + (n + 1) = n + 1
    rw [Nat.add_succ, ih]
```

## Math Track: Peano Axioms in Lean

Lean's `Nat` type directly encodes the Peano axioms:
1. 0 is a natural number (`Nat.zero`)
2. Every natural number has a successor (`Nat.succ`)
3. 0 is not a successor (by disjointness of constructors)
4. Successor is injective (by constructor injectivity)
5. Induction principle (by structural recursion)

## CS Track: Verified Algorithms

Induction lets you prove that recursive algorithms are correct.
If your function recurs on `n`, you prove properties by induction on `n`.
