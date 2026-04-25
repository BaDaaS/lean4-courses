# 0025 - Contributing to CSLib

## Goal

Learn the workflow and conventions for contributing to CSLib, the
Computer Science Library for Lean 4.

## What is CSLib?

CSLib formalizes computer science foundations: labelled transition systems,
process algebras (CCS), automata theory, lambda calculus, modal logics,
and more.

- Website: https://www.cslib.io/
- GitHub: https://github.com/leanprover/cslib
- Whitepaper: https://arxiv.org/abs/2602.04846

## Setting Up

```bash
git clone https://github.com/leanprover/cslib
cd cslib
lake build
```

## CSLib Architecture

Key modules:
- `Cslib.Foundations.LTS` - Labelled Transition Systems
- `Cslib.Foundations.FLTS` - Functional LTS
- `Cslib.Foundations.Bisimulation` - Bisimulation theory
- `Cslib.Foundations.Automata` - DFA, NFA, omega-automata
- `Cslib.Foundations.ProcessAlgebra` - CCS, process equivalences
- `Cslib.Foundations.LambdaCalculus` - Lambda calculus
- `Cslib.Foundations.Logic` - Modal and temporal logics
- `Cslib.Foundations.InferenceSystem` - Inference rules

## CSLib Conventions

### File Template

Every file must:
1. Have a copyright header
2. Use `module` keyword
3. Use `public import` for all imports
4. Import `Cslib.Init` transitively
5. Use `@[expose] public section`
6. Have a module docstring with Main definitions/statements

### Namespace

All declarations must be under `Cslib.*`:

```lean fromFile:Examples.lean#cslib_namespace
namespace Cslib.Foundations.MyModule
-- definitions here
end Cslib.Foundations.MyModule
```

### Key Abstractions to Build On

- `LTS` / `FLTS` for transition systems
- `IsBisimulation` for equivalence relations
- `InferenceSystem` for structural operational semantics
- `Acceptor` / `omegaAcceptor` for automata
- `FreeM` for free monads

### Proof Style

- `grind` is the primary automation tactic
- Use `@[scoped grind =]` on definitions
- Use `@[scoped grind ->]` on directional lemmas
- `@[simp]` for simplification lemmas

## CI Validation

```bash
lake build --wfail --iofail
lake exe mk_all --module --check
lake test
lake lint
lake exe lint-style
```

## PR Conventions

Title format: `type(scope): description`
Types: `feat`, `fix`, `doc`, `style`, `refactor`, `test`, `chore`

## Exercises

1. Clone CSLib and build it
2. Read the LTS and Bisimulation modules
3. Understand how CCS is formalized
4. Add a missing lemma or theorem
5. Run the full CI validation before submitting
