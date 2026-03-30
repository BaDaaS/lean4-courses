/-
# 0001 - Types Solutions
-/

namespace Course0001

-- Exercise 1
#check 42                     -- Nat
#check "hello"                -- String
#check (3, "hi")              -- Nat x String
#check fun x : Nat => x + 1  -- Nat -> Nat
#check @List.nil Nat          -- List Nat

-- Exercise 2
def myPair : Nat × String := (42, "answer")

-- Exercise 3
def myTriple : Bool × Bool × Nat := (true, false, 7)

-- Exercise 4
def compareFn : Nat -> Nat -> Bool :=
  fun a b => a < b

-- Exercise 5
#check (1 = 1)   -- Prop (equality proposition)
#check (1 == 1)  -- Bool (decidable equality)

-- Exercise 6
def myNot (P : Prop) : Prop := P -> False

-- Exercise 7
def myId {alpha : Type} (x : alpha) : alpha := x

#eval myId 42
#eval myId "hello"

-- =============================================
-- Additional exercises (increasing difficulty)
-- =============================================

-- Exercise 8 (medium): Type alias using abbrev
abbrev NatPair := Prod Nat Nat
def examplePair : NatPair := (3, 7)

#eval examplePair  -- (3, 7)

-- Exercise 9 (hard): Define your own Either type
inductive Either (alpha : Type) (beta : Type) where
  | left  : alpha -> Either alpha beta
  | right : beta -> Either alpha beta

def eitherExample1 : Either Nat String := Either.left 42
def eitherExample2 : Either Nat String := Either.right "hello"

-- Exercise 10 (hard): Extract Nat from Sum Nat String
def extractNat (x : Sum Nat String) : Nat :=
  match x with
  | Sum.inl n => n
  | Sum.inr _ => 0

#eval extractNat (Sum.inl 42)       -- 42
#eval extractNat (Sum.inr "hello")  -- 0

-- Exercise 11 (challenge): Prop coercion demonstration
-- In Lean, Prop is Sort 0, and Type is Sort 1. There is a
-- coercion that lets Props be used in certain Type contexts.
-- Here we simply show that a proof of P has type P.
def propToType (P : Prop) (h : P) : P := h

-- Demonstrate usage:
#check propToType True True.intro  -- True

end Course0001
