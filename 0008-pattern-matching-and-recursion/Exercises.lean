/-
# 0008 - Pattern Matching and Recursion Exercises
-/

-- Exercise 1: Implement map for lists
def myMap (f : alpha -> beta) : List alpha -> List beta := sorry

-- Exercise 2: Implement filter for lists
def myFilter (p : alpha -> Bool) : List alpha -> List alpha := sorry

-- Exercise 3: Implement foldr (right fold)
def myFoldr (f : alpha -> beta -> beta) (init : beta) :
    List alpha -> beta := sorry

-- Exercise 4: Implement reverse using an accumulator
def myReverse (xs : List alpha) : List alpha :=
  sorry

-- Exercise 5: Implement zip
def myZip : List alpha -> List beta -> List (alpha x beta) := sorry

-- Exercise 6: Fibonacci (with termination)
def fib : Nat -> Nat := sorry

-- #eval fib 10  -- 55

-- Exercise 7: Implement flatten for nested lists
def flatten : List (List alpha) -> List alpha := sorry

-- Exercise 8: Implement take and drop
def myTake : Nat -> List alpha -> List alpha := sorry
def myDrop : Nat -> List alpha -> List alpha := sorry

-- Exercise 9: Implement a function that computes the depth of a tree
inductive Tree (alpha : Type) where
  | leaf : Tree alpha
  | node (left : Tree alpha) (val : alpha) (right : Tree alpha) : Tree alpha

def depth : Tree alpha -> Nat := sorry

-- Exercise 10 (challenge): Implement merge sort
def merge (xs ys : List Nat) : List Nat := sorry

def mergeSort (xs : List Nat) : List Nat := sorry

-- ============================================================
-- Additional Exercises
-- ============================================================

-- Exercise 11 (medium): Implement partition
-- Split a list into two: elements satisfying the predicate, and
-- elements that do not.
def partition (p : alpha -> Bool) (xs : List alpha) :
    List alpha × List alpha :=
  sorry

-- Exercise 12 (hard): Implement quicksort for List Nat
def quickSort (xs : List Nat) : List Nat := sorry

-- Exercise 13 (hard): Implement unfold
-- Generate a list from a seed value. The function f returns
-- none to stop, or some (element, nextSeed) to continue.
def unfold (f : sigma -> Option (alpha × sigma)) (seed : sigma)
    (fuel : Nat) : List alpha :=
  sorry

-- Exercise 14 (challenge): Balanced BST insertion
-- Define a simple BST and an insert function that maintains
-- the BST property.
inductive BST where
  | empty : BST
  | node (left : BST) (val : Nat) (right : BST) : BST

def BST.insert (t : BST) (x : Nat) : BST := sorry

def BST.toList : BST -> List Nat := sorry
