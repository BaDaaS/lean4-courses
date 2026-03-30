# 0019 - Compiled Programs and Lake

## Goal

Build real compiled Lean programs. Understand Lake's project system,
dependencies, multi-file projects, and the compilation pipeline.

## Lean Compilation Pipeline

Lean 4 compiles to C, then to native code:

```
Lean source -> Lean IR -> C code -> Native binary
```

This means Lean programs run at native speed, not interpreted.

## Lake Project Structure

```
my_project/
  lakefile.lean       -- Build configuration
  lean-toolchain      -- Lean version pin
  Main.lean           -- Entry point (for executables)
  MyProject/
    Basic.lean        -- Library modules
    Utils.lean
  MyProject.lean      -- Root import file
```

## lakefile.lean

```lean
import Lake
open Lake DSL

package myproject where
  leanOptions := #[
    ⟨`autoImplicit, false⟩  -- Disable auto-implicit (good practice)
  ]

-- Library target
@[default_target]
lean_lib MyProject where
  srcDir := "."

-- Executable target
lean_exe myapp where
  root := `Main
  -- Link to system libraries if needed
  -- moreLinkArgs := #["-lsqlite3"]
```

## Adding Dependencies

```lean
-- lakefile.lean
require mathlib from git
  "https://github.com/leanprover-community/mathlib4" @ "master"

require std from git
  "https://github.com/leanprover/std4" @ "main"
```

## Multi-File Projects

```lean
-- MyProject/Types.lean
namespace MyProject

structure Config where
  verbose : Bool
  maxItems : Nat

end MyProject

-- MyProject/Core.lean
import MyProject.Types

namespace MyProject

def processConfig (cfg : Config) : IO Unit := do
  if cfg.verbose then
    IO.println "Verbose mode enabled"

end MyProject

-- Main.lean
import MyProject.Core

def main (args : List String) : IO Unit := do
  let cfg : MyProject.Config := {
    verbose := args.contains "--verbose"
    maxItems := 100
  }
  MyProject.processConfig cfg
```

## Building and Running

```bash
lake build              # Build all default targets
lake build myapp        # Build specific target
lake exe myapp          # Build and run
./build/bin/myapp       # Run directly

lake clean              # Clean build artifacts
lake update             # Update dependencies
```

## Command-Line Arguments

```lean
def main (args : List String) : IO Unit := do
  match args with
  | ["--help"] => IO.println "Usage: myapp [options]"
  | ["--version"] => IO.println "1.0.0"
  | files => for f in files do
      IO.println s!"Processing: {f}"
```

## Compilation Flags

```lean
-- In lakefile.lean, set compiler options
package myproject where
  moreLeanArgs := #["-DautoImplicit=false"]
  moreServerOptions := #[⟨`autoImplicit, false⟩]
```
