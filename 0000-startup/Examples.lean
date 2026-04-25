/-
# 0000 - Startup Examples

Code examples from the README, wrapped in anchors for injection.
-/

namespace Course0000Examples

-- #anchor: first_lean_file
-- This is a comment
#check 42          -- Nat
#check "hello"     -- String
#check true        -- Bool

#eval 2 + 3        -- 5
#eval "hello " ++ "world"  -- "hello world"

def greeting : String := "Hello, Lean 4!"
#eval greeting
-- #end

-- #anchor: def_double
def double (n : Nat) : Nat := 2 * n
#eval double 5  -- 10 (runs compiled code)
-- #end

-- #anchor: theorem_two_eq
theorem two_eq : 1 + 1 = 2 := rfl
-- #eval two_eq  -- ERROR: not executable
-- #end

-- #anchor: example_declarations
example : 1 + 1 = 2 := rfl          -- checked, then forgotten
example (n : Nat) : Nat := n + 1    -- also fine
-- #end

-- #anchor: abbrev_nat_pair
abbrev NatPair := Nat × Nat  -- always unfolded by simp
-- #end

-- #anchor: opaque_secret_value
opaque secretValue : Nat := 42
-- The kernel cannot see that secretValue = 42
-- #end

-- #anchor: noncomputable_classical_choice
noncomputable def classicalChoice (P : Prop) [h : Decidable P] :
    Bool := if P then true else false
-- #end

-- #anchor: axiom_my_axiom
axiom myAxiom : forall (n : Nat), n + 0 = n
-- No proof needed, but no guarantee of consistency
-- #end

-- #anchor: print_double
#print double
-- def double : Nat -> Nat :=
-- fun n => 2 * n
-- #end

-- #anchor: print_axioms
#print axioms two_eq   -- shows which axioms were used
-- #end

-- #anchor: theorem_one_plus_one
-- A theorem is a type (the statement) with a term (the proof)
theorem one_plus_one : 1 + 1 = 2 := rfl
-- #end

-- #anchor: factorial_def
def factorial : Nat -> Nat
  | 0 => 1
  | n + 1 => (n + 1) * factorial n

#eval factorial 10  -- 3628800
-- #end

end Course0000Examples
