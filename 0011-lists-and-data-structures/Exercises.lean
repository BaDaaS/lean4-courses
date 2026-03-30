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

-- ============================================================
-- Additional Exercises
-- ============================================================

-- Exercise 9 (medium): Prove that filter preserves membership
-- If x is in (filter p xs), then x is in xs.
theorem mem_of_mem_filter {alpha : Type} (p : alpha -> Bool)
    (xs : List alpha) (x : alpha)
    (h : x ∈ xs.filter p) : x ∈ xs := by
  sorry

-- Exercise 10 (hard): Implement lookup for association lists
-- and prove it finds the correct value.
def assocLookup {alpha : Type} [BEq alpha] {beta : Type}
    (key : alpha) : List (alpha × beta) -> Option beta
  | [] => none
  | (k, v) :: rest =>
    if k == key then some v else assocLookup key rest

-- Exercise 11 (hard): Prove that length of filter is <= length
-- of original list.
theorem length_filter_le {alpha : Type} (p : alpha -> Bool)
    (xs : List alpha) :
    (xs.filter p).length <= xs.length := by
  sorry

-- Exercise 12 (challenge): Prove reverse distributes over append
-- reverse (xs ++ ys) = reverse ys ++ reverse xs
theorem reverse_append {alpha : Type} (xs ys : List alpha) :
    (xs ++ ys).reverse = ys.reverse ++ xs.reverse := by
  sorry
