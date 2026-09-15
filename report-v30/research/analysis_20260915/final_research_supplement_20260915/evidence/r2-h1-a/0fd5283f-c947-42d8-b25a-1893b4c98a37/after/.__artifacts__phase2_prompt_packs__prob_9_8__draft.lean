import Mathlib
import ProbabilityTheory.chapter_09.def_9_3
import ProbabilityTheory.chapter_09.thm_9_6

/-
TASK ID: prob_9_8
TYPE: Problem
SOURCE PLAN: experiment_targets
TASK CONTENT:
\textbf{Problem 9.8} Prove that $\phi_X(2\pi)=1$ if and only if $P(X\in\mathbb{Z})=1$.
-/

-- WRITE FINAL LEAN CODE BELOW
open MeasureTheory Filter Set

namespace ProbabilityTheory

noncomputable section

/-- **Problem 9.8.** At frequency `2π`, the characteristic function is one
exactly when the random variable is integer-valued almost surely. -/
theorem prob_9_8
    {Ω : Type*} [MeasurableSpace Ω] (P : Measure Ω) [IsProbabilityMeasure P]
    (X : Ω → ℝ) (hX : AEMeasurable X P) :
    characteristicFunction (P.map X) (2 * Real.pi) = 1 ↔
      ∀ᵐ ω ∂P, ∃ z : ℤ, X ω = z := by
  let f : Ω → ℂ := fun ω =>
    Complex.exp (((2 * Real.pi * X ω : ℝ) : ℂ) * Complex.I)
  have hf_meas : AEStronglyMeasurable f P := by
    dsimp [f]
    fun_prop
  have hf_norm : ∀ ω, ‖f ω‖ = 1 := by
    intro ω
    simp [f, Complex.norm_exp]
  have hf_int : Integrable f P := by
    have h := P.integrableOn_of_bounded (s := Set.univ) (measure_ne_top P Set.univ)
      hf_meas (M := 1) (Eventually.of_forall fun ω => by
        show ‖f ω‖ ≤ (1 : ℝ)
        rw [hf_norm ω])
    simpa only [IntegrableOn, Measure.restrict_univ] using h
  have hf_re : ∀ ω, (f ω).re = Real.cos (2 * Real.pi * X ω) := by
    intro ω
    change (Complex.exp (((2 * Real.pi * X ω : ℝ) : ℂ) * Complex.I)).re = _
    exact Complex.exp_ofReal_mul_I_re _
  have hcos_int : Integrable (fun ω => Real.cos (2 * Real.pi * X ω)) P :=
    hf_int.re.congr (Eventually.of_forall hf_re)
  constructor
  · intro hφ
    have hint : ∫ ω, f ω ∂P = 1 := by
      rw [characteristicFunction_map_apply hX] at hφ
      simpa [f, mul_comm, mul_left_comm, mul_assoc] using hφ
    have hcos : ∫ ω, Real.cos (2 * Real.pi * X ω) ∂P = 1 := by
      calc
        (∫ ω, Real.cos (2 * Real.pi * X ω) ∂P) = ∫ ω, (f ω).re ∂P :=
          integral_congr_ae (Eventually.of_forall fun ω => (hf_re ω).symm)
        _ = (∫ ω, f ω ∂P).re := integral_re hf_int
        _ = 1 := by rw [hint]; simp
    have hsub : ∫ ω, (1 - Real.cos (2 * Real.pi * X ω)) ∂P = 0 := by
      rw [integral_sub (integrable_const 1) hcos_int]
      have hone : ∫ _ω : Ω, (1 : ℝ) ∂P = 1 :=
        integral_eq_const (Eventually.of_forall fun _ => rfl)
      rw [hone, hcos]
      norm_num
    have hae_zero : (fun ω => 1 - Real.cos (2 * Real.pi * X ω)) =ᵐ[P] 0 :=
      (integral_eq_zero_iff_of_nonneg_ae
        (Eventually.of_forall fun ω => sub_nonneg.mpr (Real.cos_le_one _))
        ((integrable_const 1).sub hcos_int)).mp hsub
    filter_upwards [hae_zero] with ω hω
    simp only [Pi.zero_apply] at hω
    have hcos_one : Real.cos (2 * Real.pi * X ω) = 1 := (sub_eq_zero.mp hω).symm
    obtain ⟨z, hz⟩ := (Real.cos_eq_one_iff _).mp hcos_one
    refine ⟨z, ?_⟩
    have hpi : 2 * Real.pi ≠ 0 := by positivity
    apply mul_left_cancel₀ hpi
    calc
      (2 * Real.pi) * X ω = (z : ℝ) * (2 * Real.pi) := by simpa [mul_comm] using hz.symm
      _ = (2 * Real.pi) * (z : ℝ) := by ring
  · intro hInt
    rw [characteristicFunction_map_apply hX]
    calc
      (∫ ω, Complex.exp (Complex.I * (X ω : ℂ) * ((2 * Real.pi : ℝ) : ℂ)) ∂P) =
          ∫ _ω : Ω, (1 : ℂ) ∂P := by
        apply integral_congr_ae
        filter_upwards [hInt] with ω hω
        obtain ⟨z, hz⟩ := hω
        rw [hz]
        rw [show Complex.I * (((z : ℤ) : ℝ) : ℂ) * ((2 * Real.pi : ℝ) : ℂ) =
          (z : ℂ) * (2 * (Real.pi : ℂ) * Complex.I) by push_cast; ring]
        exact (Complex.exp_eq_one_iff.mpr ⟨z, rfl⟩)
      _ = 1 := integral_eq_const (Eventually.of_forall fun _ => rfl)

end

end ProbabilityTheory
