# 0016 - Metaprogramming Intro

## Goal

Introduction to Lean 4's metaprogramming facilities: macros, syntax
extensions, elaboration, and custom tactics.

## Macros

Macros transform syntax before elaboration:

```lean
-- Define a simple macro
macro "say_hello" : term => `("Hello, World!")

#eval say_hello  -- "Hello, World!"
```

## Syntax Extensions

Define new notation:

```lean
-- Custom infix operator
infixl:65 " +++ " => List.append

#eval [1, 2] +++ [3, 4]  -- [1, 2, 3, 4]
```

## Custom Notation

```lean
-- Mathematical notation
notation "||" x "||" => Int.natAbs x

#eval || -5 ||  -- 5
```

## Simple Custom Tactics

```lean
-- A tactic that tries rfl, then simp, then omega
macro "auto" : tactic => `(tactic| first | rfl | simp | omega)

example : 2 + 2 = 4 := by auto
example (n : Nat) : n + 0 = n := by auto
example (n : Nat) (h : n > 3) : n > 1 := by auto
```

## Elaboration (Advanced)

For deeper metaprogramming, Lean provides the `MetaM` and `TacticM`
monads:

```lean
-- Custom tactic using TacticM
elab "my_assumption" : tactic => do
  let goal <- Lean.Elab.Tactic.getMainGoal
  let goalType <- goal.getType
  let lctx <- Lean.MonadLCtx.getLCtx
  for decl in lctx do
    if (← Lean.Meta.isDefEq decl.type goalType) then
      goal.assign decl.toExpr
      return
  Lean.Meta.throwTacticEx `my_assumption goal
    m!"no matching hypothesis"
```

## Math Track

Custom notation makes formalized mathematics readable. Mathlib uses
extensive notation: ring operations, function arrows, logical connectives.
Understanding macros helps you read and extend this notation.

## CS Track

Lean's metaprogramming is its killer feature as a programming language.
You can extend the compiler with new syntax, custom linters, code
generators, and domain-specific languages, all type-checked.
