/-
# 0022 - File IO and CLI Tools Solutions

Key implementations for exercises.
-/

-- Exercise 1: head
def myHead (n : Nat) (path : String) : IO Unit := do
  let handle <- IO.FS.Handle.mk path .read
  let mut count := 0
  let mut done := false
  while !done && count < n do
    let line <- handle.getLine
    if line.isEmpty then
      done := true
    else
      IO.print line
      count := count + 1

-- Exercise 3: find (simplified)
partial def findFiles
    (root : System.FilePath)
    (pattern : String) : IO (Array System.FilePath) := do
  let mut results := #[]
  let entries <- root.readDir
  for entry in entries do
    if (<- entry.path.isDir) then
      let sub <- findFiles entry.path pattern
      results := results ++ sub
    else
      let name := entry.fileName
      if name.containsSubstr pattern then
        results := results.push entry.path
  return results

-- Exercise 4: uniq
def myUniq (path : String) : IO Unit := do
  let content <- IO.FS.readFile path
  let lines := content.splitOn "\n"
  let mut prev := ""
  for line in lines do
    if line != prev then
      IO.println line
      prev := line

-- Exercise 5: sort
def mySort (path : String) (reverse : Bool) : IO Unit := do
  let content <- IO.FS.readFile path
  let lines := content.splitOn "\n" |>.filter (!. .isEmpty)
  let sorted := lines.mergeSort (fun a b => if reverse then a > b else a < b)
  for line in sorted do
    IO.println line
