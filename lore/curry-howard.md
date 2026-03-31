# The Curry-Howard Correspondence

The discovery that proofs and programs are the same thing.

## The Idea

| Logic | Programming |
|-------|-------------|
| Proposition | Type |
| Proof of P | Term of type P |
| P implies Q | Function type P -> Q |
| Modus ponens | Function application |
| P and Q | Pair type (P, Q) |
| P or Q | Sum type P + Q |
| True | Unit type |
| False | Empty type |
| Not P | P -> Empty |
| For all x, P(x) | Dependent function (x : A) -> P x |
| Exists x, P(x) | Dependent pair (x : A, P x) |

A proposition is true if and only if its corresponding type is
inhabited (has at least one term).

## The History

The correspondence was discovered independently by two people:

### Haskell Curry (1934)

Curry noticed that the types of combinators in combinatory logic
correspond to axiom schemas of propositional logic. For example,
the K combinator `K : A -> B -> A` corresponds to the axiom schema
"P implies (Q implies P)."

At the time, this was seen as a curiosity.

### William Alvin Howard (1969)

Howard extended Curry's observation to natural deduction (not just
combinatory logic). He showed that:

- The **introduction rules** of natural deduction correspond to
  **constructor forms** in lambda calculus
- The **elimination rules** correspond to **destructor forms**
- **Proof normalization** (cutting redundant steps from a proof)
  corresponds to **beta reduction** (evaluating a program)

Howard's manuscript circulated privately from 1969 and was published
in 1980. It was immediately recognized as fundamental.

### The Modern View

Today, the Curry-Howard correspondence is understood as a deep
structural identity between logic and computation. Every new type
system gives a new logic, and every new logic gives a new type
system. Lean 4 is built entirely on this principle.

## Why It Matters for Lean

In Lean, there is no separate "proof language" and "programming
language." Proofs ARE programs. When you write:

```lean
theorem trans (hpq : P -> Q) (hqr : Q -> R) (hp : P) : R :=
  hqr (hpq hp)
```

You are simultaneously:
- Proving that `(P -> Q) -> (Q -> R) -> P -> R` (transitivity of
  implication)
- Writing a function that composes two functions

The kernel does not distinguish between the two. It just checks that
the term has the right type.

## The Three Legs

The correspondence has been extended far beyond propositional logic:

| Logic | Type Theory | Category Theory |
|-------|-------------|-----------------|
| Proposition | Type | Object |
| Proof | Term | Morphism |
| Implication | Function type | Exponential |
| Conjunction | Product type | Product |
| Disjunction | Sum type | Coproduct |
| True | Terminal | Terminal object |
| False | Initial | Initial object |

This three-way correspondence (logic, types, categories) is sometimes
called the **Curry-Howard-Lambek correspondence**, after Joachim
Lambek who identified the categorical leg in 1968-1972.

## References

- Haskell Curry, "Functionality in Combinatory Logic," Proceedings
  of the National Academy of Sciences, 1934.
  https://doi.org/10.1073/pnas.20.11.584
- William Alvin Howard, "The formulae-as-types notion of
  construction," manuscript 1969, published in "To H.B. Curry:
  Essays on Combinatory Logic, Lambda Calculus, and Formalism,"
  Academic Press, 1980.
- Joachim Lambek, "Deductive Systems and Categories I, II, III,"
  Mathematical Structures in Computer Science, 1968-1972.
- Philip Wadler, "Propositions as Types," Communications of the ACM,
  2015. https://doi.org/10.1145/2699407 (excellent accessible
  overview).
- The Lean 4 implementation is described in de Moura and Ullrich,
  "The Lean 4 Theorem Prover and Programming Language," CADE 2021.
