# 0000 - Startup

## Goal

Get Lean 4 installed and running. Write your first definitions and proofs.

**Lore:**
- [def vs theorem vs example](../lore/def-vs-theorem.md) - What the kernel sees
- [From LCF to Lean](../lore/lcf-to-lean.md) - The family tree of proof assistants

## Installation

1. Install elan (Lean version manager):

```bash
curl https://elan.lean-lang.org/install.sh -sSf | sh
```

2. Verify:

```bash
lean --version
```

3. (Optional) Install VS Code + lean4 extension for interactive feedback.

## Your First Lean File

Create a file `Hello.lean`:

```lean
-- This is a comment
#check 42          -- Nat
#check "hello"     -- String
#check true        -- Bool

#eval 2 + 3        -- 5
#eval "hello " ++ "world"  -- "hello world"

def greeting : String := "Hello, Lean 4!"
#eval greeting
```

## Key Commands

| Command | Purpose |
|---------|---------|
| `#check expr` | Show the type of an expression |
| `#eval expr` | Evaluate an expression |
| `#print name` | Print the definition of a name |
| `def` | Define a value or function |
| `theorem` | State and prove a theorem |
| `example` | Check a proof/definition, then discard it |

## Declaration Keywords: def, theorem, example, and Friends

Lean has several keywords for top-level declarations. They look
similar but have important differences in how the kernel and
compiler treat them.

### def

The primary way to define a named function or value. The body is
**compiled** into executable code (Lean IR, then C). The definition
is **reducible**: other code can unfold it.

```lean
def double (n : Nat) : Nat := 2 * n
#eval double 5  -- 10 (runs compiled code)
```

### theorem

A `theorem` is essentially a **noncomputable def**. The body (the
proof) is **erased** at compile time and **not** compiled into
executable code. You cannot `#eval` a theorem or use it in a
computation.

```lean
theorem two_eq : 1 + 1 = 2 := rfl
-- #eval two_eq  -- ERROR: not executable
```

Why erase proofs? Because of **proof irrelevance**: in `Prop`, all
proofs of the same statement are considered equal. The compiled
program never needs to inspect a proof at runtime, so erasing it
is safe and saves memory/compute.

A `theorem` is also **opaque** to the kernel by default: later
definitions cannot unfold the proof body. This is an optimization
(the kernel does not need to look inside proofs to type-check code
that uses them).

### example

An **anonymous** def/theorem. Lean type-checks it and then
immediately discards it. It has no name and no lasting effect on
the environment. Useful for testing and exercises.

```lean
example : 1 + 1 = 2 := rfl          -- checked, then forgotten
example (n : Nat) : Nat := n + 1    -- also fine
```

### lemma

In Lean 4, `lemma` is an alias for `theorem`. No semantic
difference. Use it for stylistic reasons (smaller results vs.
big theorems).

### abbrev

A `def` that is marked **always reducible**. The simplifier and
other tactics will always unfold it. Use for type aliases and
lightweight wrappers.

```lean
abbrev NatPair := Nat x Nat  -- always unfolded by simp
```

### opaque

A declaration with a body that the kernel **cannot unfold**. The
body exists (the value is well-defined), but nothing can look
inside it. Used for FFI bindings and performance isolation.

```lean
opaque secretValue : Nat := 42
-- The kernel cannot see that secretValue = 42
```

### noncomputable def

A `def` that is not compiled. Used when the definition depends on
classical axioms or other non-constructive principles that have no
computational content.

```lean
noncomputable def classicalChoice (P : Prop) [h : Decidable P] :
    Bool := if P then true else false
```

### axiom

Postulates a term without providing a body. This extends Lean's
logic with a new assumption. Dangerous: inconsistent axioms make
the logic unsound.

```lean
axiom myAxiom : forall (n : Nat), n + 0 = n
-- No proof needed, but no guarantee of consistency
```

Lean has three built-in axioms: `propext` (propositional
extensionality), `Quot.sound` (quotient soundness), and
`Classical.choice` (axiom of choice).

### Summary Table

| Keyword | Named? | Compiled? | Reducible? | Erased? |
|---------|--------|-----------|------------|---------|
| `def` | yes | yes | yes (default) | no |
| `abbrev` | yes | yes | always | no |
| `theorem` | yes | no | no (opaque) | yes |
| `lemma` | yes | no | no (opaque) | yes |
| `example` | no | yes* | n/a | discarded |
| `opaque` | yes | depends | never | no |
| `noncomputable def` | yes | no | yes | no |
| `axiom` | yes | no | n/a (no body) | yes |

(*) `example` generates code by default but discards everything
after type-checking.

**Source:** This classification is discussed in detail at
https://proofassistants.stackexchange.com/questions/1575 and in
the Lean 4 reference manual.

## What Lean Actually Is

Lean 4 is an implementation of the **Calculus of Inductive
Constructions** (CIC), a dependent type theory that serves as both
a programming language and a logical foundation. Understanding
what this means requires knowing three things: the kernel, the
trusted computing base, and the elaboration pipeline.

### The kernel

The **kernel** (also called the type checker) is the small, trusted
core of Lean. It checks that every term has the type you claim it
has. If the kernel accepts `theorem T : P := proof`, then `proof`
genuinely has type `P`, and `P` is a valid proposition. The
soundness of every proof in Lean reduces to the correctness of
this one component.

