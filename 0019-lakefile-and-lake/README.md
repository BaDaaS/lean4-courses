# 0019 - Lakefile and Lake

## Goal

Master Lake, Lean 4's build system. Understand lakefile.lean in depth:
packages, libraries, executables, dependencies, custom targets, and
build scripts.

## What is Lake?

Lake (Lean Make) is Lean 4's build system and package manager.
It is written in Lean itself and configured via `lakefile.lean`.

## Creating a Project

```bash
lake init myproject        # Create a new project
lake init myproject math   # Create with Mathlib template
```

This generates:

```
myproject/
  lakefile.lean            # Build configuration
  lean-toolchain           # Lean version pin
  Main.lean                # Entry point
  MyProject/
    Basic.lean             # Library root
  MyProject.lean           # Root import
```

## lakefile.lean Anatomy

```lean
import Lake
open Lake DSL

-- Package: the top-level unit
package myproject where
  -- Lean compiler options
  leanOptions := #[
    <<`autoImplicit, false>>
  ]
  -- Extra arguments passed to the Lean compiler
  moreLeanArgs := #[]
  -- Extra arguments passed to the C linker
  moreLinkArgs := #[]

-- Library: a collection of Lean modules
@[default_target]
lean_lib MyProject where
  srcDir := "."            -- Where to find source files
  roots := #[`MyProject]   -- Root modules
  -- globs := #[.submodules `MyProject]  -- Alternative: all submodules

-- Executable: a compiled binary
lean_exe myapp where
  root := `Main            -- Entry point module
  -- Depends on the library automatically

-- Another library (multi-lib project)
lean_lib MyTests where
  srcDir := "tests"
  roots := #[`Tests]
```

## Package Options

```lean
package myproject where
  -- Lean compiler flags
  leanOptions := #[
    <<`autoImplicit, false>>,     -- Disable auto-implicit
    <<`relaxedAutoImplicit, false>> -- Strict mode
  ]

  -- Paths
  srcDir := "."           -- Default source directory
  buildDir := ".lake/build"  -- Build output directory

  -- Linker flags (for FFI)
  moreLinkArgs := #["-lsqlite3", "-lm"]
```

## Dependencies

### From Git

```lean
require mathlib from git
  "https://github.com/leanprover-community/mathlib4"
    @ "master"

require std from git
  "https://github.com/leanprover/std4" @ "main"

-- Pin to a specific commit
require mylib from git
  "https://github.com/org/mylib"
    @ "abc1234def5678"
```

### Local Dependencies

```lean
require mylib from ".." / "mylib"
```

### After Adding Dependencies

```bash
lake update     # Fetch/update all dependencies
lake build      # Build everything
```

## Library Configuration

```lean
-- Build all .lean files under a directory
lean_lib MyLib where
  srcDir := "src"
  globs := #[.submodules `MyLib]  -- All files under MyLib/

-- Build specific root modules only
lean_lib MyLib where
  roots := #[`MyLib.Core, `MyLib.Utils]

-- Multiple source directories via multiple libs
lean_lib Frontend where
  srcDir := "frontend/src"
  roots := #[`Frontend]

lean_lib Backend where
  srcDir := "backend/src"
  roots := #[`Backend]
```

## Executable Configuration

```lean
lean_exe myapp where
  root := `Main
  -- Support for C interop
  extraDepTargets := #[`ffi.o]

-- Multiple executables
lean_exe cli where
  root := `CLI.Main

lean_exe server where
  root := `Server.Main
```

## Custom Targets (FFI, Code Generation)

```lean
-- Compile a C file
target ffi.o pkg : FilePath := do
  let oFile := pkg.buildDir / "c" / "ffi.o"
  let srcFile := pkg.dir / "c" / "ffi.c"
  let leanInclude <- getLeanIncludeDir
  buildO oFile srcFile
    #["-I", leanInclude.toString]
    #["-fPIC"]

-- Compile multiple C files
target mylib.a pkg : FilePath := do
  let oFiles <- #["foo.c", "bar.c"].mapM fun src => do
    let oFile := pkg.buildDir / "c" / (src ++ ".o")
    let srcFile := pkg.dir / "c" / src
    buildO oFile srcFile #[] #[]
  let aFile := pkg.buildDir / "c" / "mylib.a"
  buildStaticLib aFile oFiles
```

## Scripts

```lean
-- Define a custom lake script
script greet (args) do
  IO.println s!"Hello, {args.getD 0 "World"}!"
  return 0

-- Run with: lake run greet Alice
```

## lean-toolchain

Pin the exact Lean version:

```
leanprover/lean4:v4.29.0
```

Always commit this file. It ensures reproducible builds.

## Lake Commands Reference

| Command | Purpose |
|---------|---------|
| `lake init name` | Create new project |
| `lake build` | Build default targets |
| `lake build target` | Build specific target |
| `lake build --wfail` | Warnings as errors |
| `lake clean` | Remove build artifacts |
| `lake update` | Update dependencies |
| `lake exe name` | Build and run executable |
| `lake env lean file` | Run lean on a file |
| `lake run script` | Run a lake script |
| `lake test` | Run tests (if configured) |

## Multi-Package Workspaces

```lean
-- Root lakefile.lean
package workspace

-- Sub-packages
require libA from "." / "lib-a"
require libB from "." / "lib-b"
```

## Formatting and Linting

As of 2025, Lean 4 has no official source code formatter (`lean fmt`
does not exist). The tracking issue is
[leanprover/lean4#1488](https://github.com/leanprover/lean4/issues/1488)
(labeled P-high, still open). Lean 4 has an internal
`PrettyPrinter/Formatter` module, but it is not yet suitable for
reformatting source files. The main difficulty is Lean's user-extensible
syntax: custom macros, notation, and DSLs mean a formatter must handle
arbitrary parser extensions, not just a fixed grammar.

### Third-party formatters

- [lean-fmt](https://github.com/lotusirous/lean-fmt): a lightweight
  Go-based tool for basic whitespace and indentation normalization.
  Self-described as "a workaround until the official Lean formatter is
  ready." Not a full semantic formatter.
- [format_lean](https://github.com/leanprover-community/format_lean):
  a Python tool from the Lean community, originally for Lean 3. Limited
  Lean 4 support.

### Linters

- `lake build --wfail`: treats all warnings as errors. This is the
  baseline for CI.
- Batteries `runLinter`: the standard linter executable shipped with
  Batteries. Projects can set `lintDriver` in their lakefile to use it.
- Lean 4.22.0+ added a built-in simp argument cleanup linter.
- Mathlib linters (`Mathlib.Tactic.Linter.Lint`): `simpNF`,
  `docBlame`, `unusedArguments`, and more. Requires Mathlib as a
  dependency.
- `lint-style` (Mathlib/CSLib): text-based style checks for copyright
  headers, line length, trailing whitespace.

### What to use in CI today

For projects without Mathlib, the practical setup is:

```bash
lake build --wfail    # Warnings as errors
```

There is no formatter to enforce. Consistent style must be maintained
manually or via editor configuration.

## Best Practices

1. Always pin lean-toolchain to an exact version
2. Use `autoImplicit := false` for production code
3. Separate libraries from executables
4. Use `globs` for large projects, `roots` for small ones
5. Pin git dependencies to commits, not branches, for reproducibility
6. Add `.lake/` to `.gitignore`
7. Use `lake build --wfail` in CI
