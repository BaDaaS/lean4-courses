/-
# 0019 - Compiled Programs Solutions

These are the key source files for each exercise.
Create the Lake projects and add these files.
-/

/-
## Exercise 1: Main.lean for hello project
-/

-- def main : IO Unit := do
--   IO.println "Hello from a compiled Lean program!"

/-
## Exercise 2: Multi-file calculator

-- Calc/Expr.lean
namespace Calc

inductive Expr where
  | num (n : Int)
  | add (l r : Expr)
  | sub (l r : Expr)
  | mul (l r : Expr)

def Expr.eval : Expr -> Int
  | .num n => n
  | .add l r => l.eval + r.eval
  | .sub l r => l.eval - r.eval
  | .mul l r => l.eval * r.eval

end Calc

-- Main.lean
-- import Calc.Expr
-- def main : IO Unit := do
--   let expr := Calc.Expr.add (Calc.Expr.num 3) (Calc.Expr.mul (Calc.Expr.num 4) (Calc.Expr.num 5))
--   IO.println s!"Result: {expr.eval}"
-/

/-
## Exercise 3: Word counter (wc clone)
-/

def wc (path : String) : IO (Nat x Nat x Nat) := do
  let content <- IO.FS.readFile path
  let lines := content.splitOn "\n" |>.length
  let words := content.splitOn " "
    |>.bind (fun s => s.splitOn "\n")
    |>.filter (fun s => !s.isEmpty)
    |>.length
  let chars := content.length
  return (lines, words, chars)

def wcMain (args : List String) : IO Unit := do
  let mut totalLines := 0
  let mut totalWords := 0
  let mut totalChars := 0
  for path in args do
    let (l, w, c) <- wc path
    IO.println s!"  {l}\t{w}\t{c}\t{path}"
    totalLines := totalLines + l
    totalWords := totalWords + w
    totalChars := totalChars + c
  if args.length > 1 then
    IO.println s!"  {totalLines}\t{totalWords}\t{totalChars}\ttotal"
