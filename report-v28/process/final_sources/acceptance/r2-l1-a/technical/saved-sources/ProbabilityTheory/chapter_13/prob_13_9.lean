import Mathlib

/-
TASK ID: prob_13_9
TYPE: Problem
SOURCE PLAN: experiment_targets
TASK CONTENT:
\textbf{13.9.} Suppose (X n)n\geq0 is a sequence of random variables defined on a probability

space (we take X 0 = 0 as the initial rv.)For n \geq 1, let

Yn \coloneqqX n -E [Xn\vertX0,X 1,...,X n- 1].

The random variable Y n can be interpreted as the new information contained in X n

relative to the information contained in the past X 0,...,X n- 1Let Sn denote the

partial sum S n \coloneqqY 1 +Y 2 +\cdot\cdot\cdot+ Yn for n \geq 1 and S 0 = 0. Show that (S n)n\geq0 is a

martingale relative to the filtration (\sigma(X 1,X 2,...,X n))n\geq0.
-/

-- WRITE FINAL LEAN CODE BELOW

open MeasureTheory
open scoped BigOperators ProbabilityTheory
noncomputable section

def prob139History {Ω : Type*} (X : ℕ → Ω → ℝ) (n : ℕ) : Ω → Fin n → ℝ :=
  fun ω k => X (k.1 + 1) ω

def prob139Filtration {Ω : Type*} [m : MeasurableSpace Ω]
    (X : ℕ → Ω → ℝ) (hX : ∀ n, Measurable (X n)) : Filtration ℕ m where
  seq n := MeasurableSpace.comap (prob139History X n) inferInstance
  mono' := by
    intro n k hnk
    let p : (Fin k → ℝ) → (Fin n → ℝ) := fun v i => v (Fin.castLE hnk i)
    have hp : Measurable p := measurable_pi_lambda _ fun i => measurable_pi_apply (Fin.castLE hnk i)
    have heq : prob139History X n = p ∘ prob139History X k := by
      funext ω i
      simp [prob139History, p]
    change MeasurableSpace.comap (prob139History X n) inferInstance ≤ MeasurableSpace.comap (prob139History X k) inferInstance
    rw [heq]
    exact (hp.comp (Measurable.of_comap_le le_rfl)).comap_le
  le' := by
    intro n
    exact (measurable_pi_lambda _ fun (i : Fin n) => hX (i.1 + 1)).comap_le

theorem prob139_observation_measurable {Ω : Type*} [m : MeasurableSpace Ω]
    (X : ℕ → Ω → ℝ) (hX : ∀ n, Measurable (X n)) (n : ℕ) :
    Measurable[prob139Filtration X hX (n + 1)] (X (n + 1)) := by
  let e : (Fin (n + 1) → ℝ) → ℝ := fun v => v ⟨n, Nat.lt_succ_self n⟩
  have he : Measurable e := measurable_pi_apply (⟨n, Nat.lt_succ_self n⟩ : Fin (n + 1))
  have hh : Measurable[prob139Filtration X hX (n + 1)] (prob139History X (n + 1)) :=
    Measurable.of_comap_le le_rfl
  have heq : X (n + 1) = e ∘ prob139History X (n + 1) := by
    funext ω
    rfl
  rw [heq]
  exact he.comp hh

def prob139Innovation {Ω : Type*} [m : MeasurableSpace Ω]
    (P : Measure Ω) (X : ℕ → Ω → ℝ) (hX : ∀ n, Measurable (X n)) : ℕ → Ω → ℝ
  | 0 => 0
  | n + 1 => X (n + 1) - P[X (n + 1) | prob139Filtration X hX n]

def prob139PartialSum {Ω : Type*} [m : MeasurableSpace Ω]
    (P : Measure Ω) (X : ℕ → Ω → ℝ) (hX : ∀ n, Measurable (X n)) (n : ℕ) : Ω → ℝ :=
  fun ω => ∑ k ∈ Finset.range n, prob139Innovation P X hX (k + 1) ω

@[simp] theorem prob139PartialSum_zero {Ω : Type*} [m : MeasurableSpace Ω]
    (P : Measure Ω) (X : ℕ → Ω → ℝ) (hX : ∀ n, Measurable (X n)) :
    prob139PartialSum P X hX 0 = 0 := by funext ω; simp [prob139PartialSum]

theorem prob139PartialSum_succ {Ω : Type*} [m : MeasurableSpace Ω]
    (P : Measure Ω) (X : ℕ → Ω → ℝ) (hX : ∀ n, Measurable (X n)) (n : ℕ) :
    prob139PartialSum P X hX (n + 1) =
      prob139PartialSum P X hX n + prob139Innovation P X hX (n + 1) := by
  funext ω
  simp [prob139PartialSum, Finset.sum_range_succ]

