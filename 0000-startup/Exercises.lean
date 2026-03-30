/-
# 0000 - Startup Exercises

Replace each `sorry` with the correct definition or proof.
Use `#check` and `#eval` freely to explore.
-/

-- Exercise 1: Define a constant `myName` of type `String`
def myName : String := sorry

-- Exercise 2: Define a constant `myAge` of type `Nat`
def myAge : Nat := sorry

-- Exercise 3: Define a function that doubles a natural number
def double (n : Nat) : Nat := sorry

-- Exercise 4: Verify that double 5 = 10
#check (rfl : double 5 = 10)  -- This should work once double is correct

-- Exercise 5: Prove that 2 + 2 = 4
theorem two_plus_two : 2 + 2 = 4 := sorry

-- Exercise 6: Define a function that returns true if a number is zero
def isZero (n : Nat) : Bool := sorry

-- Exercise 7: Use #eval to test your isZero function
-- Uncomment and verify:
-- #eval isZero 0    -- should be true
-- #eval isZero 42   -- should be false
