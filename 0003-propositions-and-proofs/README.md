# 0003 - Propositions and Proofs

## Goal

Understand the Curry-Howard correspondence: propositions are types,
proofs are terms. Learn to construct proofs of basic logical
statements. See how Lean's proof terms correspond to natural
deduction derivations.

**Lore:**

- [The Curry-Howard correspondence](../lore/curry-howard.md) -
  The full history
- [Why modus ponens is function application](../lore/why-modus-ponens.md)
- [def vs theorem](../lore/def-vs-theorem.md) - Why proofs are erased

## Curry-Howard Correspondence

The central idea: **propositions are types, proofs are terms**. A
proposition P is a type; a proof of P is a term of that type. If
the type is inhabited (has at least one term), the proposition is
true. If the type is empty, the proposition is false.

This is not a metaphor. It is a precise, formal correspondence
between logical systems and type systems, discovered independently
by Haskell Curry (1934, for combinatory logic and Hilbert-style
deduction) and William Alvin Howard (1969, for natural deduction
and the simply typed lambda calculus).

| Logic | Type theory (Lean) | Natural deduction rule |
|-------|--------------------|----------------------|
| Proposition P | `P : Prop` | judgment |
| Proof of P | `h : P` | derivation |
| P implies Q | `P -> Q` | implication |
| P and Q | `P /\ Q` (`And P Q`) | conjunction |
| P or Q | `P \/ Q` (`Or P Q`) | disjunction |
| not P | `P -> False` | negation |
| True | `True` | tautology |
| False | `False` | absurdity |
| forall x, P x | `(x : A) -> P x` | universal quantification |
| exists x, P x | `Exists (fun x => P x)` | existential quantification |

### Why this works

The correspondence is structural. Each logical connective has
**introduction rules** (how to prove it) and **elimination rules**
(how to use a proof of it). These correspond exactly to data
constructors and pattern matching in type theory:

| Connective | Introduction (build proof) | Elimination (use proof) |
|------------|--------------------------|------------------------|
| `P -> Q`   | `fun (h : P) => ...` (assume P, derive Q) | `f h` (apply to proof of P) |
| `P /\ Q`   | `And.intro hp hq` (prove both) | `h.left`, `h.right` (extract one) |
| `P \/ Q`   | `Or.inl hp` or `Or.inr hq` (prove one) | `match h with \| inl => ... \| inr => ...` (case split) |
| `False`    | (none: no constructor) | `False.elim h` (anything follows) |
| `True`     | `trivial` | (nothing useful to extract) |
| `Exists`   | `Exists.intro w hw` (witness + proof) | `match h with \| intro w hw => ...` |

This table is exactly the natural deduction rules of Gentzen (1935),
translated into type theory.

## Natural Deduction

Gerhard Gentzen introduced natural deduction in 1935 as a formal
system that mirrors how mathematicians actually reason. Each
connective has introduction rules (for proving) and elimination
rules (for using). The Curry-Howard correspondence maps each rule
to a type-theoretic operation.

### Implication

**Introduction rule** (->I): assume P, derive Q; conclude P -> Q.

```
  [P]
   .
   .
   Q
-------  (->I)
P -> Q
```

In Lean: `fun (hp : P) => ...proof of Q using hp...`

**Elimination rule** (->E, modus ponens): from P -> Q and P,
conclude Q.

```
P -> Q    P
-----------  (->E)
     Q
```

In Lean: `hpq hp` (function application).

### Conjunction

**Introduction** (/\I): from proofs of P and Q, conclude P /\ Q.

```
  P    Q
---------  (/\I)
 P /\ Q
```

In Lean: `And.intro hp hq`

**Elimination** (/\E): from P /\ Q, conclude P (or Q).

```
P /\ Q        P /\ Q
------  (/\E1)  ------  (/\E2)
  P               Q
```

In Lean: `h.left` and `h.right`

### Disjunction

**Introduction** (\/I): from P, conclude P \/ Q.

```
  P               Q
------  (\/I1)  ------  (\/I2)
P \/ Q          P \/ Q
```

In Lean: `Or.inl hp` and `Or.inr hq`

**Elimination** (\/E): from P \/ Q, and proofs that both P and Q
lead to R, conclude R.

```
         [P]    [Q]
          .      .
          .      .
P \/ Q    R      R
------------------  (\/E)
        R
```

In Lean: `match h with | Or.inl hp => ... | Or.inr hq => ...`

### Negation and absurdity

`Not P` is defined as `P -> False`. This is the standard encoding
in constructive logic. A proof of `Not P` is a function that takes
any proof of P and derives a contradiction.

**Ex falso quodlibet** (from falsehood, anything follows):

```
False
-----  (False-E)
  P
```

In Lean: `False.elim h` or `absurd hp hnp`

`False` has no introduction rule (no constructor). It is the empty
type. You can never prove `False` unless the context is already
contradictory.

## Implication = Function

A proof of `P -> Q` is a function that takes a proof of P and
returns a proof of Q:

