import Mathlib

/- TASK ID: prob_13_9 -/

open MeasureTheory
open scoped ProbabilityTheory

noncomputable section

def prob_13_9_filtration {Ω : Type*} [MeasurableSpace Ω]
    (X : ℕ → Ω → ℝ) (hX : ∀ n, StronglyMeasurable (X n)) :
    Filtration ℕ ‹MeasurableSpace Ω› :=
  Filtration.natural X hX

def prob_13_9_innovation {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) (ℱ : Filtration ℕ ‹MeasurableSpace Ω›)
    (X : ℕ → Ω → ℝ) : ℕ → Ω → ℝ
  | 0 => 0
  | n + 1 => X (n + 1) - P[X (n + 1) | ℱ n]

def prob_13_9_partialSum {Ω : Type*} (Y : ℕ → Ω → ℝ) (n : ℕ) : Ω → ℝ :=
  ∑ k ∈ Finset.range n, Y (k + 1)

@[simp] theorem prob_13_9_partialSum_zero {Ω : Type*} (Y : ℕ → Ω → ℝ) :
    prob_13_9_partialSum Y 0 = 0 := by
  simp [prob_13_9_partialSum]

@[simp] theorem prob_13_9_partialSum_succ {Ω : Type*} (Y : ℕ → Ω → ℝ) (n : ℕ) :
    prob_13_9_partialSum Y (n + 1) =
      prob_13_9_partialSum Y n + Y (n + 1) := by
  simp [prob_13_9_partialSum, Finset.sum_range_succ]

theorem prob_13_9_filtration_zero_eq_bot {Ω : Type*} [MeasurableSpace Ω]
    (X : ℕ → Ω → ℝ) (hX : ∀ n, StronglyMeasurable (X n))
    (hX0 : X 0 = 0) :
    prob_13_9_filtration X hX 0 = ⊥ := by
  rw [prob_13_9_filtration, Filtration.natural_eq_comap]
  have hfun : (fun ω (j : Set.Iic (0 : ℕ)) => X j ω) =
      (fun _ => (fun _ => (0 : ℝ))) := by
    funext ω j
    have hj : (j : ℕ) = 0 := Nat.eq_zero_of_le_zero j.2
    simpa [hj, hX0]
  rw [hfun]
  simp

theorem prob_13_9_innovation_integrable {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) (ℱ : Filtration ℕ ‹MeasurableSpace Ω›)
    (X : ℕ → Ω → ℝ) (hXint : ∀ n, 1 ≤ n → Integrable (X n) P) :
    ∀ n, Integrable (prob_13_9_innovation P ℱ X n) P
  | 0 => by simpa [prob_13_9_innovation] using (integrable_zero Ω ℝ P)
  | n + 1 => (hXint (n + 1) (Nat.succ_le_succ (Nat.zero_le n))).sub integrable_condExp

theorem prob_13_9_innovation_stronglyAdapted {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) (X : ℕ → Ω → ℝ) (hX : ∀ n, StronglyMeasurable (X n)) :
    StronglyAdapted (prob_13_9_filtration X hX)
      (prob_13_9_innovation P (prob_13_9_filtration X hX) X) := by
  intro n
  cases n with
  | zero => exact stronglyMeasurable_zero
  | succ n =>
      exact (Filtration.stronglyAdapted_natural hX (n + 1)).sub
        (stronglyMeasurable_condExp.mono
          ((prob_13_9_filtration X hX).mono (Nat.le_succ n)))

theorem prob_13_9_partialSum_integrable {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) (ℱ : Filtration ℕ ‹MeasurableSpace Ω›)
    (X : ℕ → Ω → ℝ) (hXint : ∀ n, 1 ≤ n → Integrable (X n) P) :
    ∀ n, Integrable (prob_13_9_partialSum (prob_13_9_innovation P ℱ X) n) P
  | 0 => by simp
  | n + 1 => by
      rw [prob_13_9_partialSum_succ]
      exact (prob_13_9_partialSum_integrable P ℱ X hXint n).add
        (prob_13_9_innovation_integrable P ℱ X hXint (n + 1))

