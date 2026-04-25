# 0009 - Dependent Types

## Goal

Understand dependent types: types that depend on values. This is Lean's
most powerful feature, enabling precise specifications and verified code.

## What Are Dependent Types?

A dependent type is a type that mentions a value. The type can change
depending on the value:

```lean fromFile:Examples.lean#vec_inductive
-- Vector: a list with its length in the type
inductive Vec (alpha : Type) : Nat -> Type where
  | nil : Vec alpha 0
  | cons (head : alpha) (tail : Vec alpha n) : Vec alpha (n + 1)
```

The type `Vec Nat 3` is different from `Vec Nat 5`. The compiler
knows the length at type-checking time.

## Dependent Function Types (Pi Types)

A function whose return type depends on the input value:

```lean fromFile:Examples.lean#dependent_function_types
-- The return type depends on the Bool value
def boolToType : Bool -> Type
  | true  => Nat
  | false => String

def getValue : (b : Bool) -> boolToType b
  | true  => (42 : Nat)
  | false => "hello"
```

## Sigma Types (Dependent Pairs)

A pair where the type of the second element depends on the first:

```lean fromFile:Examples.lean#sigma_types
-- A number together with a proof it is positive
def posNum : { n : Nat // n > 0 } :=
  ⟨5, by omega⟩

#eval posNum.val  -- 5
```

## Fin: Bounded Natural Numbers

`Fin n` is the type of natural numbers less than n:

```lean fromFile:Examples.lean#fin_bounded
-- Fin 3 has exactly three values: 0, 1, 2
def safeIndex {alpha : Type} (xs : List alpha) (i : Fin xs.length) : alpha :=
  xs[i]

-- This cannot go out of bounds!
```

## Propositions as Types in Practice

```lean fromFile:Examples.lean#propositions_as_types
-- A function that takes a proof the list is non-empty
def head! {alpha : Type} (xs : List alpha) (h : xs.length > 0) : alpha :=
  match xs, h with
  | x :: _, _ => x

-- Usage requires providing the proof
example : head! [1, 2, 3] (by simp) = 1 := rfl
```

## Math Track: Pi and Sigma Types

- Pi type `(x : A) -> B x` generalizes function types. When B does not
  depend on x, it reduces to `A -> B`.
- Sigma type `(x : A) x B x` (Sigma A B) generalizes product types.
  When B does not depend on x, it reduces to `A x B`.

These correspond to the dependent product and dependent sum from type
theory, or indexed families of sets.

## CS Track: Types That Prevent Bugs

Dependent types let you encode invariants in the type system:

- `Vec alpha n` prevents length mismatches
- `Fin n` prevents out-of-bounds access
- `{ x : Nat // x > 0 }` prevents division by zero

Bugs that would be runtime errors in other languages become compile-time
errors in Lean.
