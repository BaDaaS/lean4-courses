/-
# 0011 - Lists and Data Structures Solutions
-/

namespace Course0011

universe u v w

-- Exercise 1
theorem map_map {alpha : Type u} {beta : Type v} {gamma : Type w}
    (f : beta -> gamma) (g : alpha -> beta) (xs : List alpha) :
    (xs.map g).map f = xs.map (f . g) := by
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
def chunksOf {alpha : Type u} (n : Nat) (xs : List alpha) :
    List (List alpha) :=
  if n == 0 then [xs]
  else go n xs
where
  go (n : Nat) (xs : List alpha) : List (List alpha) :=
    if xs.isEmpty then []
    else xs.take n :: go n (xs.drop n)
  termination_by xs.length

-- Exercise 7
structure Stack (alpha : Type u) where
  data : List alpha

def Stack.empty {alpha : Type u} : Stack alpha := { data := [] }

def Stack.push {alpha : Type u} (s : Stack alpha) (x : alpha) :
    Stack alpha :=
  { data := x :: s.data }

def Stack.pop {alpha : Type u} (s : Stack alpha) :
    Option (alpha x Stack alpha) :=
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

end Course0011
