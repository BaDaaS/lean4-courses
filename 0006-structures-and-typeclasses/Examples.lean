/-
# 0006 - Structures and Typeclasses Examples

Code examples from the README, wrapped in anchors for injection.
-/

namespace Course0006Examples

-- #anchor: point_structure
structure Point where
  x : Float
  y : Float

def origin : Point := { x := 0.0, y := 0.0 }
def p : Point := { x := 3.0, y := 4.0 }

-- Field access
#eval p.x    -- 3.0

-- Functional update
def shifted := { p with x := p.x + 1.0 }
-- #end

-- #anchor: config_defaults
structure Config where
  verbose : Bool := false
  maxRetries : Nat := 3
  timeout : Nat := 30

def myConfig : Config := { verbose := true }
-- maxRetries = 3, timeout = 30 (defaults)
-- #end

-- #anchor: typeclasses
class Printable (alpha : Type) where
  print : alpha -> String

instance : Printable Nat where
  print n := toString n

instance : Printable Bool where
  print b := if b then "yes" else "no"

-- Use the typeclass
def display [Printable alpha] (x : alpha) : String :=
  Printable.print x

#eval display 42      -- "42"
#eval display true    -- "yes"
-- #end

-- #anchor: builtin_typeclasses
-- ToString: convert to string
instance : ToString Point where
  toString p := s!"({p.x}, {p.y})"

-- BEq: boolean equality
instance : BEq Point where
  beq a b := a.x == b.x && a.y == b.y

-- Repr: debug representation
instance : Repr Point where
  reprPrec p _ := s!"Point({p.x}, {p.y})"

-- Inhabited: has a default value
instance : Inhabited Point where
  default := { x := 0.0, y := 0.0 }
-- #end

-- #anchor: extending_structures
structure ColorPoint extends Point where
  color : String

def cp : ColorPoint := { x := 1.0, y := 2.0, color := "red" }
#eval cp.x      -- inherits from Point
#eval cp.color
-- #end

-- #anchor: algebraic_structures
class MyGroup (G : Type) where
  e : G                       -- identity
  mul : G -> G -> G           -- group operation
  inv : G -> G                -- inverse
  mul_assoc : forall a b c, mul (mul a b) c = mul a (mul b c)
  mul_e : forall a, mul a e = a
  mul_inv : forall a, mul a (inv a) = e
-- #end

end Course0006Examples
