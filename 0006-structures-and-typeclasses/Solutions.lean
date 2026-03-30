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

end Course0006
