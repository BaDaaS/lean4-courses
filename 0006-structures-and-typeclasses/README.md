# 0006 - Structures and Typeclasses

## Goal

Learn structures (named product types with fields) and typeclasses
(interfaces for ad-hoc polymorphism). These are how Lean models algebraic
structures and achieves polymorphism.

## Structures

A structure is a named product type with named fields:

```lean
structure Point where
  x : Float
  y : Float

def origin : Point := { x := 0.0, y := 0.0 }
def p : Point := { x := 3.0, y := 4.0 }

-- Field access
#eval p.x    -- 3.0

-- Functional update
def shifted := { p with x := p.x + 1.0 }
```

## Structures with Default Values

```lean
structure Config where
  verbose : Bool := false
  maxRetries : Nat := 3
  timeout : Nat := 30

def myConfig : Config := { verbose := true }
-- maxRetries = 3, timeout = 30 (defaults)
```

## Typeclasses

Typeclasses are structures with instance resolution:

```lean
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
```

## Common Built-in Typeclasses

```lean
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
```

## Extending Structures

```lean
structure ColorPoint extends Point where
  color : String

def cp : ColorPoint := { x := 1.0, y := 2.0, color := "red" }
#eval cp.x      -- inherits from Point
#eval cp.color
```

## Math Track: Algebraic Structures

Typeclasses model algebraic structures perfectly:

```lean
class MyGroup (G : Type) where
  e : G                       -- identity
  mul : G -> G -> G           -- group operation
  inv : G -> G                -- inverse
  mul_assoc : forall a b c, mul (mul a b) c = mul a (mul b c)
  mul_e : forall a, mul a e = a
  mul_inv : forall a, mul a (inv a) = e
```

Mathlib uses this pattern extensively with classes like `Group`,
`Ring`, `Field`, `Module`, etc.

## CS Track: Interfaces and Polymorphism

Typeclasses are like interfaces in Java/Go or traits in Rust. They let
you write generic code that works for any type implementing the interface.
The key difference: instance resolution is automatic (no explicit vtable
or impl block needed at call sites).
