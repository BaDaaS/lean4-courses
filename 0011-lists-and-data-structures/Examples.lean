/-
# 0011 - Lists and Data Structures Examples

Code examples from the README, wrapped in anchors for injection.
-/

import Std

namespace Course0011Examples

-- #anchor: list_basics
-- List is defined as:
-- inductive List (alpha : Type) where
--   | nil : List alpha
--   | cons (head : alpha) (tail : List alpha) : List alpha

-- Sugar: [] for nil, x :: xs for cons, [1, 2, 3] for cons 1 (cons 2 (cons 3 nil))

#eval [1, 2, 3].map (. * 2)       -- [2, 4, 6]
#eval [1, 2, 3].filter (. > 1)    -- [2, 3]
#eval [1, 2, 3].foldl (. + .) 0   -- 6
#eval [1, 2, 3] ++ [4, 5]         -- [1, 2, 3, 4, 5]
#eval [1, 2, 3].reverse            -- [3, 2, 1]
#eval [1, 2, 3].length             -- 3
-- #end

-- #anchor: map_id_proof
theorem map_id {alpha : Type} (xs : List alpha) : xs.map id = xs := by
  induction xs with
  | nil => rfl
  | cons x xs ih => simp [List.map, ih]
-- #end

-- #anchor: array_basics
def arr : Array Nat := #[1, 2, 3, 4, 5]
#eval arr[2]       -- 3
#eval arr.size     -- 5
#eval arr.push 6   -- #[1, 2, 3, 4, 5, 6]
-- #end

-- #anchor: hashmap_basics
def m : Std.HashMap String Nat :=
  let h : Std.HashMap String Nat := {}
  let h := h.insert "alice" 30
  h.insert "bob" 25

#eval m["alice"]?  -- some 30
-- #end

end Course0011Examples
