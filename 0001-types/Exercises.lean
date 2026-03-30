/-
# 0001 - Types Exercises
-/

-- Exercise 1: What are the types of these expressions?
-- Use #check to verify your guesses before uncommenting.

-- Guess the type, then verify:
#check 42
#check "hello"
#check (3, "hi")
#check fun x : Nat => x + 1
#check @List.nil Nat

-- Exercise 2: Define a value of type Nat x String
def myPair : Prod Nat String := (3, "Hi")

-- Exercise 3: Define a value of type Bool x Bool x Nat
def myTriple : Prod Bool (Prod Bool Nat) := (true, false, 5)

-- Exercise 4: Define a function type that takes two Nats and returns a Bool
-- (just the type signature with sorry body)
def compareFn : Nat -> Nat -> Bool := fun a b => a <= b

-- Exercise 5: What is the difference between these two?
-- Uncomment and think about what #check tells you.
#check (1 = 1)           -- lives in Prop
#check (1 == 1)          -- lives in Bool (BEq instance)

-- Exercise 6: Define a function that takes a Prop and returns a Prop
-- Hint: negation is a function Prop -> Prop
def myNot (P : Prop) : Prop := P -> False

-- Exercise 7: Use universe polymorphism
-- Define the identity function for any type
def myId {alpha : Type} (x : alpha) : alpha := x

-- Verify:
#eval myId 42        -- 42
#eval myId "hello"   -- "hello"

-- =============================================
-- Additional exercises (increasing difficulty)
-- =============================================

-- Exercise 8 (medium): Define a type alias for a pair of Nats
-- Use `abbrev` to create a type alias called `NatPair`
-- Then define a value of that type.
-- Hint: use Prod Nat Nat (the `x` notation does not work
-- inside abbrev outside a namespace with the right opens)
abbrev NatPair := sorry  -- fix this
def examplePair : NatPair := sorry

-- Exercise 9 (hard): Define your own Either type (Sum type)
-- Either alpha beta should have two constructors:
--   left : alpha -> Either alpha beta
--   right : beta -> Either alpha beta
inductive Either (alpha : Type) (beta : Type) where
  | placeholder  -- remove this and add real constructors

-- Exercise 10 (hard): Define a function that extracts a Nat from
-- a Sum Nat String, returning 0 for the String case
-- Hint: Sum is defined in the standard library with .inl and .inr
def extractNat (x : Sum Nat String) : Nat := sorry

-- Verify (uncomment once implemented):
-- #eval extractNat (Sum.inl 42)       -- 42
-- #eval extractNat (Sum.inr "hello")  -- 0

-- Exercise 11 (challenge): The type Prop lives in Type.
-- Show that True (a Prop) can be used where Type is expected
-- by defining a function that accepts any Type and calling it
-- with a Prop value.
-- Hint: Prop is Type 0 in Lean's universe hierarchy, but there
-- is a coercion from Prop to Type. Demonstrate it:
def propToType (P : Prop) (h : P) : P := sorry
