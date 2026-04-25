/-
# 0012 - Finite Types and Decidability Examples

Code examples from the README, wrapped in anchors for injection.
-/

namespace Course0012Examples

-- #anchor: decidable_propositions
-- Decidable is defined as:
-- inductive Decidable (p : Prop) where
--   | isFalse (h : Not p) : Decidable p
--   | isTrue (h : p) : Decidable p

-- Nat equality is decidable
#eval decide (3 = 3)   -- true
#eval decide (3 = 4)   -- false
-- #end

-- #anchor: decidable_eq
-- DecidableEq alpha means equality on alpha is decidable
-- Most concrete types have this: Nat, Int, String, Bool, etc.

instance : DecidableEq Bool := inferInstance
-- #end

-- #anchor: fin_n
-- Fin 3 has exactly three values
def f0 : Fin 3 := 0
def f1 : Fin 3 := 1
def f2 : Fin 3 := 2
-- def f3 : Fin 3 := 3  -- error!

-- Safe array access
def safeGet (arr : Array alpha) (i : Fin arr.size) : alpha :=
  arr[i]
-- #end

end Course0012Examples
