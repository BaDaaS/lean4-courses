# What intro/exact/apply Actually Build

Every tactic is a step in constructing a lambda term. The proof state
is a partially-built term with holes (metavariables). Each tactic
fills in part of the term.

## The Full Correspondence

| Tactic | Term being built | Plain English |
|--------|-----------------|---------------|
| `intro x` | `fun x =>` | Take a function argument |
| `exact e` | `e` | Return a value (close the hole) |
| `apply f` | `f ?_` | Call a function, leave its argument as a new hole |
| `refine e` | `e` with explicit `?_` holes | Partial term with named blanks |
| `constructor` | `And.intro ?_ ?_` | Build a pair/struct |
| `left` | `Or.inl ?_` | Inject into left of sum |
| `right` | `Or.inr ?_` | Inject into right of sum |
| `exists w` | `Exists.intro w ?_` | Provide a witness |
| `cases h` | `match h with ...` | Pattern-match |
| `induction n` | `Nat.rec ?_ ?_ n` | Apply the recursor |
| `rfl` | `Eq.refl _` | Reflexivity (both sides are definitionally equal) |
| `rw [h]` | `Eq.mpr (congrArg ...) ...` | Transport along an equality |
| `have h := e` | `let h := e; ...` | Bind an intermediate result |
| `exfalso` | `False.elim ?_` | Change goal to False |
| `contradiction` | `absurd h1 h2` | Find contradictory hypotheses |
| `assumption` | (whatever matches) | Search context for a matching term |

## Worked Example

```lean
theorem trans : (P -> Q) -> (Q -> R) -> P -> R := by
  intro hpq hqr hp
  apply hqr
  apply hpq
  exact hp
```

Step by step:

```
Tactic          Term under construction              Remaining holes
------          -----------------------              ---------------
(start)         ?_                                   ?_ : (P->Q)->(Q->R)->P->R
intro hpq       fun hpq => ?a                        ?a : (Q->R)->P->R
intro hqr       fun hpq hqr => ?b                    ?b : P->R
intro hp        fun hpq hqr hp => ?c                  ?c : R
apply hqr       fun hpq hqr hp => hqr ?d              ?d : Q
apply hpq       fun hpq hqr hp => hqr (hpq ?e)        ?e : P
exact hp        fun hpq hqr hp => hqr (hpq hp)        (none)
```

Final term: `fun hpq hqr hp => hqr (hpq hp)`

You can verify with `#print trans`.

## Why This Matters

Understanding that tactics build terms means:
1. You can always switch between tactic mode and term mode
2. You can use `showTerm` to see what a tactic produces
3. You can debug failed proofs by asking "what term is being built?"
4. The kernel only sees the final term, never the tactics

## References

- The tactic-as-term-builder paradigm originates in Milner's LCF.
  See Gordon, Milner, Wadsworth, "Edinburgh LCF," Springer, 1979.
- Lean 4's implementation is described in de Moura and Ullrich,
  "The Lean 4 Theorem Prover and Programming Language," CADE 2021.
