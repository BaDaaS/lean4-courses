/-
# 0027 - Contributing to ArkLib Examples

Code examples from the README, wrapped in anchors for injection.
-/

namespace Course0027Examples

-- #anchor: commitment_scheme
-- Example: commitment scheme
structure CommitmentScheme where
  Message : Type
  Commitment : Type
  Opening : Type
  commit : Message -> Opening -> Commitment
  verify : Message -> Opening -> Commitment -> Prop
-- #end

-- #anchor: is_binding
-- Binding: cannot open to two different messages
def isBinding (cs : CommitmentScheme) : Prop :=
  forall m1 m2 o1 o2 c,
    cs.verify m1 o1 c -> cs.verify m2 o2 c -> m1 = m2
-- #end

end Course0027Examples
