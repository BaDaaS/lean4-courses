/-
# 0007 - Monads and Do Notation Exercises
-/

-- Exercise 1: Use Option with do-notation
-- Return the head of a list, or none if empty
def safeHead (xs : List alpha) : Option alpha := sorry

-- Exercise 2: Chain Option computations with do-notation
-- Given a list of lists, get the head of the first list
def headOfHead (xss : List (List alpha)) : Option alpha := do
  sorry

-- Exercise 3: Implement safe indexing into a list
def safeIndex (xs : List alpha) (i : Nat) : Option alpha := sorry

-- Exercise 4: Chain safe operations
-- Get the element at index i, then use it to index into another list
def doubleIndex (xs ys : List Nat) (i : Nat) : Option Nat := do
  sorry

-- Exercise 5: Use the Except monad for error handling
def safeSqrt (n : Float) : Except String Float :=
  if n < 0.0 then .error "negative input" else .ok (Float.sqrt n)

-- Chain two sqrt operations
def doubleSqrt (n : Float) : Except String Float := do
  sorry

-- Exercise 6: Write a function that processes a list of strings as numbers
-- Return the sum, or an error if any string is not a number
def sumStrings (strs : List String) : Except String Int := do
  sorry

-- Exercise 7: Define your own simple monad
-- Identity monad (wraps a value, bind just applies the function)
structure Id (alpha : Type) where
  val : alpha

instance : Monad Id where
  pure := sorry
  bind := sorry

-- Exercise 8: Write an IO action that prints three lines
def greet (name : String) : IO Unit := do
  sorry
