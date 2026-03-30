# 0028 - Elaboration and Unification

## Goal

Understand how Lean's elaborator works: type inference, metavariable
resolution, and unification. Debug elaboration failures.

## Metavariables

When Lean encounters an unknown, it creates a metavariable:

```lean
-- When you write:
def f := List.map (. + 1) [1, 2, 3]

-- Lean sees List.map (?f) (?xs) and creates metavariables
-- ?f : ?alpha -> ?beta
-- ?xs : List ?alpha
-- Then unifies: ?alpha = Nat, ?beta = Nat, ?f = (. + 1)
```

## Unification

Unification finds assignments for metavariables that make types match:

```lean
-- Given: f : Nat -> Bool, and goal type List Bool
-- List.map ?f ?xs : List ?beta
-- Unify: ?beta = Bool
-- Then ?f : ?alpha -> Bool
-- From ?xs = [1, 2, 3] : List Nat, unify: ?alpha = Nat
```

### When Unification Fails

```lean
-- This fails because Lean cannot unify Nat with String:
-- def bad : Nat := "hello"
-- Error: type mismatch, String != Nat
```

## Implicit Argument Resolution

```lean
-- @ shows all implicit arguments
#check @List.map  -- {alpha beta : Type} -> (alpha -> beta) -> List alpha -> List beta

-- Lean fills these in by unification:
-- List.map (. + 1) [1, 2, 3]
-- becomes
-- @List.map Nat Nat (. + 1) [1, 2, 3]
```

## Typeclass Resolution

```lean
-- When Lean sees [Add Nat]:
-- 1. Search for an instance of Add Nat
-- 2. Found: instAddNat
-- 3. Insert it as the implicit argument
```

### Resolution Order
1. Local instances (from `variable` or function arguments)
2. Global instances (registered with `instance`)
3. Default instances

## Coercions

```lean
-- Lean inserts coercions automatically:
def f (n : Int) : Int := n + 1
#check f (3 : Nat)  -- Works! Lean inserts Nat -> Int coercion
```

## Debugging Elaboration

```lean
-- Show what Lean elaborated
set_option pp.all true in
#check List.map (. + 1) [1, 2, 3]

-- Show implicit arguments
set_option pp.implicit true in
#check List.map (. + 1) [1, 2, 3]

-- Show universe levels
set_option pp.universes true in
#check Type

-- Trace elaboration
set_option trace.Elab.step true in
def foo := 42
```

## Common Elaboration Errors

### "failed to synthesize instance"
A typeclass instance was not found. Solutions:
- Add the instance
- Make sure the right imports are in place
- Use `@` to provide the instance manually

### "type mismatch"
Two types that should be equal are not. Solutions:
- Check your types with `#check`
- Use `show` to clarify the expected type
- Insert explicit type annotations

### "unknown identifier"
The name is not in scope. Solutions:
- Check imports
- Use the fully qualified name
- Check namespace (open the right namespace)

## Writing Elaboration-Friendly Code

1. Provide type annotations on top-level definitions
2. Use explicit type annotations when Lean struggles
3. Avoid overly clever implicit argument chains
4. Use `@` to debug implicit resolution
5. Keep typeclass hierarchies shallow when possible
