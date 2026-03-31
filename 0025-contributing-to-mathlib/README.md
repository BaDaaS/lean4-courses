# 0024 - Contributing to Mathlib

## Goal

Learn the workflow, conventions, and tools for contributing to Mathlib4,
the community math library for Lean 4.

## What is Mathlib?

Mathlib is the largest library of formalized mathematics. It covers:
algebra, analysis, topology, number theory, category theory, combinatorics,
measure theory, and more.

Repository: https://github.com/leanprover-community/mathlib4

## Setting Up

```bash
# Clone Mathlib
git clone https://github.com/leanprover-community/mathlib4
cd mathlib4

# Get pre-built oleans (avoids hours of compilation)
lake exe cache get

# Build (should be fast after cache)
lake build
```

## Finding What to Contribute

1. **Zulip**: https://leanprover.zulipchat.com/ - ask in #new members
2. **Issues labeled "good first issue"** on GitHub
3. **Fill gaps**: search for `sorry` in Mathlib (there are none, but
   there are `TODO` comments)
4. **Extend existing theories**: add missing lemmas about existing objects
5. **Formalize new mathematics**: requires discussion on Zulip first

## Mathlib Conventions

### File Structure

```lean
/-
Copyright (c) 2024 Your Name. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Your Name
-/
import Mathlib.Algebra.Group.Basic

/-!
# Title

Description of the module.

## Main definitions

- `Foo`: description
- `Bar`: description

## Main results

- `foo_bar`: description

## References

* [Author, *Title*][bibtexKey]
-/
```

### Naming Conventions

Mathlib names are highly systematic:
- `operation_property`: `mul_comm`, `add_zero`
- `type.operation`: `List.map`, `Finset.sum`
- `_iff` for biconditionals
- `_of_` for conditional results
- `not_` prefix for negation

### Style

- 100 character line limit
- `where` clauses preferred over `fun ... =>`
- Tactic proofs for non-trivial statements
- `simp` lemmas tagged with `@[simp]`
- No `autoImplicit`

## PR Workflow

1. Create a branch from `master`
2. Make changes in a single file (or closely related files)
3. Run linters: `lake exe lint-style` and `lake lint`
4. Run tests: `lake build --wfail`
5. Open PR with descriptive title
6. Respond to review comments
7. Keep PRs small (under 300 lines of diff)

## Linting

```bash
lake exe lint-style           # Text-based style linters
lake lint                     # Environment linters
lake exe mk_all --check       # Verify all files imported
```

## Useful Commands When Working on Mathlib

```bash
# Search for a definition
grep -r "^def MyThing" Mathlib/

# Search for a theorem name
grep -r "^theorem.*my_lemma" Mathlib/

# Find which file imports what
grep -r "import Mathlib.Algebra.Group" Mathlib/
```

## Mathlib Tactics (Not in Lean Core)

These tactics are provided by Mathlib, not by Lean itself. They are
essential for working in Mathlib.

### ring

Solves equalities in commutative (semi)rings by normalization.

```lean
example (x y : Int) : (x + y) ^ 2 = x ^ 2 + 2 * x * y + y ^ 2 := by
  ring
```

**Under the hood:** Normalizes both sides into a canonical polynomial
form (sum of monomials sorted lexicographically), then checks they are
identical. The normalization is verified by a reflection proof: the
tactic builds a symbolic representation, evaluates it, and produces a
chain of ring axiom applications.

**Reference:** The ring tactic is inspired by Gregoire and Mahboubi,
"Proving Equalities in a Commutative Ring Done Right in Coq," TPHOLs
2005. The Lean 4 version is a reimplementation by the Mathlib team.

### norm_num

Normalizes and evaluates numeric expressions.

```lean
example : (3 : Nat) * 4 + 1 = 13 := by norm_num
example : Nat.Prime 17 := by norm_num
```

**Under the hood:** Uses a plugin architecture. Each `norm_num`
extension knows how to evaluate specific operations (arithmetic,
primality, GCD, etc.). The proof is built by computation: the tactic
evaluates the expression and produces a verified equality chain.

**Reference:** Rob Lewis, "A Formal Proof of Hensel's Lemma over the
p-adic Integers," CPP 2019 (describes the norm_num framework).

### field_simp

Clears denominators in field expressions. Transforms `a / b = c / d`
into `a * d = c * b` (with side goals proving denominators are
nonzero).

