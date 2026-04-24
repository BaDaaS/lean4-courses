# 0001 - Types

## Goal

Understand Lean's type system: basic types, type universes, and how
types relate to both mathematical objects and data specifications.
Learn the formal judgment notation that underpins type checking.

## Basic Types

```lean
#check Nat           -- Type
#check Int           -- Type
#check Bool          -- Type
#check String        -- Type
#check Float         -- Type
```

Each of these is a **closed type**: it has no free type variables.
`Nat : Type` is a **typing judgment** stating that `Nat` is a
well-formed type in universe `Type` (which is `Sort 1`).

## Typing Judgments

Everything the kernel does is expressed as **judgments**. A judgment
is a formal assertion about a term. The kernel checks judgments; it
never guesses or approximates.

The central judgment is:

```
Gamma |- t : T
```

Read: "in context Gamma, term t has type T." The context Gamma is a
list of variable declarations: `(x : Nat), (h : x > 0), ...`.

When you write `def f (n : Nat) : Bool := n == 0`, the kernel
checks:

```
(n : Nat) |- (n == 0) : Bool
```

The context contains `n : Nat`. The body `n == 0` must have type
`Bool` in that context.

### Formation, introduction, elimination

Type theorists classify rules into three groups. These terms appear
throughout courses 0003-0005, so it is worth learning them now:

**Formation rules** say when a type is well-formed. "If `A : Type`
and `B : Type`, then `A -> B : Type`." This is a judgment about
types.

**Introduction rules** say how to build values of a type. "If
`a : A` and `b : B`, then `(a, b) : A x B`." Data constructors
are introduction rules.

**Elimination rules** say how to use values of a type. "If
`p : A x B`, then `p.1 : A` and `p.2 : B`." Pattern matching and
projection are elimination rules.

Every type in Lean has these three components. They are not separate
syntax; they are a way of reading the definitions:

| Type      | Formation         | Introduction          | Elimination       |
| --------- | ----------------- | --------------------- | ----------------- |
| `A -> B`  | both `A`, `B` are types | `fun (x : A) => e` | function application `f a` |
| `A x B`   | both `A`, `B` are types | `(a, b)`            | `.1`, `.2`        |
| `A + B`   | both `A`, `B` are types | `Sum.inl a`, `Sum.inr b` | `match` on `Sum` |
| `Nat`     | always well-formed | `Nat.zero`, `Nat.succ n` | `match` / recursion |
| `Bool`    | always well-formed | `true`, `false`       | `if ... then ... else` |

### Definitional equality

Two terms are **definitionally equal** (written `t =_def s`) if the
kernel can reduce them to the same normal form by computation. This
is checked automatically and silently. For example:

```lean
-- The kernel reduces both sides to 4, so rfl works
example : 2 + 2 = 4 := rfl
```

Definitional equality includes:

- **Beta reduction**: `(fun x => e) a =_def e[x := a]`
- **Delta reduction**: unfolding definitions (e.g., `double 3`
  unfolds to `2 * 3`)
- **Iota reduction**: pattern matching on a known constructor
  (e.g., `match Nat.zero with | 0 => ... | succ n => ...`
  reduces to the first branch)
- **Zeta reduction**: `let x := a; e =_def e[x := a]`

If `t =_def s`, they are interchangeable everywhere. No proof is
needed. This is stronger than **propositional equality** (`t = s`),
which requires a proof term.

## Type Universes

Every type itself has a type. Lean organizes types into an infinite
hierarchy to avoid Russell's paradox:

```lean
#check Nat           -- Nat : Type
#check Type          -- Type : Type 1
#check Type 1        -- Type 1 : Type 2
```

