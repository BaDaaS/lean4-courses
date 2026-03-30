/-
# 0006 - Structures and Typeclasses Solutions
-/

namespace Course0006

-- Exercise 1 (given)
structure Vec2 where
  x : Float
  y : Float

-- Exercise 2
def Vec2.add (a b : Vec2) : Vec2 :=
  { x := a.x + b.x, y := a.y + b.y }

-- Exercise 3
def Vec2.scale (s : Float) (v : Vec2) : Vec2 :=
  { x := s * v.x, y := s * v.y }

-- Exercise 4
instance : ToString Vec2 where
  toString v := s!"({v.x}, {v.y})"

-- Exercise 5
instance : BEq Vec2 where
  beq a b := a.x == b.x && a.y == b.y

-- Exercise 6
class HasSize (alpha : Type) where
  size : alpha -> Nat

instance : HasSize String where
  size s := s.length

instance {a : Type} : HasSize (List a) where
  size xs := xs.length

-- Exercise 7
def isSmall {alpha : Type} [HasSize alpha] (x : alpha) : Bool :=
  HasSize.size x <= 3

-- Exercise 8
structure Student where
  name : String
  age : Nat
  gpa : Float

instance : ToString Student where
  toString s := s!"{s.name} (age {s.age}, GPA {s.gpa})"

-- Exercise 9
class MyMonoid (M : Type) where
  mempty : M
  mappend : M -> M -> M

instance : MyMonoid Nat where
  mempty := 0
  mappend := Nat.add

instance : MyMonoid String where
  mempty := ""
  mappend := String.append

-- ============================================================
-- Additional Exercises
-- ============================================================

-- Exercise 10 (medium): Ord typeclass for Nat
class MyOrd (alpha : Type) where
  cmp : alpha -> alpha -> Ordering

instance : MyOrd Nat where
  cmp a b := compare a b

def myMax {alpha : Type} [MyOrd alpha] (a b : alpha) : alpha :=
  match MyOrd.cmp a b with
  | .gt => a
  | _ => b

#eval myMax 3 7  -- 7

-- Exercise 11 (hard): Functor typeclass with Box
structure Box (alpha : Type) where
  val : alpha

class MyFunctor (F : Type -> Type) where
  fmap : {alpha beta : Type} -> (alpha -> beta) -> F alpha -> F beta

instance : MyFunctor Box where
  fmap f b := { val := f b.val }

instance : MyFunctor List where
  fmap := List.map

#eval (MyFunctor.fmap (. + 1) (Box.mk 41)).val  -- 42

-- Exercise 12 (hard): Vec2 addition is commutative (using Int)
structure IntVec2 where
  x : Int
  y : Int
deriving Repr, BEq, DecidableEq

def IntVec2.add (a b : IntVec2) : IntVec2 :=
  { x := a.x + b.x, y := a.y + b.y }

theorem intVec2_add_comm (a b : IntVec2) :
    IntVec2.add a b = IntVec2.add b a := by
  simp [IntVec2.add, Int.add_comm]

-- Exercise 13 (challenge): Ring typeclass for Int
class MyRing (R : Type) where
  zero : R
  one : R
  add : R -> R -> R
  mul : R -> R -> R
  neg : R -> R

instance : MyRing Int where
  zero := 0
  one := 1
  add := Int.add
  mul := Int.mul
  neg := Int.neg

def square {R : Type} [MyRing R] (x : R) : R :=
  MyRing.mul x x

#eval square (3 : Int)  -- 9

end Course0006
