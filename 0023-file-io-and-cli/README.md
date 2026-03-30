# 0022 - File IO and CLI Tools

## Goal

Build production-quality CLI tools. Argument parsing, streaming IO,
directory traversal, and structured error handling.

## Argument Parsing

```lean
structure Args where
  verbose : Bool := false
  output : Option String := none
  files : Array String := #[]

def parseArgs (args : List String) : Except String Args := do
  let mut result : Args := {}
  let mut rest := args
  while h : !rest.isEmpty do
    match rest with
    | "--verbose" :: tail =>
      result := { result with verbose := true }
      rest := tail
    | "--output" :: path :: tail =>
      result := { result with output := some path }
      rest := tail
    | file :: tail =>
      result := { result with files := result.files.push file }
      rest := tail
    | [] => break
  return result
```

## Streaming File Processing

For large files, process line by line instead of reading everything:

```lean
def processLines (path : String) (f : String -> IO Unit) : IO Unit := do
  let handle <- IO.FS.Handle.mk path .read
  let mut done := false
  while !done do
    let line <- handle.getLine
    if line.isEmpty then
      done := true
    else
      f line.trimRight
```

## Directory Traversal

```lean
def walkDir (path : System.FilePath) : IO (Array System.FilePath) := do
  let mut result := #[]
  let entries <- path.readDir
  for entry in entries do
    if (<- entry.path.isDir) then
      let sub <- walkDir entry.path
      result := result ++ sub
    else
      result := result.push entry.path
  return result
```

## Structured Exit Codes

```lean
def mainWithExitCode (args : List String) : IO UInt32 := do
  match parseArgs args with
  | .error msg =>
    IO.eprintln s!"Error: {msg}"
    return 1
  | .ok parsedArgs =>
    -- process...
    return 0

def main (args : List String) : IO UInt32 :=
  mainWithExitCode args
```

## Colored Output

```lean
def red (s : String) : String := s!"\x1b[31m{s}\x1b[0m"
def green (s : String) : String := s!"\x1b[32m{s}\x1b[0m"
def bold (s : String) : String := s!"\x1b[1m{s}\x1b[0m"
```
