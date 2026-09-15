import Mathlib

/-
TASK ID: def_10_1
TYPE: Definition
SOURCE PLAN: chapter10-almost-sure-probability
TASK CONTENT:
\begin{defbox}{10.1}
A sequence of random variables $(X_n)_{n\geq 1}$ defined on a probability space $(\Omega,\mathcal{F},P)$ is said to converge to $X$ surely if
\[
\lim_{n\to\infty} X_n(\omega)=X(\omega)
\]
for all $\omega\in\Omega$.

A sequence of random variables $(X_n)_{n\geq 1}$ is said to converge to $X$ almost surely if there exists an event $E$ with $P(E)=1$ such that
\[
\lim_{n\to\infty} X_n(\omega)=X(\omega)
\]
for $\omega$ in $E$. In this case, we write $X_n\xrightarrow{\mathrm{a.s.}}X$ or $X_n\to X$ with probability $1$.
\end{defbox}
-/

-- WRITE FINAL LEAN CODE BELOW

open Filter MeasureTheory

/-- Sure convergence of a sequence of real-valued random variables: the
sequence and its limit are random variables, and convergence is pointwise at
every sample point. -/
def ConvergesSurely {Ω : Type*} [MeasurableSpace Ω] (μ : Measure Ω)
    (Xn : ℕ → Ω → ℝ) (X : Ω → ℝ) : Prop :=
  (∀ n : ℕ, AEStronglyMeasurable (Xn n) μ) ∧
    AEStronglyMeasurable X μ ∧
      ∀ ω : Ω, Tendsto (fun n : ℕ => Xn n ω) atTop (nhds (X ω))

/-- Almost sure convergence in the Mathlib-native almost-everywhere form.  The
measurability conjuncts record the random-variable contract. -/
def ConvergesAlmostSurely {Ω : Type*} [MeasurableSpace Ω] (μ : Measure Ω)
    (Xn : ℕ → Ω → ℝ) (X : Ω → ℝ) : Prop :=
  (∀ n : ℕ, AEStronglyMeasurable (Xn n) μ) ∧
    AEStronglyMeasurable X μ ∧
      ∀ᵐ ω ∂μ, Tendsto (fun n : ℕ => Xn n ω) atTop (nhds (X ω))

/-- The event form of almost-sure convergence for an arbitrary measure:
the random-variable contract together with convergence on a measurable event
whose complement is null. -/
def ConvergesAlmostSurelyOnEvent {Ω : Type*} [MeasurableSpace Ω] (μ : Measure Ω)
    (Xn : ℕ → Ω → ℝ) (X : Ω → ℝ) : Prop :=
  (∀ n : ℕ, AEStronglyMeasurable (Xn n) μ) ∧
    AEStronglyMeasurable X μ ∧
      ∃ E : Set Ω, MeasurableSet E ∧ μ Eᶜ = 0 ∧
        ∀ ω ∈ E, Tendsto (fun n : ℕ => Xn n ω) atTop (nhds (X ω))

/-- The measurable full-event form is equivalent to Mathlib's almost-everywhere
form for every measure. -/
theorem convergesAlmostSurelyOnEvent_iff {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (Xn : ℕ → Ω → ℝ) (X : Ω → ℝ) :
    ConvergesAlmostSurelyOnEvent μ Xn X ↔ ConvergesAlmostSurely μ Xn X := by
  constructor
  · rintro ⟨hXn, hX, E, hE, hE_full, hconv⟩
    refine ⟨hXn, hX, ae_iff.2 ?_⟩
    refine MeasureTheory.measure_mono_null ?_ hE_full
    intro ω hbad
    change ω ∉ E
    intro hω
    exact hbad (hconv ω hω)
  · rintro ⟨hXn, hX, hconv⟩
    have hbad :
        μ {ω : Ω | ¬ Tendsto (fun n : ℕ => Xn n ω) atTop (nhds (X ω))} = 0 :=
      ae_iff.1 hconv
    obtain ⟨N, hbadN, hN_meas, hN_null⟩ :=
      exists_measurable_superset_of_null hbad
    refine ⟨hXn, hX, Nᶜ, hN_meas.compl, ?_, ?_⟩
    · simpa only [compl_compl] using hN_null
    · intro ω hω
      by_contra hω_bad
      exact hω (hbadN hω_bad)

/-- On a probability space, the generic full-event form is exactly the
textbook measurable-event-of-probability-one formulation. -/
theorem convergesAlmostSurely_iff_exists_measure_one_event
    {Ω : Type*} [MeasurableSpace Ω] (μ : Measure Ω) [IsProbabilityMeasure μ]
    (Xn : ℕ → Ω → ℝ) (X : Ω → ℝ) :
    ConvergesAlmostSurely μ Xn X ↔
      (∀ n : ℕ, AEStronglyMeasurable (Xn n) μ) ∧
        AEStronglyMeasurable X μ ∧
          ∃ E : Set Ω, MeasurableSet E ∧ μ E = 1 ∧
            ∀ ω ∈ E, Tendsto (fun n : ℕ => Xn n ω) atTop (nhds (X ω)) := by
  constructor
  · intro hconv
    rcases (convergesAlmostSurelyOnEvent_iff μ Xn X).2 hconv with
      ⟨hXn, hX, E, hE, hE_full, hE_conv⟩
    refine ⟨hXn, hX, E, hE, ?_, hE_conv⟩
    have hfin : μ Eᶜ ≠ ⊤ := by
      rw [hE_full]
      simp
    simpa [hE_full, MeasureTheory.IsProbabilityMeasure.measure_univ] using
      (MeasureTheory.measure_compl hE.compl hfin)
  · rintro ⟨hXn, hX, E, hE, hE_one, hE_conv⟩
    apply (convergesAlmostSurelyOnEvent_iff μ Xn X).1
    refine ⟨hXn, hX, E, hE, ?_, hE_conv⟩
    have hfin : μ E ≠ ⊤ := by
      rw [hE_one]
      simp
    rw [MeasureTheory.measure_compl hE hfin]
    simp [hE_one, MeasureTheory.IsProbabilityMeasure.measure_univ]

/-- Exported definition for Definition 10.1: the sure and almost-sure convergence
interfaces introduced by the textbook. -/
def def_10_1 :=
  (@ConvergesSurely, @ConvergesAlmostSurely, @ConvergesAlmostSurelyOnEvent)
