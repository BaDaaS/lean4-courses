/-
# 0012 - Finite Types and Decidability Exercises
-/

-- Exercise 1: Use decide to check propositions
#eval decide (2 + 2 = 4)    -- what is this?
#eval decide (2 + 2 = 5)    -- what is this?

-- Exercise 2: Write a function using Fin for safe access
def safeHead (xs : List alpha) (h : xs.length > 0) : alpha :=
  sorry

-- Exercise 3: Enumerate all values of Fin 4
-- Return them as a list
def allFin4 : List (Fin 4) := sorry

-- Exercise 4: Implement a function that converts Fin n to Nat
def finToNat (i : Fin n) : Nat := sorry

-- Exercise 5: Write a decision procedure
-- Given two lists of Nats, decide if they are equal
def listNatDecEq (xs ys : List Nat) : Decidable (xs = ys) := sorry

-- Exercise 6: Use if-then-else with a Prop (needs Decidable)
-- Return "yes" if n is even, "no" otherwise
def evenOrOdd (n : Nat) : String := sorry

-- Exercise 7: Prove that Fin 0 is empty (has no inhabitants)
theorem fin_zero_empty : Fin 0 -> False := sorry

-- Exercise 8: Define a function from Fin 3 to String
-- mapping 0 -> "zero", 1 -> "one", 2 -> "two"
def fin3ToString : Fin 3 -> String := sorry

-- Exercise 9 (medium): Count elements satisfying a decidable predicate
-- Given a list and a decidable predicate, count how many elements
-- satisfy the predicate.
def countIf (p : alpha -> Prop) [DecidablePred p]
    (xs : List alpha) : Nat := sorry

-- Exercise 10 (hard): Prove that the conjunction of two decidable
-- propositions is decidable. Construct the Decidable instance
-- manually (do not use inferInstance).
def decidableAnd (P Q : Prop) [Decidable P] [Decidable Q] :
    Decidable (P /\ Q) := sorry

-- Exercise 11 (hard): Bounded search. Find the smallest n < bound
-- satisfying a decidable predicate, or return none.
def boundedSearch (p : Nat -> Prop) [DecidablePred p]
    (bound : Nat) : Option Nat := sorry

-- Exercise 12 (challenge): Prove that equality on List Nat is
-- decidable. Construct the instance manually without using
-- inferInstance. You may use decidable equality on Nat.
def listNatDecEqManual :
    (xs ys : List Nat) -> Decidable (xs = ys) := sorry
