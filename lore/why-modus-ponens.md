# Why Modus Ponens Is Just Function Application

In classical logic, **modus ponens** is the rule:

```
If P -> Q and P, then Q.
```

In Lean, this is literally function application:

```lean
example (hpq : P -> Q) (hp : P) : Q := hpq hp
```

`hpq` is a function from `P` to `Q`. `hp` is a value of type `P`.
Applying the function gives a value of type `Q`. That is modus ponens.

## Why This Works

The Curry-Howard correspondence identifies:

| Logic | Type Theory |
|-------|-------------|
| Proposition P | Type P |
| Proof of P | Term of type P |
| P implies Q | Function type P -> Q |
| Modus ponens | Function application |
| Conjunction P /\ Q | Product type P x Q |
| Disjunction P \/ Q | Sum type P + Q |
| Universal forall x, P(x) | Dependent function (x : A) -> P x |
| Existential exists x, P(x) | Dependent pair (x : A) x P x |
| True | Unit type (one element) |
| False | Empty type (no elements) |
| Negation Not P | Function P -> Empty |

Every logical rule corresponds to a type-theoretic operation.
Modus ponens is the simplest one: function application.

## The `apply` Tactic Is Backwards Modus Ponens

When you write:

```lean
apply hpq
```

with goal `Q` and `hpq : P -> Q`, you are saying: "I have a function
that produces `Q`, so the remaining problem is to provide its input
`P`." This is modus ponens run backward: instead of going from P to
Q, you go from the goal Q back to the subgoal P.

This backward reasoning is what makes tactics natural for interactive
proofs: you start from what you want and work backward to what you
have.

## References

- Haskell Curry, "Functionality in Combinatory Logic," Proceedings
  of the National Academy of Sciences, 1934.
- William Alvin Howard, "The formulae-as-types notion of
  construction," manuscript 1969, published in "To H.B. Curry:
  Essays on Combinatory Logic, Lambda Calculus, and Formalism,"
  Academic Press, 1980.
