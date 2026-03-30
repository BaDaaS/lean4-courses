# 0003 - Propositions and Proofs

## Goal

Understand the Curry-Howard correspondence: propositions are types, proofs
are terms. Learn to construct proofs of basic logical statements.

## Curry-Howard Correspondence

| Logic | Lean (Types) |
|-------|-------------|
| Proposition P | `P : Prop` |
| Proof of P | `h : P` (a term of type P) |
| P and Q | `P /\ Q` (And) |
| P or Q | `P \/ Q` (Or) |
| P implies Q | `P -> Q` (function) |
| not P | `P -> False` |
| for all x, P x | `(x : A) -> P x` |
| exists x, P x | `Exists (fun x => P x)` |
| True | `True` (has proof `trivial`) |
| False | `False` (no proof exists) |

## Implication = Function

A proof of `P -> Q` is a function that takes a proof of P and returns
a proof of Q:

```lean
theorem modus_ponens (hpq : P -> Q) (hp : P) : Q :=
  hpq hp
```

## Conjunction (And)

```lean
-- Constructing And
theorem and_intro (hp : P) (hq : Q) : P /\ Q :=
  And.intro hp hq

-- Destructing And
theorem and_left (h : P /\ Q) : P :=
  h.left    -- or And.left h or h.1
```

## Disjunction (Or)

```lean
-- Constructing Or
theorem or_left (hp : P) : P \/ Q :=
  Or.inl hp

-- Destructing Or (case analysis)
theorem or_comm (h : P \/ Q) : Q \/ P :=
  match h with
  | Or.inl hp => Or.inr hp
  | Or.inr hq => Or.inl hq
```

## Negation

`Not P` is defined as `P -> False`:

```lean
theorem not_false_proof : Not False :=
  fun h => h    -- False implies anything

theorem absurd_example (hp : P) (hnp : Not P) : Q :=
  absurd hp hnp
```

## Existential Quantifier

```lean
theorem exists_example : Exists (fun n : Nat => n > 0) :=
  Exists.intro 1 (Nat.lt.base 0)
  -- witness: 1, proof: 0 < 1
```

## Math Track

This is the foundation of formal mathematics. Every theorem in Mathlib
is a term whose type is the statement of the theorem. When you "prove"
something, you are constructing a term of the right type.

## CS Track

The Curry-Howard correspondence means programs ARE proofs. A function
`P -> Q` is simultaneously a program transforming P-values into Q-values
AND a proof that P implies Q. This duality is what makes Lean powerful
for verified programming.
