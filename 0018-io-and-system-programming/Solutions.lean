/-
# 0018 - IO and System Programming Solutions
-/

-- Exercise 1
def ex1_main : IO Unit := do
  IO.println "Hello, Lean 4!"

-- Exercise 2
def ex2_echo : IO Unit := do
  let stdin <- IO.getStdin
  let line <- stdin.getLine
  IO.print line

-- Exercise 3
def ex3_cat (args : List String) : IO Unit := do
  match args with
  | [path] =>
    let content <- IO.FS.readFile path
    IO.print content
  | _ => IO.eprintln "Usage: cat <file>"

-- Exercise 4
def countLines (path : String) : IO Nat := do
  let content <- IO.FS.readFile path
  return content.splitOn "\n" |>.length

-- Exercise 5
def simpleGrep (pattern : String) (path : String) : IO Unit := do
  let content <- IO.FS.readFile path
  let lines := content.splitOn "\n"
  for line in lines do
    if line.containsSubstr pattern then
      IO.println line

-- Exercise 6
def printEnv (key : Option String) : IO Unit := do
  match key with
  | some k =>
    let val <- IO.getEnv k
    match val with
    | some v => IO.println s!"{k}={v}"
    | none => IO.eprintln s!"{k} not set"
  | none =>
    IO.println "Specify an environment variable name"

-- Exercise 7
def copyFile (src dst : String) : IO Unit := do
  let content <- IO.FS.readFile src
  IO.FS.writeFile dst content

-- Exercise 8
def timed (action : IO alpha) : IO (alpha x Nat) := do
  let start <- IO.monoMsNow
  let result <- action
  let stop <- IO.monoMsNow
  return (result, (stop - start).toNat)

-- Exercise 9
def repl : IO Unit := do
  let stdin <- IO.getStdin
  IO.print "> "
  let line <- stdin.getLine
  let trimmed := line.trim
  if trimmed == "quit" then
    IO.println "Bye!"
    return
  match trimmed.toNat? with
  | some n => IO.println s!"= {n}"
  | none => IO.println s!"Not a number: {trimmed}"
  repl
