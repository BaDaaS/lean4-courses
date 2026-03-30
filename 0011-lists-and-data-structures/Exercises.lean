/-
# 0011 - Lists and Data Structures Exercises
-/

-- Exercise 1: Prove that mapping then mapping = mapping the composition
theorem map_map (f : beta -> gamma) (g : alpha -> beta) (xs : List alpha) :
    (xs.map g).map f = xs.map (f . g) := by
  sorry

-- Exercise 2: Prove append is associative
theorem append_assoc (xs ys zs : List alpha) :
    (xs ++ ys) ++ zs = xs ++ (ys ++ zs) := by
  sorry

-- Exercise 3: Prove reverse of reverse is identity
-- Hint: you may need a helper lemma about reverse and append
theorem reverse_reverse (xs : List alpha) :
    xs.reverse.reverse = xs := by
  sorry

-- Exercise 4: Implement and prove correct a membership check
def myElem [BEq alpha] (x : alpha) : List alpha -> Bool
  | [] => false
  | y :: ys => x == y || myElem x ys

-- Exercise 5: Implement intersperse
-- intersperse "," ["a", "b", "c"] = ["a", ",", "b", ",", "c"]
def intersperse (sep : alpha) : List alpha -> List alpha := sorry

-- Exercise 6: Implement chunksOf
-- chunksOf 2 [1,2,3,4,5] = [[1,2],[3,4],[5]]
def chunksOf (n : Nat) (xs : List alpha) : List (List alpha) := sorry

-- Exercise 7: Implement a stack using a list
structure Stack (alpha : Type) where
  data : List alpha

def Stack.empty : Stack alpha := { data := [] }
def Stack.push (s : Stack alpha) (x : alpha) : Stack alpha := sorry
def Stack.pop (s : Stack alpha) : Option (alpha x Stack alpha) := sorry
def Stack.peek (s : Stack alpha) : Option alpha := sorry

-- Exercise 8: Prove that length of map = length of original
theorem length_map (f : alpha -> beta) (xs : List alpha) :
    (xs.map f).length = xs.length := by
  sorry
