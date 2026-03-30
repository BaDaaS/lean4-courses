/-
# 0028 - Lean Internals Solutions
-/

namespace Course0028

-- Exercise 1: Define a simplified Expr type using de Bruijn indices
-- var n refers to the variable bound n lambdas up
-- app is function application
-- lam is lambda abstraction (no variable name needed with de Bruijn)
-- lit is a natural number literal
inductive Expr where
  | var (index : Nat) : Expr
  | app (fn : Expr) (arg : Expr) : Expr
  | lam (body : Expr) : Expr
  | lit (val : Nat) : Expr
deriving Repr, BEq

-- Exercise 2: Implement substitution on Expr
-- shift increases free variable indices by the given amount
-- Free variables are those with index >= cutoff
def shift (cutoff : Nat) (amount : Int) : Expr -> Expr
  | .var idx =>
    if idx >= cutoff then
      .var (Int.toNat (Int.ofNat idx + amount))
    else
      .var idx
  | .app fn arg => .app (shift cutoff amount fn) (shift cutoff amount arg)
  | .lam body => .lam (shift (cutoff + 1) amount body)
  | .lit v => .lit v

-- subst replaces variable at index 0 with the given expression
-- and decrements all other free variables
def subst (target : Expr) (replacement : Expr) : Expr :=
  go 0 target
where
  go (depth : Nat) : Expr -> Expr
    | .var idx =>
      if idx == depth then shift 0 (Int.ofNat depth) replacement
      else if idx > depth then .var (idx - 1)
      else .var idx
    | .app fn arg => .app (go depth fn) (go depth arg)
    | .lam body => .lam (go (depth + 1) body)
    | .lit v => .lit v

-- Exercise 3: Implement a simple beta-reduction step
-- Reduces the leftmost-outermost redex, if any
def betaStep : Expr -> Option Expr
  | .app (.lam body) arg => some (subst body arg)
  | .app fn arg =>
    match betaStep fn with
    | some fn' => some (.app fn' arg)
    | none =>
      match betaStep arg with
      | some arg' => some (.app fn arg')
      | none => none
  | .lam body =>
    match betaStep body with
    | some body' => some (.lam body')
    | none => none
  | _ => none

-- Exercise 4: Implement a type checker for simply-typed lambda calculus
inductive Ty where
  | nat : Ty
  | arrow (dom : Ty) (cod : Ty) : Ty
deriving Repr, BEq

-- A typing context is a list of types, indexed by de Bruijn index
abbrev Ctx := List Ty

def lookupCtx (ctx : Ctx) (idx : Nat) : Option Ty :=
  match ctx, idx with
  | [], _ => none
  | t :: _, 0 => some t
  | _ :: rest, n + 1 => lookupCtx rest n

-- Type check: given a context and an expression, return its type
def typeCheck (ctx : Ctx) : Expr -> Option Ty
  | .var idx => lookupCtx ctx idx
  | .lit _ => some .nat
  | .lam body =>
    -- Without type annotations on lambda, we cannot infer.
    -- We use a convention: lam always introduces a Nat-typed variable.
    match typeCheck (.nat :: ctx) body with
    | some bodyTy => some (.arrow .nat bodyTy)
    | none => none
  | .app fn arg =>
    match typeCheck ctx fn, typeCheck ctx arg with
    | some (.arrow dom cod), some argTy =>
      if dom == argTy then some cod else none
    | _, _ => none

-- Exercise 5: Define a simplified Environment type
structure EnvEntry where
  name : String
  expr : Expr
  ty : Option Ty
deriving Repr

abbrev Env := List EnvEntry

-- Exercise 6: Implement lookup and extension of the environment
def envLookup (env : Env) (name : String) : Option EnvEntry :=
  match env with
  | [] => none
  | e :: rest =>
    if e.name == name then some e
    else envLookup rest name

def envExtend (env : Env) (name : String) (expr : Expr)
    (ty : Option Ty) : Env :=
  { name := name, expr := expr, ty := ty } :: env

-- Tests
#eval Expr.lam (.var 0)  -- identity function
#eval betaStep (.app (.lam (.var 0)) (.lit 42))  -- should reduce to lit 42
#eval typeCheck [] (.lit 5)  -- some Ty.nat
#eval typeCheck [] (.lam (.var 0))  -- some (arrow nat nat)
#eval envLookup (envExtend [] "x" (.lit 1) (some .nat)) "x"

end Course0028
