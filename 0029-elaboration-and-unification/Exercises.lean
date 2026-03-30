/-
# 0029 - Elaboration and Unification Exercises
-/

namespace Course0029E

-- Exercise 1: Define a simple Type system
-- Constructors: TVar (name), TArrow (domain, codomain), TNat, TBool
inductive Ty where
  | tvar (name : String) : Ty
  | tarrow (dom : Ty) (cod : Ty) : Ty
  | tnat : Ty
  | tbool : Ty
deriving Repr, BEq

-- Exercise 2: Define substitution on types
-- Replace all occurrences of (tvar name) with the replacement type.
def Ty.substVar (t : Ty) (name : String) (replacement : Ty) : Ty :=
  sorry

-- A substitution is a list of (variable name, replacement type) pairs.
abbrev Subst := List (String × Ty)

-- Apply a full substitution to a type (fold over the pairs).
def applySubst (s : Subst) (t : Ty) : Ty := sorry

-- Exercise 3: Implement occurs check
-- Return true if the variable with the given name appears in the type.
-- This is needed to prevent infinite types during unification.
def occursIn (name : String) : Ty -> Bool := sorry

-- Compose two substitutions: apply s2 after s1
def composeSubst (s1 s2 : Subst) : Subst :=
  s1.map (fun (n, t) => (n, applySubst s2 t)) ++ s2

-- Size of a type (used as fuel for termination)
def Ty.size : Ty -> Nat
  | .tvar _ => 1
  | .tnat => 1
  | .tbool => 1
  | .tarrow d c => 1 + d.size + c.size

-- Exercise 4: Implement unification of two types
-- Given two types, return a most general unifier (as Option Subst).
-- Return none if the types cannot be unified.
-- We use a fuel parameter to guarantee termination.
-- For arrows, unify domains first, apply resulting substitution to
-- codomains, then unify those.
def unifyAux (fuel : Nat) (t1 t2 : Ty) : Option Subst := sorry

def unify (t1 t2 : Ty) : Option Subst :=
  unifyAux (t1.size + t2.size + 10) t1 t2

-- Exercise 5: Define typing contexts and typing judgments
-- A typing context maps variable names to types.
abbrev TypingCtx := List (String × Ty)

-- Look up a variable name in the context.
def ctxLookup (ctx : TypingCtx) (name : String) : Option Ty :=
  sorry

-- Simple expression type for STLC (with type annotations on lambdas)
inductive Expr where
  | evar (name : String) : Expr
  | eapp (fn : Expr) (arg : Expr) : Expr
  | elam (param : String) (paramTy : Ty) (body : Expr) : Expr
  | elit (val : Nat) : Expr
  | ebool (val : Bool) : Expr
deriving Repr

-- Exercise 6: Implement a simple type inference algorithm for STLC
-- Since lambdas carry type annotations, this is straightforward:
-- - Variables: look up in context
-- - Literals: Nat or Bool
-- - Lambda: check body with param added to context, return arrow type
-- - Application: infer fn type, check it is an arrow, check arg matches domain
def infer (ctx : TypingCtx) : Expr -> Option Ty := sorry

-- Test: infer [] (elam "x" tnat (evar "x")) should give some (tarrow tnat tnat)
-- Test: infer [] (eapp (elam "x" tnat (evar "x")) (elit 5)) should give some tnat

end Course0029E
