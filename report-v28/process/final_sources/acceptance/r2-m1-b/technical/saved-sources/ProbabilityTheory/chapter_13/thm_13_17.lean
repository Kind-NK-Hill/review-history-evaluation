import Mathlib.Probability.Martingale.OptionalStopping
import ProbabilityTheory.chapter_13.def_13_9
import ProbabilityTheory.chapter_13.thm_13_15

open MeasureTheory
open scoped ProbabilityTheory

noncomputable section

theorem thm_13_17_stoppedProcess_eq {Ω S : Type*}
    (X : ℕ → Ω → S) (T : Ω → WithTop ℕ) :
    def_13_9_stoppedProcess X T = MeasureTheory.stoppedProcess X T := by
  funext n ω
  cases hT : T ω with
  | top =>
      simp [def_13_9_stoppedProcess, def_13_9_stoppedIndex,
        MeasureTheory.stoppedProcess, hT]
      apply congrArg (fun j => X j ω)
      rw [WithTop.untopA_eq_untop (by simp)]
      apply WithTop.coe_injective
      rw [WithTop.coe_untop]
      rfl
  | coe k =>
      simp [def_13_9_stoppedProcess, def_13_9_stoppedIndex,
        MeasureTheory.stoppedProcess, hT]
      apply congrArg (fun j => X j ω)
      rw [WithTop.untopA_eq_untop (by simp)]
      apply WithTop.coe_injective
      rw [WithTop.coe_untop]
      calc
        (↑(min k n) : WithTop ℕ) = ↑(min n k) := congrArg WithTop.some (Nat.min_comm k n)
        _ = min (↑n) (↑k) := WithTop.coe_min n k

theorem thm_13_17_toMathlibMartingale {Ω : Type*} [𝓕 : MeasurableSpace Ω]
    {P : Measure Ω} {𝓕n : ℕ → MeasurableSpace Ω} {X : ℕ → Ω → ℝ}
    (hM : def_13_7 P 𝓕n X) :
    MeasureTheory.Martingale X
      (def_13_8_mathlibFiltration 𝓕n (def_13_7_isFiltration hM)) P := by
  refine ⟨fun n => (def_13_7_adapted hM n).stronglyMeasurable, ?_⟩
  intro i j hij
  exact (thm_13_15_multiStep_of_martingale hM i j hij).condExp_eq

theorem thm_13_17 {Ω : Type*} [𝓕 : MeasurableSpace Ω]
    {P : Measure Ω} {𝓕n : ℕ → MeasurableSpace Ω}
    {X : ℕ → Ω → ℝ} {T : Ω → WithTop ℕ}
    (hM : def_13_7 P 𝓕n X) (hT : def_13_8 𝓕n T) :
    def_13_7 P 𝓕n (def_13_9_stoppedProcess X T) := by
  letI : IsProbabilityMeasure P := def_13_7_isProbabilityMeasure hM
  let ℱ := def_13_8_mathlibFiltration 𝓕n (def_13_7_isFiltration hM)
  have hMX : MeasureTheory.Martingale X ℱ P :=
    thm_13_17_toMathlibMartingale hM
  have hτ : MeasureTheory.IsStoppingTime ℱ T := by
    exact def_13_8_toMathlibIsStoppingTime hT
  have hsub : MeasureTheory.Submartingale
      (MeasureTheory.stoppedProcess X T) ℱ P :=
    hMX.submartingale.stoppedProcess hτ
  have hsuper : MeasureTheory.Supermartingale
      (MeasureTheory.stoppedProcess X T) ℱ P := by
    have hnsub : MeasureTheory.Submartingale
        (MeasureTheory.stoppedProcess (-X) T) ℱ P :=
      hMX.neg.submartingale.stoppedProcess hτ
    simpa using hnsub.neg
  have hstopped : MeasureTheory.Martingale
      (MeasureTheory.stoppedProcess X T) ℱ P :=
    MeasureTheory.martingale_iff.mpr ⟨hsuper, hsub⟩
  rw [thm_13_17_stoppedProcess_eq]
  refine ⟨def_13_7_isFiltration hM, fun n => hstopped.integrable n,
    fun n => (hstopped.stronglyMeasurable n).measurable, ?_⟩
  intro n
  refine ⟨def_13_7_isProbabilityMeasure hM,
    (def_13_7_isFiltration hM).1 n, hstopped.integrable (n + 1), ?_⟩
  exact hstopped.condExp_ae_eq (Nat.le_succ n)

theorem thm_13_17_expectation {Ω : Type*} [𝓕 : MeasurableSpace Ω]
    {P : Measure Ω} {𝓕n : ℕ → MeasurableSpace Ω}
    {X : ℕ → Ω → ℝ} {T : Ω → WithTop ℕ}
    (hM : def_13_7 P 𝓕n X) (hT : def_13_8 𝓕n T) (n : ℕ) :
    ∫ ω, def_13_9_stoppedProcess X T n ω ∂P = ∫ ω, X 0 ω ∂P := by
  letI : IsProbabilityMeasure P := def_13_7_isProbabilityMeasure hM
  calc
    ∫ ω, def_13_9_stoppedProcess X T n ω ∂P =
        ∫ ω, def_13_9_stoppedProcess X T 0 ω ∂P :=
      thm_13_15_expectation_constant (thm_13_17 hM hT) n
    _ = ∫ ω, X 0 ω ∂P := by
      congr 1
      funext ω
      cases h : T ω <;>
        simp [def_13_9_stoppedProcess, def_13_9_stoppedIndex, h]
