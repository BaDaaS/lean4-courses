/-
# 0029 - Elaboration and Unification Examples

Code examples from the README, wrapped in anchors for injection.
-/

namespace Course0029Examples

-- #anchor: metavariables
-- When you write:
def f := List.map (. + 1) [1, 2, 3]

-- Lean sees List.map (?f) (?xs) and creates metavariables
-- ?f : ?alpha -> ?beta
-- ?xs : List ?alpha
-- Then unifies: ?alpha = Nat, ?beta = Nat, ?f = (. + 1)
-- #end

-- #anchor: implicit_argument_resolution
-- @ shows all implicit arguments
#check @List.map  -- {alpha beta : Type} -> (alpha -> beta) -> List alpha -> List beta

-- Lean fills these in by unification:
-- List.map (. + 1) [1, 2, 3]
-- becomes
-- @List.map Nat Nat (. + 1) [1, 2, 3]
-- #end

-- #anchor: coercions
-- Lean inserts coercions automatically:
def g (n : Int) : Int := n + 1
#check g (3 : Nat)  -- Works! Lean inserts Nat -> Int coercion
-- #end

-- #anchor: debugging_elaboration
-- Show what Lean elaborated
set_option pp.all true in
#check List.map (. + 1) [1, 2, 3]

-- Show implicit arguments (pp.explicit shows all implicit args)
set_option pp.explicit true in
#check List.map (. + 1) [1, 2, 3]

-- Show universe levels
set_option pp.universes true in
#check Type

-- Trace elaboration
set_option trace.Elab.step true in
def foo := 42
-- #end

end Course0029Examples
