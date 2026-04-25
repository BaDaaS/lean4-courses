/-
# 0010 - Natural Numbers and Induction Examples

Code examples from the README, wrapped in anchors for injection.
-/

namespace Course0010Examples

-- #anchor: add_zero_induction
theorem add_zero (n : Nat) : n + 0 = n := by
  induction n with
  | zero => rfl
  | succ n ih => simp [Nat.succ_add, ih]
-- #end

-- #anchor: zero_add_induction
theorem zero_add (n : Nat) : 0 + n = n := by
  induction n with
  | zero => rfl
  | succ n ih =>
    -- ih : 0 + n = n
    -- goal : 0 + (n + 1) = n + 1
    rw [Nat.add_succ, ih]
-- #end

end Course0010Examples
