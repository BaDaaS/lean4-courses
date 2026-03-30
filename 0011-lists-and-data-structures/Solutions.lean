/-
# 0011 - Lists and Data Structures Solutions
-/

namespace Course0011

universe u v w

-- Exercise 1
theorem map_map {alpha : Type u} {beta : Type v} {gamma : Type w}
    (f : beta -> gamma) (g : alpha -> beta) (xs : List alpha) :
    (xs.map g).map f = xs.map (fun x => f (g x)) := by
  induction xs with
  | nil => rfl
  | cons x xs ih => simp [List.map, ih]

-- Exercise 2
theorem append_assoc {alpha : Type u} (xs ys zs : List alpha) :
    (xs ++ ys) ++ zs = xs ++ (ys ++ zs) := by
  induction xs with
  | nil => rfl
  | cons x xs ih => simp [ih]

-- Exercise 3
theorem reverse_reverse {alpha : Type u} (xs : List alpha) :
    xs.reverse.reverse = xs := by
  simp

-- Exercise 4
def myElem {alpha : Type u} [BEq alpha] (x : alpha) :
    List alpha -> Bool
  | [] => false
  | y :: ys => x == y || myElem x ys

-- Exercise 5
def intersperse {alpha : Type u} (sep : alpha) :
    List alpha -> List alpha
  | [] => []
  | [x] => [x]
  | x :: xs => x :: sep :: intersperse sep xs

-- Exercise 6
private def chunksOfAux {alpha : Type u} (n : Nat)
    (xs : List alpha) (hn : n > 0) : List (List alpha) :=
  if hx : xs = [] then []
  else
    have hlen : xs.length > 0 := by
      cases xs with
      | nil => contradiction
      | cons _ _ => simp
    have : (xs.drop n).length < xs.length := by
      simp [List.length_drop]; omega
    xs.take n :: chunksOfAux n (xs.drop n) hn
termination_by xs.length

def chunksOf {alpha : Type u} (n : Nat) (xs : List alpha) :
    List (List alpha) :=
  if h : n = 0 then [xs]
  else chunksOfAux n xs (Nat.pos_of_ne_zero h)

-- Exercise 7
structure Stack (alpha : Type u) where
  data : List alpha

def Stack.empty {alpha : Type u} : Stack alpha := { data := [] }

def Stack.push {alpha : Type u} (s : Stack alpha) (x : alpha) :
    Stack alpha :=
  { data := x :: s.data }

def Stack.pop {alpha : Type u} (s : Stack alpha) :
    Option (alpha × Stack alpha) :=
  match s.data with
  | [] => none
  | x :: xs => some (x, { data := xs })

def Stack.peek {alpha : Type u} (s : Stack alpha) :
    Option alpha :=
  match s.data with
  | [] => none
  | x :: _ => some x

-- Exercise 8
theorem length_map {alpha : Type u} {beta : Type v}
    (f : alpha -> beta) (xs : List alpha) :
    (xs.map f).length = xs.length := by
  induction xs with
  | nil => rfl
  | cons x xs ih => simp [ih]

-- ============================================================
-- Additional Exercises
-- ============================================================

-- Exercise 9 (medium): filter preserves membership
theorem mem_of_mem_filter {alpha : Type u} (p : alpha -> Bool)
    (xs : List alpha) (x : alpha)
    (h : x ∈ xs.filter p) : x ∈ xs := by
  simp [List.mem_filter] at h
  exact h.1

-- Exercise 10 (hard): Association list lookup
def assocLookup {alpha : Type u} [BEq alpha] {beta : Type v}
    (key : alpha) : List (alpha × beta) -> Option beta
  | [] => none
  | (k, v) :: rest =>
    if k == key then some v else assocLookup key rest

#eval assocLookup "b" [("a", 1), ("b", 2), ("c", 3)]
-- some 2
#eval assocLookup "z" [("a", 1), ("b", 2)]
-- none

-- Exercise 11 (hard): length of filter <= length
theorem length_filter_le {alpha : Type u} (p : alpha -> Bool)
    (xs : List alpha) :
    (xs.filter p).length <= xs.length :=
  List.length_filter_le p xs

-- Exercise 12 (challenge): reverse distributes over append
theorem reverse_append {alpha : Type u} (xs ys : List alpha) :
    (xs ++ ys).reverse = ys.reverse ++ xs.reverse := by
  simp

end Course0011
