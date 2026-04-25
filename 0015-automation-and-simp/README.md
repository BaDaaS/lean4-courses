# 0015 - Automation and Simp

## Goal

Master Lean's proof automation: simp, omega, decide, aesop, and how to
write custom simp lemmas.

## The simp Tactic

`simp` applies a database of `@[simp]` lemmas repeatedly until no more
apply:

```lean fromFile:Examples.lean#simp_basics
example (xs : List Nat) : xs ++ [] = xs := by simp
example (n : Nat) : n + 0 = n := by simp
example (n : Nat) : 0 + n = n := by simp
```

### simp only

Restrict to specific lemmas:

```lean fromFile:Examples.lean#simp_only
example (a b c : Nat) (h : a = b) : a + c = b + c := by
  simp only [h]
```

### Adding simp lemmas

```lean fromFile:Examples.lean#adding_simp_lemmas
def double (n : Nat) : Nat := 2 * n

@[simp]
theorem double_def (n : Nat) : double n = 2 * n := rfl

-- Now simp will automatically use this
```

## omega

Solves linear arithmetic over Nat and Int:

```lean fromFile:Examples.lean#omega_examples
example (n m : Nat) (h : n < m) : n + 1 <= m := by omega
example (a b : Int) (h1 : a > 0) (h2 : b > 0) : a + b > 0 := by omega
```

## decide

Evaluates decidable propositions:

```lean fromFile:Examples.lean#decide_examples
example : 2 + 2 = 4 := by decide
```

`Nat.Prime` requires Mathlib:

```lean
-- Requires Mathlib
-- example : Nat.Prime 7 := by decide
```

## norm_num

Normalizes numeric expressions:

```lean
example : (3 : Nat) * 4 = 12 := by norm_num
example : (2 : Int) - 5 = -3 := by norm_num
```

## ring

Solves equalities in commutative (semi)rings:

```lean
example (x y : Int) : (x + y) ^ 2 = x ^ 2 + 2 * x * y + y ^ 2 := by
  ring
```

## Combining Tactics

```lean fromFile:Examples.lean#combining_tactics
-- simp then omega for the remainder
example (n : Nat) (h : n > 0) : n - 1 + 1 = n := by
  omega
```

Clearing denominators with `field_simp` requires Mathlib:

```lean
-- Requires Mathlib
-- example (x : Rat) (h : x != 0) : x / x = 1 := by
--   field_simp
```

## Math Track

Automation is what makes large-scale formalization practical. Without
simp, omega, and ring, proofs would be 10x longer. Learning what each
tactic can solve lets you focus on the interesting parts of proofs.

## CS Track

Think of these tactics as SAT/SMT solvers embedded in the type checker.
`omega` is a decision procedure for Presburger arithmetic. `simp` is a
term rewriting engine. `decide` is a brute-force evaluator.
