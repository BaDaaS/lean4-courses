/-
# 0023 - File IO and CLI Examples

Code examples from the README, wrapped in anchors for injection.
-/

namespace Course0023Examples

-- #anchor: argument_parsing
structure Args where
  verbose : Bool := false
  output : Option String := none
  files : Array String := #[]

def parseArgs (args : List String) : Except String Args := do
  let mut result : Args := {}
  let mut rest := args
  while _h : !rest.isEmpty do
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
-- #end

-- #anchor: streaming_file_processing
def processLines (path : String) (f : String -> IO Unit) :
    IO Unit := do
  let handle <- IO.FS.Handle.mk path .read
  let mut done := false
  while !done do
    let line <- handle.getLine
    if line.isEmpty then
      done := true
    else
      f line.trimAsciiEnd.toString
-- #end

-- #anchor: directory_traversal
partial def walkDir (path : System.FilePath) :
    IO (Array System.FilePath) := do
  let mut result := #[]
  let entries <- path.readDir
  for entry in entries do
    if (<- entry.path.isDir) then
      let sub <- walkDir entry.path
      result := result ++ sub
    else
      result := result.push entry.path
  return result
-- #end

-- #anchor: structured_exit_codes
def mainWithExitCode (args : List String) : IO UInt32 := do
  match parseArgs args with
  | .error msg =>
    IO.eprintln s!"Error: {msg}"
    return 1
  | .ok _parsedArgs =>
    -- process...
    return 0

def main (args : List String) : IO UInt32 :=
  mainWithExitCode args
-- #end

-- #anchor: colored_output
def red (s : String) : String := s!"\x1b[31m{s}\x1b[0m"
def green (s : String) : String := s!"\x1b[32m{s}\x1b[0m"
def bold (s : String) : String := s!"\x1b[1m{s}\x1b[0m"
-- #end

end Course0023Examples
