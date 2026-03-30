/-
# 0008 - Pattern Matching and Recursion Solutions
-/

namespace Course0008

universe u v

-- Exercise 1
def myMap {alpha : Type u} {beta : Type v} (f : alpha -> beta) :
    List alpha -> List beta
  | [] => []
  | x :: xs => f x :: myMap f xs

-- Exercise 2
def myFilter {alpha : Type u} (p : alpha -> Bool) :
    List alpha -> List alpha
  | [] => []
  | x :: xs => if p x then x :: myFilter p xs else myFilter p xs

-- Exercise 3
def myFoldr {alpha : Type u} {beta : Type v}
    (f : alpha -> beta -> beta) (init : beta) :
    List alpha -> beta
  | [] => init
  | x :: xs => f x (myFoldr f init xs)

-- Exercise 4
def myReverse {alpha : Type u} (xs : List alpha) : List alpha :=
  go [] xs
where
  go (acc : List alpha) : List alpha -> List alpha
    | [] => acc
    | x :: xs => go (x :: acc) xs

-- Exercise 5
def myZip {alpha : Type u} {beta : Type v} :
    List alpha -> List beta -> List (alpha × beta)
  | a :: as, b :: bs => (a, b) :: myZip as bs
  | _, _ => []

-- Exercise 6
def fib : Nat -> Nat
  | 0 => 0
  | 1 => 1
  | n + 2 => fib (n + 1) + fib n

#eval fib 10  -- 55

-- Exercise 7
def flatten {alpha : Type u} : List (List alpha) -> List alpha
  | [] => []
  | xs :: xss => xs ++ flatten xss

-- Exercise 8
def myTake {alpha : Type u} : Nat -> List alpha -> List alpha
  | 0, _ => []
  | _, [] => []
  | n + 1, x :: xs => x :: myTake n xs

def myDrop {alpha : Type u} : Nat -> List alpha -> List alpha
  | 0, xs => xs
  | _, [] => []
  | n + 1, _ :: xs => myDrop n xs

-- Exercise 9
inductive Tree (alpha : Type u) where
  | leaf : Tree alpha
  | node (left : Tree alpha) (val : alpha)
      (right : Tree alpha) : Tree alpha

def depth {alpha : Type u} : Tree alpha -> Nat
  | .leaf => 0
  | .node l _ r => 1 + max (depth l) (depth r)

-- Exercise 10
def merge (xs ys : List Nat) : List Nat :=
  match xs, ys with
  | [], ys => ys
  | xs, [] => xs
  | x :: xs', y :: ys' =>
    if x <= y then x :: merge xs' (y :: ys')
    else y :: merge (x :: xs') ys'
termination_by xs.length + ys.length

def mergeSort (xs : List Nat) : List Nat :=
  match h : xs with
  | [] => []
  | [x] => [x]
  | _ :: _ :: _ =>
    let mid := xs.length / 2
    let left := xs.take mid
    let right := xs.drop mid
    merge (mergeSort left) (mergeSort right)
termination_by xs.length
decreasing_by all_goals simp_all; omega

-- ============================================================
-- Additional Exercises
-- ============================================================

-- Exercise 11 (medium): partition
def partition {alpha : Type u} (p : alpha -> Bool)
    (xs : List alpha) : List alpha × List alpha :=
  match xs with
  | [] => ([], [])
  | x :: rest =>
    let (yes, no) := partition p rest
    if p x then (x :: yes, no) else (yes, x :: no)

#eval partition (. > 3) [1, 5, 2, 8, 3, 7]
-- ([5, 8, 7], [1, 2, 3])

-- Exercise 12 (hard): quicksort
-- We use List.filter on the tail so the result is strictly smaller.
def quickSort (xs : List Nat) : List Nat :=
  match xs with
  | [] => []
  | pivot :: rest =>
    let lo := rest.filter (. < pivot)
    let hi := rest.filter (. >= pivot)
    quickSort lo ++ [pivot] ++ quickSort hi
termination_by xs.length
decreasing_by
  all_goals simp_all
  all_goals (
    calc (List.filter _ rest.attach).length
        _ <= rest.attach.length := List.length_filter_le _ _
        _ = rest.length := by simp [List.length_attach]
    omega)

#eval quickSort [5, 3, 8, 1, 9, 2, 7]
-- [1, 2, 3, 5, 7, 8, 9]

-- Exercise 13 (hard): unfold
def unfold {alpha : Type u} {sigma : Type v}
    (f : sigma -> Option (alpha × sigma)) (seed : sigma)
    (fuel : Nat) : List alpha :=
  match fuel with
  | 0 => []
  | fuel' + 1 =>
    match f seed with
    | none => []
    | some (x, seed') => x :: unfold f seed' fuel'

-- Generate [1, 2, 3, 4, 5] from seed 1
#eval unfold (fun n => if n <= 5 then some (n, n + 1) else none) 1 10

-- Exercise 14 (challenge): BST insertion
inductive BST where
  | empty : BST
  | node (left : BST) (val : Nat) (right : BST) : BST

def BST.insert (t : BST) (x : Nat) : BST :=
  match t with
  | .empty => .node .empty x .empty
  | .node l v r =>
    if x < v then .node (l.insert x) v r
    else if x > v then .node l v (r.insert x)
    else .node l v r  -- duplicate, no change

def BST.toList : BST -> List Nat
  | .empty => []
  | .node l v r => l.toList ++ [v] ++ r.toList

#eval (BST.empty.insert 5 |>.insert 3 |>.insert 7
  |>.insert 1 |>.insert 4).toList
-- [1, 3, 4, 5, 7]

end Course0008
