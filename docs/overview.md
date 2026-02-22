# Overview

This is a Lean 4 formalization of the Gaussian free field, one of the
most fundamental objects in quantum field theory and probability. The
project is split across three repositories, each handling a different
layer of abstraction.

## [gaussian-field](https://github.com/mrdouglasny/gaussian-field) — the functional analysis

The bottom layer. It builds the mathematical machinery needed to
construct Gaussian probability measures on infinite-dimensional spaces.

The key idea: given a space of test functions (like Schwartz functions
on Euclidean space, or smooth periodic functions on a circle) and a
linear operator that controls the covariance, the library produces a
probability measure on the dual space — the space of distributions.
This measure is Gaussian, centered, and satisfies all the expected
properties: the characteristic functional has the right exponential
form, all moments are computable, and pairings with test functions
are integrable.

To make this work, the test function spaces must be "nuclear" — a
topological condition that guarantees the measure exists. The library
proves nuclearity for Schwartz space (via Hermite function expansions)
and for smooth periodic functions on circles (via Fourier series), and
provides a tensor product construction so these can be combined into
product spaces like cylinders and tori.

## [QFTFramework](https://github.com/mrdouglasny/QFTFramework) — the abstract axioms

The middle layer. It defines what a quantum field theory is, without
committing to any particular spacetime or field content.

A spacetime packages the geometry: what the test functions are, what
field configurations look like, what symmetries act, and what "time"
means. A theory specifies the field content: how many bosonic and
fermionic species, what couplings, what symmetry group.

Combining a spacetime with a theory gives a QFT: a probability measure
on field configurations plus a generating functional. The Osterwalder-
Schrader axioms (OS0 through OS4) then provide checkable conditions
that a QFT must satisfy — analyticity, regularity, symmetry invariance,
reflection positivity, and clustering.

The framework comes with built-in spacetimes for Euclidean space, tori,
and lattices, plus standard theories like the free scalar, phi-four,
and O(N) models.

## [GFF](https://github.com/mrdouglasny/GFF) — the bridge

The top layer. It connects the other two by filling QFTFramework's
abstract slots with gaussian-field's concrete constructions.

For each spacetime (cylinder, torus, Euclidean space), it provides:

- A SpacetimeData instance, specifying the test function space, field
  configurations, symmetries, and time structure using gaussian-field
  types.

- A covariance operator built from the eigenvalues of the Laplacian
  plus mass squared, via the spectral multiplier construction.

- A QFTData instance packaging the Gaussian measure as the QFT's
  probability measure.

- Osterwalder-Schrader axiom statements. For spacetimes with an
  infinite time direction (cylinder, Euclidean space), all five axioms
  are stated. For compact spacetimes (torus), only the applicable
  axioms are stated — there is no infinite time direction to cluster
  along or reflect across.

The spacetimes implemented here are examples. The framework is general:
any spacetime whose test functions form a nuclear Frechet space can be
plugged in by providing the appropriate instance and eigenvalue spectrum.

## Current status

The gaussian-field library is largely proved: nuclearity of Schwartz
space and circle functions, the Gaussian measure construction, and all
moment identities carry no sorries. The QFTFramework definitions are
concrete and sorry-free. The GFF bridge layer has sorry-filled proofs
for the OS axioms — these are the main targets for future work.
