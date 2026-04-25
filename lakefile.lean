import Lake
open Lake DSL

package lean4courses where
  leanOptions := #[
    ⟨`autoImplicit, false⟩
  ]

-- Each course's Solutions.lean is a standalone module
-- named Course00XX inside a namespace

@[default_target]
lean_lib Course0000 where
  srcDir := "0000-startup"
  roots := #[`Solutions, `Examples]

lean_lib Course0001 where
  srcDir := "0001-types"
  roots := #[`Solutions, `Examples]

lean_lib Course0002 where
  srcDir := "0002-functions"
  roots := #[`Solutions, `Examples]

lean_lib Course0003 where
  srcDir := "0003-propositions-and-proofs"
  roots := #[`Solutions, `Examples]

lean_lib Course0004 where
  srcDir := "0004-tactics"
  roots := #[`Solutions, `Examples]

lean_lib Course0005 where
  srcDir := "0005-inductive-types"
  roots := #[`Solutions, `Examples]

lean_lib Course0006 where
  srcDir := "0006-structures-and-typeclasses"
  roots := #[`Solutions]

lean_lib Course0007 where
  srcDir := "0007-monads-and-do-notation"
  roots := #[`Solutions]

lean_lib Course0008 where
  srcDir := "0008-pattern-matching-and-recursion"
  roots := #[`Solutions]

lean_lib Course0009 where
  srcDir := "0009-dependent-types"
  roots := #[`Solutions]

lean_lib Course0010 where
  srcDir := "0010-natural-numbers-and-induction"
  roots := #[`Solutions]

lean_lib Course0011 where
  srcDir := "0011-lists-and-data-structures"
  roots := #[`Solutions]

lean_lib Course0012 where
  srcDir := "0012-finite-types-and-decidability"
  roots := #[`Solutions]

lean_lib Course0013 where
  srcDir := "0013-algebraic-structures"
  roots := #[`Solutions]

lean_lib Course0014 where
  srcDir := "0014-basic-number-theory"
  roots := #[`Solutions]

lean_lib Course0015 where
  srcDir := "0015-automation-and-simp"
  roots := #[`Solutions]

lean_lib Course0017 where
  srcDir := "0017-projects"
  roots := #[`Solutions]

lean_lib Course0019 where
  srcDir := "0019-lakefile-and-lake"
  roots := #[`Solutions]

lean_lib Course0025 where
  srcDir := "0025-contributing-to-mathlib"
  roots := #[`Solutions]

lean_lib Course0026 where
  srcDir := "0026-contributing-to-cslib"
  roots := #[`Solutions]

lean_lib Course0027 where
  srcDir := "0027-contributing-to-arklib"
  roots := #[`Solutions]

lean_lib Course0028 where
  srcDir := "0028-lean-internals"
  roots := #[`Solutions]

lean_lib Course0029 where
  srcDir := "0029-elaboration-and-unification"
  roots := #[`Solutions]

lean_lib Course0030 where
  srcDir := "0030-advanced-metaprogramming"
  roots := #[`Solutions]

lean_lib Course0031 where
  srcDir := "0031-type-theory-foundations"
  roots := #[`Solutions]
