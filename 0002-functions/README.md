# 0002 - Functions

## Goal

Master function definitions in Lean 4: lambda expressions, currying,
implicit arguments, and partial application.

## Defining Functions

```lean
-- Named definition
def add (a b : Nat) : Nat := a + b

-- Lambda (anonymous function)
def add' : Nat -> Nat -> Nat := fun a b => a + b

-- With pattern matching
def isEven : Nat -> Bool
  | 0 => true
  | 1 => false
  | n + 2 => isEven n
```

## Currying

All functions in Lean are curried. A function taking two arguments is
actually a function returning a function:

```lean
-- These are the same type:
-- Nat -> Nat -> Nat
-- Nat -> (Nat -> Nat)

def add3 := add 3  -- partial application: Nat -> Nat
#eval add3 7        -- 10
```

## Implicit Arguments

Arguments in `{}` are inferred by Lean:

```lean
def listLength {alpha : Type} (xs : List alpha) : Nat :=
  match xs with
  | [] => 0
  | _ :: tail => 1 + listLength tail

#eval listLength [1, 2, 3]  -- Lean infers alpha = Nat
```

Use `@` to pass implicit arguments explicitly:

```lean
#eval @listLength Nat [1, 2, 3]
```

## Instance-Implicit Arguments

Arguments in `[]` are resolved via typeclass search:

```lean
def printIt [ToString alpha] (x : alpha) : String :=
  toString x
```

## Where Clauses

```lean
def hypotenuse (a b : Float) : Float :=
  Float.sqrt (sq a + sq b)
where
  sq (x : Float) := x * x
```

## Math Track: Functions as Maps

In mathematics, a function f : A -> B assigns to each element of A exactly
one element of B. In Lean, this is enforced by the type system: you must
handle every input (totality).

Composition works naturally:

```lean
def compose (f : beta -> gamma) (g : alpha -> beta) : alpha -> gamma :=
  fun x => f (g x)
```

## CS Track: Functions as Computations

Functions in Lean are pure (no side effects). They always return the same
output for the same input. This makes reasoning about code straightforward.

```lean
-- Higher-order functions
def applyTwice (f : alpha -> alpha) (x : alpha) : alpha :=
  f (f x)

#eval applyTwice (fun n : Nat => n + 1) 0  -- 2
```
