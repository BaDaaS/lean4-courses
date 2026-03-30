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
    List alpha -> List beta -> List (alpha x beta)
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
  match xs with
  | [] => []
  | [x] => [x]
  | _ =>
    let mid := xs.length / 2
    let left := xs.take mid
    let right := xs.drop mid
    merge (mergeSort left) (mergeSort right)
termination_by xs.length

end Course0008
