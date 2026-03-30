/-
# 0019 - Compiled Programs Exercises

For these exercises, create actual Lake projects and build them.
Instructions for each exercise describe the project to create.
-/

/-
## Exercise 1: Hello World Project

Create a Lake project called "hello" with:
- A Main.lean that prints "Hello from a compiled Lean program!"
- Build and run it

Commands:
  lake init hello
  cd hello
  lake build
  ./build/bin/hello
-/

/-
## Exercise 2: Multi-File Calculator

Create a project "calc" with:
- Calc/Parser.lean: parse string to arithmetic expression
- Calc/Eval.lean: evaluate expressions
- Main.lean: read from stdin, parse, evaluate, print result

Structure:
  calc/
    lakefile.lean
    Main.lean
    Calc/
      Parser.lean
      Eval.lean
    Calc.lean
-/

/-
## Exercise 3: Word Counter (like wc)

Build a command-line tool that:
- Accepts file paths as arguments
- Prints line count, word count, and character count for each file
- Prints totals if multiple files given
-/

/-
## Exercise 4: JSON Pretty Printer

Build a tool that:
- Reads JSON from stdin or a file
- Pretty-prints it with indentation
- Define your own simple JSON type and parser
-/

/-
## Exercise 5: File Deduplicator

Build a tool that:
- Takes a directory path as argument
- Finds files with identical content (by hashing)
- Reports duplicate groups
- Hint: use IO.Process.output to call system commands
  or implement a simple hash function
-/

/-
## Exercise 6: Project with a Library and an Executable

Create a project that:
- Has a library (MyLib) with utility functions
- Has an executable that uses the library
- The library exports: string reversal, palindrome check, Caesar cipher
- The executable provides a CLI interface to these functions
-/
