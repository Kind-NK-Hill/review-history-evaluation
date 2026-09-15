import Mathlib
import ProbabilityTheory.chapter_13.thm_13_16
import ProbabilityTheory.chapter_13.thm_13_17_support

/-
TASK ID: thm_13_17
TYPE: Theorem_with_Proof
SOURCE PLAN: experiment_targets
TASK CONTENT:
\begin{thmbox}{13.17}
\end{thmbox}

The stopped process .(XT

n )n\geq0 is a martingale relative to the filtration

(\mathcal{F}n)n\geq0, andE[XT

n ]= E[X0] for alln \geq 0.

\textit{Proof} The expectationE[XT

n ] is less than or equal to maxk E[Xk], with maximum

taken over k = 0, 1,...,n Since E[Xk] is finite for all k, the maximum is also

finite.

For n \geq 0,t h e n-th random variable XT

n in the stopped process is a function of

X0,X 1,...,X n and T Since T is a stopping time, XT

n is\mathcal{F}n-measurable.

We write XT

n+1 as XT

n + (Xn+1 - Xn)1{T> n}The conditional expectation of

XT

n+1 given. \mathcal{F}n is

E[XT

n+1\vert\mathcal{F}n]= XT

n + 1{T> n}E[Xn+1 - Xn\vert\mathcal{F}n]= XT

n + 1{T> n} \cdot 0 = XT

n .

This proves that XT

n is a martingale relative to .(\mathcal{F}n)n\geq0.

Because.(XT

n )n\geq1 is a martingale, the last statement about the expectation. E[XT

n ]

follows from Theorem 13.16. \hfill $\square$

In contrast to the previous theorem, we are not just interested in the expected

value of the stopped process at a particular time, but also interested in the expected

value of the martingale sequence when it stops. The following theorem is called

the martingale stopping theorem, which is also known as Doob's optional stopping

theorem. Under the gambling scenario, the first condition in the theorem means

that a gambler has to leave the casino within a fixed duration. The second one

requires that the game must end when the gambler lose all of his fortune or win

a predetermined amount of money. The third one models the scenario in which the

increments are uniformly bounded.
-/

-- WRITE FINAL LEAN CODE BELOW


open MeasureTheory
open scoped ProbabilityTheory

noncomputable section

/-- The textbook filtration, packaged in Mathlib's filtration structure. -/
abbrev thm_13_17_filtration {Ω : Type*} [𝓕 : MeasurableSpace Ω]
    (𝓕n : ℕ → MeasurableSpace Ω)
    (h𝓕n : def_13_6_isFiltration (𝓕 := 𝓕) 𝓕n) :
    MeasureTheory.Filtration ℕ 𝓕 :=
  def_13_8_mathlibFiltration 𝓕n h𝓕n

/-- The stopped-process convention of Definition 13.9 agrees pointwise with
Mathlib's `stoppedProcess`. -/
theorem thm_13_17_stoppedProcess_eq {Ω S : Type*}
    (X : ℕ → Ω → S) (T : Ω → WithTop ℕ) :
    def_13_9_stoppedProcess X T = MeasureTheory.stoppedProcess X T := by
  funext n ω
  cases hT : T ω with
  | top =>
      simp only [def_13_9_stoppedProcess, def_13_9_stoppedIndex,
        MeasureTheory.stoppedProcess, hT]
      rw [min_eq_left le_top,
        WithTop.untopA_eq_untop WithTop.coe_ne_top, WithTop.untop_coe]
  | coe k =>
      simp only [def_13_9_stoppedProcess, def_13_9_stoppedIndex,
        MeasureTheory.stoppedProcess, hT]
      rw [min_comm, ← WithTop.coe_min,
        WithTop.untopA_eq_untop WithTop.coe_ne_top, WithTop.untop_coe]

