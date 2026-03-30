/-
# 0028 - Lean Internals Exercises
-/

namespace Course0028E

-- Exercise 1: Define a simplified Expr type using de Bruijn indices
-- Constructors: var (index), app (fn, arg), lam (body), lit (nat value)
-- de Bruijn indices: var 0 is the innermost bound variable,
-- var 1 is the next one out, etc.
inductive Expr where
  | var (index : Nat) : Expr
  | app (fn : Expr) (arg : Expr) : Expr
  | lam (body : Expr) : Expr
  | lit (val : Nat) : Expr
deriving Repr, BEq

-- Exercise 2: Implement substitution on Expr
-- First, implement shift: increase free variable indices by amount.
-- Free variables are those with index >= cutoff.
def shift (cutoff : Nat) (amount : Int) : Expr -> Expr := sorry

-- Then implement subst: replace variable at de Bruijn index 0
-- with the replacement expression, and decrement other free variables.
def subst (target : Expr) (replacement : Expr) : Expr := sorry

-- Exercise 3: Implement a simple beta-reduction step
-- Find the leftmost-outermost redex (app of lam to arg) and reduce it.
-- Return none if no redex exists.
def betaStep : Expr -> Option Expr := sorry

-- Test: betaStep (app (lam (var 0)) (lit 42)) should give some (lit 42)

-- Exercise 4: Implement a type checker for simply-typed lambda calculus
inductive Ty where
  | nat : Ty
  | arrow (dom : Ty) (cod : Ty) : Ty
deriving Repr, BEq

-- A typing context maps de Bruijn indices to types
abbrev Ctx := List Ty

-- Type check an expression in a context.
-- Convention: lam always introduces a Nat-typed variable (since we
-- have no type annotations on lambda).
def typeCheck (ctx : Ctx) : Expr -> Option Ty := sorry

-- Test: typeCheck [] (lit 5) should give some Ty.nat
-- Test: typeCheck [] (lam (var 0)) should give some (arrow nat nat)

-- Exercise 5: Define a simplified Environment type
-- An environment maps names to definitions (expression + optional type).
structure EnvEntry where
  name : String
  expr : Expr
  ty : Option Ty
deriving Repr

abbrev Env := List EnvEntry

-- Exercise 6: Implement lookup and extension of the environment
-- Look up a name in the environment, returning the first match.
def envLookup (env : Env) (name : String) : Option EnvEntry := sorry

-- Add a new entry to the front of the environment.
def envExtend (env : Env) (name : String) (expr : Expr)
    (ty : Option Ty) : Env := sorry

end Course0028E
