# 0005 - Inductive Types

## Goal

Define your own types using `inductive`. Understand constructors,
recursion, and how inductive types model both mathematical objects and
algebraic data types. Learn the type-theoretic vocabulary that Lean
inherits from the Calculus of Inductive Constructions.

## Type Theory Vocabulary

Before looking at code, here is the precise naming that type theorists
use. Every concept below appears in the exercises.

### Term variables and type variables

A **term variable** is a variable that ranges over values: `x`, `n`,
`head`, `tail`. You already know these from programming.

A **type variable** is a variable that ranges over types: `alpha`,
`beta` in `(alpha : Type)`. When you write
`def maybeMap {alpha beta : Type} ...`, `alpha` and `beta` are type
variables. The function is **polymorphic**: it works for any choice of
type.

In System F notation, a polymorphic identity function is written:

```
id = /\alpha. \x:alpha. x
```

The `/\alpha` (capital lambda) abstracts over a type. In Lean this is:

```lean
def id {alpha : Type} (x : alpha) : alpha := x
```

The curly braces `{...}` mark the type argument as implicit (the
compiler infers it). Square brackets `[...]` are for type class
arguments. Round parentheses `(...)` are explicit.

### Type constructors and data constructors

A **type constructor** is a function from types to types. `List` by
itself is not a type. `List Nat` is a type. `List` is a type
constructor of **kind** `Type -> Type`. Other examples: `Maybe`,
`RoseTree`, `Array`.

A **data constructor** (also called an **introduction form** or just
**constructor**) builds a value of the inductive type. For
`Maybe alpha`, the data constructors are `nothing` and `just`.

In type theory, the data constructors are the **introduction rules**
for the type. Pattern matching is the **elimination rule**. Together
they define the type completely.

### Kinds: the types of types

A **kind** is the type of a type-level expression. In Lean:

| Expression    | Kind              | Explanation                  |
| ------------- | ----------------- | ---------------------------- |
| `Nat`         | `Type`            | A concrete type              |
| `Bool`        | `Type`            | A concrete type              |
| `List`        | `Type -> Type`    | Takes one type, returns one  |
| `Maybe`       | `Type -> Type`    | Same                         |
| `Prod`        | `Type -> Type -> Type` | Takes two types         |
| `TypedExpr`   | `Ty -> Type`      | Dependent: takes a value     |

Lean does not have a separate kind language. Kinds are just types in
the universe hierarchy: `Type : Type 1`, `Type 1 : Type 2`, etc.

### Universes

Lean has a cumulative universe hierarchy to avoid Russell's paradox:

```
Sort 0 = Prop        -- the type of propositions
Sort 1 = Type        -- also called Type 0
Sort 2 = Type 1
Sort 3 = Type 2
...
```

When you write `(alpha : Type)`, this means `alpha : Type 0`, and
the whole function lives in `Type 1`. The `universe` command lets
you be polymorphic over universe levels:

```lean
universe u
def id' {alpha : Type u} (x : alpha) : alpha := x
```

## The Lambda Cube and Where Lean Sits

Henk Barendregt (1991) organized type systems into a cube with three
axes of dependency. Each axis adds one new form of abstraction:

1. **Terms depending on terms**: ordinary functions `\x. e`.
   Present in all systems.

2. **Terms depending on types**: polymorphism. A term like
   `id {alpha : Type} (x : alpha) := x` abstracts over a type.
   This is the step from STLC to System F.

3. **Types depending on types**: type operators. A type-level
   function like `List : Type -> Type` takes a type and returns a
   type. This is the step from System F to System F-omega.

4. **Types depending on terms**: dependent types.
   `TypedExpr : Ty -> Type` is a type that depends on a value.
   This is the step to the Calculus of Constructions.

The eight corners of the cube are:

| System                | Terms on terms | Terms on types | Types on types | Types on terms |
| --------------------- | -------------- | -------------- | -------------- | -------------- |
| STLC (lambda ->)      | yes            | no             | no             | no             |
| System F              | yes            | yes            | no             | no             |
| System F-omega        | yes            | yes            | yes            | no             |
| LF                    | yes            | no             | no             | yes            |
| CC (top corner)       | yes            | yes            | yes            | yes            |

