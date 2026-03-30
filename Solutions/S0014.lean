/-
# 0014 - Basic Number Theory Solutions
-/

namespace S0014

-- Exercise 1
theorem dvd_refl (n : Nat) : n ∣ n := ⟨1, by omega⟩

-- Exercise 2
theorem one_dvd (n : Nat) : 1 ∣ n := ⟨n, by omega⟩

-- Exercise 3
theorem dvd_zero (n : Nat) : n ∣ 0 := ⟨0, by omega⟩

-- Exercise 4
theorem dvd_trans {a b c : Nat} (hab : a ∣ b) (hbc : b ∣ c) :
    a ∣ c := by
  obtain ⟨k1, hk1⟩ := hab
  obtain ⟨k2, hk2⟩ := hbc
  exact ⟨k1 * k2, by subst hk1; subst hk2; exact Nat.mul_assoc a k1 k2⟩

-- Exercise 5
theorem dvd_add {a b c : Nat} (hab : a ∣ b) (hac : a ∣ c) :
    a ∣ (b + c) := by
  obtain ⟨k1, hk1⟩ := hab
  obtain ⟨k2, hk2⟩ := hac
  exact ⟨k1 + k2, by subst hk1; subst hk2; exact Nat.left_distrib a k1 k2⟩

-- Exercise 6
def myGcd (a b : Nat) : Nat :=
  if h : b = 0 then a
  else
    have : a % b < b := Nat.mod_lt a (Nat.pos_of_ne_zero h)
    myGcd b (a % b)
termination_by b

-- Exercise 7
theorem six_dvd_twelve : 6 ∣ 12 := ⟨2, rfl⟩

-- Exercise 8: Simple primality check using fuel-based recursion
def isPrimeCheck (n : Nat) : Bool :=
  if n < 2 then false
  else go n 2
where
  go (n d : Nat) : Bool :=
    if d * d > n then true
    else if n % d == 0 then false
    else go n (d + 1)
  decreasing_by
    simp_all [Nat.not_lt]
    omega

#eval isPrimeCheck 2    -- true
#eval isPrimeCheck 7    -- true
#eval isPrimeCheck 10   -- false

-- Exercise 9
theorem zero_plus (n : Nat) : 0 + n = n := by omega

-- Exercise 10
theorem mul_div_cancel_left (n m : Nat) (h : n > 0) :
    n * m / n = m := by
  exact Nat.mul_div_cancel_left m h

end S0014
