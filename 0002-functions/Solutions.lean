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

-- =============================================
-- Additional exercises (increasing difficulty)
-- =============================================

-- Exercise 8 (medium): Pipe operator
def pipe {alpha beta : Type} (x : alpha) (f : alpha -> beta) : beta := f x

infixl:1 " |>> " => pipe

#eval pipe 5 (fun n : Nat => n * 2)  -- 10
#eval pipe (pipe 5 (fun n : Nat => n + 1)) (fun n => n * 3)  -- 18

-- Exercise 9 (hard): Compose is associative
theorem compose_assoc {alpha beta gamma delta : Type}
    (f : gamma -> delta) (g : beta -> gamma) (h : alpha -> beta) :
    compose f (compose g h) = compose (compose f g) h := by
  rfl

-- Exercise 10 (hard): Apply a list of functions sequentially
def applyAll {alpha : Type} (fs : List (alpha -> alpha)) (x : alpha) : alpha :=
  match fs with
  | [] => x
  | f :: rest => applyAll rest (f x)

#eval applyAll [(fun n : Nat => n + 1), (fun n => n * 2), (fun n => n + 10)] 5
-- 22

-- Exercise 11 (challenge): Church numerals
def churchZero {alpha : Type} (_f : alpha -> alpha) (x : alpha) : alpha := x

def churchSucc {alpha : Type}
    (n : (alpha -> alpha) -> alpha -> alpha)
    (f : alpha -> alpha) (x : alpha) : alpha :=
  f (n f x)

def churchAdd {alpha : Type}
    (m n : (alpha -> alpha) -> alpha -> alpha)
    (f : alpha -> alpha) (x : alpha) : alpha :=
  m f (n f x)

-- Church numeral 1 = succ zero
#eval churchSucc churchZero (fun n : Nat => n + 1) 0  -- 1
-- Church numeral 2 + 3 = 5
#eval churchAdd
  (churchSucc (churchSucc churchZero))
  (churchSucc (churchSucc (churchSucc churchZero)))
  (fun n : Nat => n + 1) 0  -- 5

end Course0002
