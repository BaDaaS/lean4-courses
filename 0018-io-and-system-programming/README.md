# 0018 - IO and System Programming

## Goal

Use the IO monad for real programs: reading/writing files, environment
variables, process execution, and command-line interaction.

## IO Basics

```lean fromFile:Examples.lean#io_basics
def main : IO Unit := do
  IO.println "What is your name?"
  let stdin <- IO.getStdin
  let name <- stdin.getLine
  IO.println s!"Hello, {name.trim}!"
```

## File IO

```lean fromFile:Examples.lean#file_io
-- Reading a file
def readFile (path : String) : IO String := do
  IO.FS.readFile path

-- Writing a file
def writeFile (path : String) (content : String) : IO Unit := do
  IO.FS.writeFile path content

-- Appending to a file
def appendFile (path : String) (content : String) : IO Unit := do
  let h <- IO.FS.Handle.mk path .append
  h.putStr content
```

## Environment Variables

```lean fromFile:Examples.lean#env_variables
def getEnvOrDefault (key default : String) : IO String := do
  let val <- IO.getEnv key
  return val.getD default
```

## Process Execution

```lean fromFile:Examples.lean#process_execution
def runCommand (cmd : String) (args : Array String) : IO String := do
  let output <- IO.Process.output {
    cmd := cmd
    args := args
  }
  if output.exitCode != 0 then
    throw (IO.userError s!"Command failed: {output.stderr}")
  return output.stdout
```

## Error Handling in IO

```lean fromFile:Examples.lean#error_handling
def safeReadFile (path : String) : IO (Except String String) := do
  try
    let content <- IO.FS.readFile path
    return .ok content
  catch e =>
    return .error s!"Failed to read {path}: {e}"
```

## Building Executables with Lake

```lean
-- lakefile.lean
import Lake
open Lake DSL

package myapp

@[default_target]
lean_exe myapp where
  root := `Main
```

```bash
lake build
./build/bin/myapp
```

## Key IO Functions

| Function | Purpose |
|----------|---------|
| `IO.println` | Print with newline |
| `IO.print` | Print without newline |
| `IO.FS.readFile` | Read entire file |
| `IO.FS.writeFile` | Write entire file |
| `IO.FS.lines` | Read file as array of lines |
| `IO.getStdin` | Get stdin handle |
| `IO.Process.output` | Run external process |
| `IO.getEnv` | Read environment variable |
| `IO.sleep` | Sleep for milliseconds |
| `IO.monoMsNow` | Current timestamp (ms) |
