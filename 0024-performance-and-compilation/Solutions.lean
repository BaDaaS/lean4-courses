/-
# 0023 - Performance and Compilation Solutions
-/

-- Exercise 1
def factorialFast (n : Nat) : Nat :=
  go n 1
where
  go : Nat -> Nat -> Nat
    | 0, acc => acc
    | n + 1, acc => go n (acc * (n + 1))

-- Exercise 2
def sumArray (xs : Array Nat) : Nat :=
  xs.foldl (. + .) 0

-- Exercise 3
def benchmarkN (label : String) (n : Nat) (action : IO Unit) :
    IO Unit := do
  let start <- IO.monoMsNow
  for _ in List.range n do
    action
  let elapsed <- IO.monoMsNow
  let avg := (elapsed - start).toFloat / n.toFloat
  IO.println s!"{label}: {avg}ms avg over {n} runs"

-- Exercise 4
def reverseImpl (xs : List alpha) : List alpha :=
  go [] xs
where
  go (acc : List alpha) : List alpha -> List alpha
    | [] => acc
    | x :: xs => go (x :: acc) xs

-- Exercise 5
def buildString (parts : Array String) : String :=
  -- Use String.join which is optimized
  String.join parts.toList

-- Exercise 6
def fibMemo (n : Nat) : Nat :=
  let arr := go (n + 1) 0 #[]
  arr[n]!
where
  go (target idx : Nat) (arr : Array Nat) : Array Nat :=
    if idx >= target then arr
    else
      let val := match idx with
        | 0 => 0
        | 1 => 1
        | i => arr[i - 1]! + arr[i - 2]!
      go target (idx + 1) (arr.push val)

-- Exercise 7
def benchArrayVsList (n : Nat) : IO Unit := do
  -- Array
  let start1 <- IO.monoMsNow
  let mut arr : Array Nat := #[]
  for i in List.range n do
    arr := arr.push i
  let elapsed1 <- IO.monoMsNow

  -- List (build reversed, then reverse)
  let start2 <- IO.monoMsNow
  let mut lst : List Nat := []
  for i in List.range n do
    lst := i :: lst
  let _reversed := lst.reverse
  let elapsed2 <- IO.monoMsNow

  IO.println s!"Array.push x{n}: {elapsed1 - start1}ms"
  IO.println s!"List.cons  x{n}: {elapsed2 - start2}ms"