If we had `Type : Type` (a type containing itself), we could
encode Russell's paradox and prove `False`. Jean-Yves Girard
proved this in 1972 (Girard's paradox): an impredicative `Type :
Type` makes the system inconsistent. The universe hierarchy
prevents this.

The hierarchy in Lean is:

```
Sort 0 = Prop     -- propositions (proof-irrelevant)
Sort 1 = Type     -- also called Type 0
Sort 2 = Type 1
Sort 3 = Type 2
...
```

The hierarchy is **cumulative**: if `T : Type n`, then `T` can also
be used where `Type m` is expected, for any `m >= n`. This means
you rarely need to think about universe levels explicitly.

### Universe polymorphism

When you write a definition that should work at any universe level,
Lean uses **universe variables**:

```lean
universe u v
def Prod' (alpha : Type u) (beta : Type v) :=
  alpha x beta
-- Prod' : Type u -> Type v -> Type (max u v)
```

The result lives in `Type (max u v)` because the product must
be large enough to contain both components.

### Prop: the impredicative universe

`Prop` (`Sort 0`) is special. It is **impredicative**: a
proposition can quantify over all propositions, including itself,
without moving up a universe level.

```lean
-- This lives in Prop, not Type 1
#check forall (P : Prop), P -> P    -- Prop
```

In contrast, `forall (T : Type), T -> T` lives in `Type 1`
because it quantifies over `Type`.

Impredicativity is safe for `Prop` because of **proof irrelevance**:
all proofs of a proposition are considered equal. You cannot extract
computational content from a proof. This restriction (called the
"singleton elimination" rule) prevents the inconsistency that
impredicativity would otherwise cause.

**Reference:** Coquand, T. (1986). "An Analysis of Girard's
Paradox." LICS '86. This paper shows why `Type : Type` is
inconsistent and why `Prop : Type` with proof irrelevance is safe.

## Function Types

```lean
#check Nat -> Nat          -- function from Nat to Nat
#check Nat -> Bool         -- predicate on Nat
#check Nat -> Nat -> Nat   -- curried two-argument function
```

`->` is right-associative: `Nat -> Nat -> Nat` means
`Nat -> (Nat -> Nat)`. This is a function that takes a `Nat` and
returns a function `Nat -> Nat`. See course 0002 for why this
matters (currying).

In dependent type theory, `A -> B` is sugar for the **Pi type**
`(x : A) -> B` where `B` does not mention `x`. When `B` does
mention `x`, you have a dependent function type:

```lean
-- Non-dependent: return type is always Bool
def isEven : Nat -> Bool := ...

-- Dependent: return type depends on the input
def Vec (alpha : Type) (n : Nat) : Type := ...
def head : (n : Nat) -> Vec alpha (n + 1) -> alpha := ...
```

The Pi type `(x : A) -> B x` is the fundamental type former in
dependent type theory. All other type constructions (product types,
sum types, even `Nat`) are defined as inductive types on top of it
(see course 0005).

## Product and Sum Types

```lean
-- Product (pair): both components
#check Nat x Bool          -- Nat x Bool : Type
#check (3, true)            -- (3, true) : Nat x Bool

-- Sum (either): one of two options
#check Sum Nat Bool         -- Sum Nat Bool : Type
```

Products and sums correspond to logical connectives under the
Curry-Howard correspondence (see course 0003):

| Type theory | Logic | Set theory |
| ----------- | ----- | ---------- |
| `A x B` (product) | `A /\ B` (and) | `A intersection B` |
| `A + B` (sum)      | `A \/ B` (or)  | `A union B` (disjoint) |
| `A -> B` (function)| `A -> B` (implies) | `B^A` (function set) |
| `Unit` (one element) | `True` | `{*}` (singleton) |
| `Empty` (no elements) | `False` | `{}` (empty set) |

The **cardinality** of these types follows algebraic rules:
`|A x B| = |A| * |B|` and `|A + B| = |A| + |B|`. This is why they
are called **algebraic data types** in ML/Haskell. More on this in
course 0005.

### Sigma types (dependent pairs)

Just as `->` generalizes to Pi types, `x` generalizes to **Sigma
types** (dependent pairs). A Sigma type `(x : A) x B x` is a pair
where the type of the second component depends on the value of the
first:

```lean
-- Non-dependent pair
#check (3, true)          -- Nat x Bool

-- Dependent pair (Sigma type)
-- A natural number n together with a proof that n > 0
#check (Sigma (n : Nat) (n > 0))
-- Equivalent shorthand:
-- { n : Nat // n > 0 }    (subtype notation)
```

Under Curry-Howard, Sigma types correspond to the existential
quantifier: `exists x : A, B x` is a pair of a witness `x` and a
proof of `B x`.

## Math Track: Types as Sets (with Caveats)

Think of a type as a set. `n : Nat` means "n is an element of Nat".
Function types `A -> B` correspond to the set of all functions from
A to B.

The analogy is useful but imperfect. In set theory, a set is
determined by its elements (extensionality). In type theory, a type
is determined by its **introduction and elimination rules**. Two
types can have the same elements but different computational
behavior. The connection between type theory and set theory is made
precise by **categorical semantics**: types are objects in a
category, functions are morphisms, and the typing rules correspond
to categorical structure.

`Prop` is the universe of propositions. A proposition `P : Prop` is
either provable (inhabited) or not. A proof `h : P` is a witness
that P holds.

Under the **BHK interpretation** (Brouwer-Heyting-Kolmogorov), a
proof of `P -> Q` is a function that transforms proofs of P into
proofs of Q. A proof of `P /\ Q` is a pair of proofs. A proof of
`P \/ Q` is either a proof of P or a proof of Q, together with a
tag saying which. A proof of `exists x, P x` is a specific witness
`x` together with a proof of `P x`. This is exactly what Lean's
type system implements.

**Reference:** The BHK interpretation was developed by L.E.J.
Brouwer (1907), Arend Heyting (1930), and Andrey Kolmogorov (1932).
It provides the constructive semantics that Lean's `Prop` universe
implements (before `Classical.choice` is invoked).

## CS Track: Types as Specifications

Types specify what data looks like and what functions accept/return.
Lean's type checker ensures your program respects these
specifications at compile time.

```lean
-- The type tells you exactly what this function does
def increment (n : Nat) : Nat := n + 1

-- Type error: String is not Nat
-- def bad : Nat := "hello"  -- won't compile
```

In programming language theory, a type system is **sound** if
well-typed programs do not "go wrong" (no runtime type errors).
This is stated as two properties:

- **Progress**: a well-typed term is either a value or can take a
  computation step.
- **Preservation**: if a well-typed term takes a step, the result
  is still well-typed (at the same type).

Together: "well-typed programs don't get stuck." Lean's type system
is sound, so if the kernel accepts your code, it will not crash
with a type error at runtime.

**Reference:** Wright, A. and Felleisen, M. (1994). "A Syntactic
Approach to Type Soundness." Information and Computation. This paper
established the progress + preservation framework.

## Type Annotations

```lean
-- Explicit annotation
def x : Nat := 42

-- Lean can infer types
def y := 42           -- inferred as Nat

-- Annotations on function parameters
def add (a : Nat) (b : Nat) : Nat := a + b
```

Type inference in Lean uses **higher-order unification**, which is
undecidable in general. In practice, Lean's elaborator handles most
cases. When it cannot infer a type, it asks you to annotate. The
`{...}` and `[...]` argument syntaxes control which arguments the
elaborator should infer (see course 0002).

## The `Prop` vs `Bool` Distinction

This is critical in Lean:

- `Bool` is a data type with values `true` and `false` (computable)
- `Prop` is the universe of propositions (logical, may not be
  computable)

```lean
#check (5 < 10 : Prop)      -- a proposition
#check (decide (5 < 10))     -- computable decision
#eval decide (5 < 10)        -- true
```

The difference is subtle but fundamental:

| Aspect | `Bool` | `Prop` |
| ------ | ------ | ------ |
| Universe | `Type` | `Sort 0` |
| Values | `true`, `false` | proofs (terms of type P) |
| Decidable? | Always (2 values) | Not always (undecidable in general) |
| Proof irrelevance | No (`true != false`) | Yes (all proofs of P are equal) |
| Can branch on? | Yes (`if b then ...`) | Only if `Decidable P` |
| Erased at runtime? | No | Yes |

`Decidable P` is the bridge. When `P : Prop` has a `Decidable`
instance, Lean can convert between the logical world (`Prop`) and
the computational world (`Bool`). The tactic `decide` uses this to
check decidable propositions by computation.

Not all propositions are decidable. "This Turing machine halts" is
a `Prop` with no `Decidable` instance. The halting problem is the
canonical example, but undecidability appears everywhere: equality
of real numbers, set membership for arbitrary sets, etc. This is
why `Prop` and `Bool` must remain separate.
