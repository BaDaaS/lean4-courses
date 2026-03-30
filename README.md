# Lean 4 Crash Course

A hands-on crash course in Lean 4 for mathematicians and computer
scientists. The goal is to go from zero to contributing to Mathlib,
CSLib, and ArkLib.

## How to Use

Each directory `NNNN-topic/` contains:

- `README.md` - Lecture notes with explanations
- `Exercises.lean` - Exercises (replace `sorry` with proofs/definitions)
- `Solutions.lean` - Reference solutions

Courses are sequential. Complete them in order.

## Prerequisites

- Install Lean 4 via elan: https://lean-lang.org/lean4/doc/setup.html
- Basic familiarity with a programming language (for CS track)
- Basic familiarity with mathematical proofs (for math track)

## Course Outline

### Part I: Foundations (0000-0009)

| #    | Topic                    | Math Focus                  | CS Focus                         |
| ---- | ------------------------ | --------------------------- | -------------------------------- |
| 0000 | Startup                  | Lean as a proof assistant   | Lean as a programming language   |
| 0001 | Types                    | Types as mathematical sets  | Types as data specifications     |
| 0002 | Functions                | Functions as maps           | Functions as computations        |
| 0003 | Propositions and Proofs  | Curry-Howard, logic in Lean | Props as types                   |
| 0004 | Tactics                  | Interactive proofs          | Tactic DSL, proof automation     |
| 0005 | Inductive Types          | Constructing N, Z, trees    | ADTs, enums, recursive types     |
| 0006 | Structures/Typeclasses   | Algebraic structures        | Interfaces and polymorphism      |
| 0007 | Monads and Do Notation   | Kleisli composition         | IO, Option, error handling       |
| 0008 | Pattern Matching/Recurse | Structural induction        | Exhaustive matching, termination |
| 0009 | Dependent Types          | Pi and Sigma types          | Indexed families, Vec n          |

### Part II: Core Mathematics and CS (0010-0017)

| #    | Topic                   | Math Focus              | CS Focus                    |
| ---- | ----------------------- | ----------------------- | --------------------------- |
| 0010 | Nat and Induction       | Peano axioms, induction | Recursive algorithms on Nat |
| 0011 | Lists/Data Structures   | Sequences, finite sets  | Functional data structures  |
| 0012 | Finite Types/Decidable  | Decidable predicates    | Bool vs Prop, Fin n         |
| 0013 | Algebraic Structures    | Groups, rings, fields   | Abstract interfaces         |
| 0014 | Basic Number Theory     | Divisibility, primes    | Verified algorithms         |
| 0015 | Automation and Simp     | Simplification          | simp, omega, ring, norm_num |
| 0016 | Metaprogramming Intro   | Custom tactics          | Lean 4 macro system         |
| 0017 | Projects                | Formalise a theorem     | Build a verified program    |

### Part III: Systems Programming (0018-0023)

| #    | Topic                  | Focus                                 |
| ---- | ---------------------- | ------------------------------------- |
| 0018 | IO and System Prog     | File IO, processes, environment       |
| 0019 | Compiled Programs      | Lake projects, multi-file, executables|
| 0020 | FFI and C Interop      | Calling C from Lean, opaque types     |
| 0021 | Concurrency and Tasks  | Tasks, Mutex, IO.Ref, channels        |
| 0022 | File IO and CLI        | Building real CLI tools               |
| 0023 | Performance/Compile    | Tail recursion, Array, @[inline], FFI |

### Part IV: Contributing to Libraries (0024-0026)

| #    | Topic                   | Focus                               |
| ---- | ----------------------- | ----------------------------------- |
| 0024 | Contributing to Mathlib | Conventions, PR workflow, linting   |
| 0025 | Contributing to CSLib   | LTS, bisimulation, process algebra  |
| 0026 | Contributing to ArkLib  | Cryptographic formalization         |

### Part V: Deep Lean Expertise (0027-0030)

| #    | Topic                     | Focus                              |
| ---- | ------------------------- | ---------------------------------- |
| 0027 | Lean Internals            | Kernel, elaborator, compiler, IR   |
| 0028 | Elaboration/Unification   | MetaM, type inference, debugging   |
| 0029 | Advanced Metaprogramming  | Custom tactics, elaborators, DSLs  |
| 0030 | Type Theory Foundations   | CIC, universes, proof irrelevance  |

## Building

```bash
lake build
```

## Running Exercises

```bash
lake env lean 0000-startup/Exercises.lean
```
