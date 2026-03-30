# 0024 - Contributing to Mathlib

## Goal

Learn the workflow, conventions, and tools for contributing to Mathlib4,
the community math library for Lean 4.

## What is Mathlib?

Mathlib is the largest library of formalized mathematics. It covers:
algebra, analysis, topology, number theory, category theory, combinatorics,
measure theory, and more.

Repository: https://github.com/leanprover-community/mathlib4

## Setting Up

```bash
# Clone Mathlib
git clone https://github.com/leanprover-community/mathlib4
cd mathlib4

# Get pre-built oleans (avoids hours of compilation)
lake exe cache get

# Build (should be fast after cache)
lake build
```

## Finding What to Contribute

1. **Zulip**: https://leanprover.zulipchat.com/ - ask in #new members
2. **Issues labeled "good first issue"** on GitHub
3. **Fill gaps**: search for `sorry` in Mathlib (there are none, but
   there are `TODO` comments)
4. **Extend existing theories**: add missing lemmas about existing objects
5. **Formalize new mathematics**: requires discussion on Zulip first

## Mathlib Conventions

### File Structure

```lean
/-
Copyright (c) 2024 Your Name. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Your Name
-/
import Mathlib.Algebra.Group.Basic

/-!
# Title

Description of the module.

## Main definitions

- `Foo`: description
- `Bar`: description

## Main results

- `foo_bar`: description

## References

* [Author, *Title*][bibtexKey]
-/
```

### Naming Conventions

Mathlib names are highly systematic:
- `operation_property`: `mul_comm`, `add_zero`
- `type.operation`: `List.map`, `Finset.sum`
- `_iff` for biconditionals
- `_of_` for conditional results
- `not_` prefix for negation

### Style

- 100 character line limit
- `where` clauses preferred over `fun ... =>`
- Tactic proofs for non-trivial statements
- `simp` lemmas tagged with `@[simp]`
- No `autoImplicit`

## PR Workflow

1. Create a branch from `master`
2. Make changes in a single file (or closely related files)
3. Run linters: `lake exe lint-style` and `lake lint`
4. Run tests: `lake build --wfail`
5. Open PR with descriptive title
6. Respond to review comments
7. Keep PRs small (under 300 lines of diff)

## Linting

```bash
lake exe lint-style           # Text-based style linters
lake lint                     # Environment linters
lake exe mk_all --check       # Verify all files imported
```

## Useful Commands When Working on Mathlib

```bash
# Search for a definition
grep -r "^def MyThing" Mathlib/

# Search for a theorem name
grep -r "^theorem.*my_lemma" Mathlib/

# Find which file imports what
grep -r "import Mathlib.Algebra.Group" Mathlib/
```

## Exercises

1. Clone Mathlib and build it (with cache)
2. Find a simple `TODO` or missing lemma
3. Read 3 files in an area you are interested in
4. Write a new lemma and submit a PR
5. Respond to CI feedback and reviewer comments
