# 0008 - Pattern Matching and Recursion

## Goal

Master pattern matching (exhaustive, nested, with guards) and recursive
functions. Understand Lean's termination checker.

## Pattern Matching

### Basic Matching

```lean
def describe : Nat -> String
  | 0 => "zero"
  | 1 => "one"
  | _ => "many"
```

### Nested Patterns

```lean
def firstTwo : List alpha -> Option (alpha x alpha)
  | a :: b :: _ => some (a, b)
  | _           => none
```

### Multiple Discriminants

```lean
def zip : List alpha -> List beta -> List (alpha x beta)
  | a :: as, b :: bs => (a, b) :: zip as bs
  | _, _ => []
```

## Recursion and Termination

Lean requires all functions to terminate. It checks that recursive calls
are on structurally smaller arguments:

```lean
-- Lean accepts this: n is structurally smaller than n + 1
def factorial : Nat -> Nat
  | 0     => 1
  | n + 1 => (n + 1) * factorial n
```

### When Termination Is Not Obvious

Use `termination_by` to tell Lean what decreases:

```lean
def gcd (a b : Nat) : Nat :=
  if b == 0 then a
  else gcd b (a % b)
termination_by b
decreasing_by
  simp_all
  omega
```

### Mutual Recursion

```lean
mutual
  def isEven : Nat -> Bool
    | 0     => true
    | n + 1 => isOdd n

  def isOdd : Nat -> Bool
    | 0     => false
    | n + 1 => isEven n
end
```

## Well-Founded Recursion

For non-structural recursion, Lean uses well-founded recursion on a
measure that decreases at each call. The `omega` and `simp` tactics
often discharge the proof obligations automatically.

## Math Track: Structural Induction

Pattern matching on inductive types corresponds to the elimination
principle. Recursive definitions over `Nat` correspond to definition
by recursion, and proofs by pattern matching correspond to proofs by
induction.

## CS Track: Exhaustiveness and Totality

Unlike most languages, Lean's pattern matching is:
1. **Exhaustive**: every possible input must be covered
2. **Total**: every recursive function must terminate

This guarantees no runtime crashes from unhandled cases and no infinite
loops.
