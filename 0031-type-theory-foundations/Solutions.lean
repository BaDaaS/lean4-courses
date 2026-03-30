/-
# 0031 - Type Theory Foundations Solutions
-/

namespace Course0031

universe u v

-- Exercise 1: Prove proof irrelevance
-- In Lean, any two proofs of the same Prop are definitionally equal.
-- This is built into the kernel. We can state and prove it:
theorem proof_irrelevance {P : Prop} (h1 h2 : P) : h1 = h2 :=
  rfl

-- A more interesting instance: two proofs of And
theorem and_proof_irrelevance {P Q : Prop}
    (h1 h2 : P /\ Q) : h1 = h2 :=
  rfl

-- Exercise 2: Show that Prop is impredicative
-- A forall quantifying over all Props still lives in Prop.
-- This is impredicativity: Prop : Type 0, but (forall P : Prop, P) : Prop.
def impredicativeExample : Prop := forall (P : Prop), P -> P

-- The identity function on Prop lives in Prop itself
def propId : impredicativeExample := fun (_P : Prop) (p : _P) => p

-- Contrast with Type: forall (A : Type), A -> A lives in Type 1, not Type 0
-- This shows Prop is special.
#check (forall (P : Prop), P -> P : Prop)      -- Prop (impredicative)
#check (forall (A : Type), A -> A : Type 1)     -- Type 1 (predicative)

-- Exercise 3: Define the Church encoding of Nat
def CNat : Type 1 := forall (A : Type), (A -> A) -> A -> A

-- Exercise 4: Implement zero, succ, add for Church numerals
def czero : CNat := fun (_A : Type) (_s : _A -> _A) (z : _A) => z

def csucc (n : CNat) : CNat :=
  fun (A : Type) (s : A -> A) (z : A) => s (n A s z)

def cadd (m n : CNat) : CNat :=
  fun (A : Type) (s : A -> A) (z : A) => m A s (n A s z)

-- Convert Church numeral to Nat for testing
def cToNat (n : CNat) : Nat := n Nat (. + 1) 0

def cone : CNat := csucc czero
def ctwo : CNat := csucc cone
def cthree : CNat := csucc ctwo

#eval cToNat czero     -- 0
#eval cToNat cone      -- 1
#eval cToNat ctwo      -- 2
#eval cToNat cthree    -- 3
#eval cToNat (cadd ctwo cthree)  -- 5

-- Exercise 5: Prove that Bool has exactly two elements
-- Every Bool value is either true or false.
theorem bool_cases (b : Bool) : b = true \/ b = false := by
  cases b
  . right; rfl
  . left; rfl

-- Stronger: Bool has exactly two distinct elements
theorem bool_exactly_two : true != false /\ (forall (b : Bool),
    b = true \/ b = false) :=
  And.intro (by decide) bool_cases

-- Exercise 6: Prove function extensionality
-- In Lean, funext is an axiom. We demonstrate its use.
-- We show that if two functions agree on all inputs, they are equal.
theorem my_funext {A : Type u} {B : Type v} {f g : A -> B}
    (h : forall (x : A), f x = g x) : f = g :=
  funext h

-- Demonstrate: two definitions of "add 1" are equal
theorem add_one_eq : (fun (n : Nat) => n + 1) =
    (fun (n : Nat) => Nat.succ n) := by
  funext n
  rfl

-- Exercise 7: Demonstrate universe polymorphism
-- A polymorphic identity function at explicit universe levels
def polyId.{w} (A : Type w) (a : A) : A := a

-- Using it at different universe levels
#check polyId.{0} Nat 42           -- Nat
#check polyId.{1} (Type 0) Nat     -- Type

-- A polymorphic pair that works across universes
structure UPair.{w1, w2} (A : Type w1) (B : Type w2) where
  fst : A
  snd : B

def exPair1 : UPair.{0, 0} Nat Bool := { fst := 42, snd := true }
def exPair2 : UPair.{1, 0} Type Nat := { fst := Bool, snd := 7 }

-- Exercise 8: Prove that Empty type has no inhabitants
-- Empty is the type with no constructors.
-- We can use nomatch or match with no cases.
theorem empty_no_inhabitants (h : Empty) : False :=
  nomatch h

-- Equivalently, Empty -> P for any P (ex falso quodlibet)
theorem ex_falso_from_empty {P : Prop} (h : Empty) : P :=
  nomatch h

-- We can also show Empty is equivalent to False in a sense
theorem empty_iff_false : Empty -> False :=
  fun h => nomatch h

-- Not (inhabited Empty)
theorem empty_not_inhabited : Empty -> False :=
  empty_no_inhabitants

end Course0031
