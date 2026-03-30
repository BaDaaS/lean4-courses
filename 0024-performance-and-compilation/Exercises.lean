/-
# 0023 - Performance and Compilation Exercises
-/

-- Exercise 1: Convert this to tail-recursive form
def factorialSlow : Nat -> Nat
  | 0 => 1
  | n + 1 => (n + 1) * factorialSlow n

def factorialFast (n : Nat) : Nat := sorry
-- Should use an accumulator

-- Exercise 2: Rewrite using Array instead of List for performance
def sumList (xs : List Nat) : Nat :=
  xs.foldl (. + .) 0

-- Process a large collection efficiently using Array
def sumArray (xs : Array Nat) : Nat := sorry

-- Exercise 3: Write a benchmark harness
-- Run an action N times and report average time
def benchmarkN (label : String) (n : Nat) (action : IO Unit) :
    IO Unit := do
  sorry

-- Exercise 4: Implement @[implementedBy] pattern
-- Define a specification and an optimized implementation

-- Spec: reverse a list (simple but O(n^2))
def reverseSpec : List alpha -> List alpha
  | [] => []
  | x :: xs => reverseSpec xs ++ [x]

-- Efficient: O(n) with accumulator
def reverseImpl (xs : List alpha) : List alpha := sorry

-- Exercise 5: Write an efficient string builder
-- Concatenating strings one by one is O(n^2)
-- Use an Array as a buffer for O(n) total
def buildString (parts : Array String) : String := sorry

-- Exercise 6: Implement a memoized Fibonacci using Array
def fibMemo (n : Nat) : Nat := sorry

-- Exercise 7: Profile Array.push vs List.cons
-- Create a function that builds a collection of n elements
-- using each approach, and time them
def benchArrayVsList (n : Nat) : IO Unit := do
  sorry
