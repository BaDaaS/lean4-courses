# 0001 - Types

## Goal

Understand Lean's type system: basic types, type universes, and how types
relate to both mathematical objects and data specifications.

## Basic Types

```lean
#check Nat           -- Type
#check Int           -- Type
#check Bool          -- Type
#check String        -- Type
#check Float         -- Type
```

## Type Universes

Every type itself has a type. Lean organizes types into a hierarchy:

```lean
#check Nat           -- Nat : Type
#check Type          -- Type : Type 1
#check Type 1        -- Type 1 : Type 2
```

`Prop` is a special universe for propositions:

```lean
#check Prop          -- Prop : Type
#check 1 = 1         -- 1 = 1 : Prop
#check True          -- True : Prop
```

## Function Types

```lean
#check Nat -> Nat          -- function from Nat to Nat
#check Nat -> Bool         -- predicate on Nat
#check Nat -> Nat -> Nat   -- curried two-argument function
```

## Product and Sum Types

```lean
-- Product (pair): both components
#check Nat x Bool          -- Nat x Bool : Type
#check (3, true)            -- (3, true) : Nat x Bool

-- Sum (either): one of two options
#check Nat + Bool           -- no built-in syntax, use Sum
#check Sum Nat Bool         -- Sum Nat Bool : Type
```

## Math Track: Types as Sets

Think of a type as a set. `n : Nat` means "n is an element of Nat".
Function types `A -> B` correspond to the set of all functions from A to B.

`Prop` is the universe of propositions. A proposition `P : Prop` is either
provable (inhabited) or not. A proof `h : P` is a witness that P holds.

The key insight: in Lean, proving a theorem means constructing a term of
the right type.

## CS Track: Types as Specifications

Types specify what data looks like and what functions accept/return.
Lean's type checker ensures your program respects these specifications
at compile time.

```lean
-- The type tells you exactly what this function does
def increment (n : Nat) : Nat := n + 1

-- Type error: String is not Nat
-- def bad : Nat := "hello"  -- won't compile
```

## Type Annotations

```lean
-- Explicit annotation
def x : Nat := 42

-- Lean can infer types
def y := 42           -- inferred as Nat

-- Annotations on function parameters
def add (a : Nat) (b : Nat) : Nat := a + b
```

## The `Prop` vs `Bool` Distinction

This is critical in Lean:

- `Bool` is a data type with values `true` and `false` (computable)
- `Prop` is the universe of propositions (logical, may not be computable)

```lean
#check (5 < 10 : Prop)      -- a proposition
#check (decide (5 < 10))     -- computable decision
#eval decide (5 < 10)        -- true
```
