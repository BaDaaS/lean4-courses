# 0026 - Contributing to ArkLib

## Goal

Learn the workflow and conventions for contributing to ArkLib, the
cryptographic formalization library for Lean 4.

## What is ArkLib?

ArkLib formalizes cryptographic primitives, protocols, and proof systems
in Lean 4, building on Mathlib for the underlying mathematics.

## Key Mathematical Foundations

ArkLib relies heavily on:

### From Mathlib
- **Finite fields**: `GaloisField`, `ZMod`, `FiniteField`
- **Polynomials**: `Polynomial`, `MvPolynomial`
- **Linear algebra**: `Matrix`, `LinearMap`, `Module`
- **Number theory**: `Nat.Prime`, Legendre symbols, Gauss sums
- **Group theory**: `Group`, cyclic groups, group homomorphisms

### Cryptographic Concepts to Formalize
- Hash functions (collision resistance, preimage resistance)
- Commitment schemes (binding, hiding)
- Interactive proof systems (completeness, soundness)
- Polynomial commitment schemes
- SNARKs and STARKs (proof systems)
- Elliptic curve operations

## Workflow for Cryptographic Formalization

### 1. Read the Paper

Identify the mathematical objects, definitions, theorems, and proofs
in the cryptographic paper you want to formalize.

### 2. Map to Mathlib

Search Mathlib for existing formalization of the math:

```bash
MATHLIB=".lake/packages/mathlib"
grep -r "^def GaloisField" $MATHLIB/Mathlib/
grep -r "^structure Polynomial" $MATHLIB/Mathlib/
grep -r "^class Field" $MATHLIB/Mathlib/
```

### 3. Define Cryptographic Abstractions

```lean fromFile:Examples.lean#commitment_scheme
-- Example: commitment scheme
structure CommitmentScheme where
  Message : Type
  Commitment : Type
  Opening : Type
  commit : Message -> Opening -> Commitment
  verify : Message -> Opening -> Commitment -> Prop
```

### 4. State Security Properties

```lean fromFile:Examples.lean#is_binding
-- Binding: cannot open to two different messages
def isBinding (cs : CommitmentScheme) : Prop :=
  forall m1 m2 o1 o2 c,
    cs.verify m1 o1 c -> cs.verify m2 o2 c -> m1 = m2
```

### 5. Prove Properties

Use Mathlib lemmas about finite fields, polynomials, etc. to
establish the security properties.

## Example: Schwartz-Zippel Lemma

A key tool for polynomial-based cryptography:

```
If p is a non-zero polynomial of degree d over a finite field F,
and S is a finite subset of F, then
  Pr[p(r) = 0 : r <- S] <= d / |S|
```

This is formalized in Mathlib as part of `MvPolynomial`.

## Exercises

1. Search Mathlib for finite field definitions
2. Formalize a simple hash function abstraction
3. Define a commitment scheme and state binding/hiding
4. Formalize the Schwartz-Zippel statement (not proof)
5. Build on existing polynomial formalization to add a new lemma
6. Study an existing ArkLib PR to understand the contribution pattern
