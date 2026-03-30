/-
# 0002 - Functions Exercises
-/

-- Exercise 1: Define a function that computes the square of a number
def square (n : Nat) : Nat := sorry

-- Exercise 2: Define a function using a lambda expression
-- that adds 10 to its argument
def addTen : Nat -> Nat := sorry

-- Exercise 3: Define function composition
def compose {alpha beta gamma : Type}
    (f : beta -> gamma) (g : alpha -> beta) : alpha -> gamma :=
  sorry

-- Exercise 4: Define a function that applies f three times
def applyThrice {alpha : Type} (f : alpha -> alpha) (x : alpha) : alpha :=
  sorry

-- Verify: applyThrice (fun n => n + 1) 0 = 3
#check (rfl : applyThrice (fun n : Nat => n + 1) 0 = 3)

-- Exercise 5: Define the constant function (ignores second argument)
def const {alpha beta : Type} (a : alpha) (_ : beta) : alpha := sorry

-- Exercise 6: Define flip, which swaps the arguments of a function
def flip {alpha beta gamma : Type}
    (f : alpha -> beta -> gamma) : beta -> alpha -> gamma :=
  sorry

-- Exercise 7: Define a function that returns the maximum of two Nats
-- Hint: use if-then-else
def myMax (a b : Nat) : Nat := sorry

-- Verify:
-- #eval myMax 3 7  -- 7
-- #eval myMax 9 2  -- 9
