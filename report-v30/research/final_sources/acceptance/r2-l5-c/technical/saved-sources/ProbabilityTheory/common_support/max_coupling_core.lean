import Mathlib.Tactic
import Mathlib.MeasureTheory.Measure.Prod
import ProbabilityTheory.common_support.coupling_core

/-! # A generic maximum-coupling measure construction -/

open MeasureTheory Set

noncomputable section

namespace CouplingCore

variable {α : Type*} [MeasurableSpace α]

/-- Push a measure onto the diagonal. -/
def diagonalMeasure (μ : Measure α) : Measure (α × α) :=
  Measure.map (fun x => (x, x)) μ

lemma map_fst_diagonalMeasure (μ : Measure α) :
    Measure.map Prod.fst (diagonalMeasure μ) = μ := by
  rw [diagonalMeasure, Measure.map_map measurable_fst (by fun_prop)]
  change Measure.map id μ = μ
  exact Measure.map_id

lemma map_snd_diagonalMeasure (μ : Measure α) :
    Measure.map Prod.snd (diagonalMeasure μ) = μ := by
  rw [diagonalMeasure, Measure.map_map measurable_snd (by fun_prop)]
  change Measure.map id μ = μ
  exact Measure.map_id

/-- Normalize a nonzero finite measure. The endpoint hypotheses are kept explicit in the theorem
below, so this definition is never used to justify division by zero. -/
def normalizeMeasure (μ : Measure α) : Measure α := (μ univ)⁻¹ • μ

instance normalizeMeasure.instIsFiniteMeasure (μ : Measure α) [IsFiniteMeasure μ] :
    IsFiniteMeasure (normalizeMeasure μ) := by
  unfold normalizeMeasure
  infer_instance

lemma normalizeMeasure_isProbabilityMeasure (μ : Measure α) [IsFiniteMeasure μ]
    (hμ : μ univ ≠ 0) : IsProbabilityMeasure (normalizeMeasure μ) := by
  constructor
  simp [normalizeMeasure, Measure.smul_apply, ENNReal.inv_mul_cancel hμ (measure_ne_top μ univ)]

/-- Normalizing the second factor commutes with taking a product of finite measures. -/
lemma prod_normalize_right (μ ν : Measure α) [IsFiniteMeasure μ] [IsFiniteMeasure ν] :
    μ.prod (normalizeMeasure ν) = (ν univ)⁻¹ • μ.prod ν := by
  calc
    μ.prod (normalizeMeasure ν) =
        Measure.map Prod.swap ((normalizeMeasure ν).prod μ) := by rw [Measure.prod_swap]
    _ = Measure.map Prod.swap ((ν univ)⁻¹ • ν.prod μ) := by
      rw [normalizeMeasure, Measure.prod_smul_left]
    _ = (ν univ)⁻¹ • Measure.map Prod.swap (ν.prod μ) := by rw [Measure.map_smul]
    _ = (ν univ)⁻¹ • μ.prod ν := by rw [Measure.prod_swap]

/-- The measure-level maximum-coupling formula. When the residual mass is zero it explicitly uses
the diagonal coupling of `P`; otherwise it uses the diagonal common part plus the normalized
product of residuals, weighted by their common mass. -/
def maxCouplingMeasure (P : Measure α) (C L R : Measure α) : Measure (α × α) :=
  if L univ = 0 then diagonalMeasure P
  else diagonalMeasure C + (L univ)⁻¹ • L.prod R

/-- In the nondegenerate case, `maxCouplingMeasure` is exactly the textbook mixture of the
normalized common law on the diagonal and the product of the two normalized residual laws. -/
lemma maxCouplingMeasure_eq_normalized_mixture
    (P C L R : Measure α) [IsFiniteMeasure C] [IsFiniteMeasure L] [IsFiniteMeasure R]
    (hC : C univ ≠ 0) (hL : L univ ≠ 0) (hR : R univ ≠ 0)
    (hmass : R univ = L univ) :
    maxCouplingMeasure P C L R =
      C univ • diagonalMeasure (normalizeMeasure C) +
        L univ • (normalizeMeasure L).prod (normalizeMeasure R) := by
  have hCtop : C univ ≠ ⊤ := measure_ne_top C univ
  have hL_from_right : L univ ≠ 0 := by rw [← hmass]; exact hR
  have hLtop : L univ ≠ ⊤ := measure_ne_top L univ
  have hRtop : R univ ≠ ⊤ := measure_ne_top R univ
  have hdiag : diagonalMeasure (normalizeMeasure C) =
      (C univ)⁻¹ • diagonalMeasure C := by
    simp [normalizeMeasure, diagonalMeasure, Measure.map_smul]
  have hprod : (normalizeMeasure L).prod (normalizeMeasure R) =
      ((L univ)⁻¹ * (R univ)⁻¹) • L.prod R := by
    rw [normalizeMeasure, Measure.prod_smul_left, prod_normalize_right, smul_smul]
  rw [maxCouplingMeasure, if_neg hL_from_right, hdiag, hprod, smul_smul, smul_smul]
  rw [ENNReal.mul_inv_cancel hC hCtop, hmass]
  have hrinv : L univ * ((L univ)⁻¹ * (L univ)⁻¹) = (L univ)⁻¹ := by
    rw [ENNReal.mul_inv_cancel_left hL hLtop]
  rw [hrinv, one_smul]

