/-
# 0005 - Inductive Types Exercises
-/

-- Exercise 1: Define a type for traffic light colors
inductive TrafficLight where
  -- Add constructors: red, yellow, green
  | placeholder  -- remove this and add real constructors

-- Exercise 2: Define a function that returns the next light color
def nextLight : TrafficLight -> TrafficLight := sorry

-- Exercise 3: Define a binary tree of natural numbers
inductive NatTree where
  | leaf : NatTree
  | node (left : NatTree) (val : Nat) (right : NatTree) : NatTree

-- Exercise 4: Count the number of nodes in a NatTree
def countNodes : NatTree -> Nat := sorry

-- Exercise 5: Compute the sum of all values in a NatTree
def treeSum : NatTree -> Nat := sorry

-- Exercise 6: Define your own natural numbers and addition
inductive MyNat where
  | zero : MyNat
  | succ (n : MyNat) : MyNat

def myAdd : MyNat -> MyNat -> MyNat := sorry

-- Exercise 7: Define multiplication on MyNat
def myMul : MyNat -> MyNat -> MyNat := sorry

-- Exercise 8: Define a type for arithmetic expressions
inductive Expr where
  | lit (n : Int)               -- literal number
  | add (e1 e2 : Expr)         -- addition
  | mul (e1 e2 : Expr)         -- multiplication

-- Exercise 9: Write an evaluator for Expr
def eval : Expr -> Int := sorry

-- Test: eval (add (lit 3) (mul (lit 2) (lit 4))) = 11
-- #eval eval (Expr.add (Expr.lit 3) (Expr.mul (Expr.lit 2) (Expr.lit 4)))
