/-
# 0000 - Startup Solutions
-/

namespace Course0000

-- Exercise 1
def myName : String := "Ada Lovelace"

-- Exercise 2
def myAge : Nat := 30

-- Exercise 3
def double (n : Nat) : Nat := 2 * n

-- Exercise 4
#check (rfl : double 5 = 10)

-- Exercise 5
theorem two_plus_two : 2 + 2 = 4 := rfl

-- Exercise 6
def isZero (n : Nat) : Bool :=
  match n with
  | 0 => true
  | _ => false

-- Exercise 7
#eval isZero 0    -- true
#eval isZero 42   -- false

-- =============================================
-- Additional exercises (increasing difficulty)
-- =============================================

-- Exercise 8 (medium): Recursive power function
def power (n : Nat) (k : Nat) : Nat :=
  match k with
  | 0 => 1
  | k + 1 => n * power n k

#eval power 2 10  -- 1024

-- Exercise 9 (medium): Reverse a string
def reverseString (s : String) : String :=
  String.ofList (s.toList.reverse)

#eval reverseString "hello"  -- "olleh"

-- Exercise 10 (hard): Fibonacci
def fib (n : Nat) : Nat :=
  match n with
  | 0 => 0
  | 1 => 1
  | n + 2 => fib (n + 1) + fib n

#eval fib 10  -- 55

-- Exercise 11 (challenge): Prove power 2 3 = 8
theorem power_two_three : power 2 3 = 8 := rfl

end Course0000
