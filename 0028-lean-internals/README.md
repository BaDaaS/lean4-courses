# 0027 - Lean Internals

## Goal

Understand how Lean 4 works under the hood: the kernel, the elaborator,
the compiler, and the runtime. This is essential for becoming a Lean
expert rather than just a user.

**Lore:**
- [What the kernel checks](../lore/what-the-kernel-checks.md) - The trusted core
- [def vs theorem](../lore/def-vs-theorem.md) - Declaration kinds in the kernel
- [From LCF to Lean](../lore/lcf-to-lean.md) - Historical lineage

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

Every top-level declaration in Lean adds an entry to the
**environment**, a persistent map from `Name` to `Declaration`.
The `Declaration` type in the kernel has these variants:

### Declaration Kinds in the Kernel

| Kind | Body? | Compiled? | Reducible? | Erased? |
|------|-------|-----------|------------|---------|
| `axiomDecl` | no | no | n/a | yes |
| `defnDecl` | yes | yes | configurable | no |
| `thmDecl` | yes | no | no (opaque) | yes |
| `opaqueDecl` | yes | depends | never | no |
| `inductDecl` | (generates recursor) | yes | yes | no |

### What Each Declaration Keyword Produces

**`def`** creates a `defnDecl`. The body is stored and the kernel
can unfold it during type-checking. The compiler generates executable
code. The definition has a **reducibility hint** that controls when
the elaborator unfolds it:

- `@[reducible]` (or `abbrev`): always unfold
- default: unfold when needed for type-checking
- `@[irreducible]`: never unfold (treat as opaque for elaboration,
  but the kernel can still see through it)

**`theorem` / `lemma`** creates a `thmDecl`. The body (proof) is
stored for verification, then **erased** before compilation. The
kernel marks it opaque: later definitions cannot unfold the proof.
This is safe because of **proof irrelevance** in `Prop`: if `p q :
P` where `P : Prop`, then `p = q` definitionally.

Why opaque? Performance. Proof terms can be enormous (thousands of
nodes). If the kernel had to unfold proofs during type-checking of
later definitions, compilation would be much slower.

**`example`** creates a temporary `defnDecl` (or `thmDecl` for
`Prop`-typed results), type-checks it, and then discards it. No
name is registered in the environment.

**`abbrev`** creates a `defnDecl` with the `@[reducible]` attribute.
The elaborator and `simp` always unfold it. Use for type aliases:

```lean
abbrev Point := Nat x Nat
-- The kernel always sees Nat x Nat, never Point
```

**`opaque`** creates an `opaqueDecl`. The body exists (so the
definition is well-typed), but the kernel is **forbidden** from
unfolding it. This is stronger than `@[irreducible]`: even the
kernel cannot see through it. Used for:
- FFI bindings (`@[extern "c_func"] opaque ...`)
- Sealing implementation details

**`axiom`** creates an `axiomDecl` with no body. This is a raw
postulate: "trust me, a term of this type exists." Dangerous,
because an inconsistent axiom (`axiom bad : False`) makes every
proposition provable. Lean has exactly three built-in axioms:

1. `propext : (a <-> b) -> a = b` (propositional extensionality)
2. `Quot.sound : r a b -> Quot.mk r a = Quot.mk r b`
3. `Classical.choice : Nonempty a -> a` (axiom of choice)

You can check which axioms a definition depends on with
`#print axioms myDef`.

**`noncomputable def`** creates a `defnDecl` but marks it as not
compiled. The definition exists in the logic but has no executable
code. Required when the body uses `Classical.choice` or other
non-constructive principles in a computationally relevant position.

### The Reducibility Hierarchy

```
abbrev  (@[reducible])    -- always unfolded
   |
  def   (default)         -- unfolded when needed
   |
  def   (@[irreducible])  -- elaborator won't unfold
   |
opaque                    -- kernel won't unfold
   |
theorem                   -- kernel won't unfold + erased
```

**Source:** The classification of declaration kinds is discussed at
https://proofassistants.stackexchange.com/questions/1575 and in the
Lean 4 kernel source (`src/kernel/declaration.h`).

**Reference:** Proof irrelevance in the Calculus of Inductive
Constructions is described in Werner, "On the Strength of Proof-
Irrelevant Type Theories," Logical Methods in Computer Science, 2008.

## Reading Lean Source Code

The Lean 4 repository itself is written in Lean:
- `src/Lean/` - the compiler and standard library
- `src/Lean/Elab/` - elaboration
- `src/Lean/Meta/` - metaprogramming framework
- `src/Lean/Compiler/` - compiler passes
- `src/kernel/` - the kernel (C++)

Understanding these directories is key to deep Lean expertise.
