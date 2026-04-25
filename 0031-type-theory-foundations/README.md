# 0030 - Type Theory Foundations

## Goal

Understand the type theory underlying Lean 4: the Calculus of Inductive
Constructions (CIC). This is what makes you a Lean expert, not just a
user.

## Lean's Type Theory

Lean 4 implements a variant of the Calculus of Inductive Constructions
with:
- Dependent types (Pi types, Sigma types)
- Universe polymorphism
- Inductive types with recursors
- Quotient types
- Definitional proof irrelevance for Prop

## Universes

```
Prop : Type 0 : Type 1 : Type 2 : ...

-- Prop is impredicative: forall (P : Prop), P -> P : Prop
-- Type u is predicative: forall (A : Type u), A -> A : Type (u+1)
```

### Universe Polymorphism

```lean fromFile:Examples.lean#universe_polymorphism
-- Lean automatically infers universe levels
universe u v

def myId {alpha : Type u} (x : alpha) : alpha := x
-- Works at every universe level
```

### Impredicativity of Prop

```lean fromFile:Examples.lean#impredicativity_of_prop
-- This lives in Prop, not Type 1:
#check forall (P : Prop), P -> P  -- Prop

-- This lives in Type 1:
#check forall (A : Type), A -> A  -- Type 1
```

## Pi Types (Dependent Functions)

```lean fromFile:Examples.lean#pi_types
-- Non-dependent: A -> B is sugar for (x : A) -> B (where B ignores x)
-- Dependent: the return type depends on the argument

-- Example: a function that returns different types based on input
def boolToType : Bool -> Type
  | true => Nat
  | false => String

def dependentFn : (b : Bool) -> boolToType b
  | true => (42 : Nat)
  | false => "hello"
```

## Sigma Types (Dependent Pairs)

```lean fromFile:Examples.lean#sigma_types
-- Non-dependent: A x B
-- Dependent: { x : A // B x }

-- A number with a proof it is positive
def posPair : { n : Nat // n > 0 } := ⟨5, by omega⟩
```

## Inductive Types and Recursors

Every `inductive` generates a recursor:

```lean
-- For Nat:
-- Nat.rec : {motive : Nat -> Sort u} ->
--           motive 0 ->
--           ((n : Nat) -> motive n -> motive (n + 1)) ->
--           (n : Nat) -> motive n

-- This is the induction principle!
```

## Definitional vs Propositional Equality

```lean fromFile:Examples.lean#definitional_vs_propositional
-- Definitional equality: checked by the kernel, no proof needed
-- 2 + 2 and 4 are definitionally equal
example : 2 + 2 = 4 := rfl

-- Propositional equality: requires a proof
-- n + 0 and n are NOT definitionally equal (for variable n)
-- But they are propositionally equal:
example (n : Nat) : n + 0 = n := by simp
```

## Proof Irrelevance

In Prop, all proofs of the same proposition are considered equal:

```lean fromFile:Examples.lean#proof_irrelevance
-- If h1 h2 : P, then h1 = h2 (definitionally in Prop)
theorem proof_irrel (P : Prop) (h1 h2 : P) : h1 = h2 := rfl
```

This is crucial: it means proofs are erased at runtime without
changing program behavior.

## The Trusted Computing Base

Lean's trusted computing base is small:
1. The kernel (~10k lines of C++)
2. Three axioms: propext, Quot.sound, Classical.choice
3. The type theory rules (formation, introduction, elimination, computation)

Everything else (tactics, elaborator, compiler) could have bugs,
but they cannot introduce unsoundness because the kernel checks
everything.

## Axiom-Free Lean

You can avoid Classical.choice for constructive mathematics:

```lean fromFile:Examples.lean#axiom_free
-- A simple constructive theorem (uses no axioms)
theorem myTheorem : 1 + 1 = 2 := rfl

-- Check which axioms a theorem uses:
#print axioms myTheorem
-- If empty, the theorem is fully constructive
```

## Further Reading

- "Theorem Proving in Lean 4" (official tutorial)
- "The Type Theory of Lean" (forthcoming reference)
- "Type Theory and Formal Proof" by Nederpelt and Geuvers
- "Homotopy Type Theory" (HoTT book, for related foundations)
- Lean 4 source code: https://github.com/leanprover/lean4
