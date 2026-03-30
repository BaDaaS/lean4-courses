/-
# 0029 - Elaboration and Unification Solutions
-/

namespace Course0029

-- Exercise 1: Define a simple Type system
inductive Ty where
  | tvar (name : String) : Ty
  | tarrow (dom : Ty) (cod : Ty) : Ty
  | tnat : Ty
  | tbool : Ty
deriving Repr, BEq

-- Exercise 2: Define substitution on types
-- Replace all occurrences of (tvar name) with the replacement type.
def Ty.substVar (t : Ty) (name : String) (replacement : Ty) : Ty :=
  match t with
  | .tvar n => if n == name then replacement else .tvar n
  | .tarrow dom cod =>
    .tarrow (dom.substVar name replacement)
            (cod.substVar name replacement)
  | .tnat => .tnat
  | .tbool => .tbool

-- A substitution maps variable names to types
abbrev Subst := List (String × Ty)

def applySubst (s : Subst) (t : Ty) : Ty :=
  s.foldl (fun acc (name, replacement) =>
    acc.substVar name replacement) t

-- Exercise 3: Implement occurs check
-- Does variable with the given name appear anywhere in the type?
def occursIn (name : String) : Ty -> Bool
  | .tvar n => n == name
  | .tarrow dom cod => occursIn name dom || occursIn name cod
  | .tnat => false
  | .tbool => false

-- Compose two substitutions: apply s2 after s1
def composeSubst (s1 s2 : Subst) : Subst :=
  s1.map (fun (n, t) => (n, applySubst s2 t)) ++ s2

-- Size of a type (for termination of unification)
def Ty.size : Ty -> Nat
  | .tvar _ => 1
  | .tnat => 1
  | .tbool => 1
  | .tarrow d c => 1 + d.size + c.size

-- Exercise 4: Implement unification of two types
-- Returns Option Subst (a most general unifier).
-- We use a fuel parameter to guarantee termination.
-- In a real implementation you would prove a size measure decreases.
def unifyAux (fuel : Nat) (t1 t2 : Ty) : Option Subst :=
  match fuel with
  | 0 => none
  | fuel' + 1 =>
    match t1, t2 with
    | .tnat, .tnat => some []
    | .tbool, .tbool => some []
    | .tvar x, .tvar y =>
      if x == y then some []
      else some [(x, .tvar y)]
    | .tvar x, t =>
      if occursIn x t then none
      else some [(x, t)]
    | t, .tvar x =>
      if occursIn x t then none
      else some [(x, t)]
    | .tarrow d1 c1, .tarrow d2 c2 =>
      match unifyAux fuel' d1 d2 with
      | none => none
      | some s1 =>
        match unifyAux fuel' (applySubst s1 c1)
            (applySubst s1 c2) with
        | none => none
        | some s2 => some (composeSubst s1 s2)
    | _, _ => none

def unify (t1 t2 : Ty) : Option Subst :=
  unifyAux (t1.size + t2.size + 10) t1 t2

-- Exercise 5: Define typing contexts and typing judgments
abbrev TypingCtx := List (String × Ty)

def ctxLookup (ctx : TypingCtx) (name : String) : Option Ty :=
  match ctx with
  | [] => none
  | (n, t) :: rest =>
    if n == name then some t
    else ctxLookup rest name

-- Simple expression type for STLC
inductive Expr where
  | evar (name : String) : Expr
  | eapp (fn : Expr) (arg : Expr) : Expr
  | elam (param : String) (paramTy : Ty) (body : Expr) : Expr
  | elit (val : Nat) : Expr
  | ebool (val : Bool) : Expr
deriving Repr

-- Exercise 6: Implement a simple type inference algorithm for STLC
-- This is a bidirectional-style checker: lambdas have type annotations.
def infer (ctx : TypingCtx) : Expr -> Option Ty
  | .evar name => ctxLookup ctx name
  | .elit _ => some .tnat
  | .ebool _ => some .tbool
  | .elam param paramTy body =>
    match infer ((param, paramTy) :: ctx) body with
    | some bodyTy => some (.tarrow paramTy bodyTy)
    | none => none
  | .eapp fn arg =>
    match infer ctx fn, infer ctx arg with
    | some (.tarrow dom cod), some argTy =>
      if dom == argTy then some cod else none
    | _, _ => none

-- Tests
#eval Ty.tvar "a" |>.substVar "a" .tnat  -- tnat
#eval occursIn "a" (.tarrow (.tvar "a") .tnat)  -- true
#eval occursIn "b" (.tarrow (.tvar "a") .tnat)  -- false
#eval unify (.tarrow (.tvar "a") .tnat) (.tarrow .tbool .tnat)
-- some [("a", tbool)]
#eval infer [] (.elam "x" .tnat (.evar "x"))
-- some (tarrow tnat tnat)
#eval infer [] (.eapp (.elam "x" .tnat (.evar "x")) (.elit 5))
-- some tnat

end Course0029
