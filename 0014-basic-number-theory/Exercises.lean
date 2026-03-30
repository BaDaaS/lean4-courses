/-
# 0014 - Basic Number Theory Exercises
-/

-- Exercise 1: Prove that every number divides itself
theorem dvd_refl (n : Nat) : n ∣ n := sorry

-- Exercise 2: Prove that 1 divides everything
theorem one_dvd (n : Nat) : 1 ∣ n := sorry

-- Exercise 3: Prove that everything divides 0
theorem dvd_zero (n : Nat) : n ∣ 0 := sorry

-- Exercise 4: Prove divisibility is transitive
theorem dvd_trans {a b c : Nat}
    (hab : a ∣ b) (hbc : b ∣ c) : a ∣ c := sorry

-- Exercise 5: Prove that if a | b and a | c then a | (b + c)
theorem dvd_add {a b c : Nat}
    (hab : a ∣ b) (hac : a ∣ c) : a ∣ (b + c) := sorry

-- Exercise 6: Implement GCD using the Euclidean algorithm
def myGcd (a b : Nat) : Nat :=
  sorry

-- Exercise 7: Prove a concrete divisibility fact
theorem six_dvd_twelve : 6 ∣ 12 := sorry

-- Exercise 8: Implement a primality checker (Bool, not Prop)
def isPrimeCheck (n : Nat) : Bool := sorry

-- #eval isPrimeCheck 2    -- true
-- #eval isPrimeCheck 7    -- true
-- #eval isPrimeCheck 10   -- false

-- Exercise 9: Prove that 0 + n = n using omega
theorem zero_plus (n : Nat) : 0 + n = n := by
  sorry

-- Exercise 10 (challenge): Prove that if n > 0 then n * m / n = m
-- Hint: use Nat.mul_div_cancel
theorem mul_div_cancel_left (n m : Nat) (h : n > 0) :
    n * m / n = m := by
  sorry

-- Exercise 11 (medium): Prove that if a divides b then a divides
-- (b * c) for any natural number c.
theorem dvd_mul_of_dvd {a b : Nat} (c : Nat)
    (h : a ∣ b) : a ∣ (b * c) := sorry

-- Exercise 12 (hard): Implement the extended Euclidean algorithm.
-- Given a and b, return (gcd, x, y) as a triple of integers where
-- gcd = gcd(a,b) and a * x + b * y = gcd.
def extGcdFull : Nat -> Nat -> (Int × Int × Int) := sorry

-- Exercise 13 (hard): Prove a concrete instance of Bezout's identity.
-- Show that 6 * 1 + 4 * (-1) = 2.
theorem bezout_6_4 : (6 : Int) * 1 + 4 * (-1) = 2 := by sorry

-- Exercise 14 (challenge): Prove multiple GCD facts using decide.
-- Compute gcd(12,8) = 4, gcd(15,10) = 5, and gcd(100,75) = 25.
theorem gcd_facts :
    Nat.gcd 12 8 = 4 /\
    Nat.gcd 15 10 = 5 /\
    Nat.gcd 100 75 = 25 := sorry
