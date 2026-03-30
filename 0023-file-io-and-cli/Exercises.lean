/-
# 0022 - File IO and CLI Tools Exercises

Build these as actual Lake projects with executables.
-/

/-
## Exercise 1: head (print first N lines of a file)

Usage: myhead -n 10 file.txt
Default: 10 lines
-/

/-
## Exercise 2: tail (print last N lines of a file)

Usage: mytail -n 10 file.txt
-/

/-
## Exercise 3: find (list files matching a pattern)

Usage: myfind /path --name "*.lean"
Recursively walk directories and print matching file paths.
-/

/-
## Exercise 4: uniq (remove duplicate consecutive lines)

Usage: myuniq file.txt
Read from stdin if no file given.
With -c flag, prefix lines with count.
-/

/-
## Exercise 5: sort (sort lines of a file)

Usage: mysort file.txt
Flags: -r (reverse), -n (numeric sort)
-/

/-
## Exercise 6: CSV processor

Usage: mycsv file.csv --column 2 --filter "value"
Read a CSV, filter rows, and print selected columns.
-/

/-
## Exercise 7: Build a mini task runner

Read a TOML-like config file:
  [build]
  cmd = "lake build"

  [test]
  cmd = "lake test"

  [clean]
  cmd = "lake clean"

Usage: run build
       run test
       run --list
-/
