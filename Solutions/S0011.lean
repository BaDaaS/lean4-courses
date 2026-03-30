/-
# 0011 - Lists and Data Structures Solutions
-/

namespace S0011

-- Exercise 1
theorem map_map {alpha beta gamma : Type}
    (f : beta -> gamma) (g : alpha -> beta) (xs : List alpha) :
    (xs.map g).map f = xs.map (fun x => f (g x)) := by
  induction xs with
  | nil => rfl
  | cons x xs ih => simp [List.map, ih]

-- Exercise 2
theorem append_assoc {alpha : Type} (xs ys zs : List alpha) :
    (xs ++ ys) ++ zs = xs ++ (ys ++ zs) := by
  induction xs with
  | nil => rfl
  | cons x xs ih => simp [ih]

-- Exercise 3
theorem reverse_reverse {alpha : Type} (xs : List alpha) :
    xs.reverse.reverse = xs := by
  simp

-- Exercise 4
def myElem {alpha : Type} [BEq alpha] (x : alpha) : List alpha -> Bool
  | [] => false
  | y :: ys => x == y || myElem x ys

-- Exercise 5
def intersperse {alpha : Type} (sep : alpha) : List alpha -> List alpha
  | [] => []
  | [x] => [x]
  | x :: xs => x :: sep :: intersperse sep xs

-- Exercise 6: chunksOf splits a list into chunks of size n.
-- Simplified to avoid complex termination proofs.
def chunksOf {alpha : Type} (n : Nat) (xs : List alpha) :
    List (List alpha) :=
  if n == 0 then [xs]
  else
    let rec go (fuel : Nat) (ys : List alpha) : List (List alpha) :=
      match fuel, ys with
      | 0, _ => if ys.isEmpty then [] else [ys]
      | _, [] => []
      | fuel + 1, _ => ys.take n :: go fuel (ys.drop n)
    go (xs.length + 1) xs

-- Exercise 7
structure Stack (alpha : Type) where
  data : List alpha

def Stack.empty {alpha : Type} : Stack alpha :=
  { data := [] }

def Stack.push {alpha : Type} (s : Stack alpha) (x : alpha) :
    Stack alpha :=
  { data := x :: s.data }

def Stack.pop {alpha : Type} (s : Stack alpha) :
    Option (alpha × Stack alpha) :=
  match s.data with
  | [] => none
  | x :: xs => some (x, { data := xs })

def Stack.peek {alpha : Type} (s : Stack alpha) : Option alpha :=
  match s.data with
  | [] => none
  | x :: _ => some x

-- Exercise 8
theorem length_map {alpha beta : Type} (f : alpha -> beta)
    (xs : List alpha) :
    (xs.map f).length = xs.length := by
  induction xs with
  | nil => rfl
  | cons x xs ih => simp [ih]

end S0011
