# 0029 - Advanced Metaprogramming

## Goal

Write custom tactics, elaborators, and code generators. Understand
the MetaM, TacticM, and TermElabM monads.

## The Monad Stack

```
CoreM       -- names, environment, options
  |
  v
MetaM       -- metavariables, unification, type checking
  |
  v
TermElabM   -- term elaboration
  |
  v
TacticM     -- tactic state (goals, hypotheses)
```

## MetaM: The Metaprogramming Monad

```lean
import Lean

open Lean Meta

-- Check if two expressions are definitionally equal
def myIsDefEq (a b : Expr) : MetaM Bool :=
  isDefEq a b

-- Infer the type of an expression
def myInferType (e : Expr) : MetaM Expr :=
  inferType e

-- Create a fresh metavariable
def myMkFreshMVar (type : Expr) : MetaM Expr :=
  mkFreshExprMVar type
```

## Building Expressions

```lean
open Lean

-- Build the expression `Nat.add 2 3`
def mkAddExpr : MetaM Expr := do
  let two := mkNatLit 2
  let three := mkNatLit 3
  mkAppM ``Nat.add #[two, three]
```

## Custom Tactics

```lean
open Lean Elab Tactic

-- A tactic that closes goals of the form `n = n`
elab "my_rfl" : tactic => do
  let goal <- getMainGoal
  goal.withContext do
    let goalType <- goal.getType
    match goalType with
    | Expr.app (Expr.app (Expr.app (.const ``Eq _) _) a) b =>
      if (<- isDefEq a b) then
        goal.assign (mkApp (.const ``Eq.refl [.zero]) a)
      else
        throwTacticEx `my_rfl goal "sides are not defeq"
    | _ => throwTacticEx `my_rfl goal "not an equality"

example : 2 + 2 = 4 := by my_rfl
```

## Syntax and Macros (Revisited, Deeper)

```lean
-- Declare new syntax category
declare_syntax_cat myExpr
syntax num : myExpr
syntax myExpr " + " myExpr : myExpr
syntax myExpr " * " myExpr : myExpr
syntax "(" myExpr ")" : myExpr

-- Macro to elaborate custom syntax into Lean terms
syntax "[myExpr| " myExpr "]" : term

macro_rules
  | `([myExpr| $n:num]) => `($n)
  | `([myExpr| $a + $b]) => `([myExpr| $a] + [myExpr| $b])
  | `([myExpr| $a * $b]) => `([myExpr| $a] * [myExpr| $b])
  | `([myExpr| ($e)]) => `([myExpr| $e])

#eval [myExpr| (2 + 3) * 4]  -- 20
```

## Term Elaborators

```lean
-- Custom term elaborator
elab "natOfBool " b:term : term => do
  let bExpr <- elabTerm b (some (mkConst ``Bool))
  return mkApp (mkConst ``Bool.toNat) bExpr
```

## Inspecting the Environment

```lean
-- Get all declarations in the environment
def listDecls : MetaM (Array Name) := do
  let env <- getEnv
  let mut names := #[]
  for (name, _) in env.constants.map1.toList do
    names := names.push name
  return names
```

## Attribute Handlers

```lean
-- Register a custom attribute
initialize myAttr : TagAttribute <-
  registerTagAttribute `myTag "My custom attribute" fun _ _ => pure ()
```

## Writing a Linter

```lean
-- A linter that warns about definitions without docstrings
-- (simplified)
def docLinter (declName : Name) : MetaM (Option String) := do
  let env <- getEnv
  match env.findDocString? declName with
  | some _ => return none
  | none => return some s!"Missing docstring for {declName}"
```

## Exercises

1. Write a tactic that solves `True` goals
2. Write a tactic that tries multiple closers: rfl, trivial, simp
3. Write a macro for `assert_type e : T` that checks at elaboration time
4. Write a custom syntax for state machine definitions
5. Build a tactic that prints the current goal in a custom format
6. Write an elaborator that generates boilerplate code from a spec
