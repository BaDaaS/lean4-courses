# 0013 - Algebraic Structures

## Goal

Define and work with algebraic structures (monoids, groups, rings)
using typeclasses. Introduction to Mathlib's hierarchy.

## Monoid

A monoid is a set with an associative binary operation and an identity:

```lean fromFile:Examples.lean#monoid
class MyMonoid (M : Type) where
  one : M
  mul : M -> M -> M
  mul_assoc : forall a b c : M, mul (mul a b) c = mul a (mul b c)
  one_mul : forall a : M, mul one a = a
  mul_one : forall a : M, mul a one = a
```

## Group

A group adds inverses:

```lean fromFile:Examples.lean#group
class MyGroup (G : Type) extends MyMonoid G where
  inv : G -> G
  mul_inv : forall a : G, mul a (inv a) = one
```

## Ring

A ring has addition (abelian group) and multiplication (monoid) with
distributivity:

```lean fromFile:Examples.lean#ring
-- Simplified
class MyRing (R : Type) where
  zero : R
  one : R
  add : R -> R -> R
  mul : R -> R -> R
  neg : R -> R
  -- plus axioms: add_comm, add_assoc, mul_assoc, distrib, etc.
```

## Using Mathlib's Hierarchy

With Mathlib imported, you get the full hierarchy:

```
Semigroup < Monoid < Group
                   < CommMonoid
Semiring < Ring < CommRing < Field
Module, Algebra, ...
```

```lean
-- Mathlib style: state theorems generically
example [Group G] (a : G) : a * a⁻1 = 1 := mul_inv_cancel a
```

## Math Track

This is the bread and butter of abstract algebra in Lean. Mathlib's
algebraic hierarchy lets you prove theorems at the most general level
and have them apply to all concrete instances (integers, matrices,
polynomials, etc.).

## CS Track

Algebraic structures are powerful interfaces. A `Monoid` instance gives
you `fold` for free. A `Ring` instance gives you polynomial evaluation.
Generic programming over algebraic structures yields highly reusable code.