```lean
theorem modus_ponens (hpq : P -> Q) (hp : P) : Q :=
  hpq hp
```

This is exactly the ->E rule above: applying `hpq : P -> Q` to
`hp : P` gives a term of type `Q`. Modus ponens *is* function
application.

## Conjunction (And)

```lean
-- Constructing And (/\I rule)
theorem and_intro (hp : P) (hq : Q) : P /\ Q :=
  And.intro hp hq

-- Destructing And (/\E rules)
theorem and_left (h : P /\ Q) : P :=
  h.left    -- or And.left h or h.1
```

Under the hood, `And` is an inductive type (a structure) with one
constructor taking two fields:

```lean
structure And (a b : Prop) : Prop where
  intro ::
  left : a
  right : b
```

So `P /\ Q` is a **product type** (a pair of proofs). This is the
type-theoretic content: conjunction is the product.

## Disjunction (Or)

```lean
-- Constructing Or (\/I rule)
theorem or_left (hp : P) : P \/ Q :=
  Or.inl hp

-- Destructing Or (\/E rule, case analysis)
theorem or_comm (h : P \/ Q) : Q \/ P :=
  match h with
  | Or.inl hp => Or.inr hp
  | Or.inr hq => Or.inl hq
```

`Or` is an inductive type with two constructors:

```lean
inductive Or (a b : Prop) : Prop where
  | inl (h : a) : Or a b
  | inr (h : b) : Or a b
```

So `P \/ Q` is a **sum type** (a tagged union). Either you have a
proof of P (tagged `inl`) or a proof of Q (tagged `inr`). The names
`inl`/`inr` come from category theory: the **left and right
injections** of a coproduct. See the
[lore entry on inl/inr](../lore/why-inl-inr.md).

## Negation

`Not P` is defined as `P -> False`:

```lean
theorem not_false_proof : Not False :=
  fun h => h    -- False implies anything

theorem absurd_example (hp : P) (hnp : Not P) : Q :=
  absurd hp hnp
```

`absurd` first derives `False` from `hp` and `hnp` (by applying
`hnp : P -> False` to `hp : P`), then uses `False.elim` to produce
a term of any type `Q`. This is a two-step composition:
`False.elim (hnp hp)`.

## Existential Quantifier

```lean
theorem exists_example : Exists (fun n : Nat => n > 0) :=
  Exists.intro 1 (Nat.lt.base 0)
  -- witness: 1, proof: 0 < 1
```

`Exists` is a dependent pair (Sigma type in `Prop`):

```lean
inductive Exists {alpha : Sort u}
    (p : alpha -> Prop) : Prop where
  | intro (w : alpha) (h : p w) : Exists p
```

A proof of `exists x, P x` consists of:

1. A **witness** `w : alpha` (the specific value)
2. A **proof** `h : P w` (the property holds for that value)

This is the constructive interpretation: you cannot prove existence
without exhibiting a concrete example. In classical logic (with
`Classical.choice`), you can prove existence without a witness using
proof by contradiction, but the proof is then `noncomputable`.

## Universal Quantifier

The universal quantifier `forall x : A, P x` is the dependent
function type `(x : A) -> P x`. A proof is a function that takes
any `x` and returns a proof of `P x`:

```lean
theorem all_nat_pos :
    forall n : Nat, 0 <= n :=
  fun n => Nat.zero_le n
```

This is the introduction rule for `forall`: to prove `forall x, P x`,
assume an arbitrary `x` and prove `P x`. The elimination rule is
**instantiation**: from `forall x, P x` and a specific `a`, derive
`P a`. This is just function application: `h a` where
`h : forall x, P x`.

## Constructive vs. Classical Logic

Lean's `Prop` universe, without axioms, implements **constructive**
(intuitionistic) logic. The key difference from classical logic:

**The law of excluded middle** (`P \/ Not P`) is **not provable**
constructively. In constructive logic, to prove `P \/ Not P`, you
must either prove `P` or prove `Not P`. For some propositions
(e.g., "this Turing machine halts"), neither may be provable.

Lean provides `Classical.em : forall (P : Prop), P \/ Not P` via
the `Classical.choice` axiom. Using it makes your proof classical
(non-constructive). Lean tracks this: `#print axioms my_theorem`
shows whether `Classical.choice` was used.

Other classical principles that are equivalent to excluded middle:

| Principle | Statement | Lean |
|-----------|-----------|------|
| Excluded middle | `P \/ Not P` | `Classical.em P` |
| Double negation elimination | `Not Not P -> P` | `Classical.byContradiction` |
| Peirce's law | `((P -> Q) -> P) -> P` | Provable from em |
| De Morgan (strong form) | `Not (P /\ Q) -> Not P \/ Not Q` | Requires em |

In constructive logic, double negation introduction (`P -> Not Not P`)
is provable, but elimination (`Not Not P -> P`) is not. The
asymmetry is fundamental: you can always derive a contradiction from
assuming `Not P` and then proving `P`, but you cannot always extract
a proof of `P` from knowing that `Not P` leads to absurdity.

