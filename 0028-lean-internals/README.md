# 0027 - Lean Internals

## Goal

Understand how Lean 4 works under the hood: the kernel, the elaborator,
the compiler, and the runtime. This is essential for becoming a Lean
expert rather than just a user.

## Lean 4 Architecture

```
Source code
  |
  v
Parser (syntax objects)
  |
  v
Elaborator (Expr, type checking, tactic execution)
  |
  v
Kernel (trusted core, minimal)
  |
  v
Compiler (IR, optimization, C code generation)
  |
  v
Runtime (reference counting, memory management)
```

## The Kernel

The kernel is the trusted core. It only accepts fully elaborated terms
and verifies them. It is intentionally small (~10k lines) so it can be
audited.

The kernel checks:
- Type correctness of definitions
- Termination of recursive definitions
- Universe consistency
- No axiom cycles

### Kernel Axioms

Lean's kernel has very few axioms:

```lean
#print axioms Classical.choice
-- Classical.choice, propext, Quot.sound
```

- `propext`: propositional extensionality (P <-> Q implies P = Q)
- `Quot.sound`: quotient soundness
- `Classical.choice`: choice principle (non-constructive)

## The Elaborator

The elaborator transforms user-facing syntax into kernel terms.
It handles:
- Type inference (filling in implicit arguments)
- Typeclass resolution
- Tactic execution
- Macro expansion
- Auto-bound implicit variables
- Coercion insertion

### Elaboration Order

```lean
-- Lean elaborates left to right, but can defer:
-- 1. Parse into Syntax
-- 2. Elaborate term, inserting metavariables for unknowns
-- 3. Unify metavariables with constraints
-- 4. Execute tactics (which create more terms)
-- 5. Check all metavariables are resolved
```

## The Expression Type

Lean's internal representation of terms:

```
Expr =
  | bvar (index : Nat)           -- bound variable (de Bruijn)
  | fvar (id : FVarId)           -- free variable
  | mvar (id : MVarId)           -- metavariable (hole)
  | sort (level : Level)         -- Sort u, Type u, Prop
  | const (name : Name) (levels) -- defined constant
  | app (fn arg : Expr)          -- function application
  | lam (name type body : Expr)  -- lambda abstraction
  | forallE (name type body)     -- Pi type (forall)
  | letE (name type val body)    -- let binding
  | lit (val : Literal)          -- numeric/string literal
  | mdata (data : MData) (expr)  -- metadata
  | proj (name idx expr)         -- structure projection
```

## De Bruijn Indices

Lean uses de Bruijn indices for bound variables:

```lean
-- fun x => fun y => x + y
-- Internally: lam (lam (bvar 1 + bvar 0))
-- bvar 0 = innermost binder (y)
-- bvar 1 = next outer binder (x)
```

## The Compiler

Lean's compiler pipeline:
1. Lambda lifting (closure conversion)
2. Simplification
3. Erasure (remove proof terms, types)
4. Boxing/unboxing optimization
5. Reference counting insertion
6. C code generation

### What Gets Erased

In compiled code, proofs and types are erased. Only computationally
relevant terms remain:

```lean
-- The proof h is erased at runtime
def safeDiv (a b : Nat) (h : b > 0) : Nat := a / b
-- Compiles to just: a / b
```

## Environment and Declarations

```lean
-- Every definition in Lean creates a Declaration:
-- - axiom: no body, trusted
-- - definition: has a body (value)
-- - theorem: has a body (proof), erased at runtime
-- - opaque: has a body but kernel does not unfold it
-- - inductive: generates constructors and recursors
```

## Reading Lean Source Code

The Lean 4 repository itself is written in Lean:
- `src/Lean/` - the compiler and standard library
- `src/Lean/Elab/` - elaboration
- `src/Lean/Meta/` - metaprogramming framework
- `src/Lean/Compiler/` - compiler passes
- `src/kernel/` - the kernel (C++)

Understanding these directories is key to deep Lean expertise.
