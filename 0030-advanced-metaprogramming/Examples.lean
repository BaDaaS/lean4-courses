import Lean

/-
# 0030 - Advanced Metaprogramming Examples

Code examples from the README, wrapped in anchors for injection.
-/

namespace Course0030Examples

-- #anchor: metam_basics
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
-- #end

-- #anchor: building_expressions
open Lean

-- Build the expression `Nat.add 2 3`
def mkAddExpr : MetaM Expr := do
  let two := mkNatLit 2
  let three := mkNatLit 3
  mkAppM ``Nat.add #[two, three]
-- #end

-- #anchor: custom_tactic_my_rfl
open Lean Elab Tactic

-- A tactic that closes goals of the form `n = n`
elab "my_rfl" : tactic => do
  let goal <- getMainGoal
  goal.withContext do
    let goalType <- goal.getType
    match goalType with
    | Expr.app (Expr.app (Expr.app (.const ``Eq _) _) a) b =>
      if (<- isDefEq a b) then
        let proof <- mkAppM ``Eq.refl #[a]
        goal.assign proof
      else
        throwTacticEx `my_rfl goal "sides are not defeq"
    | _ => throwTacticEx `my_rfl goal "not an equality"

example : 2 + 2 = 4 := by my_rfl
-- #end

-- #anchor: syntax_and_macros
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
-- #end

-- #anchor: term_elaborator
-- Custom term elaborator
elab "natOfBool " b:term : term => do
  let bExpr <- Lean.Elab.Term.elabTerm b (some (mkConst ``Bool))
  return mkApp (mkConst ``Bool.toNat) bExpr
-- #end

-- #anchor: inspecting_environment
-- Get all declarations in the environment
def listDecls : MetaM (Array Name) := do
  let env <- getEnv
  let pairs := env.constants.toList
  return pairs.toArray.map fun (name, _) => name
-- #end

-- #anchor: attribute_handler
-- Register a custom attribute
initialize myAttr : TagAttribute <-
  registerTagAttribute `myTag "My custom attribute" fun _ _ => pure ()
-- #end

-- #anchor: doc_linter
-- A linter that warns about definitions without docstrings
-- (simplified)
def docLinter (declName : Name) : MetaM (Option String) := do
  let env <- getEnv
  let docStr <- findDocString? env declName
  match docStr with
  | some _ => return none
  | none => return some s!"Missing docstring for {declName}"
-- #end

end Course0030Examples
