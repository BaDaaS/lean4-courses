/-
# 0020 - FFI and C Interop Exercises

These exercises require creating C files alongside Lean files.
Create a Lake project for each exercise.
-/

/-
## Exercise 1: Basic FFI

Create a C function that computes factorial and call it from Lean.

C side (c/ffi.c):
  uint64_t lean_c_factorial(uint64_t n);

Lean side:
  @[extern "lean_c_factorial"]
  opaque cFactorial (n : UInt64) : UInt64
-/

/-
## Exercise 2: String FFI

Create a C function that converts a string to uppercase.

C side: takes a lean_obj_arg (String), returns lean_obj_res (String)
Lean side: opaque toUpper (s : @& String) : String
-/

/-
## Exercise 3: Wrap a System Library

Wrap the C standard library's time functions:
- Get current time as a Nat (seconds since epoch)
- Format a timestamp as a string

Hint: use time() and ctime() from <time.h>
-/

/-
## Exercise 4: Opaque Type for File Handle

Create an opaque type wrapping a C FILE*.
Implement: open, read line, write line, close.

This teaches the pattern used in real Lean libraries for
wrapping C resources.
-/

/-
## Exercise 5: Performance Comparison

Implement matrix multiplication in both pure Lean and C FFI.
Benchmark both on a 100x100 matrix multiplication.
Compare the performance.
-/

/-
## Exercise 6: SQLite Binding (Mini)

Create a minimal SQLite binding:
- Open/close a database
- Execute a simple query
- Read results

This is a realistic systems programming exercise.
Requires: sqlite3 development headers installed.
-/
