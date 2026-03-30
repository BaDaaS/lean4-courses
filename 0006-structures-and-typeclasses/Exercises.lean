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