Lean implements **CIC** (Calculus of Inductive Constructions), which
is CC extended with:

- Inductive type definitions (every `inductive` declaration)
- A universe hierarchy (`Type 0 : Type 1 : Type 2 : ...`)
- A separate impredicative universe `Prop` for propositions

CIC was introduced by Thierry Coquand and Christine Paulin-Mohring
(1990), building on Coquand and Huet's Calculus of Constructions
(1988) and Per Martin-Lof's intuitionistic type theory (1972).

### System F (Girard 1972, Reynolds 1974)

System F, also called the **polymorphic lambda calculus** or
**second-order lambda calculus**, adds type abstraction and type
application to the simply typed lambda calculus.

The key idea: a term can take a type as an argument. The polymorphic
identity is:

```
id : forall alpha. alpha -> alpha
id = /\alpha. \x:alpha. x
```

In Lean, every time you write `{alpha : Type}` in a definition, you
are using System F-style polymorphism. The exercises use this in:

- `Maybe (alpha : Type)` - a polymorphic data type
- `maybeMap {alpha beta : Type}` - a polymorphic function
- `RoseTree (alpha : Type)` - a polymorphic recursive type

System F has a remarkable property: **parametricity** (Wadler, 1989).
From the type `forall alpha. alpha -> alpha` alone, you can deduce
that the only inhabitant is the identity function. The type
constrains the implementation.

