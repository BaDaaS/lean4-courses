/-
# 0009 - Dependent Types Examples

Code examples from the README, wrapped in anchors for injection.
-/

namespace Course0009Examples

-- #anchor: vec_inductive
-- Vector: a list with its length in the type
inductive Vec (alpha : Type) : Nat -> Type where
  | nil : Vec alpha 0
  | cons (head : alpha) (tail : Vec alpha n) : Vec alpha (n + 1)
-- #end

-- #anchor: dependent_function_types
-- The return type depends on the Bool value
def boolToType : Bool -> Type
  | true  => Nat
  | false => String

def getValue : (b : Bool) -> boolToType b
  | true  => (42 : Nat)
  | false => "hello"
-- #end

-- #anchor: sigma_types
-- A number together with a proof it is positive
def posNum : { n : Nat // n > 0 } :=
  ⟨5, by omega⟩

#eval posNum.val  -- 5
-- #end

-- #anchor: fin_bounded
-- Fin 3 has exactly three values: 0, 1, 2
def safeIndex {alpha : Type} (xs : List alpha) (i : Fin xs.length) : alpha :=
  xs[i]

-- This cannot go out of bounds!
-- #end

-- #anchor: propositions_as_types
-- A function that takes a proof the list is non-empty
def head! {alpha : Type} (xs : List alpha) (h : xs.length > 0) : alpha :=
  match xs, h with
  | x :: _, _ => x

-- Usage requires providing the proof
example : head! [1, 2, 3] (by simp) = 1 := rfl
-- #end

end Course0009Examples
