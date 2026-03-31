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

## Math Track: Lean as a Proof Assistant

Lean is a language where you can state mathematical theorems as types and
provide proofs as terms. The type checker verifies your proofs are correct.

```lean
-- A theorem is a type (the statement) with a term (the proof)
theorem one_plus_one : 1 + 1 = 2 := rfl
```

`rfl` means "reflexivity" - both sides compute to the same value.

## CS Track: Lean as a Programming Language

Lean is a pure functional language with dependent types. It compiles to C
and can be used for real software, not just proofs.

```lean
def factorial : Nat -> Nat
  | 0 => 1
  | n + 1 => (n + 1) * factorial n

#eval factorial 10  -- 3628800
```

## Lake: The Build System

Lake is Lean's build system (like Cargo for Rust).

```bash
lake init my_project
cd my_project
lake build
```

This creates a project with `lakefile.lean` and a `Main.lean` entry point.