The kernel implements the following **typing judgments** (see course
0001 for the formal rules):

1. `Gamma |- t : T` ("in context Gamma, term t has type T")
2. `Gamma |- T : Sort u` ("T is a well-formed type in universe u")
3. `Gamma |- t =_def s : T` ("t and s are definitionally equal at
   type T")

Definitional equality (judgment 3) is what makes `rfl` work. When
you write `theorem : 1 + 1 = 2 := rfl`, the kernel computes both
sides and checks they reduce to the same normal form (`2`). No
lemma is needed because equality holds by computation.

### The trusted computing base

The **trusted computing base** (TCB) is everything you must trust
for Lean's proofs to be valid. In Lean 4, this consists of:

1. The kernel implementation (~5000 lines of C++)
2. Three axioms:
   - `propext : (a <-> b) -> a = b` (propositional extensionality)
   - `Quot.sound : r a b -> Quot.mk r a = Quot.mk r b` (quotient
     soundness)
   - `Classical.choice : Nonempty alpha -> alpha` (axiom of choice)

Everything else (tactics, elaboration, the standard library,
Mathlib) is **untrusted**. Tactics generate proof terms, and the
kernel checks them. A buggy tactic cannot produce a false theorem
because the kernel would reject the proof term. This is the **de
Bruijn criterion**, named after Nicolaas de Bruijn's Automath
system (1967), the first proof checker to separate trusted checking
from untrusted proof generation.

### The elaboration pipeline

When you write Lean code, it goes through several stages before
the kernel sees it:

```
Source code
  -> Parsing (syntax)
  -> Macro expansion
  -> Elaboration (type inference, implicit argument resolution,
     coercion insertion, tactic execution)
  -> Core term (fully explicit, no sugar)
  -> Kernel type-checking
```

The elaborator is the most complex part. It resolves implicit
arguments (the `{...}` and `[...]` parameters), inserts coercions
(e.g., `Nat` to `Int`), runs tactics (producing proof terms), and
performs unification. None of this is trusted. The output is a
fully explicit **core term** that the kernel can check independently.

You can see the core term with `#print`:

```lean
def double (n : Nat) : Nat := 2 * n
#print double
-- def double : Nat -> Nat :=
-- fun n => 2 * n
```

### Three axioms, and what they mean

**propext** (propositional extensionality): if two propositions are
logically equivalent (`P <-> Q`), they are equal (`P = Q`). This is
needed because Lean's `Prop` universe is **proof-irrelevant** (all
proofs of P are equal), so propositions should be determined by
their truth value alone. Without `propext`, you could have
`P <-> Q` but `P != Q`, which is awkward.

**Quot.sound**: quotient types respect their equivalence relation.
If `r a b` holds, then `a` and `b` are equal in the quotient type.
This is used to define the integers as a quotient of `Nat x Nat`
by `(a, b) ~ (c, d) iff a + d = b + c`, and for many other
mathematical constructions.

**Classical.choice**: if a type is nonempty, you can extract an
element. This is non-constructive: you get an element but no
information about which one. It implies the law of excluded middle
(`P \/ Not P` for all P) and makes Lean's logic classical rather
than purely constructive. Code that uses `Classical.choice` is
marked `noncomputable` because there is no algorithm to choose the
element.

These three axioms are independent and consistent with CIC. You can
write fully constructive Lean code by avoiding `Classical.choice`.
Lean tracks which axioms each definition depends on:

```lean
#print axioms my_theorem   -- shows which axioms were used
```

## Math Track: Lean as a Proof Assistant

Lean is a language where you can state mathematical theorems as types
and provide proofs as terms. The type checker verifies your proofs
are correct.

```lean
-- A theorem is a type (the statement) with a term (the proof)
theorem one_plus_one : 1 + 1 = 2 := rfl
```

`rfl` means "reflexivity": both sides compute to the same value.
The kernel reduces `1 + 1` to `2`, sees both sides are identical,
and accepts `Eq.refl 2` as a proof.

The largest body of formalized mathematics in Lean is **Mathlib**
(https://leanprover-community.github.io/mathlib4_docs/), which
contains over 200,000 theorems covering algebra, analysis, topology,
number theory, combinatorics, and category theory.

## CS Track: Lean as a Programming Language

Lean is a pure functional language with dependent types. It compiles
to C via an intermediate representation and can be used for real
software, not just proofs.

```lean
def factorial : Nat -> Nat
  | 0 => 1
  | n + 1 => (n + 1) * factorial n

#eval factorial 10  -- 3628800
```

Lean uses **reference counting** for memory management (not garbage
collection). The compiler performs **destructive updates** when it
detects a value has a reference count of 1, turning pure functional
code into efficient in-place mutation. This is why `Array.push` on
a uniquely-owned array is O(1), not O(n).

**Reference:** Sebastian Ullrich and Leonardo de Moura, "Counting
Immutable Beans: Reference Counting Optimized for Purely Functional
Programming," IFL 2019.

## Lake: The Build System

Lake is Lean's build system (like Cargo for Rust).

```bash
lake init my_project
cd my_project
lake build
```

This creates a project with `lakefile.lean` and a `Main.lean` entry
point.
