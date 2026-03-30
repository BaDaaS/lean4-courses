/-
# 0000 - Startup Exercises

Replace each `sorry` with the correct definition or proof.
Use `#check` and `#eval` freely to explore.
-/

-- Exercise 1: Define a constant `myName` of type `String`
def myName : String := "Danny"

-- Exercise 2: Define a constant `myAge` of type `Nat`
def myAge : Nat := 5

-- Exercise 3: Define a function that doubles a natural number
def double (n : Nat) : Nat := n + n

-- Exercise 4: Verify that double 5 = 10
#check (rfl : double 5 = 10)  -- This should work once double is correct

-- Exercise 5: Prove that 2 + 2 = 4
theorem two_plus_two : 2 + 2 = 4 := rfl

-- Exercise 6: Define a function that returns true if a number is zero
def isZero (n : Nat) : Bool :=
  match n with
  | 0 => true
  | _ => false

-- simply gets the type of isZero, which is a function from nat to Bool
#check isZero
-- Exercise 7: Use #eval to test your isZero function
-- Uncomment and verify:
#eval isZero 0    -- should be true
-- #eval isZero 42   -- should be false

#check (3, "String")

-- =============================================
-- Additional exercises (increasing difficulty)
-- =============================================

-- Exercise 8 (medium): Define a recursive function to compute n^k (power)
-- Hint: use pattern matching on k. Base case: n^0 = 1
def power (n : Nat) (k : Nat) : Nat := sorry

-- Exercise 9 (medium): Reverse a string
-- Hint: convert to a list of characters with String.toList,
-- reverse it with List.reverse, and convert back with String.ofList
def reverseString (s : String) : String := sorry

-- Verify (uncomment once implemented):
-- #eval reverseString "hello"  -- should be "olleh"

-- Exercise 10 (hard): Compute the nth Fibonacci number
-- fib 0 = 0, fib 1 = 1, fib (n+2) = fib (n+1) + fib n
-- Hint: pattern match on 0, 1, and n + 2
def fib (n : Nat) : Nat := sorry

-- Verify (uncomment once implemented):
-- #eval fib 10  -- should be 55

-- Exercise 11 (challenge): Prove that power 2 3 = 8
-- Once your power function is correct, this should work via rfl
theorem power_two_three : power 2 3 = 8 := sorry
