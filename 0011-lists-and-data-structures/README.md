# 0011 - Lists and Data Structures

## Goal

Work with lists and other functional data structures. Prove properties
about list operations using induction.

## List Basics

```lean
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
```

## Proving List Properties

```lean
theorem map_id (xs : List alpha) : xs.map id = xs := by
  induction xs with
  | nil => rfl
  | cons x xs ih => simp [List.map, ih]
```

## Other Data Structures

### Array (efficient random access)

```lean
def arr : Array Nat := #[1, 2, 3, 4, 5]
#eval arr[2]       -- 3
#eval arr.size     -- 5
#eval arr.push 6   -- #[1, 2, 3, 4, 5, 6]
```

### HashMap

```lean
def m : Std.HashMap String Nat := Std.HashMap.empty
  |>.insert "alice" 30
  |>.insert "bob" 25

#eval m.find? "alice"  -- some 30
```

## Math Track

Lists model finite sequences. Properties like associativity of append,
length preservation under map, and commutativity of certain operations
are proved by structural induction on the list.

## CS Track

Lists are the fundamental functional data structure. While Arrays
provide O(1) access, Lists provide O(1) cons and pattern matching.
Choose based on access patterns.
