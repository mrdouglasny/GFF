# GFF — Gaussian Free Field in Lean 4

This repository bridges two Lean 4 projects to formalize the Gaussian free field (GFF) as a quantum field theory satisfying the Osterwalder-Schrader axioms.

## Dependencies

- **[gaussian-field](https://github.com/mrdouglasny/gaussian-field)** — Concrete functional analysis: nuclear Frechet spaces (Schwartz, smooth periodic, tensor products), Gaussian measure construction on weak duals, spectral multiplier CLMs, and proved properties (characteristic functional, moments, probability).

- **[QFTFramework](https://github.com/mrdouglasny/QFTFramework)** — Abstract QFT axiomatics: `SpacetimeData` (test functions, distributions, symmetry groups, time structure), `TheoryData`/`QFTActionData` (field content, couplings), `QFTData` (probability measure + generating functional), and `OSTheory` (Osterwalder-Schrader axioms OS0-OS4).

GFF fills QFTFramework's abstract type slots with gaussian-field's concrete constructions.

## What this repo does

The GFF on a spacetime M is the centered Gaussian probability measure on the space of distributions (generalized functions) on M, with covariance given by the Green's function of (-Delta + m^2). Concretely:

1. **Test function spaces** come from gaussian-field's nuclear Frechet spaces
2. **Field configurations** are weak duals (continuous linear functionals on test functions)
3. **The measure** is gaussian-field's `GaussianField.measure T` for a covariance CLM `T`
4. **The covariance CLM** is `spectralCLM` applied to the singular values of (-Delta + m^2)

## Spacetimes

The three spacetimes below are **implemented examples**, not an exhaustive list. The framework is fully general: any spacetime whose test function space carries a `DyninMityaginSpace` instance can be plugged in. In particular, QFTFramework's `SpacetimeData` is parametric — it accepts any test function type, field configuration space, symmetry group, and time structure. gaussian-field's `GaussianField.measure` works for any CLM `T : E →L[ℝ] H` from any nuclear Frechet space `E`. New spacetimes (e.g. higher tori T^d, half-spaces, lattices) require only providing the appropriate `DyninMityaginSpace` instance and eigenvalue spectrum.

| Spacetime | Test functions | Covariance spectrum | OS axioms |
|-----------|---------------|-------------------|-----------|
| Cylinder S^1_L x R | `NuclearTensorProduct (SmoothMap_Circle L R) (SchwartzMap R R)` | (2 pi n/L)^2 + (2k+1) + m^2 | Full `OSTheory` (sorry'd) |
| Torus T^2 = S^1_{L1} x S^1_{L2} | `NuclearTensorProduct (SmoothMap_Circle L1 R) (SmoothMap_Circle L2 R)` | (2 pi n1/L1)^2 + (2 pi n2/L2)^2 + m^2 | OS0-OS2 only (compact, no infinite time) |
| Euclidean R^d | `SchwartzMap (EuclideanSpace R (Fin d)) R` | Hermite eigenvalues + m^2 | Full `OSTheory` (sorry'd) |

The torus is compact, so OS4 (clustering/ergodicity) is vacuously true and OS3 (reflection positivity) has no physical content — there is no infinite time direction to reflect across. We state OS0-OS2 individually but do not bundle an `OSTheory`.

## File structure

```
GFF/
  lakefile.lean                   -- depends on gaussian-field + QFTFramework
  lean-toolchain                  -- v4.28.0
  GFF.lean                        -- root import
  GFF/
    SpacetimeInstances.lean       -- SpacetimeData for cylinder, torus, R^d
    GFFConstruction.lean          -- covariance CLMs + QFTData instances
    OSVerification.lean           -- OSTheory (cylinder, R^d) + individual axioms (torus)
```

## API reference

### SpacetimeInstances.lean

Concrete `SpacetimeData` instances using gaussian-field types:

```
cylinderSpacetime (L : R) [Fact (0 < L)] : SpacetimeData
torusSpacetime (L1 L2 : R) [Fact (0 < L1)] [Fact (0 < L2)] : SpacetimeData
euclideanSpacetime (d : N) : SpacetimeData
```

Type abbreviations for test function spaces:

```
CylinderTestFun L  := NuclearTensorProduct (SmoothMap_Circle L R) (SchwartzMap R R)
TorusTestFun L1 L2 := NuclearTensorProduct (SmoothMap_Circle L1 R) (SmoothMap_Circle L2 R)
```

### GFFConstruction.lean

Covariance operators and QFTData:

```
-- Eigenvalues and singular values
qftEigenvalue L mass m : R          -- cylinder: (2 pi n/L)^2 + (2k+1) + m^2
qftSingularValue L mass m : R       -- lambda_m^{-1/2}
torusEigenvalue L1 L2 mass m : R    -- torus: (2 pi n1/L1)^2 + (2 pi n2/L2)^2 + m^2
torusSingularValue L1 L2 mass m : R

-- Covariance CLMs (test functions -> ell^2)
cylinderGFF_T L mass hL hmass : CylinderTestFun L ->L[R] ell2'
torusGFF_T L1 L2 mass hL1 hL2 hmass : TorusTestFun L1 L2 ->L[R] ell2'

-- QFTData instances
cylinderGFF L mass hL hmass : QFTData (cylinderSpacetime L) (freeScalar mass).toTheoryData
torusGFF L1 L2 mass hL1 hL2 hmass : QFTData (torusSpacetime L1 L2) (freeScalar mass).toTheoryData
euclideanGFF d mass hmass : QFTData (euclideanSpacetime d) (freeScalar mass).toTheoryData
```

### OSVerification.lean

OS axiom verification:

```
-- Full OS axiom bundles (cylinder, R^d)
cylinderGFF_OS L mass hL hmass : OSTheory (cylinderSpacetime L) (freeScalar mass).toTheoryData
euclideanGFF_OS d mass hmass : OSTheory (euclideanSpacetime d) (freeScalar mass).toTheoryData

-- Individual axioms for torus (no OSTheory bundle)
torusGFF_os0 ... : OS0_Analyticity (torusSpacetime L1 L2) (torusGFF ...)
torusGFF_os1 ... : OS1_Regularity (torusSpacetime L1 L2) (torusGFF ...)
torusGFF_os2 ... : OS2_Invariance (torusSpacetime L1 L2) (torusGFF ...)
```

## Status

All QFTData and OSTheory fields are sorry'd. The main goals are:

- **Near-term**: Fill in `measure` fields using `GaussianField.measure` (requires wrapping in `ProbabilityMeasure`)
- **Medium-term**: Prove OS0 (analyticity) and OS1 (regularity) from the Gaussian characteristic functional
- **Long-term**: Prove OS3 (reflection positivity) from heat kernel positivity, OS4 (ergodicity) from Gaussian mixing

## Building

```
lake update
lake build
```

Requires Lean v4.28.0 and Mathlib (pinned via dependencies).