```lean
example (x : Rat) (hx : x != 0) : x / x = 1 := by
  field_simp
```

Use `field_simp` before `ring` when divisions are present.

### linarith

Proves linear arithmetic goals over ordered fields/rings. More
general than `omega` (works with rationals and reals), but less
powerful for integers (no modular arithmetic).

```lean
example (x y : Rat) (h1 : x > 0) (h2 : y > 0) : x + y > 0 := by
  linarith
```

**Under the hood:** Searches for a nonnegative linear combination of
hypotheses that equals the negation of the goal. Uses the
Positivstellensatz (a real algebraic geometry result): if a system
of linear inequalities is unsatisfiable, there exists a nonnegative
linear combination of the constraints that equals a strictly negative
constant.

**Reference:** The Positivstellensatz approach for automated inequality
proving is described in Harrison, "Verifying Nonlinear Real Arithmetic
via Abstract Interpretation," 2007.

### nlinarith

Nonlinear arithmetic extension of `linarith`. Can handle some
polynomial inequalities by adding products of hypotheses.

```lean
example (x : Rat) : x ^ 2 >= 0 := by nlinarith [sq_nonneg x]
```

### polyrith

Uses an external oracle (Sage/Mathematica) to find polynomial
certificates, then verifies them in Lean.

### positivity

Proves goals of the form `0 <= e`, `0 < e`, or `e != 0`.

```lean
example (x : Rat) : 0 <= x ^ 2 + 1 := by positivity
```

**Under the hood:** Recursively decomposes the expression: sums of
nonnegatives are nonneg, products of positives are positive, squares
are nonneg, etc.

### push_neg

Pushes negations inward through quantifiers and connectives.

```lean
-- Not (forall x, P x) becomes Exists x, Not (P x)
-- Not (P /\ Q) becomes P -> Not Q
example (h : Not (forall n : Nat, n > 0)) :
    Exists n : Nat, Not (n > 0) := by
  push_neg at h
  exact h
```

**Under the hood:** Uses classical logic (`Classical.em`) to apply
De Morgan's laws and quantifier duality.

### by_contra / by_cases

Classical reasoning tactics.

```lean
-- Proof by contradiction
example (h : Not (P -> Q)) : P := by
  by_contra hp
  exact h (fun p => absurd p hp)

-- Case split on a decidable/classical proposition
example (P : Prop) : P \/ Not P := by
  by_cases hp : P
  . left; exact hp
  . right; exact hp
```

### tauto

Propositional tautology solver. Handles pure logic goals
(no arithmetic, no custom types).

```lean
example (P Q : Prop) : (P -> Q) -> (Not Q -> Not P) := by tauto
```

### aesop

Automated Extensible Search for Obvious Proofs. A configurable
best-first search that combines `simp`, `intro`, `cases`,
`constructor`, `exact`, and custom rules.

```lean
example (xs : List Nat) (h : xs != []) : xs.length > 0 := by
  aesop
```

**Reference:** Limperg and From, "Aesop: White-Box Best-First Proof
Search for Lean," CPP 2023.

### gcongr

Generalized congruence for inequalities. If `a <= b` and `f` is
monotone, proves `f a <= f b`.

```lean
example (h : a <= b) : a + c <= b + c := by gcongr
```

### abel

Solves equalities in abelian (commutative) groups.

```lean
-- In an additive commutative group:
example [AddCommGroup G] (a b c : G) :
    a + b + c = c + b + a := by abel
```

**Reference:** The abelian group tactic normalizes terms modulo
the equational theory of abelian groups (associativity, commutativity,
identity, inverse). This is a special case of Knuth-Bendix completion
for the abelian group axioms. Knuth and Bendix, "Simple Word Problems
in Universal Algebras," 1970.

### group

Solves equalities in (not necessarily commutative) groups.

### continuity / measurability / fun_prop

Domain-specific automation for topology and measure theory:
- `continuity` proves continuity of composed functions
- `measurability` proves measurability
- `fun_prop` proves general function properties

These work by recursive decomposition: the tactic knows that
compositions, sums, products of continuous functions are continuous,
etc.

## Exercises

1. Clone Mathlib and build it (with cache)
2. Find a simple `TODO` or missing lemma
3. Read 3 files in an area you are interested in
4. Write a new lemma and submit a PR
5. Respond to CI feedback and reviewer comments