Girard proved strong normalization for System F in his 1972 thesis
(in French: "Interpretation fonctionnelle et elimination des coupures
de l'arithmetique d'ordre superieur"). Reynolds independently
discovered the same system in 1974.

### System F-omega (Girard 1972)

System F-omega adds **type-level functions** (type operators) to
System F. In System F, you can abstract terms over types, but you
cannot define a function that takes a type and returns a type.

System F-omega introduces a **kind system**:

```
Kinds:   k ::= * | k -> k
Types:   T ::= alpha | T -> T | forall alpha:k. T | \alpha:k. T | T T
```

Here `*` is the kind of ordinary types (Lean's `Type`), and
`k -> k` is the kind of type-level functions.

Examples in the exercises:

| Lean definition              | System F-omega kind |
| ---------------------------- | ------------------- |
| `Nat`, `Bool`, `TrafficLight`| `*`                 |
| `Maybe`, `List`, `RoseTree`  | `* -> *`            |
| `Prod`, `Sum`                | `* -> * -> *`       |

Without System F-omega, you could not even express the type of
`List`. You could only say "List of Nat" and "List of Bool" as
separate types, with no way to abstract over the element type at the
type level.

Haskell's kind system is essentially System F-omega. GHC extensions
like `TypeFamilies` and `DataKinds` push further toward dependent
types.

### The Calculus of Constructions (Coquand and Huet, 1988)

The CoC occupies the top corner of the lambda cube. It adds
**dependent types**: types that depend on terms.

In the exercises, `TypedExpr : Ty -> Type` is a dependent type. The
type of the expression depends on a *value* of type `Ty`. You
cannot express this in System F or System F-omega, because those
systems do not allow types to mention term-level values.

Dependent function types (Pi types) generalize both ordinary
functions and polymorphism:

```
-- Ordinary function: the return type does not mention the argument
f : Nat -> Nat

-- Polymorphic function: the return type mentions a type argument
id : (alpha : Type) -> alpha -> alpha

-- Dependent function: the return type mentions a term argument
Vec.head : (n : Nat) -> Vec alpha (n + 1) -> alpha
```

In Lean, all three are special cases of the same Pi type
`(x : A) -> B x`. When `B` does not depend on `x`, Lean displays
it as `A -> B`.

### Beyond the lambda cube: inductive types

The lambda cube does not include inductive type definitions. CIC
adds them as a primitive, governed by a **positivity checker** and
a **termination checker**:

- **Strict positivity**: the type being defined must not appear in a
  negative (left-of-arrow) position in its own constructors. This
  prevents types that would make the system inconsistent.
  `| bad (f : MyType -> MyType)` is rejected because `MyType`
  appears to the left of `->`.

- **Structural recursion**: recursive functions must decrease on a
  structurally smaller argument. Lean checks this automatically.
  In `countNodes (.node l _ r)`, the recursive calls on `l` and `r`
  are on strict sub-terms of the original argument.

These two restrictions together guarantee that every function
terminates and the logic is consistent.

## How Exercises Map to the Lambda Cube

The exercises progress through the lambda cube:

| Exercise       | Definition           | System needed   | Why                              |
| -------------- | -------------------- | --------------- | -------------------------------- |
| 1-2            | `TrafficLight`       | STLC            | No type parameters               |
| 3-5            | `NatTree`            | STLC            | Recursive, but no polymorphism   |
| 6-7            | `MyNat`              | STLC            | Recursive, no polymorphism       |
| 8-9            | `Expr`               | STLC            | Recursive, no polymorphism       |
| 10             | `Maybe alpha`        | System F-omega  | Type constructor `* -> *`        |
| 11             | `RoseTree alpha`     | System F-omega  | Type constructor `* -> *`        |
| 12             | `mirrorTree` proof   | CIC             | Proof by induction               |
| 13             | `TypedExpr : Ty -> Type` | CoC / CIC  | Type indexed by a value          |

## Basic Inductive Types

### Enumeration

```lean
inductive Weekday where
  | monday | tuesday | wednesday | thursday
  | friday | saturday | sunday
```

This is a **finite sum type** (also called a tagged union or
coproduct). In type theory notation: `1 + 1 + 1 + 1 + 1 + 1 + 1`,
where each `1` is the unit type (a constructor with no arguments).
The STLC can express this.

### With data (like enums with payloads)

```lean
inductive Shape where
  | circle (radius : Float)
  | rectangle (width : Float) (height : Float)
  | triangle (base : Float) (height : Float)
```

This is a **sum of products**. Each constructor carries a product
(tuple) of fields. In type theory: `Float + (Float x Float) +
(Float x Float)`. This is the origin of the name "algebraic data
type" in ML/Haskell: the type is built from sums (+) and products
(x), like a polynomial.

### Recursive types

```lean
inductive MyNat where
  | zero : MyNat
  | succ (n : MyNat) : MyNat
```

A **recursive type** (or inductive type) refers to itself in its
constructors. In type theory, this is a fixed point:
`Nat = 1 + Nat`, meaning "a Nat is either zero (the unit) or one
plus another Nat." The `inductive` keyword computes the least fixed
point (the smallest type satisfying this equation), which gives you
the finite natural numbers (not infinite streams).

## How Lean's Nat Works

```lean
-- Nat is defined as:
-- inductive Nat where
--   | zero : Nat
--   | succ (n : Nat) : Nat

-- 3 is sugar for: Nat.succ (Nat.succ (Nat.succ Nat.zero))
```

This is exactly the Peano/Dedekind axiomatisation of the natural
numbers (1889), which itself formalises the much older idea that
every natural number is either zero or the successor of another.

## Pattern Matching on Inductive Types

```lean
def weekdayToString : Weekday -> String
  | .monday    => "Monday"
  | .tuesday   => "Tuesday"
  | .wednesday => "Wednesday"
  | .thursday  => "Thursday"
  | .friday    => "Friday"
  | .saturday  => "Saturday"
  | .sunday    => "Sunday"

def area : Shape -> Float
  | .circle r       => Float.pi * r * r
  | .rectangle w h  => w * h
  | .triangle b h   => 0.5 * b * h
```

Note that the "dot" notation (ex: `.circle`) is a short-hand for the
symbol `Shape.circle`. The compiler automatically infers the type to
be used.

Pattern matching is the **elimination principle** for an inductive
type. Given a value of the type, you inspect which constructor built
it and extract the fields. Lean requires that pattern matches are
**exhaustive**: every constructor must be handled. This is the
computational content of the induction principle.

Under the hood, Lean generates a **recursor** for each inductive
type. For `MyNat`, the recursor has the type:

```lean
MyNat.rec : {motive : MyNat -> Sort u} ->
  motive .zero ->
  ((n : MyNat) -> motive n -> motive (.succ n)) ->
  (t : MyNat) -> motive t
```

This is the Peano induction principle expressed as a dependent
eliminator. Pattern matching compiles down to calls to this recursor.

## Recursive Functions on Inductive Types

```lean
def myAdd : MyNat -> MyNat -> MyNat
  | .zero,   m => m
  | .succ n, m => .succ (myAdd n m)
```

Lean's termination checker verifies that the first argument
decreases structurally: `n` is a strict sub-term of `.succ n`. This
guarantees termination by well-founded induction on the structure of
`MyNat`. Without this check, the logic would be inconsistent
(you could prove `False` using a non-terminating function).

## Parameterized Inductive Types

```lean
inductive MyList (alpha : Type) where
  | nil : MyList alpha
  | cons (head : alpha) (tail : MyList alpha) : MyList alpha

def myLength : MyList alpha -> Nat
  | .nil => 0
  | .cons _ tail => 1 + myLength tail
```

Here `alpha` is a **type parameter** (a type variable in System F
terminology). `MyList` is a **type constructor** of kind
`Type -> Type`. You cannot write `MyList` without giving it a type
argument. `MyList Nat`, `MyList String`, `MyList (MyList Bool)` are
all concrete types.

The distinction between **parameters** and **indices** is important
in CIC:

- A **parameter** is uniform across all constructors. `alpha` in
  `MyList (alpha : Type)` is a parameter: every constructor
  produces `MyList alpha` for the same `alpha`.

- An **index** can vary between constructors. In
  `TypedExpr : Ty -> Type`, the `Ty` argument is an index: the
  constructor `litNat` produces `TypedExpr .nat` while `litBool`
  produces `TypedExpr .bool`.

Parameters live before the colon in the `inductive` declaration.
Indices live after it.

## Introduction and Elimination

Every inductive type comes with two operations:

**Introduction**: the data constructors. They build values.

```lean
-- Introducing a Maybe value
Maybe.just 42      -- : Maybe Nat
Maybe.nothing      -- : Maybe Nat
```

**Elimination**: pattern matching (or the recursor). It takes apart
values.

```lean
-- Eliminating a Maybe value
def maybeMap {alpha beta : Type}
    (f : alpha -> beta) (x : Maybe alpha) : Maybe beta :=
  match x with
  | .nothing => .nothing
  | .just a  => .just (f a)
```

This pair (introduction + elimination) satisfies **computation
rules** (also called beta rules or iota reduction in CIC):

```
-- If you introduce then immediately eliminate:
match (Maybe.just 42) with
| .nothing => ...
| .just a  => f a
-- reduces to: f 42
```

The computation rules guarantee that elimination "undoes"
introduction. This is the same idea as beta reduction in the lambda
calculus (`(\x. e) v --> e[x := v]`).

## Indexed Families (Dependent Inductive Types)

Exercise 13 introduces `TypedExpr : Ty -> Type`. This is not a
parameterized type but an **indexed family** (also called an
**inductive family** or **dependent inductive type**). The index
appears after the colon:

```lean
inductive TypedExpr : Ty -> Type where
  | litNat  : Nat -> TypedExpr .nat
  | litBool : Bool -> TypedExpr .bool
  | addExpr : TypedExpr .nat -> TypedExpr .nat -> TypedExpr .nat
  | eqExpr  : TypedExpr .nat -> TypedExpr .nat -> TypedExpr .bool
```

Notice that different constructors produce different indices
(`.nat` vs `.bool`). This is what makes it an index rather than a
parameter. The type system enforces that you cannot add a boolean
expression to a natural number expression, because
`addExpr` requires both arguments to have index `.nat`.

This is the essence of **dependently typed programming**: encoding
invariants in the type. The classic example is `Vector n`, a list
whose length is part of its type:

```lean
inductive Vector (alpha : Type) : Nat -> Type where
  | nil  : Vector alpha 0
  | cons : alpha -> Vector alpha n -> Vector alpha (n + 1)
```

Here `alpha` is a parameter (uniform across constructors) and `Nat`
is an index (varies: `nil` has index `0`, `cons` has index `n + 1`).

Indexed families require the full power of CIC. They cannot be
expressed in System F-omega.

## Math Track: Inductive Types as Initial Algebras

An inductive type is the **initial algebra** (or **free algebra**)
for the polynomial endofunctor defined by its constructors.

For `MyNat`, the functor is `F(X) = 1 + X` (corresponding to
`zero : 1 -> Nat` and `succ : Nat -> Nat`). The initial algebra of
this functor is exactly the natural numbers. The recursor
`MyNat.rec` is the unique algebra homomorphism from the initial
algebra to any other F-algebra. This is a categorical way of stating
the universal property of induction.

For `MyList alpha`, the functor is `F(X) = 1 + alpha x X`. Its
initial algebra is the type of finite lists.

The "initial" means: there is a unique homomorphism from the
inductive type to any other algebra with the same shape. That
unique homomorphism is exactly `fold` (catamorphism). Every
function defined by pattern matching on an inductive type is a
catamorphism.

**Reference:** The connection between inductive types and initial
algebras was developed by Hagino (1987) and systematically applied
to programming by Meijer, Fokkinga, and Paterson (1991, "Functional
Programming with Bananas, Lenses, Envelopes and Barbed Wire").

## CS Track: Algebraic Data Types

Inductive types are Lean's version of algebraic data types (ADTs).
They combine **sum types** (multiple constructors) with **product
types** (constructor arguments). Pattern matching provides
exhaustive case analysis.

```lean
-- Like Haskell's: data Maybe a = Nothing | Just a
inductive MyOption (alpha : Type) where
  | none : MyOption alpha
  | some (val : alpha) : MyOption alpha
```

The name "algebraic" comes from the fact that the number of values
of a type follows algebraic rules:

| Type operation    | Algebra       | Example                       |
| ----------------- | ------------- | ----------------------------- |
| Sum (`A + B`)     | Addition      | `Bool` has `2` values         |
| Product (`A x B`) | Multiplication| `Bool x Bool` has `2 * 2 = 4` |
| Function (`A -> B`)| Exponentiation| `Bool -> Bool` has `2^2 = 4` |
| Unit (`1`)        | One           | One value                     |
| Empty (`0`)       | Zero          | No values                     |

So `Maybe Bool = 1 + Bool = 1 + 2 = 3` values: `nothing`, `just true`,
`just false`.

## Historical Timeline

| Year | System                  | Author(s)                   | Key idea                                |
| ---- | ----------------------- | --------------------------- | --------------------------------------- |
| 1940 | Simply typed lambda calculus | Church                  | Types prevent paradoxes                 |
| 1967 | Automath                | de Bruijn                   | First proof checker with dependent types|
| 1971 | Intuitionistic type theory | Martin-Lof              | Dependent types + universes             |
| 1972 | System F                | Girard                      | Polymorphism (terms on types)           |
| 1972 | System F-omega          | Girard                      | Type operators (types on types)         |
| 1974 | System F (rediscovered) | Reynolds                    | Parametric polymorphism                 |
| 1986 | Calculus of Constructions| Coquand, Huet               | All four lambda cube axes               |
| 1989 | Parametricity           | Wadler                      | "Theorems for free" from types          |
| 1990 | CIC                     | Coquand, Paulin-Mohring     | CoC + inductive types                   |
| 1991 | Lambda cube             | Barendregt                  | Systematic classification               |
| 2004 | Coq 8.0                 | INRIA                       | Mature CIC implementation               |
| 2017 | Lean 4 (began)          | de Moura, Ullrich           | CIC with quotient types, code gen       |

**References:**

- Barendregt, H. (1991). "Introduction to Generalized Type Systems."
  Journal of Functional Programming.
- Coquand, T. and Huet, G. (1988). "The Calculus of Constructions."
  Information and Computation.
- Coquand, T. and Paulin-Mohring, C. (1990). "Inductively Defined
  Types." COLOG-88, LNCS 417.
- Girard, J.-Y. (1972). "Interpretation fonctionnelle et elimination
  des coupures de l'arithmetique d'ordre superieur." These de doctorat
  d'Etat, Universite Paris VII.
- Martin-Lof, P. (1984). "Intuitionistic Type Theory." Bibliopolis.
- Reynolds, J.C. (1974). "Towards a theory of type structure."
  Colloque sur la Programmation, LNCS 19.
- Wadler, P. (1989). "Theorems for Free!" FPCA '89.
