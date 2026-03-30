/-
# 0002 - Functions Exercises
-/

-- Exercise 1: Define a function that computes the square of a number
def square (n : Nat) : Nat := n * n

-- Exercise 2: Define a function using a lambda expression
-- that adds 10 to its argument
def addTen : Nat -> Nat := fun n => n + 10

-- Exercise 3: Define function composition
-- def compose {alpha beta gamma : Type}
    -- (f : beta -> gamma) (g : alpha -> beta) : alpha -> gamma :=
def compose {alpha beta gamma: Type} (f: beta -> gamma) (g : alpha -> beta) := fun x => f (g x)

-- Exercise 4: Define a function that applies f three times
def applyThrice {alpha : Type} (f : alpha -> alpha) (x : alpha) : alpha := f (f (f x))

-- Verify: applyThrice (fun n => n + 1) 0 = 3
#check (rfl : applyThrice (fun n : Nat => n + 1) 0 = 3)

-- Exercise 5: Define the constant function (ignores second argument)
def const {alpha beta : Type} (a : alpha) (_ : beta) : alpha := a

-- Exercise 6: Define flip, which swaps the arguments of a function
def myFlip {alpha beta gamma : Type}
    (f : alpha -> beta -> gamma) : beta -> alpha -> gamma :=
    fun a b => (f b a)

-- Exercise 7: Define a function that returns the maximum of two Nats
-- Hint: use if-then-else
def myMax (a b : Nat) : Nat := if a > b then a else b

-- Verify:
#eval myMax 3 7  -- 7
#eval myMax 9 2  -- 9

def myEven (n : Nat) : Bool := match n with
  | 0 => true
  | 1 => false
  | n + 2 => myEven n


#eval myEven 1000000

-- =============================================
-- Additional exercises (increasing difficulty)
-- =============================================

-- Exercise 8 (medium): Define a pipe operator
-- x |> f should equal f x
-- Use `infixl` to declare the notation with precedence 1
-- Note: we use |>> to avoid conflict with the built-in |> operator
def pipe {alpha beta : Type} (x : alpha) (f : alpha -> beta) : beta := sorry

-- Uncomment once pipe is defined:
-- infixl:1 " |>> " => pipe
-- #eval pipe 5 (fun n : Nat => n * 2)  -- should be 10

-- Exercise 9 (hard): Prove that compose is associative
-- compose f (compose g h) = compose (compose f g) h
-- Hint: use funext and rfl
theorem compose_assoc {alpha beta gamma delta : Type}
    (f : gamma -> delta) (g : beta -> gamma) (h : alpha -> beta) :
    compose f (compose g h) = compose (compose f g) h := sorry

-- Exercise 10 (hard): Apply a list of functions sequentially
-- Given a list of functions and a starting value, apply each in order.
-- applyAll [f, g, h] x = h (g (f x))
def applyAll {alpha : Type} (fs : List (alpha -> alpha)) (x : alpha) : alpha :=
  sorry

-- Verify (uncomment once implemented):
-- #eval applyAll [(fun n : Nat => n + 1), (fun n => n * 2), (fun n => n + 10)] 5
-- should be (5 + 1) = 6, then 6 * 2 = 12, then 12 + 10 = 22

-- Exercise 11 (challenge): Church numerals as higher-order functions
-- A Church numeral is a function that takes f and x
-- and applies f some number of times to x.
-- zero f x = x
-- one f x = f x
-- two f x = f (f x)
-- Define zero, one, two, and churchAdd.
def churchZero {alpha : Type} (_f : alpha -> alpha) (x : alpha) : alpha := sorry
def churchSucc {alpha : Type}
    (n : (alpha -> alpha) -> alpha -> alpha)
    (f : alpha -> alpha) (x : alpha) : alpha := sorry
def churchAdd {alpha : Type}
    (m n : (alpha -> alpha) -> alpha -> alpha)
    (f : alpha -> alpha) (x : alpha) : alpha := sorry

-- Verify (uncomment once implemented):
-- #eval churchAdd churchZero (churchSucc churchZero) (fun n : Nat => n + 1) 0
-- should be 1
