/-
# 0028 - Lean Internals Examples

Code examples from the README, wrapped in anchors for injection.
-/

namespace Course0028Examples

-- #anchor: print_axioms_choice
#print axioms Classical.choice
-- Classical.choice, propext, Quot.sound
-- #end

-- #anchor: safe_div
-- The proof h is erased at runtime
def safeDiv (a b : Nat) (h : b > 0) : Nat := a / b
-- Compiles to just: a / b
-- #end

-- #anchor: abbrev_point
abbrev Point := Nat × Nat
-- The kernel always sees Nat × Nat, never Point
-- #end

end Course0028Examples
