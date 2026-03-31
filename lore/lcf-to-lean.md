# From LCF to Lean: The Family Tree of Proof Assistants

## The Timeline

### 1966-1967: Automath (de Bruijn, Eindhoven)

Nicolaas Govert de Bruijn created Automath, the first system for
writing complete mathematical proofs in a formal language. He
introduced **de Bruijn indices** (the internal variable representation
Lean still uses today) and the **de Bruijn criterion**: a proof
checker should be so simple that its correctness is obvious.

Lean's kernel follows the de Bruijn criterion: ~10k lines of C++,
small enough to audit.

### 1972-1979: LCF (Milner, Stanford/Edinburgh)

Robin Milner created LCF (Logic for Computable Functions) with two
revolutionary ideas:

1. **The tactic mechanism**: interactive proof construction via
   goal-directed search (see `lore/why-tactic.md`)
2. **The ML metalanguage**: Milner invented ML (Meta Language)
   specifically to write tactics for LCF. ML later became a major
   programming language family (OCaml, SML, F#).

LCF's architecture (small trusted kernel + untrusted tactics) is
still the design of every major proof assistant today.

### 1985-1988: The Calculus of Constructions (Coquand/Huet, INRIA)

Thierry Coquand and Gerard Huet developed the Calculus of
Constructions (CoC), a type theory that unifies simple types,
polymorphism, and dependent types. This became the theoretical
foundation for Coq and eventually for Lean.

Coquand and Christine Paulin later added inductive types, creating
the **Calculus of Inductive Constructions (CIC)**, which is what Lean
4's kernel implements (with minor variations).

### 1989: Coq (Huet/Coquand/Paulin, INRIA)

Named after Thierry Coquand (and the French word for rooster), Coq
implemented CIC with:
- Dependent types
- Universe polymorphism
- Inductive types with recursors
- Tactic-based proofs (inherited from LCF)

Coq proved that large-scale formalization was feasible. Landmark
results include the Four Color Theorem (Gonthier, 2005) and
CompCert, a verified C compiler (Leroy, 2006).

### 1986: Isabelle (Paulson, Cambridge)

Larry Paulson created Isabelle as a "generic" proof assistant that
could support multiple logics. Isabelle/HOL (with higher-order logic)
became the dominant variant. Its `sledgehammer` tool, which calls
external SMT solvers, pioneered proof automation.

### 2013: Lean 1-3 (de Moura, Microsoft Research)

Leonardo de Moura started Lean at Microsoft Research. Lean 1-3 were
based on CIC (like Coq) with some innovations in elaboration and
automation. The Mathlib library was started by the Lean community
during this period.

### 2021: Lean 4 (de Moura/Ullrich, Microsoft Research)

A complete rewrite. Lean 4 is:
- **Self-hosting**: the compiler is written in Lean itself
- **A programming language**: compiles to C, suitable for real
  software
- **Extensible**: tactics, elaborators, and syntax extensions are
  written in Lean via metaprogramming monads (`MetaM`, `TacticM`)

Key innovation: in all previous systems, the metalanguage (for
writing tactics) was separate from the object language (for writing
proofs). In Lean 4, they are the same language. You write proofs,
programs, and tactics all in Lean.

## The Family Tree

```
Automath (de Bruijn, 1967, Eindhoven)
  |
  |   LCF (Milner, 1972, Stanford/Edinburgh)
  |     |
  |     +-> HOL (Gordon, 1988, Cambridge)
  |     |     |
  |     |     +-> HOL Light (Harrison, 1996)
  |     |     +-> HOL4
  |     |
  |     +-> Isabelle (Paulson, 1986, Cambridge)
  |     |     |
  |     |     +-> Isabelle/HOL
  |     |
  |     +-> ML (Milner, 1973)
  |           |
  |           +-> SML, OCaml, F#
  |
  CoC (Coquand/Huet, 1985, INRIA)
    |
    +-> CIC (Coquand/Paulin, 1988)
    |     |
    |     +-> Coq (1989, INRIA)
    |     |     |
    |     |     +-> Rocq (2024, renamed)
    |     |
    |     +-> Lean 1-3 (de Moura, 2013, MSR)
    |           |
    |           +-> Lean 4 (de Moura/Ullrich, 2021)
    |                 |
    |                 +-> Mathlib4
    |                 +-> CSLib
    |                 +-> ArkLib
    |
    +-> Agda (Norell, 2007, Chalmers)
    |
    +-> Idris (Brady, 2013, St Andrews)
```

## References

- Nicolaas de Bruijn, "The Mathematical Language AUTOMATH,"
  Symposium on Automatic Demonstration, Springer LNCS 125, 1970.
- Michael Gordon, Robin Milner, Christopher Wadsworth, "Edinburgh
  LCF," Springer LNCS 78, 1979.
- Thierry Coquand and Gerard Huet, "The Calculus of Constructions,"
  Information and Computation, 1988.
  https://doi.org/10.1016/0890-5401(88)90005-3
- Thierry Coquand and Christine Paulin, "Inductively Defined Types,"
  LNCS 417, 1990.
- Leonardo de Moura and Sebastian Ullrich, "The Lean 4 Theorem
  Prover and Programming Language," CADE-28, 2021.
  https://doi.org/10.1007/978-3-030-79876-5_37
- For the full history, see: Herman Geuvers, "Proof Assistants:
  History, Ideas and Future," Sadhana, 2009.
  https://doi.org/10.1007/s12046-009-0001-5
