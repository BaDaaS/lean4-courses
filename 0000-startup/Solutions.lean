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

end Course0000
