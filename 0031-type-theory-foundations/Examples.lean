/-
# 0031 - Type Theory Foundations Examples

Code examples from the README, wrapped in anchors for injection.
-/

namespace Course0031Examples

-- #anchor: universe_polymorphism
-- Lean automatically infers universe levels
universe u v

def myId {alpha : Type u} (x : alpha) : alpha := x
-- Works at every universe level
-- #end

-- #anchor: impredicativity_of_prop
-- This lives in Prop, not Type 1:
#check forall (P : Prop), P -> P  -- Prop

-- This lives in Type 1:
#check forall (A : Type), A -> A  -- Type 1
-- #end

-- #anchor: pi_types
-- Non-dependent: A -> B is sugar for (x : A) -> B (where B ignores x)
-- Dependent: the return type depends on the argument

-- Example: a function that returns different types based on input
def boolToType : Bool -> Type
  | true => Nat
  | false => String

def dependentFn : (b : Bool) -> boolToType b
  | true => (42 : Nat)
  | false => "hello"
-- #end

-- #anchor: sigma_types
-- Non-dependent: A x B
-- Dependent: { x : A // B x }

-- A number with a proof it is positive
def posPair : { n : Nat // n > 0 } := ⟨5, by omega⟩
-- #end

-- #anchor: definitional_vs_propositional
-- Definitional equality: checked by the kernel, no proof needed
-- 2 + 2 and 4 are definitionally equal
example : 2 + 2 = 4 := rfl

-- Propositional equality: requires a proof
-- n + 0 and n are NOT definitionally equal (for variable n)
-- But they are propositionally equal:
example (n : Nat) : n + 0 = n := by simp
-- #end

-- #anchor: proof_irrelevance
-- If h1 h2 : P, then h1 = h2 (definitionally in Prop)
theorem proof_irrel (P : Prop) (h1 h2 : P) : h1 = h2 := rfl
-- #end

-- #anchor: axiom_free
-- A simple constructive theorem (uses no axioms)
theorem myTheorem : 1 + 1 = 2 := rfl

-- Check which axioms a theorem uses:
#print axioms myTheorem
-- If empty, the theorem is fully constructive
-- #end

end Course0031Examples