**Practical implication:** Proofs using `Classical.em` are marked
`noncomputable` because there is no algorithm that decides arbitrary
propositions. Constructive proofs, by contrast, always have
computational content: a proof of `P \/ Q` tells you which
disjunct holds, and a proof of `exists x, P x` contains the
witness.

**Reference:** Heyting, A. (1930). "Die formalen Regeln der
intuitionistischen Logik." Sitzungsberichte der Preussischen
Akademie der Wissenschaften. This paper gives the first formal
axiomatization of intuitionistic logic.

## Why `theorem` vs `def`?

Since proofs are just terms, you could write:

```lean fromFile:Examples.lean#theorem_vs_def
def my_proof : 1 + 1 = 2 := rfl
```

This works. But `theorem` is better for proofs because:

1. **Proof erasure.** The body of a `theorem` is erased at compile
   time. The compiled program never needs to inspect proofs at
   runtime. This is safe because of **proof irrelevance**: all
   proofs of the same `Prop` are definitionally equal (see course
   0031).

2. **Opacity.** The kernel does not unfold theorem bodies when
   type-checking later definitions. This is a performance
   optimization: proofs can be very large, and unfolding them would
   slow down the kernel.

3. **Intent.** `theorem` signals "this is a logical statement."
   `def` signals "this is a computation." The distinction helps
   readers.

An `example` is an anonymous theorem/def that is checked and
discarded. Useful for quick tests.

See the full classification of `def`/`theorem`/`example`/`abbrev`/
`opaque`/`axiom` in course 0000.

### Proof irrelevance, formally

In Lean's `Prop` universe, if `h1 : P` and `h2 : P`, then
`h1 = h2` definitionally. The kernel treats all proofs of the same
proposition as identical. This is why proof erasure is safe: if all
proofs are equal, no computation can depend on which proof was used.

This is a design choice. Martin-Lof's intensional type theory does
**not** have proof irrelevance: different proofs of the same
proposition can be distinguished. Lean follows the Coq tradition of
separating `Prop` (proof-irrelevant, impredicative) from `Type`
(proof-relevant, predicative). The separation is enforced by the
**singleton elimination** restriction: you cannot pattern-match on
a `Prop` to produce a `Type`, unless the `Prop` has at most one
constructor with `Prop`-typed fields.

**Reference:** The Curry-Howard correspondence was independently
discovered by Haskell Curry (1934, for combinatory logic) and
William Alvin Howard (1969, for natural deduction). Howard's
original manuscript, "The formulae-as-types notion of construction,"
circulated as a manuscript from 1969 and was published in 1980.

**Reference:** Gentzen, G. (1935). "Untersuchungen uber das
logische Schliessen." Mathematische Zeitschrift. This paper
introduced natural deduction and the sequent calculus, the logical
systems that the Curry-Howard correspondence maps to type theory.

## Math Track

This is the foundation of formal mathematics. Every theorem in
Mathlib is a term whose type is the statement of the theorem. When
you "prove" something, you are constructing a term of the right
type.

The natural deduction rules above are the same rules taught in a
first course on mathematical logic, but here they are executable.
When a mathematician writes "assume P, then by hypothesis Q, then
by cases on P \/ Q...", they are implicitly constructing a lambda
term. Lean makes this explicit.

A subtle point: in paper mathematics, proofs are often classical
(using contradiction, excluded middle) without comment. In Lean,
every use of classical reasoning is tracked. This does not mean
classical proofs are wrong; it means Lean gives you information
about the logical strength of each result.

## CS Track

The Curry-Howard correspondence means programs ARE proofs. A
function `P -> Q` is simultaneously a program transforming P-values
into Q-values AND a proof that P implies Q. This duality is what
makes Lean powerful for verified programming.

The correspondence extends further than the basic connectives:

| Programming concept | Logical concept |
|---------------------|-----------------|
| Type | Proposition |
| Program | Proof |
| Function `A -> B` | Implication `A -> B` |
| Pair `(a, b) : A x B` | Conjunction proof |
| Tagged union `inl a : A + B` | Disjunction proof |
| Empty type (no values) | False (no proof) |
| Unit type (one value) | True (trivial proof) |
| Exception / abort | Ex falso (from False, anything) |
| Continuation passing | Double negation `(A -> R) -> R` |
| Type-level function | Dependent type / universal quantification |
| Generic / parametric polymorphism | Quantification over types |

The last row hints at System F (course 0005). The continuation row
is particularly interesting: in CPS (continuation-passing style),
a value of type `A` is represented as `(A -> R) -> R` for any `R`.
Under Curry-Howard, this is double negation `Not Not A`. The fact
that CPS transformation is always possible corresponds to the fact
that `A -> Not Not A` is constructively provable. The reverse
(extracting `A` from `(A -> R) -> R`) corresponds to double
negation elimination, which is classical.
