/-
Copyright (c) 2026 Michael R. Douglas. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.

# SpacetimeData Instances from gaussian-field

Provides concrete `SpacetimeData` instances using gaussian-field's nuclear
Fréchet spaces. This replaces QFTFramework's axiomatized `TestFunctionTorus`
with concrete constructions from gaussian-field.

## Main definitions

- `cylinderSpacetime L` — cylinder S¹_L × ℝ using NuclearTensorProduct
- `torusSpacetime L₁ L₂` — flat torus T² = S¹_{L₁} × S¹_{L₂}
- `euclideanSpacetime d` — flat ℝ^d using SchwartzMap
-/

import QFTFramework
import GaussianField
import SmoothCircle
import HeatKernel

open GaussianField

noncomputable section

/-! ## Cylinder spacetime S¹_L × ℝ

The test function space is the nuclear tensor product
`NuclearTensorProduct (SmoothMap_Circle L ℝ) (SchwartzMap ℝ ℝ)`,
which is a DyninMityaginSpace and hence a nuclear Fréchet space.

This is the 2D case of QFTFramework's Torus spacetime, but using
concrete types from gaussian-field rather than axiomatized ones. -/

/-- Abbreviation for the cylinder test function space. -/
abbrev CylinderTestFun (L : ℝ) [Fact (0 < L)] :=
  NuclearTensorProduct (SmoothMap_Circle L ℝ) (SchwartzMap ℝ ℝ)

/-- Cylinder spacetime: S¹_L × ℝ.

Test functions are the nuclear tensor product of smooth periodic functions
on S¹_L with Schwartz functions on ℝ. Field configurations are the weak
dual (tempered distributions). -/
def cylinderSpacetime (L : ℝ) [Fact (0 < L)] : SpacetimeData where
  TestFun := CylinderTestFun L
  TestFunℂ := CylinderTestFun L  -- real space serving as complex placeholder
  instACG_TF := inferInstance
  instMod_TF := inferInstance
  instTS_TF := inferInstance
  instACG_TFℂ := inferInstance
  instMod_TFℂ := sorry  -- Module ℂ structure (future: complexification)
  instTS_TFℂ := inferInstance
  toComplex := sorry  -- real-to-complex embedding (future)
  FieldConfig := Configuration (CylinderTestFun L)
  instMS_FC := instMeasurableSpaceConfiguration
  instTS_FC := inferInstance
  eval := fun ω f => ω f
  eval_measurable := sorry  -- measurability of evaluation
  SymGroup := sorry  -- Circle rotations × ℝ translations
  instGrp_SG := sorry
  symAction := sorry
  TransVec := ℝ × ℝ  -- (θ shift, x shift)
  instNACG_TV := inferInstance
  translateEmbed := sorry
  timeReflection := sorry  -- θ ↦ -θ
  positiveTimeSubmodule := sorry
  timeShift := sorry

/-! ## Torus spacetime T² = S¹_{L₁} × S¹_{L₂}

The flat 2-torus with periods L₁, L₂. Test functions are the nuclear tensor
product `NuclearTensorProduct (SmoothMap_Circle L₁ ℝ) (SmoothMap_Circle L₂ ℝ)`.

Since T² is compact, the translation group is compact and `Filter.cocompact`
is `⊥`, so OS4 clustering is vacuously true. However, there is no distinguished
time direction with infinite extent, so OS3 (reflection positivity) and OS4
(ergodicity) do not have their usual physical content. The GFF on T² is still
a well-defined Gaussian measure — it just doesn't reconstruct a Hilbert space
QFT via Osterwalder-Schrader. -/

/-- Abbreviation for the torus test function space. -/
abbrev TorusTestFun (L₁ L₂ : ℝ) [Fact (0 < L₁)] [Fact (0 < L₂)] :=
  NuclearTensorProduct (SmoothMap_Circle L₁ ℝ) (SmoothMap_Circle L₂ ℝ)

/-- Torus spacetime: T² = S¹_{L₁} × S¹_{L₂}.

Test functions are the nuclear tensor product of smooth periodic functions
on each circle factor. The spacetime is compact, so clustering is vacuous
and there is no infinite time direction for reflection positivity. -/
def torusSpacetime (L₁ L₂ : ℝ) [Fact (0 < L₁)] [Fact (0 < L₂)] : SpacetimeData where
  TestFun := TorusTestFun L₁ L₂
  TestFunℂ := TorusTestFun L₁ L₂  -- real space serving as complex placeholder
  instACG_TF := inferInstance
  instMod_TF := inferInstance
  instTS_TF := inferInstance
  instACG_TFℂ := inferInstance
  instMod_TFℂ := sorry  -- Module ℂ structure (future: complexification)
  instTS_TFℂ := inferInstance
  toComplex := sorry  -- real-to-complex embedding (future)
  FieldConfig := Configuration (TorusTestFun L₁ L₂)
  instMS_FC := instMeasurableSpaceConfiguration
  instTS_FC := inferInstance
  eval := fun ω f => ω f
  eval_measurable := sorry
  -- Symmetry: torus translations (θ₁, θ₂) ↦ (θ₁ + a₁, θ₂ + a₂)
  SymGroup := sorry
  instGrp_SG := sorry
  symAction := sorry
  -- Translation group is compact (ℝ/L₁ℤ × ℝ/L₂ℤ), but we use ℝ² and
  -- rely on cocompact being ⊥ for the compact quotient in OS4
  TransVec := ℝ × ℝ
  instNACG_TV := inferInstance
  translateEmbed := sorry
  -- "Time" reflection: θ₁ ↦ -θ₁ (formal; no infinite time direction)
  timeReflection := sorry
  positiveTimeSubmodule := sorry
  timeShift := sorry

/-! ## Euclidean spacetime ℝ^d

Test functions are Schwartz functions `𝓢(ℝ^d, ℝ)`, which are
DyninMityaginSpaces when d ≥ 1. This matches QFTFramework's
`Euclidean.lean` but uses gaussian-field's nuclear structure. -/

/-- Euclidean spacetime ℝ^d with Schwartz test functions.

For d ≥ 1, `SchwartzMap (EuclideanSpace ℝ (Fin d)) ℝ` is a
DyninMityaginSpace (proved in gaussian-field via Hermite functions). -/
def euclideanSpacetime (d : ℕ) : SpacetimeData where
  TestFun := SchwartzMap (EuclideanSpace ℝ (Fin d)) ℝ
  TestFunℂ := SchwartzMap (EuclideanSpace ℝ (Fin d)) ℂ
  instACG_TF := inferInstance
  instMod_TF := inferInstance
  instTS_TF := inferInstance
  instACG_TFℂ := inferInstance
  instMod_TFℂ := inferInstance
  instTS_TFℂ := inferInstance
  toComplex := sorry  -- real-to-complex Schwartz embedding
  FieldConfig := WeakDual ℝ (SchwartzMap (EuclideanSpace ℝ (Fin d)) ℝ)
  instMS_FC := sorry  -- measurable space on weak dual
  instTS_FC := inferInstance
  eval := fun ω f => ω f
  eval_measurable := sorry
  SymGroup := sorry  -- E(d) = O(d) ⋊ ℝ^d
  instGrp_SG := sorry
  symAction := sorry
  TransVec := EuclideanSpace ℝ (Fin d)
  instNACG_TV := inferInstance
  translateEmbed := sorry
  timeReflection := sorry  -- (x₀, x⃗) ↦ (-x₀, x⃗)
  positiveTimeSubmodule := sorry
  timeShift := sorry

end
