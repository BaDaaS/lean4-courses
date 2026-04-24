/-
# 0005 - Inductive Types Exercises
-/

-- Exercise 1: Define a type for traffic light colors
inductive TrafficLight where
  | red
  | yellow
  | green

inductive WeekDay where
  | monday
  | tuesday
  | wednesday
  | thursday
  | friday
  | saturday
  | sunday

def isWeekEnd : WeekDay -> Bool
  | WeekDay.monday | WeekDay.tuesday | WeekDay.wednesday
  | WeekDay.thursday | WeekDay.friday => false
  | WeekDay.saturday | WeekDay.sunday => true

def isWeek : WeekDay -> Bool :=
    fun w => not (isWeekEnd w)

-- Exercise 2: Define a function that returns the next light color
def nextLight : TrafficLight -> TrafficLight
  | TrafficLight.red => .green
  | TrafficLight.green => .yellow
  | TrafficLight.yellow => .red

def TrafficLightToString: TrafficLight -> String
  | TrafficLight.red => "red"
  | TrafficLight.yellow => "yellow"
  | TrafficLight.green => "green"

#eval TrafficLightToString (TrafficLight.yellow)

-- Exercise 3: Define a binary tree of natural numbers
inductive NatTree where
  | leaf : NatTree
  | node (left : NatTree) (val: Nat) (rght: NatTree) : NatTree

-- Exercise 4: Count the number of nodes in a NatTree
def countNodes : NatTree -> Nat
  | NatTree.leaf => 0
  | NatTree.node l _v r => countNodes l + countNodes r + 1

-- Exercise 5: Compute the sum of all values in a NatTree
def sumTree : NatTree -> Nat
  | NatTree.leaf => 0
  | NatTree.node l v r => sumTree l + sumTree r + v

-- Exercise 6: Define your own natural numbers and addition
inductive MyNat where
  | zero: MyNat
  | succ (n: MyNat) : MyNat

def myAdd : MyNat -> MyNat -> MyNat
  | MyNat.zero, m => m
  | MyNat.succ n, m => .succ (myAdd n m)

-- Exercise 7: Define multiplication on MyNat
def myMul : MyNat -> MyNat -> MyNat
  | MyNat.zero, n => Zero
  | n, MyNat.zero => Zero
  | .succ n, m => myMul n (myMul n, m)
  | n, .succ m => myMul m (myMul n, m)

-- Exercise 8: Define a type for arithmetic expressions
inductive Expr where
  | lit (n : Int)               -- literal number
  | add (e1 e2 : Expr)         -- addition
  | mul (e1 e2 : Expr)         -- multiplication

-- Exercise 9: Write an evaluator for Expr
def eval : Expr -> Int := sorry

-- Test: eval (add (lit 3) (mul (lit 2) (lit 4))) = 11
-- #eval eval (Expr.add (Expr.lit 3) (Expr.mul (Expr.lit 2) (Expr.lit 4)))

-- =============================================
-- Additional exercises (increasing difficulty)
-- =============================================

-- Exercise 10 (medium): Define an Option-like type and map over it
-- Define Maybe with nothing and just constructors, then define
-- maybeMap that applies a function inside just.
inductive Maybe (alpha : Type) where
  | nothing : Maybe alpha
  | just    : alpha -> Maybe alpha

def maybeMap {alpha beta : Type}
    (f : alpha -> beta) (x : Maybe alpha) : Maybe beta := sorry

-- Exercise 11 (hard): Define a rose tree (tree with a list of children)
-- and a function to count all nodes
inductive RoseTree (alpha : Type) where
  | node : alpha -> List (RoseTree alpha) -> RoseTree alpha

def countRoseNodes {alpha : Type} (t : RoseTree alpha) : Nat := sorry

-- Hint: you will need a helper function to count nodes in a list of trees.
-- def countForest {alpha : Type} (ts : List (RoseTree alpha)) : Nat := ...

-- Exercise 12 (hard): Define mirror for NatTree and prove
-- that mirror (mirror t) = t
-- First define mirror:
def mirrorTree : NatTree -> NatTree := sorry

-- Then prove the involution property:
-- theorem mirror_mirror (t : NatTree) : mirrorTree (mirrorTree t) = t := sorry

-- Exercise 13 (challenge): Define a well-typed expression language
-- with type safety built into the definition.
-- The type Ty represents expression types, and TypedExpr is indexed
-- by the type of the expression it represents.
inductive Ty where
  | nat  : Ty
  | bool : Ty

-- Define a function that maps Ty to actual Lean types
def Ty.toType : Ty -> Type
  | .nat  => Nat
  | .bool => Bool

-- Define TypedExpr indexed by Ty, so that:
--   litNat n : TypedExpr .nat
--   litBool b : TypedExpr .bool
--   addExpr e1 e2 : TypedExpr .nat (both e1 and e2 must be .nat)
--   eqExpr e1 e2 : TypedExpr .bool (both e1 and e2 must be .nat)
inductive TypedExpr : Ty -> Type where
  | placeholder : TypedExpr .nat  -- remove and add real constructors

-- Define type-safe evaluators, one for each result type:
-- def evalTypedNat : TypedExpr Ty.nat -> Nat := sorry
-- def evalTypedBool : TypedExpr Ty.bool -> Bool := sorry
