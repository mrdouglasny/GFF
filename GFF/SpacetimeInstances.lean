/-
Copyright (c) 2026 Michael R. Douglas. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.

# SpacetimeData Instances from gaussian-field

Provides concrete `SpacetimeData` instances using gaussian-field's nuclear
Fréchet spaces. This replaces QFTFramework's axiomatized `TestFunctionTorus`
with concrete constructions from gaussian-field.

## Main definitions

- `cylinderSpacetime L` — cylinder S¹_L × ℝ using NuclearTensorProduct
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
