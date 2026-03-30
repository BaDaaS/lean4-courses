/-
# 0001 - Types Exercises
-/

-- Exercise 1: What are the types of these expressions?
-- Use #check to verify your guesses before uncommenting.

-- Guess the type, then verify:
-- #check 42
-- #check "hello"
-- #check (3, "hi")
-- #check fun x : Nat => x + 1
-- #check @List.nil Nat

-- Exercise 2: Define a value of type Nat x String
def myPair : Nat x String := sorry

-- Exercise 3: Define a value of type Bool x Bool x Nat
def myTriple : Bool x Bool x Nat := sorry

-- Exercise 4: Define a function type that takes two Nats and returns a Bool
-- (just the type signature with sorry body)
def compareFn : Nat -> Nat -> Bool := sorry

-- Exercise 5: What is the difference between these two?
-- Uncomment and think about what #check tells you.
-- #check (1 = 1)           -- lives in Prop
-- #check (1 == 1)          -- lives in Bool (BEq instance)

-- Exercise 6: Define a function that takes a Prop and returns a Prop
-- Hint: negation is a function Prop -> Prop
def myNot (P : Prop) : Prop := sorry

-- Exercise 7: Use universe polymorphism
-- Define the identity function for any type
def myId {alpha : Type} (x : alpha) : alpha := sorry

-- Verify:
-- #eval myId 42        -- 42
-- #eval myId "hello"   -- "hello"
