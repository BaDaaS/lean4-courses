/-
# 0005 - Inductive Types Solutions
-/

namespace Course0005

-- Exercise 1
inductive TrafficLight where
  | red | yellow | green

-- Exercise 2
def nextLight : TrafficLight -> TrafficLight
  | .red    => .green
  | .green  => .yellow
  | .yellow => .red

-- Exercise 3 (given)
inductive NatTree where
  | leaf : NatTree
  | node (left : NatTree) (val : Nat) (right : NatTree) : NatTree

-- Exercise 4
def countNodes : NatTree -> Nat
  | .leaf => 0
  | .node l _ r => 1 + countNodes l + countNodes r

-- Exercise 5
def treeSum : NatTree -> Nat
  | .leaf => 0
  | .node l v r => treeSum l + v + treeSum r

-- Exercise 6
inductive MyNat where
  | zero : MyNat
  | succ (n : MyNat) : MyNat

def myAdd : MyNat -> MyNat -> MyNat
  | .zero,   m => m
  | .succ n, m => .succ (myAdd n m)

-- Exercise 7
def myMul : MyNat -> MyNat -> MyNat
  | .zero,   _ => .zero
  | .succ n, m => myAdd m (myMul n m)

-- Exercise 8 (given)
inductive Expr where
  | lit (n : Int)
  | add (e1 e2 : Expr)
  | mul (e1 e2 : Expr)

-- Exercise 9
def eval : Expr -> Int
  | .lit n     => n
  | .add e1 e2 => eval e1 + eval e2
  | .mul e1 e2 => eval e1 * eval e2

#eval eval (Expr.add (Expr.lit 3) (Expr.mul (Expr.lit 2) (Expr.lit 4)))
-- 11

end Course0005
