/-
# 0031 - Type Theory Foundations Exercises
-/

namespace Course0031E

universe u v

-- Exercise 1: Prove proof irrelevance
-- In Lean 4, any two proofs of the same Prop are definitionally equal.
-- Prove that given two proofs of P, they are equal.
theorem proof_irrelevance {P : Prop} (h1 h2 : P) : h1 = h2 :=
  sorry

-- Exercise 2: Show that Prop is impredicative
-- Define a type that quantifies over all Props but itself lives in Prop.
-- For example: forall (P : Prop), P -> P
-- Then provide an inhabitant of that type.
def impredicativeExample : Prop := sorry

-- Provide a proof/value:
-- def propId : impredicativeExample := sorry

-- Exercise 3: Define the Church encoding of Nat
-- A Church numeral is: forall (A : Type), (A -> A) -> A -> A
-- The number n applies the successor function n times to the zero element.
def CNat : Type 1 := sorry

-- Exercise 4: Implement zero, succ, add for Church numerals
-- czero: apply successor 0 times
-- csucc n: apply successor one more time than n does
-- cadd m n: apply successor m times after n times
def czero : CNat := sorry
def csucc (n : CNat) : CNat := sorry
def cadd (m n : CNat) : CNat := sorry

-- Conversion to Nat for testing:
-- def cToNat (n : CNat) : Nat := n Nat (. + 1) 0

-- Exercise 5: Prove that Bool has exactly two elements
-- Every Bool is either true or false.
theorem bool_cases (b : Bool) : b = true \/ b = false := sorry

-- Exercise 6: Prove function extensionality (use funext)
-- If two functions agree on all inputs, they are equal.
theorem my_funext {A : Type u} {B : Type v} {f g : A -> B}
    (h : forall (x : A), f x = g x) : f = g :=
  sorry

-- Demonstrate: show these two definitions of "add 1" are equal
theorem add_one_eq : (fun (n : Nat) => n + 1) =
    (fun (n : Nat) => Nat.succ n) := sorry

-- Exercise 7: Demonstrate universe polymorphism
-- Define a polymorphic identity function with explicit universe level
-- def polyId.{w} (A : Type w) (a : A) : A := sorry

-- Define a structure UPair that pairs values from different universes
-- structure UPair.{w1, w2} (A : Type w1) (B : Type w2) where
--   fst : A
--   snd : B

-- Exercise 8: Prove that Empty type has no inhabitants
-- Given a value of type Empty, derive False.
-- Hint: use nomatch or match with no cases.
theorem empty_no_inhabitants (h : Empty) : False := sorry

-- Also prove: Empty implies any proposition (ex falso quodlibet)
theorem ex_falso_from_empty {P : Prop} (h : Empty) : P := sorry

end Course0031E
