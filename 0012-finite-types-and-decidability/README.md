# 0012 - Finite Types and Decidability

## Goal

Understand `Decidable`, `DecidableEq`, `Fintype`, and `Fin`. Learn when
propositions can be computed and how finite types enable enumeration.

## Decidable Propositions

A proposition P is `Decidable` if we can algorithmically determine
whether it is true or false:

```lean fromFile:Examples.lean#decidable_propositions
-- Decidable is defined as:
-- inductive Decidable (p : Prop) where
--   | isFalse (h : Not p) : Decidable p
--   | isTrue (h : p) : Decidable p

-- Nat equality is decidable
#eval decide (3 = 3)   -- true
#eval decide (3 = 4)   -- false
```

## Bool vs Prop

```lean
-- Bool: computational truth value
-- Prop: logical truth value

-- Converting between them:
-- decide : [Decidable p] -> Bool
-- Decidable.decide converts Prop to Bool when decidable
```

## DecidableEq

```lean fromFile:Examples.lean#decidable_eq
-- DecidableEq alpha means equality on alpha is decidable
-- Most concrete types have this: Nat, Int, String, Bool, etc.

instance : DecidableEq Bool := inferInstance
```

## Fin n

`Fin n` is the type of natural numbers less than n:

```lean fromFile:Examples.lean#fin_n
-- Fin 3 has exactly three values
def f0 : Fin 3 := 0
def f1 : Fin 3 := 1
def f2 : Fin 3 := 2
-- def f3 : Fin 3 := 3  -- error!

-- Safe array access
def safeGet (arr : Array alpha) (i : Fin arr.size) : alpha :=
  arr[i]
```

## Fintype

A type is `Fintype` if it has finitely many elements:

```lean
-- Bool is finite (two elements)
-- Fin n is finite (n elements)
-- Unit is finite (one element)
```

## Math Track

Decidability is a key concept in logic. Classical logic assumes every
proposition is decidable (law of excluded middle). In constructive logic
(Lean's default), you must prove decidability explicitly. Lean provides
`Classical.em` when you need classical reasoning.

Finite types correspond to finite sets. `Fintype` lets you enumerate
all elements, compute cardinality, and decide universal/existential
quantification over finite domains.

## CS Track

Decidability determines what can be computed. If `P` is `Decidable`,
you can use `if P then ... else ...` in code. Without decidability,
propositions exist only in the logic layer, not in executable code.

`Fin n` provides compile-time bounds checking. If you index an array
with `Fin arr.size`, out-of-bounds access is impossible by construction.