/-- Theorem 13.17, martingale part: stopping a martingale at an arbitrary
stopping time preserves integrability, adaptedness, and the one-step
conditional-expectation identity. -/
theorem thm_13_17_stopped_martingale {Ω : Type*} [𝓕 : MeasurableSpace Ω]
    {P : Measure Ω} {𝓕n : ℕ → MeasurableSpace Ω} {X : ℕ → Ω → ℝ}
    {T : Ω → WithTop ℕ} (hM : def_13_7 P 𝓕n X) (hT : def_13_8 𝓕n T) :
    def_13_7 P 𝓕n (def_13_9_stoppedProcess X T) := by
  let ℱ : MeasureTheory.Filtration ℕ 𝓕 :=
    thm_13_17_filtration 𝓕n (def_13_7_isFiltration hM)
  letI : IsProbabilityMeasure P := def_13_7_isProbabilityMeasure hM
  have hτ : MeasureTheory.IsStoppingTime ℱ T := by
    simpa [ℱ, thm_13_17_filtration] using
      (def_13_8_toMathlibIsStoppingTime hT)
  have hXadapt : MeasureTheory.StronglyAdapted ℱ X := by
    intro n
    change StronglyMeasurable[𝓕n n] (X n)
    exact (def_13_7_adapted hM n).stronglyMeasurable
  have hYint : ∀ n, Integrable (MeasureTheory.stoppedProcess X T n) P :=
    fun n => MeasureTheory.integrable_stoppedProcess hτ
      (def_13_7_integrable hM) n
  have hYadapt : MeasureTheory.StronglyAdapted ℱ
      (MeasureTheory.stoppedProcess X T) :=
    hXadapt.stoppedProcess_of_discrete hτ
  rw [thm_13_17_stoppedProcess_eq X T]
  refine ⟨def_13_7_isFiltration hM, hYint, ?_, ?_⟩
  · intro n
    have hn := hYadapt n
    change StronglyMeasurable[𝓕n n] (MeasureTheory.stoppedProcess X T n) at hn
    exact hn.measurable
  · intro n
    let s : Set Ω := {ω | (n : WithTop ℕ) < T ω}
    let Z : Ω → ℝ := fun ω => X (n + 1) ω - X n ω
    have hs : @MeasurableSet Ω (𝓕n n) s := by
      have hs' := hτ.measurableSet_gt n
      change @MeasurableSet Ω (𝓕n n) {ω | (n : WithTop ℕ) < T ω} at hs'
      exact hs'
    have hZint : Integrable Z P :=
      (def_13_7_integrable hM (n + 1)).sub (def_13_7_integrable hM n)
    have hs_ambient : MeasurableSet s :=
      (def_13_7_condExp_sub_ambient hM n) s hs
    have hsZint : Integrable (s.indicator Z) P := hZint.indicator hs_ambient
    have hcoe (m : ℕ) : (m : WithTop ℕ).untopA = m := by
      calc
        (m : WithTop ℕ).untopA = (m : WithTop ℕ).untop (by simp) :=
          WithTop.untopA_eq_untop (by simp)
        _ = m := WithTop.untop_coe m
    have hstep : MeasureTheory.stoppedProcess X T (n + 1) =
        MeasureTheory.stoppedProcess X T n + s.indicator Z := by
      funext ω
      cases hTω : T ω with
      | top =>
          simp [MeasureTheory.stoppedProcess, s, Z, hTω, hcoe]
      | coe k =>
          simp only [MeasureTheory.stoppedProcess, s, Z, hTω,
            Set.mem_setOf_eq, Pi.add_apply]
          rw [← WithTop.coe_min, ← WithTop.coe_min,
            WithTop.untopA_eq_untop WithTop.coe_ne_top,
            WithTop.untopA_eq_untop WithTop.coe_ne_top,
            WithTop.untop_coe, WithTop.untop_coe]
          by_cases hnk : n < k
          · have hminn : min n k = n := min_eq_left hnk.le
            have hmins : min (n + 1) k = n + 1 := min_eq_left (Nat.succ_le_iff.2 hnk)
            simp [s, hTω, hnk, hminn, hmins]
          · have hkn : k ≤ n := Nat.le_of_not_gt hnk
            have hmins : min (n + 1) k = k := min_eq_right (hkn.trans (Nat.le_succ n))
            have hminn : min n k = k := min_eq_right hkn
            simp [s, hTω, hnk, hmins, hminn]
    have hcondZ : P[Z | 𝓕n n] =ᵐ[P] 0 := by
      change P[X (n + 1) - X n | 𝓕n n] =ᵐ[P] 0
      have hsub := condExp_sub (def_13_7_integrable hM (n + 1))
        (def_13_7_integrable hM n) (𝓕n n)
      have hnext := def_13_7_condExp_succ hM n
      have hself_eq := condExp_of_stronglyMeasurable
        (def_13_7_condExp_sub_ambient hM n)
        (def_13_7_adapted hM n).stronglyMeasurable
        (def_13_7_integrable hM n)
      have hself : P[X n | 𝓕n n] =ᵐ[P] X n :=
        Filter.Eventually.of_forall fun ω => congrFun hself_eq ω
      filter_upwards [hsub, hnext, hself] with ω hsubω hnextω hselfω
      rw [hsubω]
      change P[X (n + 1) | 𝓕n n] ω - P[X n | 𝓕n n] ω = 0
      rw [hnextω, hselfω]
      exact sub_self _
    have hindicator : P[s.indicator Z | 𝓕n n] =ᵐ[P] 0 := by
      refine (condExp_indicator hZint hs).trans ?_
      filter_upwards [hcondZ] with ω hω
      by_cases hωs : ω ∈ s <;> simp [Set.indicator, hωs, hω]
    have hselfY : P[MeasureTheory.stoppedProcess X T n | 𝓕n n] =ᵐ[P]
        MeasureTheory.stoppedProcess X T n := by
      have hn := hYadapt n
      change StronglyMeasurable[𝓕n n] (MeasureTheory.stoppedProcess X T n) at hn
      have heq := condExp_of_stronglyMeasurable
        (def_13_7_condExp_sub_ambient hM n) hn (hYint n)
      exact Filter.Eventually.of_forall fun ω => congrFun heq ω
    have hadd := condExp_add (hYint n) hsZint (𝓕n n)
    have hce : P[MeasureTheory.stoppedProcess X T (n + 1) | 𝓕n n] =ᵐ[P]
        MeasureTheory.stoppedProcess X T n := by
      rw [hstep]
      filter_upwards [hadd, hselfY, hindicator] with ω haddω hselfω hindicatorω
      calc
        P[MeasureTheory.stoppedProcess X T n + s.indicator Z | 𝓕n n] ω =
            (P[MeasureTheory.stoppedProcess X T n | 𝓕n n] +
              P[s.indicator Z | 𝓕n n]) ω := haddω
        _ = P[MeasureTheory.stoppedProcess X T n | 𝓕n n] ω +
              P[s.indicator Z | 𝓕n n] ω := rfl
        _ = MeasureTheory.stoppedProcess X T n ω + 0 := by
              rw [hselfω, hindicatorω]
              rfl
        _ = MeasureTheory.stoppedProcess X T n ω := add_zero _
    exact
      { isProbabilityMeasure := inferInstance
        sub_ambient := def_13_7_condExp_sub_ambient hM n
        integrable := hYint (n + 1)
        condExp_eq := hce }

