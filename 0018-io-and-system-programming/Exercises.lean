/-
# 0018 - IO and System Programming Exercises

These exercises produce actual executables. Create a Lake project
to build and run them.
-/

-- Exercise 1: Hello World executable
-- Write a main function that prints "Hello, Lean 4!"
def ex1_main : IO Unit := do
  sorry

-- Exercise 2: Echo program
-- Read a line from stdin and print it back
def ex2_echo : IO Unit := do
  sorry

-- Exercise 3: File reader
-- Read a file path from the command line and print its contents
def ex3_cat (args : List String) : IO Unit := do
  sorry

-- Exercise 4: Line counter
-- Count the number of lines in a file
def countLines (path : String) : IO Nat := do
  sorry

-- Exercise 5: Simple grep
-- Search for a pattern in a file, print matching lines
def simpleGrep (pattern : String) (path : String) : IO Unit := do
  sorry

-- Exercise 6: Environment variable printer
-- Print all environment variables (or a specific one)
def printEnv (key : Option String) : IO Unit := do
  sorry

-- Exercise 7: File copier
-- Copy the contents of one file to another
def copyFile (src dst : String) : IO Unit := do
  sorry

-- Exercise 8: Timer
-- Measure how long a computation takes
def timed (action : IO alpha) : IO (alpha x Nat) := do
  sorry

-- Exercise 9: Write a simple REPL
-- Read a line, evaluate it as a Nat expression, print result, repeat
-- Type "quit" to exit
def repl : IO Unit := do
  sorry
