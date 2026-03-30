/-
# 0014 - Basic Number Theory Solutions
-/

namespace Course0014

-- Exercise 1
theorem dvd_refl (n : Nat) : n ∣ n := ⟨1, by omega⟩

-- Exercise 2
theorem one_dvd (n : Nat) : 1 ∣ n := ⟨n, by omega⟩

-- Exercise 3
theorem dvd_zero (n : Nat) : n ∣ 0 := ⟨0, by omega⟩

-- Exercise 4
theorem dvd_trans {a b c : Nat}
    (hab : a ∣ b) (hbc : b ∣ c) : a ∣ c := by
  obtain ⟨k1, hk1⟩ := hab
  obtain ⟨k2, hk2⟩ := hbc
  subst hk1
  rw [Nat.mul_assoc] at hk2
  exact ⟨k1 * k2, hk2⟩

-- Exercise 5
theorem dvd_add {a b c : Nat}
    (hab : a ∣ b) (hac : a ∣ c) : a ∣ (b + c) := by
  obtain ⟨k1, hk1⟩ := hab
  obtain ⟨k2, hk2⟩ := hac
  subst hk1; subst hk2
  exact ⟨k1 + k2, by rw [Nat.mul_add]⟩

-- Exercise 6
def myGcd (a b : Nat) : Nat :=
  if _h : b = 0 then a
  else myGcd b (a % b)
termination_by b
decreasing_by
  exact Nat.mod_lt a (by omega)

-- Exercise 7
theorem six_dvd_twelve : 6 ∣ 12 := ⟨2, rfl⟩

-- Exercise 8
-- We use a fuel-based approach to avoid termination issues
-- with nonlinear arithmetic.
def isPrimeCheck (n : Nat) : Bool :=
  if n < 2 then false
  else go n 2 n
where
  go (n d fuel : Nat) : Bool :=
    match fuel with
    | 0 => true
    | fuel' + 1 =>
      if d * d > n then true
      else if n % d == 0 then false
      else go n (d + 1) fuel'

#eval isPrimeCheck 2    -- true
#eval isPrimeCheck 7    -- true
#eval isPrimeCheck 10   -- false

-- Exercise 9
theorem zero_plus (n : Nat) : 0 + n = n := by omega

-- Exercise 10
theorem mul_div_cancel_left (n m : Nat) (h : n > 0) :
    n * m / n = m := by
  exact Nat.mul_div_cancel_left m h

-- Exercise 11 (medium): dvd_mul_of_dvd
theorem dvd_mul_of_dvd {a b : Nat} (c : Nat)
    (h : a ∣ b) : a ∣ (b * c) := by
  obtain ⟨k, hk⟩ := h
  subst hk
  exact ⟨k * c, by rw [Nat.mul_assoc]⟩

-- Exercise 12 (hard): Extended Euclidean algorithm
-- Returns (gcd, x, y) as a triple of integers
def extGcdFull : Nat -> Nat -> (Int × Int × Int)
  | a, 0 => (a, 1, 0)
  | a, b + 1 =>
    let r := a % (b + 1)
    let result := extGcdFull (b + 1) r
    (result.1, result.2.2,
     result.2.1 - (a / (b + 1) : Int) * result.2.2)
termination_by _ b => b
decreasing_by
  simp_all
  exact Nat.mod_lt a (by omega)

-- Exercise 13 (hard): Bezout's identity for 6 and 4
theorem bezout_6_4 : (6 : Int) * 1 + 4 * (-1) = 2 := by
  decide

-- Exercise 14 (challenge): Prove multiple GCD facts using decide
-- and a divisibility chain.
theorem gcd_facts :
    Nat.gcd 12 8 = 4 /\
    Nat.gcd 15 10 = 5 /\
    Nat.gcd 100 75 = 25 := by
  exact ⟨by decide, by decide, by decide⟩

end Course0014