/-- Theorem 13.17, expectation part: every finite-time stopped value has the
same expectation as the initial value. -/
theorem thm_13_17_expectation {Ω : Type*} [𝓕 : MeasurableSpace Ω]
    {P : Measure Ω} {𝓕n : ℕ → MeasurableSpace Ω} {X : ℕ → Ω → ℝ}
    {T : Ω → WithTop ℕ} (hM : def_13_7 P 𝓕n X) (hT : def_13_8 𝓕n T) :
    ∀ n : ℕ, ∫ ω, def_13_9_stoppedProcess X T n ω ∂P =
      ∫ ω, X 0 ω ∂P := by
  letI : IsProbabilityMeasure P := def_13_7_isProbabilityMeasure hM
  have hzero : def_13_9_stoppedProcess X T 0 = X 0 := by
    funext ω
    cases hTω : T ω <;>
      simp [def_13_9_stoppedProcess, def_13_9_stoppedIndex, hTω]
  intro n
  cases n with
  | zero => rw [hzero]
  | succ n =>
      rw [← hzero]
      exact thm_13_16 (thm_13_17_stopped_martingale hM hT) (n + 1)
        (Nat.succ_le_succ (Nat.zero_le n))

/-- Theorem 13.17: the stopped process is a martingale and its expectation is
constant. -/
theorem thm_13_17 {Ω : Type*} [𝓕 : MeasurableSpace Ω]
    {P : Measure Ω} {𝓕n : ℕ → MeasurableSpace Ω} {X : ℕ → Ω → ℝ}
    {T : Ω → WithTop ℕ} (hM : def_13_7 P 𝓕n X) (hT : def_13_8 𝓕n T) :
    def_13_7 P 𝓕n (def_13_9_stoppedProcess X T) ∧
      ∀ n : ℕ, ∫ ω, def_13_9_stoppedProcess X T n ω ∂P =
        ∫ ω, X 0 ω ∂P :=
  ⟨thm_13_17_stopped_martingale hM hT, thm_13_17_expectation hM hT⟩
