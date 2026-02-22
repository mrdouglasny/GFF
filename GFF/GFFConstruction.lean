/-
Copyright (c) 2026 Michael R. Douglas. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.

# GFF Construction — QFTData Instances

Defines the covariance operator T for each spacetime and constructs
QFTData instances using gaussian-field's Gaussian measure.

## Main definitions

- `cylinderGFF_T` — covariance CLM for cylinder via spectralCLM
- `cylinderGFF` — QFTData for free scalar on cylinder
- `euclideanGFF` — QFTData for free scalar on ℝ^d
-/

import GFF.SpacetimeInstances

open GaussianField

noncomputable section

/-! ## Cylinder GFF

The covariance operator T for the free massive scalar on S¹_L × ℝ is
constructed via `spectralCLM` with singular values σ_m = λ_m^{-1/2}
where λ_m = (2πn/L)² + (2k+1) + m² are the eigenvalues of -Δ + m²
on the product basis. -/

/-- Covariance CLM for the free scalar on the cylinder S¹_L × ℝ.

T = spectralCLM(σ) where σ_m = ((2πn/L)² + (2k+1) + mass²)^{-1/2}
with (n,k) = unpair(m). Maps test functions to ℓ² sequences. -/
def cylinderGFF_T (L mass : ℝ) [Fact (0 < L)] (hL : 0 < L) (hmass : 0 < mass) :
    CylinderTestFun L →L[ℝ] ell2' :=
  spectralCLM (fun m => qftSingularValue L mass m)
    (qft_singular_values_bounded L mass hL hmass)

/-- QFTData for the free massive scalar on the cylinder S¹_L × ℝ.

The probability measure is the Gaussian measure with covariance
C(f,g) = ⟨T(f), T(g)⟩_{ℓ²} where T = cylinderGFF_T. -/
def cylinderGFF (L mass : ℝ) [Fact (0 < L)] (hL : 0 < L) (hmass : 0 < mass) :
    QFTData (cylinderSpacetime L) (freeScalar mass).toTheoryData where
  measure := sorry  -- ProbabilityMeasure from GaussianField.measure (cylinderGFF_T ...)
  weight := fun _ => 1
  weight_integrable := sorry
  genFunℂ := sorry  -- Z[J] = ∫ exp(i⟨ω,J⟩) dμ(ω)

/-! ## Euclidean GFF

The covariance operator for the free massive scalar on ℝ^d is
(-Δ + m²)^{-1/2}, which maps Schwartz functions to ℓ² via the
Hermite expansion. -/

/-- QFTData for the free massive scalar on Euclidean ℝ^d.

Generalizes OSforGFF from d=4 to any dimension d.
The measure is the Gaussian measure with covariance given by
the Green's function of (-Δ + m²). -/
def euclideanGFF (d : ℕ) (mass : ℝ) (hmass : 0 < mass) :
    QFTData (euclideanSpacetime d) (freeScalar mass).toTheoryData where
  measure := sorry  -- Gaussian measure from (-Δ + m²)^{-1/2}
  weight := fun _ => 1
  weight_integrable := sorry
  genFunℂ := sorry

end
