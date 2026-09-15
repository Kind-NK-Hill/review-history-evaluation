import Mathlib.Probability.Martingale.OptionalStopping
import ProbabilityTheory.chapter_13.def_13_9
import ProbabilityTheory.chapter_13.thm_13_16

/-! # Theorem 13.17 -/

open MeasureTheory
open scoped ProbabilityTheory

noncomputable section

/-- The textbook stopped-index implementation is extensionally equal to
Mathlib's stopped process. -/
theorem thm_13_17_stoppedProcess_eq_mathlib {Ω S : Type*}
    (X : ℕ → Ω → S) (T : Ω → WithTop ℕ) :
    def_13_9_stoppedProcess X T = MeasureTheory.stoppedProcess X T := by
  funext n ω
  cases hT : T ω with
  | top =>
      simp only [def_13_9_stoppedProcess, def_13_9_stoppedIndex,
        MeasureTheory.stoppedProcess, hT]
      rw [min_eq_left (le_top)]
      rw [WithTop.untopA_eq_untop (by simp), WithTop.untop_coe]
  | coe k =>
      simp only [def_13_9_stoppedProcess, def_13_9_stoppedIndex,
        MeasureTheory.stoppedProcess, hT]
      rw [← WithTop.coe_min]
      rw [WithTop.untopA_eq_untop (by simp), WithTop.untop_coe, min_comm]

/-- Bridge from the book-facing martingale to Mathlib's martingale. -/
theorem thm_13_17_toMathlibMartingale {Ω : Type*} [𝓕 : MeasurableSpace Ω]
    {P : Measure Ω} {𝓕n : ℕ → MeasurableSpace Ω} {X : ℕ → Ω → ℝ}
    (hM : def_13_7 P 𝓕n X) :
    MeasureTheory.Martingale X (def_13_8_mathlibFiltration 𝓕n hM.1) P := by
  letI : IsProbabilityMeasure P := def_13_7_isProbabilityMeasure hM
  apply martingale_nat
  · intro n
    exact (hM.2.2.1 n).stronglyMeasurable
  · exact hM.2.1
  · intro n
    exact (hM.2.2.2 n).condExp_eq.symm

/-- Bridge back to the book-facing interface, retaining all martingale fields. -/
theorem thm_13_17_ofMathlibMartingale {Ω : Type*} [𝓕 : MeasurableSpace Ω]
    {P : Measure Ω} [IsProbabilityMeasure P]
    {𝓕n : ℕ → MeasurableSpace Ω} (h𝓕n : def_13_6_isFiltration (𝓕 := 𝓕) 𝓕n)
    {Y : ℕ → Ω → ℝ}
    (hM : MeasureTheory.Martingale Y (def_13_8_mathlibFiltration 𝓕n h𝓕n) P) :
    def_13_7 P 𝓕n Y := by
  refine ⟨h𝓕n, fun n => hM.integrable n, ?_, ?_⟩
  · intro n
    exact (hM.stronglyMeasurable n).measurable
  · intro n
    refine
      { isProbabilityMeasure := inferInstance
        sub_ambient := h𝓕n.1 n
        integrable := hM.integrable (n + 1)
        condExp_eq := ?_ }
    exact hM.condExp_ae_eq (Nat.le_succ n)

/-- Theorem 13.17, martingale part. -/
theorem thm_13_17_stoppedProcess_martingale
    {Ω : Type*} [𝓕 : MeasurableSpace Ω]
    {P : Measure Ω} {𝓕n : ℕ → MeasurableSpace Ω}
    {X : ℕ → Ω → ℝ} {T : Ω → WithTop ℕ}
    (hM : def_13_7 P 𝓕n X) (hT : def_13_8 𝓕n T) :
    def_13_7 P 𝓕n (def_13_9_stoppedProcess X T) := by
  letI : IsProbabilityMeasure P := def_13_7_isProbabilityMeasure hM
  let F := def_13_8_mathlibFiltration 𝓕n hM.1
  have hT' : IsStoppingTime F T := hT.2
  have hXM : Martingale X F P := thm_13_17_toMathlibMartingale hM
  have hsub : Submartingale (stoppedProcess X T) F P :=
    hXM.submartingale.stoppedProcess hT'
  have hsuper : Supermartingale (stoppedProcess X T) F P := by
    have hnsub : Submartingale (stoppedProcess (-X) T) F P :=
      hXM.neg.submartingale.stoppedProcess hT'
    have hneg : stoppedProcess (-X) T = -(stoppedProcess X T) := by
      funext n ω
      rfl
    have hnsub' : Submartingale (-(stoppedProcess X T)) F P := by
      rw [← hneg]
      exact hnsub
    simpa only [neg_neg] using hnsub'.neg
  have hstopM : Martingale (stoppedProcess X T) F P :=
    martingale_iff.mpr ⟨hsuper, hsub⟩
  rw [thm_13_17_stoppedProcess_eq_mathlib]
  exact thm_13_17_ofMathlibMartingale hM.1 hstopM

/-- Theorem 13.17, expectation part, including `n = 0`. -/
theorem thm_13_17_expectation_constant
    {Ω : Type*} [𝓕 : MeasurableSpace Ω]
    {P : Measure Ω} {𝓕n : ℕ → MeasurableSpace Ω}
    {X : ℕ → Ω → ℝ} {T : Ω → WithTop ℕ}
    (hM : def_13_7 P 𝓕n X) (hT : def_13_8 𝓕n T) (n : ℕ) :
    ∫ ω, def_13_9_stoppedProcess X T n ω ∂P = ∫ ω, X 0 ω ∂P := by
  letI : IsProbabilityMeasure P := def_13_7_isProbabilityMeasure hM
  have hSM := thm_13_17_stoppedProcess_martingale hM hT
  have hzero : def_13_9_stoppedProcess X T 0 = X 0 := by
    funext ω
    cases hTω : T ω <;> simp [def_13_9_stoppedProcess, def_13_9_stoppedIndex, hTω]
  calc
    ∫ ω, def_13_9_stoppedProcess X T n ω ∂P =
        ∫ ω, def_13_9_stoppedProcess X T 0 ω ∂P :=
      thm_13_15_expectation_constant hSM n
    _ = ∫ ω, X 0 ω ∂P := by rw [hzero]

/-- Combined public form of Theorem 13.17. -/
theorem thm_13_17
    {Ω : Type*} [𝓕 : MeasurableSpace Ω]
    {P : Measure Ω} {𝓕n : ℕ → MeasurableSpace Ω}
    {X : ℕ → Ω → ℝ} {T : Ω → WithTop ℕ}
    (hM : def_13_7 P 𝓕n X) (hT : def_13_8 𝓕n T) :
    def_13_7 P 𝓕n (def_13_9_stoppedProcess X T) ∧
      ∀ n : ℕ, ∫ ω, def_13_9_stoppedProcess X T n ω ∂P =
        ∫ ω, X 0 ω ∂P :=
  ⟨thm_13_17_stoppedProcess_martingale hM hT,
    thm_13_17_expectation_constant hM hT⟩
