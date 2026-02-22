/-
Copyright (c) 2026 Michael R. Douglas. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.

# OS Axiom Verification for GFF

States that the Gaussian free field on each spacetime satisfies the
Osterwalder-Schrader axioms. All proofs are sorry'd — filling these in
is the main goal of the GFF project.

## Main definitions

- `cylinderGFF_OS` — OSTheory for free scalar on S¹_L × ℝ
- `torusGFF_QFT` — QFTData for free scalar on T² (no OSTheory: see below)
- `euclideanGFF_OS` — OSTheory for free scalar on ℝ^d
-/

import GFF.GFFConstruction

open GaussianField

noncomputable section

/-! ## Cylinder GFF satisfies OS axioms -/

/-- The free massive scalar on S¹_L × ℝ satisfies all OS axioms.

- OS0 (Analyticity): characteristic functional exp(-½‖Tf‖²) is entire
- OS1 (Regularity): Gaussian bound |Z[f]| ≤ exp(c·‖f‖²)
- OS2 (Invariance): measure is circle-rotation and ℝ-translation invariant
- OS3 (Reflection positivity): from heat kernel positivity
- OS4 (Clustering): Gaussian correlations decay; ergodic by mixing -/
def cylinderGFF_OS (L mass : ℝ) [Fact (0 < L)] (hL : 0 < L) (hmass : 0 < mass) :
    OSTheory (cylinderSpacetime L) (freeScalar mass).toTheoryData where
  toQFTData := cylinderGFF L mass hL hmass
  real_action := sorry  -- weight = 1 everywhere
  os0 := sorry  -- Analyticity: charFun is analytic
  os1 := sorry  -- Regularity: Gaussian bound
  os2 := sorry  -- Invariance: measure is symmetric
  os3 := sorry  -- Reflection positivity: from heat kernel
  os4_clustering := sorry  -- Clustering: Gaussian correlations decay
  os4_ergodicity := sorry  -- Ergodicity: from mixing

/-! ## Torus GFF — QFT without full OS axioms

The GFF on T² = S¹_{L₁} × S¹_{L₂} is a well-defined QFT (probability measure
+ generating functional), but does NOT satisfy all OS axioms in a meaningful way:

- OS0 (Analyticity): **holds** — charFun is entire
- OS1 (Regularity): **holds** — Gaussian bound
- OS2 (Invariance): **holds** — torus translation invariance
- OS3 (Reflection positivity): **vacuous/problematic** — no infinite time direction,
  so "positive time" submodule is the whole space or empty. Formally satisfiable
  but physically meaningless.
- OS4 (Clustering): **vacuously true** — TransVec = ℝ × ℝ but torus translations
  are periodic, so cocompact filter is ⊥ on the compact quotient
- OS4 (Ergodicity): **vacuously true** — same reason

We provide the individual axiom statements that do hold, but do NOT construct
an `OSTheory` instance since it would be misleading. -/

/-- OS0 for torus GFF: the characteristic functional is analytic. -/
theorem torusGFF_os0 (L₁ L₂ mass : ℝ) [Fact (0 < L₁)] [Fact (0 < L₂)]
    (hL₁ : 0 < L₁) (hL₂ : 0 < L₂) (hmass : 0 < mass) :
    OS0_Analyticity (torusSpacetime L₁ L₂) (torusGFF L₁ L₂ mass hL₁ hL₂ hmass) :=
  sorry

/-- OS1 for torus GFF: exponential regularity bound. -/
theorem torusGFF_os1 (L₁ L₂ mass : ℝ) [Fact (0 < L₁)] [Fact (0 < L₂)]
    (hL₁ : 0 < L₁) (hL₂ : 0 < L₂) (hmass : 0 < mass) :
    OS1_Regularity (torusSpacetime L₁ L₂) (torusGFF L₁ L₂ mass hL₁ hL₂ hmass) :=
  sorry

/-- OS2 for torus GFF: torus translation invariance. -/
theorem torusGFF_os2 (L₁ L₂ mass : ℝ) [Fact (0 < L₁)] [Fact (0 < L₂)]
    (hL₁ : 0 < L₁) (hL₂ : 0 < L₂) (hmass : 0 < mass) :
    OS2_Invariance (torusSpacetime L₁ L₂) (torusGFF L₁ L₂ mass hL₁ hL₂ hmass) :=
  sorry

/-! ## Euclidean GFF satisfies OS axioms -/

/-- The free massive scalar on ℝ^d satisfies all OS axioms.

This generalizes OSforGFF (which proved OS axioms for d=4) to
arbitrary dimension d. -/
def euclideanGFF_OS (d : ℕ) (mass : ℝ) (hmass : 0 < mass) :
    OSTheory (euclideanSpacetime d) (freeScalar mass).toTheoryData where
  toQFTData := euclideanGFF d mass hmass
  real_action := sorry
  os0 := sorry
  os1 := sorry
  os2 := sorry
  os3 := sorry
  os4_clustering := sorry
  os4_ergodicity := sorry

end