theorem prob139Innovation_integrable {Ω : Type*} [m : MeasurableSpace Ω]
    (P : Measure Ω) (X : ℕ → Ω → ℝ) (hX : ∀ n, Measurable (X n))
    (hInt : ∀ n, Integrable (X n) P) (n : ℕ) :
    Integrable (prob139Innovation P X hX n) P := by
  cases n with
  | zero => exact integrable_zero Ω ℝ P
  | succ n => exact (hInt (n + 1)).sub integrable_condExp

theorem prob139Innovation_stronglyAdapted {Ω : Type*} [m : MeasurableSpace Ω]
    (P : Measure Ω) (X : ℕ → Ω → ℝ) (hX : ∀ n, Measurable (X n)) :
    StronglyAdapted (prob139Filtration X hX) (prob139Innovation P X hX) := by
  intro n
  cases n with
  | zero => exact stronglyMeasurable_zero
  | succ n =>
      exact (prob139_observation_measurable X hX n).stronglyMeasurable.sub
        (stronglyMeasurable_condExp.mono ((prob139Filtration X hX).mono (Nat.le_succ n)))

theorem prob139Innovation_condExp_eq_zero {Ω : Type*} [m : MeasurableSpace Ω]
    (P : Measure Ω) [IsProbabilityMeasure P]
    (X : ℕ → Ω → ℝ) (hX : ∀ n, Measurable (X n))
    (hInt : ∀ n, Integrable (X n) P) (n : ℕ) :
    P[prob139Innovation P X hX (n + 1) | prob139Filtration X hX n] =ᵐ[P] 0 := by
  calc
    P[prob139Innovation P X hX (n + 1) | prob139Filtration X hX n]
        =ᵐ[P] P[X (n + 1) | prob139Filtration X hX n] -
          P[P[X (n + 1) | prob139Filtration X hX n] | prob139Filtration X hX n] := by
            simpa [prob139Innovation] using
              (condExp_sub (hInt (n + 1)) integrable_condExp (prob139Filtration X hX n))
    _ =ᵐ[P] 0 := by
      rw [condExp_of_stronglyMeasurable
        ((prob139Filtration X hX).le n) stronglyMeasurable_condExp integrable_condExp]
      exact Filter.Eventually.of_forall fun ω => sub_self _

theorem prob139PartialSum_integrable {Ω : Type*} [m : MeasurableSpace Ω]
    (P : Measure Ω) (X : ℕ → Ω → ℝ) (hX : ∀ n, Measurable (X n))
    (hInt : ∀ n, Integrable (X n) P) (n : ℕ) :
    Integrable (prob139PartialSum P X hX n) P := by
  unfold prob139PartialSum
  apply integrable_finsetSum
  intro k hk
  exact prob139Innovation_integrable P X hX hInt (k + 1)

theorem prob139PartialSum_stronglyAdapted {Ω : Type*} [m : MeasurableSpace Ω]
    (P : Measure Ω) (X : ℕ → Ω → ℝ) (hX : ∀ n, Measurable (X n)) :
    StronglyAdapted (prob139Filtration X hX) (prob139PartialSum P X hX) := by
  intro n
  unfold prob139PartialSum
  apply Finset.stronglyMeasurable_fun_sum
  intro k hk
  exact (prob139Innovation_stronglyAdapted P X hX (k + 1)).mono
    ((prob139Filtration X hX).mono (Nat.succ_le_of_lt (Finset.mem_range.mp hk)))

theorem prob_13_9 {Ω : Type*} [m : MeasurableSpace Ω]
    (P : Measure Ω) [IsProbabilityMeasure P]
    (X : ℕ → Ω → ℝ) (hX0 : X 0 = 0)
    (hX : ∀ n, Measurable (X n)) (hInt : ∀ n, Integrable (X n) P) :
    Martingale (prob139PartialSum P X hX) (prob139Filtration X hX) P := by
  refine martingale_of_condExp_sub_eq_zero_nat
    (prob139PartialSum_stronglyAdapted P X hX)
    (prob139PartialSum_integrable P X hX hInt) ?_
  intro n
  have hdiff : prob139PartialSum P X hX (n + 1) - prob139PartialSum P X hX n =
      prob139Innovation P X hX (n + 1) := by
    rw [prob139PartialSum_succ]
    abel
  rw [hdiff]
  exact prob139Innovation_condExp_eq_zero P X hX hInt n
