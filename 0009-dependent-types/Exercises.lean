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

-- ============================================================
-- Additional Exercises
-- ============================================================

-- Exercise 10 (medium): Define a NonEmpty list type
-- A list that is guaranteed to have at least one element.
structure NonEmpty (alpha : Type) where
  head : alpha
  tail : List alpha

def NonEmpty.toList (ne : NonEmpty alpha) : List alpha := sorry

def NonEmpty.fromList? (xs : List alpha) : Option (NonEmpty alpha) :=
  sorry

-- length is always >= 1
def NonEmpty.length (ne : NonEmpty alpha) : Nat := sorry

-- Exercise 11 (hard): Define Matrix as Vec of Vecs, implement
-- transpose
def Matrix (alpha : Type) (rows cols : Nat) : Type :=
  Vec (Vec alpha cols) rows

def Matrix.get (m : Matrix alpha rows cols)
    (i : Fin rows) (j : Fin cols) : alpha := sorry

def Matrix.transpose (m : Matrix alpha rows cols) :
    Matrix alpha cols rows := sorry

-- Exercise 12 (hard): Implement Vec.reverse
-- Hint: you may need a helper function with an accumulator,
-- or use Vec.append with a cast.
def Vec.reverseAux : Vec alpha n -> Vec alpha m ->
    Vec alpha (n + m) := sorry

-- Exercise 13 (challenge): Prove that Vec.map composed with
-- Vec.map equals Vec.map of the composition.
-- (Vec.map is already defined above in exercises 1-9.)
theorem Vec.map_map (f : beta -> gamma) (g : alpha -> beta)
    (v : Vec alpha n) :
    Vec.map f (Vec.map g v) = Vec.map (fun x => f (g x)) v := by
  sorry
