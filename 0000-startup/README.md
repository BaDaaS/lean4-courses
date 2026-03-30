# 0000 - Startup

## Goal

Get Lean 4 installed and running. Write your first definitions and proofs.

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
