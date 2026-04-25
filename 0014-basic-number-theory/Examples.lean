/-
# 0014 - Basic Number Theory Examples

Code examples from the README, wrapped in anchors for injection.
-/

namespace Course0014Examples

-- #anchor: modular_arithmetic
#eval 17 % 5    -- 2
#eval 10 % 3    -- 1

-- ZMod n is the type of integers modulo n (from Mathlib)
-- #end

-- #anchor: is_prime
-- A number is prime if it is > 1 and has no divisors other than 1 and itself
def isPrime (n : Nat) : Prop :=
  n > 1 /\ forall m, Dvd.dvd m n -> m = 1 \/ m = n
-- #end

end Course0014Examples
