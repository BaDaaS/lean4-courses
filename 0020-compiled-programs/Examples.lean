/-
# 0020 - Compiled Programs Examples

Code examples from the README, wrapped in anchors for injection.
Most blocks are lakefile.lean configuration or multi-file project
snippets that require project context, and are left inline.
-/

namespace Course0020Examples

-- #anchor: command_line_arguments
def main (args : List String) : IO Unit := do
  match args with
  | ["--help"] => IO.println "Usage: myapp [options]"
  | ["--version"] => IO.println "1.0.0"
  | files => for f in files do
      IO.println s!"Processing: {f}"
-- #end

end Course0020Examples
