/-
# 0006 - Structures and Typeclasses Exercises
-/

-- Exercise 1: Define a structure for a 2D vector
structure Vec2 where
  x : Float
  y : Float

-- Exercise 2: Define vector addition
def Vec2.add (a b : Vec2) : Vec2 := sorry

-- Exercise 3: Define vector scaling
def Vec2.scale (s : Float) (v : Vec2) : Vec2 := sorry

-- Exercise 4: Define a ToString instance for Vec2
instance : ToString Vec2 where
  toString := sorry

-- Exercise 5: Define a BEq instance for Vec2
instance : BEq Vec2 where
  beq := sorry

-- Exercise 6: Define a typeclass for things with a "size"
class HasSize (alpha : Type) where
  size : alpha -> Nat

-- Provide instances for String and List
instance : HasSize String where
  size := sorry

instance {a : Type} : HasSize (List a) where
  size := sorry

-- Exercise 7: Write a generic function using HasSize
def isSmall [HasSize alpha] (x : alpha) : Bool := sorry
-- Should return true if size <= 3

-- Exercise 8: Define a structure for a student record
-- with fields: name (String), age (Nat), gpa (Float)
-- Give it a ToString instance
structure Student where
  -- fill in fields
  placeholder : Unit := ()  -- remove this

-- Exercise 9: Define a typeclass Monoid with
-- an identity element and an associative binary operation
class MyMonoid (M : Type) where
  mempty : M
  mappend : M -> M -> M

-- Provide an instance for Nat (under addition)
instance : MyMonoid Nat where
  mempty := sorry
  mappend := sorry

-- Provide an instance for String (under concatenation)
instance : MyMonoid String where
  mempty := sorry
  mappend := sorry

-- ============================================================
-- Additional Exercises
-- ============================================================

-- Exercise 10 (medium): Define an Ord typeclass for comparison
-- It should have a single method `cmp` that returns Ordering.
-- Provide an instance for Nat.
class MyOrd (alpha : Type) where
  cmp : alpha -> alpha -> Ordering

instance : MyOrd Nat where
  cmp := sorry

-- Use it to write a generic `myMax` function
def myMax {alpha : Type} [MyOrd alpha] (a b : alpha) : alpha := sorry

-- Exercise 11 (hard): Define a Functor-like typeclass and Box type
-- Box wraps a single value. MyFunctor has a single method `fmap`.
structure Box (alpha : Type) where
  val : alpha

class MyFunctor (F : Type -> Type) where
  fmap : {alpha beta : Type} -> (alpha -> beta) -> F alpha -> F beta

instance : MyFunctor Box where
  fmap := sorry

instance : MyFunctor List where
  fmap := sorry

-- Exercise 12 (hard): Prove Vec2 addition is commutative
-- We cannot use `=` on Float directly (no DecidableEq), so define
-- a propositional version: two Vec2s are "pairwise equal" when
-- their fields are equal.
-- Hint: Float.add_comm is not available, so state the theorem
-- in terms of a generic commutative addition.
-- Instead, define a simple IntVec2 with Int fields and prove it.
structure IntVec2 where
  x : Int
  y : Int
deriving Repr, BEq, DecidableEq

def IntVec2.add (a b : IntVec2) : IntVec2 :=
  { x := a.x + b.x, y := a.y + b.y }

theorem intVec2_add_comm (a b : IntVec2) :
    IntVec2.add a b = IntVec2.add b a := by
  sorry

-- Exercise 13 (challenge): Define a Ring typeclass and provide
-- an instance for Int.
-- A ring has: zero, one, add, mul, neg
-- with the usual laws (you only need to state the structure,
-- not prove the laws for the exercise).
class MyRing (R : Type) where
  zero : R
  one : R
  add : R -> R -> R
  mul : R -> R -> R
  neg : R -> R

instance : MyRing Int where
  zero := sorry
  one := sorry
  add := sorry
  mul := sorry
  neg := sorry

-- Use the ring to write a generic function:
-- square x = x * x
def square {R : Type} [MyRing R] (x : R) : R := sorry
