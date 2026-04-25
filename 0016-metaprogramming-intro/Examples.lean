import Lean

/-
# 0016 - Metaprogramming Intro Examples

Code examples from the README, wrapped in anchors for injection.
-/

-- #anchor: say_hello_macro
-- Define a simple macro
macro "say_hello" : term => `("Hello, World!")

#eval say_hello  -- "Hello, World!"
-- #end

namespace Course0016Examples

-- #anchor: custom_infix
-- Custom infix operator
infixl:65 " +++ " => List.append

#eval [1, 2] +++ [3, 4]  -- [1, 2, 3, 4]
-- #end

end Course0016Examples

-- #anchor: auto_tactic
-- A tactic that tries rfl, then omega, then simp
macro "auto" : tactic => `(tactic| first | rfl | omega | simp)

example : 2 + 2 = 4 := by auto
example (n : Nat) : n + 0 = n := by auto
example (n : Nat) (h : n > 3) : n > 1 := by auto
-- #end

-- #anchor: my_assumption_tactic
-- Custom tactic using TacticM
elab "my_assumption" : tactic => do
  let goal <- Lean.Elab.Tactic.getMainGoal
  let goalType <- goal.getType
  let lctx <- Lean.MonadLCtx.getLCtx
  for decl in lctx do
    if (<- Lean.Meta.isDefEq decl.type goalType) then
      goal.assign decl.toExpr
      return
  Lean.Meta.throwTacticEx `my_assumption goal
    m!"no matching hypothesis"
-- #end
