/-
# 0018 - IO and System Programming Examples

Code examples from the README, wrapped in anchors for injection.
-/

namespace Course0018Examples

-- #anchor: io_basics
def main : IO Unit := do
  IO.println "What is your name?"
  let stdin <- IO.getStdin
  let name <- stdin.getLine
  IO.println s!"Hello, {name.trim}!"
-- #end

-- #anchor: file_io
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
-- #end

-- #anchor: env_variables
def getEnvOrDefault (key default : String) : IO String := do
  let val <- IO.getEnv key
  return val.getD default
-- #end

-- #anchor: process_execution
def runCommand (cmd : String) (args : Array String) : IO String := do
  let output <- IO.Process.output {
    cmd := cmd
    args := args
  }
  if output.exitCode != 0 then
    throw (IO.userError s!"Command failed: {output.stderr}")
  return output.stdout
-- #end

-- #anchor: error_handling
def safeReadFile (path : String) : IO (Except String String) := do
  try
    let content <- IO.FS.readFile path
    return .ok content
  catch e =>
    return .error s!"Failed to read {path}: {e}"
-- #end

end Course0018Examples
