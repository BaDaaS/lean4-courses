/-
# 0001 - Types Examples

Runnable examples from the course README, organized with anchor markers
so the README can reference them directly.
-/

namespace Course0001Examples

-- #anchor: basic_types
#check Nat           -- Type
#check Int           -- Type
#check Bool          -- Type
#check String        -- Type
#check Float         -- Type
-- #end

-- #anchor: definitional_equality
-- The kernel reduces both sides to 4, so rfl works
example : 2 + 2 = 4 := rfl
-- #end

-- #anchor: type_universes
#check Nat           -- Nat : Type
#check Type          -- Type : Type 1
#check Type 1        -- Type 1 : Type 2
-- #end

-- #anchor: universe_polymorphism
universe u v
def Prod' (alpha : Type u) (beta : Type v) :=
  Prod alpha beta
-- Prod' : Type u -> Type v -> Type (max u v)
-- #end

-- #anchor: prop_impredicative
-- This lives in Prop, not Type 1
#check forall (P : Prop), P -> P    -- Prop
-- #end

-- #anchor: function_types
#check Nat -> Nat          -- function from Nat to Nat
#check Nat -> Bool         -- predicate on Nat
#check Nat -> Nat -> Nat   -- curried two-argument function
-- #end

-- #anchor: dependent_function_types
-- Non-dependent: return type is always Bool
def isEven : Nat -> Bool := fun n => n % 2 == 0

-- Dependent: return type depends on the input
def Vec (alpha : Type) (n : Nat) : Type := Fin n -> alpha
def head (alpha : Type) (n : Nat) (v : Vec alpha (n + 1)) : alpha := v ⟨0, Nat.zero_lt_succ n⟩
-- #end

-- #anchor: product_and_sum_types
-- Product (pair): both components
#check Prod Nat Bool        -- Nat x Bool : Type
#check (3, true)            -- (3, true) : Nat x Bool

-- Sum (either): one of two options
#check Sum Nat Bool         -- Sum Nat Bool : Type
-- #end

-- #anchor: sigma_types
-- Non-dependent pair
#check (3, true)          -- Nat x Bool

-- Dependent pair (Sigma type)
-- A natural number n together with a proof that n > 0
-- PSigma works when the second component is a Prop
#check PSigma (fun n : Nat => n > 0)
-- Subtype notation (same idea, but as a Type):
#check { n : Nat // n > 0 }
-- #end

-- #anchor: types_as_specifications
-- The type tells you exactly what this function does
def increment (n : Nat) : Nat := n + 1

-- Type error: String is not Nat
-- def bad : Nat := "hello"  -- won't compile
-- #end

-- #anchor: type_annotations
-- Explicit annotation
def x : Nat := 42

-- Lean can infer types
def y := 42           -- inferred as Nat

-- Annotations on function parameters
def add (a : Nat) (b : Nat) : Nat := a + b
-- #end

-- #anchor: prop_vs_bool
#check (5 < 10 : Prop)      -- a proposition
#check (decide (5 < 10))     -- computable decision
#eval decide (5 < 10)        -- true
-- #end

end Course0001Examples
