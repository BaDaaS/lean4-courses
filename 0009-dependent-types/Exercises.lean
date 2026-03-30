/-
# 0009 - Dependent Types Exercises
-/

-- Exercise 1: Define a length-indexed vector
inductive Vec (alpha : Type) : Nat -> Type where
  | nil : Vec alpha 0
  | cons (head : alpha) (tail : Vec alpha n) : Vec alpha (n + 1)

-- Exercise 2: Define head for Vec (no Option needed - it cannot be empty!)
def Vec.head : Vec alpha (n + 1) -> alpha := sorry

-- Exercise 3: Define tail for Vec
def Vec.tail : Vec alpha (n + 1) -> Vec alpha n := sorry

-- Exercise 4: Define map for Vec (preserves length in the type)
def Vec.map (f : alpha -> beta) : Vec alpha n -> Vec beta n := sorry

-- Exercise 5: Define append for Vec (lengths add up in the type)
def Vec.append : Vec alpha n -> Vec alpha m -> Vec alpha (n + m) := sorry

-- Exercise 6: Define a safe division function
-- Takes a proof that the divisor is not zero
def safeDiv (a : Nat) (b : Nat) (h : b > 0) : Nat := sorry

-- Exercise 7: Define a subtype for even numbers
def EvenNat := { n : Nat // n % 2 = 0 }

-- Construct some even numbers
def zero_even : EvenNat := sorry
def four_even : EvenNat := sorry

-- Exercise 8: Define replicate for Vec
-- Create a Vec of n copies of a value
def Vec.replicate (n : Nat) (x : alpha) : Vec alpha n := sorry

-- Exercise 9 (challenge): Define zip for Vec
-- Both vectors must have the same length
def Vec.zip : Vec alpha n -> Vec beta n -> Vec (alpha x beta) n := sorry
