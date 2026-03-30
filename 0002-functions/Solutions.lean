/-
# 0002 - Functions Solutions
-/

namespace Course0002

-- Exercise 1
def square (n : Nat) : Nat := n * n

-- Exercise 2
def addTen : Nat -> Nat := fun n => n + 10

-- Exercise 3
def compose {alpha beta gamma : Type}
    (f : beta -> gamma) (g : alpha -> beta) : alpha -> gamma :=
  fun x => f (g x)

-- Exercise 4
def applyThrice {alpha : Type} (f : alpha -> alpha) (x : alpha) : alpha :=
  f (f (f x))

#check (rfl : applyThrice (fun n : Nat => n + 1) 0 = 3)

-- Exercise 5
def const {alpha beta : Type} (a : alpha) (_ : beta) : alpha := a

-- Exercise 6
def flip {alpha beta gamma : Type}
    (f : alpha -> beta -> gamma) : beta -> alpha -> gamma :=
  fun b a => f a b

-- Exercise 7
def myMax (a b : Nat) : Nat :=
  if a >= b then a else b

#eval myMax 3 7  -- 7
#eval myMax 9 2  -- 9

end Course0002