lemma maxCouplingMeasure_isCoupling
    (P Q C L R : Measure α) [IsFiniteMeasure L] [IsFiniteMeasure R]
    (hP : C + L = P) (hQ : C + R = Q) (hmass : R univ = L univ) :
    IsCoupling (maxCouplingMeasure P C L R) P Q := by
  by_cases hr : L univ = 0
  · have hL : L = 0 := Measure.measure_univ_eq_zero.mp hr
    have hRmass : R univ = 0 := hmass.trans hr
    have hR : R = 0 := Measure.measure_univ_eq_zero.mp hRmass
    subst L
    subst R
    simp only [add_zero] at hP hQ
    have hpq : P = Q := hP.symm.trans hQ
    rw [maxCouplingMeasure, if_pos (by simp)]
    exact ⟨map_fst_diagonalMeasure P, (map_snd_diagonalMeasure P).trans hpq⟩
  · have htop : L univ ≠ ⊤ := measure_ne_top L univ
    have hinv : (L univ)⁻¹ * L univ = 1 := ENNReal.inv_mul_cancel hr htop
    constructor
    · rw [maxCouplingMeasure, if_neg hr, Measure.map_add _ _ measurable_fst,
        map_fst_diagonalMeasure, Measure.map_smul, Measure.map_fst_prod, hmass]
      simpa [smul_smul, hinv] using hP
    · rw [maxCouplingMeasure, if_neg hr, Measure.map_add _ _ measurable_snd,
        map_snd_diagonalMeasure, Measure.map_smul, Measure.map_snd_prod]
      simpa [smul_smul, hinv] using hQ

lemma maxCouplingMeasure_isProbabilityMeasure
    (P Q C L R : Measure α) [IsProbabilityMeasure P]
    [IsFiniteMeasure L] [IsFiniteMeasure R]
    (hP : C + L = P) (hQ : C + R = Q) (hmass : R univ = L univ) :
    IsProbabilityMeasure (maxCouplingMeasure P C L R) := by
  have hc := maxCouplingMeasure_isCoupling P Q C L R hP hQ hmass
  constructor
  calc
    maxCouplingMeasure P C L R univ
        = Measure.map Prod.fst (maxCouplingMeasure P C L R) univ := by
            rw [Measure.map_apply measurable_fst MeasurableSet.univ]
            rfl
    _ = P univ := by rw [hc.1]
    _ = 1 := measure_univ

lemma diagonalMeasure_mismatch [MeasurableEq α] (μ : Measure α) :
    diagonalMeasure μ (mismatchSet (α := α)) = 0 := by
  rw [diagonalMeasure, Measure.map_apply (by fun_prop)
    measurableSet_mismatchSet]
  have hpre : (fun x : α => (x, x)) ⁻¹' mismatchSet (α := α) = ∅ := by
    ext x
    simp [mismatchSet]
  rw [hpre]
  exact measure_empty

lemma maxCouplingMeasure_mismatch [MeasurableEq α]
    (P C L R : Measure α) [IsFiniteMeasure L] [IsFiniteMeasure R]
    (hmass : R univ = L univ) (hdiag : L.prod R (diagonal α) = 0) :
    maxCouplingMeasure P C L R (mismatchSet (α := α)) = L univ := by
  by_cases hr : L univ = 0
  · simp [maxCouplingMeasure, hr, diagonalMeasure_mismatch]
  · have htop : L univ ≠ ⊤ := measure_ne_top L univ
    rw [maxCouplingMeasure, if_neg hr, Measure.add_apply,
      diagonalMeasure_mismatch, zero_add, Measure.smul_apply]
    have hprod : L.prod R (mismatchSet (α := α)) = L univ * R univ := by
      rw [← Measure.prod_prod univ univ, univ_prod_univ, mismatchSet,
        measure_compl measurableSet_diagonal (by rw [hdiag]; simp), hdiag]
      simp
    rw [hprod, hmass]
    exact ENNReal.inv_mul_cancel_left hr htop

end CouplingCore
