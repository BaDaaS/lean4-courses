# 0014 - Basic Number Theory

## Goal

Prove basic number theory facts: divisibility, primes, modular
arithmetic. Combine tactics and term-mode proofs.

## Divisibility

```lean
-- a divides b means there exists k such that b = a * k
-- In Lean: a | b is notation for Dvd.dvd a b

example : 3 | 12 := ⟨4, rfl⟩
```

## Modular Arithmetic

```lean
#eval 17 % 5    -- 2
#eval 10 % 3    -- 1

-- ZMod n is the type of integers modulo n (from Mathlib)
```

## Key Lemmas (from Lean's stdlib)

```lean
-- Nat.dvd_refl : n | n
-- Nat.dvd_trans : a | b -> b | c -> a | c
-- Nat.dvd_add : a | b -> a | c -> a | (b + c)
-- Nat.dvd_mul_right : a | a * b
-- Nat.mod_def : a % b = a - b * (a / b)
```

## Primality

```lean
-- A number is prime if it is > 1 and has no divisors other than 1 and itself
def isPrime (n : Nat) : Prop :=
  n > 1 /\ forall m, m | n -> m = 1 \/ m = n
```

## Math Track

Number theory is one of the richest areas of Mathlib. Divisibility,
GCD, Bezout's identity, the fundamental theorem of arithmetic, and
modular arithmetic are all formalized. These exercises give you a taste.

## CS Track

Number theory algorithms (GCD, modular exponentiation, primality
testing) are foundational in cryptography. Lean lets you prove these
algorithms correct, not just test them.
