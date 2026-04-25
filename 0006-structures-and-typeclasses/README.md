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

## Category Theory Perspective

**Structures as objects with structure.** A `structure` in Lean
defines a type together with named projection functions (fields).
Categorically, a structure is an object in a **comma category** or
**slice category**: it is a type `A` equipped with specified
morphisms. When fields carry proof obligations (equational laws),
the structure is a **model** of an algebraic theory — an algebra for
a Lawvere theory (Lawvere 1963).

**Typeclasses as coherent structure.** A typeclass `C : Type → Prop`
(conceptually) carves out those types that carry a particular
structure. When the typeclass provides operations with no laws (like
`ToString`), instances are just functions. When it provides
operations with laws (like `Group`), instances are algebras. The
**instance resolution** mechanism (searching for `[C A]`) constructs
the unique canonical morphism that the universal property demands —
when there is only one sensible instance, this is a categorical
choice function.

**The category of algebras.** The class `MyGroup G` defines a
category **Grp** whose objects are pairs `(G, instance : MyGroup G)`
and whose morphisms are **group homomorphisms** — functions
`φ : G → H` preserving the operations: `φ (mul a b) = mul (φ a) (φ b)`.
In Mathlib, `MonoidHom`, `RingHom`, `LinearMap`, etc., are exactly
the hom-sets of the corresponding algebraic categories `Mon`, `Ring`,
`Mod_R`. The typeclass provides the *object* structure; the `Hom`
type provides the *morphism* structure.

**Forgetful functors and free constructions.** Every typeclass gives
rise to a **forgetful functor** `U : Alg → Type` that sends an
algebra `(A, instance)` to its carrier type `A`. Forgetful functors
have left adjoints called **free constructions**: the free group
`F(S)` on a set `S` is left adjoint to the forgetful functor from
`Grp` to `Set`. This adjunction `Free ⊣ Forget` is the categorical
content of every "universal property" in algebra. In Lean, free
monoids are `List` (with concatenation), free groups are finite
words with cancellation, etc.

**Natural transformations between typeclasses.** A function
`∀ A [C A], F A → G A` that is natural in `A` (commutes with all
relevant maps) is a **natural transformation** between the functors
`F` and `G` restricted to `C`-structured types. Typeclass
**coherence** — the property that all ways of deriving a given
instance produce definitionally equal results — is the categorical
statement that the relevant diagram of natural transformations
commutes. Coherence theorems in algebra (e.g., Mac Lane's coherence
for monoidal categories) have direct counterparts in Lean's
typeclass system.

**Structures as objects in a fibration.** The `extends` syntax
`structure ColorPoint extends Point` creates a morphism
`forget : ColorPoint → Point` (projection, dropping the extra field).
This is a **section-retraction pair**: `Point` is a retract of
`ColorPoint`. The category of structures extending `Point` is the
**slice category** `Type / Point`. In this setting, `ColorPoint`
is an object over `Point`, and the forgetful map is the structure
morphism.

**Preorders and thin categories.** The typeclass
`class Preorder (A : Type)` with `le_refl` and `le_trans` defines a
**preorder**: a category where each hom-set `Hom(a, b)` has at most
one element (so that `a ≤ b` is a proposition, not data). The axioms
are exactly the categorical identity (`le_refl`) and composition
(`le_trans`). A partial order adds antisymmetry (skeletality: if
`a ≤ b` and `b ≤ a` then `a = b`). A lattice adds products
(`meet = inf`) and coproducts (`join = sup`). This hierarchy of
typeclasses in Mathlib is literally the hierarchy of increasingly
structured categories.

**Reference:** Lawvere, F.W. (1963). "Functorial Semantics of
Algebraic Theories." PhD thesis, Columbia University. Introduces
Lawvere theories as the categorical axiomatization of universal
algebra.

**Reference:** Mac Lane, S. (1971). *Categories for the Working
Mathematician.* Springer. Chapter VIII covers adjunctions and free
constructions; the coherence theorem for monoidal categories appears
in Chapter VII.

---

## CS Track: Interfaces and Polymorphism

Typeclasses are like interfaces in Java/Go or traits in Rust. They let
you write generic code that works for any type implementing the interface.
The key difference: instance resolution is automatic (no explicit vtable
or impl block needed at call sites).