theorem prob_13_9_partialSum_stronglyAdapted {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) (X : ℕ → Ω → ℝ) (hX : ∀ n, StronglyMeasurable (X n)) :
    StronglyAdapted (prob_13_9_filtration X hX)
      (prob_13_9_partialSum
        (prob_13_9_innovation P (prob_13_9_filtration X hX) X)) := by
  let ℱ := prob_13_9_filtration X hX
  let Y := prob_13_9_innovation P ℱ X
  have hY : StronglyAdapted ℱ Y := prob_13_9_innovation_stronglyAdapted P X hX
  intro n
  induction n with
  | zero =>
      simpa [Y] using
        (stronglyMeasurable_zero : StronglyMeasurable[ℱ 0] (0 : Ω → ℝ))
  | succ n ih =>
      rw [prob_13_9_partialSum_succ]
      exact (ih.mono (ℱ.mono n.le_succ)).add (hY (n + 1))

theorem prob_13_9_condExp_innovation_succ_ae_eq_zero
    {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) [IsFiniteMeasure P]
    (ℱ : Filtration ℕ ‹MeasurableSpace Ω›)
    (X : ℕ → Ω → ℝ) (hXint : ∀ n, 1 ≤ n → Integrable (X n) P) (n : ℕ) :
    P[prob_13_9_innovation P ℱ X (n + 1) | ℱ n] =ᵐ[P] 0 := by
  rw [prob_13_9_innovation]
  refine (condExp_sub (hXint (n + 1) (Nat.succ_le_succ (Nat.zero_le n)))
    integrable_condExp (ℱ n)).trans ?_
  rw [condExp_of_stronglyMeasurable (ℱ.le n)
    stronglyMeasurable_condExp integrable_condExp]
  simp

private theorem prob_13_9_stronglyMeasurable
    {Ω : Type*} [MeasurableSpace Ω] (X : ℕ → Ω → ℝ)
    (hX0 : X 0 = 0) (hXmeas : ∀ n, 1 ≤ n → Measurable (X n)) :
    ∀ n, StronglyMeasurable (X n) := by
  intro n
  cases n with
  | zero =>
      simpa [hX0] using
        (stronglyMeasurable_zero : StronglyMeasurable (0 : Ω → ℝ))
  | succ n =>
      exact (hXmeas (n + 1) (Nat.succ_le_succ (Nat.zero_le n))).stronglyMeasurable

theorem prob_13_9
    {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) [IsProbabilityMeasure P]
    (X : ℕ → Ω → ℝ) (hX0 : X 0 = 0)
    (hXmeas : ∀ n, 1 ≤ n → Measurable (X n))
    (hXint : ∀ n, 1 ≤ n → Integrable (X n) P) :
    let hXstrong := prob_13_9_stronglyMeasurable X hX0 hXmeas
    let ℱ := prob_13_9_filtration X hXstrong
    let Y := prob_13_9_innovation P ℱ X
    let S := prob_13_9_partialSum Y
    Martingale S ℱ P := by
  dsimp only
  let hXstrong := prob_13_9_stronglyMeasurable X hX0 hXmeas
  let ℱ := prob_13_9_filtration X hXstrong
  let Y := prob_13_9_innovation P ℱ X
  let S := prob_13_9_partialSum Y
  change Martingale S ℱ P
  refine martingale_of_condExp_sub_eq_zero_nat
    (prob_13_9_partialSum_stronglyAdapted P X hXstrong)
    (prob_13_9_partialSum_integrable P ℱ X hXint) ?_
  intro n
  have hinc : S (n + 1) - S n = Y (n + 1) := by
    funext ω
    simp [S, Y]
  rw [hinc]
  exact prob_13_9_condExp_innovation_succ_ae_eq_zero P ℱ X hXint n
