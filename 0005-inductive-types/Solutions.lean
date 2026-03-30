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

-- =============================================
-- Additional exercises (increasing difficulty)
-- =============================================

-- Exercise 10 (medium): Option-like type with map
inductive Maybe (alpha : Type) where
  | nothing : Maybe alpha
  | just    : alpha -> Maybe alpha

def maybeMap {alpha beta : Type}
    (f : alpha -> beta) (x : Maybe alpha) : Maybe beta :=
  match x with
  | .nothing => .nothing
  | .just a  => .just (f a)

#eval maybeMap (fun n : Nat => n * 2) (Maybe.just 5)  -- Maybe.just 10

-- Exercise 11 (hard): Rose tree with node counting
inductive RoseTree (alpha : Type) where
  | node : alpha -> List (RoseTree alpha) -> RoseTree alpha

def countForest {alpha : Type} (ts : List (RoseTree alpha)) : Nat :=
  match ts with
  | [] => 0
  | t :: rest => countRoseNodes t + countForest rest
where countRoseNodes {alpha : Type} (t : RoseTree alpha) : Nat :=
  match t with
  | .node _ children => 1 + countForest children

def countRoseNodes {alpha : Type} (t : RoseTree alpha) : Nat :=
  match t with
  | .node _ children => 1 + countRoseForest children
where countRoseForest {alpha : Type}
    (ts : List (RoseTree alpha)) : Nat :=
  match ts with
  | [] => 0
  | t :: rest => countRoseNodes t + countRoseForest rest

-- Exercise 12 (hard): Mirror and mirror-mirror involution
def mirrorTree : NatTree -> NatTree
  | .leaf => .leaf
  | .node l v r => .node (mirrorTree r) v (mirrorTree l)

theorem mirror_mirror (t : NatTree) :
    mirrorTree (mirrorTree t) = t := by
  induction t with
  | leaf => rfl
  | node l v r ihl ihr =>
    simp [mirrorTree]
    exact ⟨ihl, ihr⟩

-- Exercise 13 (challenge): Well-typed expression language
inductive Ty where
  | nat  : Ty
  | bool : Ty

def Ty.toType : Ty -> Type
  | .nat  => Nat
  | .bool => Bool

inductive TypedExpr : Ty -> Type where
  | litNat  : Nat -> TypedExpr .nat
  | litBool : Bool -> TypedExpr .bool
  | addExpr : TypedExpr .nat -> TypedExpr .nat -> TypedExpr .nat
  | eqExpr  : TypedExpr .nat -> TypedExpr .nat -> TypedExpr .bool

def evalTypedNat : TypedExpr Ty.nat -> Nat
  | .litNat n      => n
  | .addExpr e1 e2 => evalTypedNat e1 + evalTypedNat e2

def evalTypedBool : TypedExpr Ty.bool -> Bool
  | .litBool b     => b
  | .eqExpr e1 e2  => evalTypedNat e1 == evalTypedNat e2

-- Test: 3 + 4 = 7
#eval evalTypedNat
  (TypedExpr.addExpr (TypedExpr.litNat 3) (TypedExpr.litNat 4))
-- 7

-- Test: (3 + 4) == 7 is true
#eval evalTypedBool (TypedExpr.eqExpr
  (TypedExpr.addExpr (TypedExpr.litNat 3) (TypedExpr.litNat 4))
  (TypedExpr.litNat 7))
-- true

end Course0005
