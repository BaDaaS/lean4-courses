# 0002 - Functions

## Goal

Master function definitions in Lean 4: lambda expressions, currying,
implicit arguments, and partial application. Understand how these
connect to the lambda calculus, the theoretical foundation underneath.

## The Lambda Calculus Connection

Every function in Lean is, at its core, a term in the lambda
calculus. The lambda calculus was introduced by Alonzo Church in
1936 as a formal system for computation, and it remains the
foundation of all functional programming languages.

The untyped lambda calculus has three constructs:

```
e ::= x           -- variable
    | \x. e        -- abstraction (function)
    | e1 e2        -- application (function call)
```

That is the entire language. Everything else (numbers, booleans,
data structures) can be encoded using just these three forms (Church
encodings). Lean's `fun x => e` is exactly `\x. e`. Function
application `f a` is exactly `f a`.

The **simply typed lambda calculus** (STLC, Church 1940) adds types:
every variable has a type, every function has a type `A -> B`, and
the type checker ensures you never apply a function to the wrong
type of argument. Lean's type system is a far richer descendant of
the STLC (see course 0005 for the full lambda cube).

## Defining Functions

```lean fromFile:Examples.lean#defining_functions
-- Named definition
def add (a b : Nat) : Nat := a + b

-- Lambda (anonymous function)
def add' : Nat -> Nat -> Nat := fun a b => a + b

-- With pattern matching
def isEven : Nat -> Bool
  | 0 => true
  | 1 => false
  | n + 2 => isEven n
```

These three forms are interchangeable. The compiler desugars all of
them into lambda terms and match expressions. `def add (a b : Nat)
: Nat := a + b` is sugar for
`def add : Nat -> Nat -> Nat := fun a b => a + b`.

## Beta Reduction and Computation

The fundamental computation rule of the lambda calculus is **beta
reduction**: applying a function to an argument substitutes the
argument into the body.

```
(\x. e) a   --->   e[x := a]
```

In Lean terms:

```lean fromFile:Examples.lean#beta_reduction
-- (fun x => x + 1) 3   computes to   3 + 1   computes to   4
#eval (fun x => x + 1) 3    -- 4
```

The kernel uses beta reduction (among other reductions; see course
0001 on definitional equality) to check whether two terms are equal
by computation. This is what makes `rfl` work: the kernel reduces
both sides and checks they are identical.

**Eta reduction** is the other direction: if `f : A -> B`, then
`fun x => f x` is considered equal to `f`. This is because both
behave identically on every input. In Lean, eta equality holds
definitionally for functions:

```lean fromFile:Examples.lean#eta_reduction
-- These are definitionally equal
example : (fun x => Nat.succ x) = Nat.succ := rfl
```

### Normal forms and termination

A term is in **normal form** when no more reductions apply. The
kernel reduces terms to normal form to check definitional equality.
This is only possible if all reductions terminate, which is why
Lean requires all functions to be **total** (terminating on all
inputs).

In the untyped lambda calculus, reduction can loop forever:
`(\x. x x) (\x. x x)` reduces to itself. Church and Rosser proved
(1936) that if a normal form exists, all reduction strategies find
the same one (confluence), but not all terms have normal forms.

In the simply typed lambda calculus, every term has a normal form
(strong normalization). Lean's CIC also has this property (for its
core calculus without axioms), which is essential for the kernel's
correctness: type-checking always terminates.

**Reference:** Church, A. and Rosser, J.B. (1936). "Some properties
of conversion." Transactions of the AMS.

## Currying

All functions in Lean are curried. A function taking two arguments
is actually a function returning a function:

```lean fromFile:Examples.lean#currying_partial_application
-- These are the same type:
-- Nat -> Nat -> Nat
-- Nat -> (Nat -> Nat)

def add3 := add 3  -- partial application: Nat -> Nat
#eval add3 7        -- 10
```

Currying is named after Haskell Curry (1930s), though the idea was
first used by Moses Schonfinkel (1924) and even earlier by Gottlob
Frege (1893). The key insight: you never need multi-argument
functions. A "two-argument function" `f : A -> B -> C` is a
function that takes an `A` and returns a function `B -> C`.

This is not just a syntactic trick. It has a precise
category-theoretic meaning. In a **cartesian closed category**
(which is the categorical semantics of the STLC), there is a
natural isomorphism:

```
Hom(A x B, C)  ~=  Hom(A, C^B)
```

A function from pairs `(A x B) -> C` corresponds to a curried
function `A -> (B -> C)`. This is the **exponential adjunction**.
Lean's `Function.curry` and `Function.uncurry` implement both
directions.

## Implicit Arguments

Arguments in `{}` are inferred by Lean:

```lean fromFile:Examples.lean#list_length
def listLength {alpha : Type} (xs : List alpha) : Nat :=
  match xs with
  | [] => 0
  | _ :: tail => 1 + listLength tail

#eval listLength [1, 2, 3]  -- Lean infers alpha = Nat
```

Use `@` to pass implicit arguments explicitly:

```lean fromFile:Examples.lean#list_length_explicit
#eval @listLength Nat [1, 2, 3]
```

### How inference works

