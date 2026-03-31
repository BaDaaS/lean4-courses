# What the Kernel Checks

The kernel is the trusted core of Lean. It is intentionally small
(~10,000 lines of C++) so it can be audited. Everything else (the
elaborator, tactics, compiler) could have bugs, but they cannot
introduce unsoundness because the kernel re-checks everything.

## What the Kernel Receives

After elaboration and tactic execution, the kernel receives a
**fully elaborated declaration**: a name, a type, and a body (term).
No metavariables, no implicit argument holes, no tactic scripts. Just
a raw lambda term.

## What It Checks

The kernel performs **type checking** on the term. This involves:

### 1. Well-formedness of types

Every type must itself be well-typed. `Nat : Type`, `Type : Type 1`,
`Prop : Type`, etc. The kernel checks the universe hierarchy is
consistent (no `Type : Type`, which would be unsound per Girard's
paradox).

**Reference:** Jean-Yves Girard, "Interpretation fonctionnelle et
elimination des coupures de l'arithmetique d'ordre superieur," PhD
thesis, 1972 (Girard's paradox shows that `Type : Type` is
inconsistent).

### 2. Type correctness of terms

For every subterm, the kernel checks that the types match:

- `f x` : check that `f : A -> B` and `x : A`, then `f x : B`
- `fun (x : A) => body` : check that `body : B` assuming `x : A`,
  then `fun x => body : A -> B`
- `let x := v; body` : check `v : A`, then `body[x := v] : B`

### 3. Definitional equality

When comparing types, the kernel reduces terms to their normal form
and checks structural equality. Definitional equality includes:

- **Beta reduction**: `(fun x => body) arg` = `body[x := arg]`
- **Delta reduction**: unfolding a definition to its body
- **Iota reduction**: reducing a match/recursor application
- **Zeta reduction**: unfolding a let binding
- **Eta expansion**: `f` = `fun x => f x` (for functions)
- **Proof irrelevance**: if `P : Prop` and `a b : P`, then `a` = `b`

### 4. Universe consistency

The kernel checks that universe levels are consistent. `Sort u`
requires `u` to be well-formed. Universe polymorphic definitions
must work for all universe instantiations.

### 5. Termination of recursive definitions

For inductive types, the kernel checks that the recursor is used
correctly. Structural recursion must decrease on a well-founded
measure.

### 6. Positivity of inductive types

Inductive type definitions must satisfy the **strict positivity**
condition: the type being defined cannot appear in a negative
position (as an argument to a function) in its own constructors.
This prevents paradoxes like:

```lean
-- REJECTED: negative occurrence of Bad in its own constructor
-- inductive Bad where
--   | mk : (Bad -> False) -> Bad
```

**Reference:** Thierry Coquand and Christine Paulin, "Inductively
Defined Types," LNCS 417, 1990.

## What the Kernel Does NOT Check

- Whether the proof is elegant
- Whether the definition is efficient
- Whether the naming follows conventions
- Whether the code compiles to efficient C

These are concerns of the elaborator, linter, and compiler, which
are outside the trusted core.

## The Trusted Computing Base

Lean's trusted computing base is:

1. The kernel (~10k lines of C++)
2. Three axioms: `propext`, `Quot.sound`, `Classical.choice`
3. The type theory rules (CIC with inductives and quotients)

If the kernel has no bugs, and the axioms are consistent, then every
`theorem` accepted by Lean is correct.

## References

- Thierry Coquand and Gerard Huet, "The Calculus of Constructions,"
  Information and Computation, 1988.
  https://doi.org/10.1016/0890-5401(88)90005-3
- The Lean 4 kernel source code is at `src/kernel/` in the Lean 4
  repository: https://github.com/leanprover/lean4
- Leonardo de Moura and Sebastian Ullrich, "The Lean 4 Theorem
  Prover and Programming Language," CADE-28, 2021.
  https://doi.org/10.1007/978-3-030-79876-5_37