When you call `listLength [1, 2, 3]`, the elaborator sees that the
argument has type `List Nat`. It needs to find `alpha` such that
`List alpha = List Nat`. It solves `alpha := Nat` by **unification**:
finding a substitution that makes two types equal.

Lean's unification is **higher-order**: it can solve for unknown
functions, not just unknown types. For example, given
`f ?m 3 = Nat.succ 3`, it can infer `?m := fun x => Nat.succ x`.
Higher-order unification is undecidable in general (Huet, 1973),
but Lean's elaborator uses heuristics that work well in practice.

### Three kinds of implicit arguments

| Syntax | Name | Resolution |
| ------ | ---- | ---------- |
| `{x : T}` | Implicit | Solved by unification |
| `[x : T]` | Instance-implicit | Solved by typeclass search |
| `(x : T)` | Explicit | Must be provided by the caller |

Instance-implicit arguments `[...]` trigger Lean's **typeclass
resolution** engine, which searches for a registered instance of the
required class. This is how `ToString`, `Add`, `BEq`, and other
overloaded operations work. See course 0006 for details.

**Reference:** Huet, G. (1973). "The Undecidability of Unification
in Third Order Logic." Information and Control. This established
that higher-order unification is undecidable, motivating the
heuristic approaches used in Lean and Coq.

## Instance-Implicit Arguments

Arguments in `[]` are resolved via typeclass search:

```lean
def printIt [ToString alpha] (x : alpha) : String :=
  toString x
```

The elaborator searches for an instance of `ToString alpha`. If
`alpha = Nat`, it finds `instToStringNat : ToString Nat` in the
environment and passes it automatically. This is the same mechanism
as Haskell's type classes (Wadler and Blott, 1989), adapted for
dependent types.

## Where Clauses

```lean fromFile:Examples.lean#where_clause
def hypotenuse (a b : Float) : Float :=
  Float.sqrt (sq a + sq b)
where
  sq (x : Float) := x * x
```

`where` binds local definitions that are in scope only within the
body. This is syntactic sugar for `let`:

```lean fromFile:Examples.lean#let_clause
def hypotenuse' (a b : Float) : Float :=
  let sq (x : Float) := x * x
  Float.sqrt (sq a + sq b)
```

In the lambda calculus, `let x := e1; e2` is sugar for
`(fun x => e2) e1`. Lean's kernel reduces `let` bindings by
**zeta reduction**.

## Higher-Order Functions

A **higher-order function** takes a function as an argument or
returns one. This is the main source of abstraction power in
functional programming.

```lean fromFile:Examples.lean#higher_order_functions
-- Takes a function as argument
def applyTwice {alpha : Type} (f : alpha -> alpha) (x : alpha) : alpha :=
  f (f x)

#eval applyTwice (fun n : Nat => n + 1) 0  -- 2

-- Returns a function
def adder (n : Nat) : Nat -> Nat :=
  fun m => n + m

#eval adder 3 7  -- 10
```

In System F terms, `applyTwice` has the polymorphic type
`forall alpha. (alpha -> alpha) -> alpha -> alpha`. The `{alpha :
Type}` in Lean is the System F type abstraction (see course 0005).

### Church encodings

Higher-order functions are powerful enough to encode all data.
Church (1936) showed that in the untyped lambda calculus, you can
represent natural numbers, booleans, pairs, and lists using only
functions:

```
-- Church numerals
0 = \f. \x. x
1 = \f. \x. f x
2 = \f. \x. f (f x)
3 = \f. \x. f (f (f x))

-- A Church numeral n takes a function f and applies it n times
-- Addition: apply f (m + n) times
add = \m. \n. \f. \x. m f (n f x)
```

In Lean, you would not use Church encodings (inductive types are
more efficient and more readable), but they demonstrate that
functions alone are computationally complete. The Church numeral
for `n` has type `(alpha -> alpha) -> alpha -> alpha` in System F,
which is the polymorphic type of "apply a function n times."

## Math Track: Functions as Morphisms

In mathematics, a function f : A -> B assigns to each element of A
exactly one element of B. In Lean, this is enforced by the type
system: you must handle every input (totality).

Composition works naturally:

```lean
def compose (f : beta -> gamma) (g : alpha -> beta) :
    alpha -> gamma :=
  fun x => f (g x)
```

Composition is associative and has identity (`fun x => x`), making
types and functions a **category**. This is the category **Type**
(or **Set** for mathematicians who prefer to think in terms of
sets). The lambda calculus is the **internal language** of cartesian
closed categories, a result due to Lambek (1980).

Function extensionality states that if `forall x, f x = g x`, then
`f = g`. In Lean, this is a theorem (`funext`), not an axiom. It
follows from `propext` and `Quot.sound`.

## CS Track: Functions as Computations

Functions in Lean are pure (no side effects). They always return
the same output for the same input (**referential transparency**).
This makes equational reasoning valid: you can always replace `f a`
with its result without changing the program's meaning.

Purity has costs (I/O, mutable state), which Lean handles through
the `IO` monad (see course 0018) and linearity-like optimizations
(destructive updates when the reference count is 1).

**Reference:** Schonfinkel, M. (1924). "Uber die Bausteine der
mathematischen Logik." Mathematische Annalen. This paper introduced
the idea of reducing multi-argument functions to single-argument
functions (currying).
