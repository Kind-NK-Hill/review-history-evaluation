import Mathlib

/-
TASK ID: thm_8_6
TYPE: Theorem_with_Proof
SOURCE PLAN: experiment_targets
TASK CONTENT:
\begin{thmbox}{8.6}
Suppose $P$ and $Q$ are probability measures defined on the set of nonnegative integers $\Omega=\{0,1,2,3,\dots\}$. Then, the total variation distance between $P$ and $Q$ is given by
\[
d_{TV}(P,Q)=\frac{1}{2}\sum_{i=0}^{\infty} |P(\{i\})-Q(\{i\})|.
\]

If probability measures $P$ and $Q$ have piece-wise continuous pdf's $f(x)$ and $g(x)$, respectively, then we have
\[
d_{TV}(P,Q)=\frac{1}{2}\int_{-\infty}^{\infty} |f(x)-g(x)|\, dx.
\]
\end{thmbox}

\textit{Proof} We only prove the discrete case. We first note that in the definition of total variation distance, we can remove the absolute value in (8.3) without changing the result. This is because if $P(A)<Q(A)$, we can consider the complement $A^c$ and use the fact that
\[
|P(A)-Q(A)| = |1-P(A^c)-(1-Q(A^c))| = P(A^c)-Q(A^c).
\]

Hence, the computation of total variation distance amounts to the maximization of $P(A)-Q(A)$ over all events $A$. We claim that is maximized when $A$ is the event
\[
A_+\triangleq \{i\in \Omega : P(\{i\})>Q(\{i\})\}.
\]

To see this, we let $A_-\triangleq \{i : P(\{i\})<Q(\{i\})\}$, and $A_0=\{i : P(\{i\})=Q(\{i\})\}$. The three events $A_+$, $A_-$, and $A_0$ are disjoint. Hence,
\[
P(A_+)+P(A_-)+P(A_0)=1=Q(A_+)+Q(A_-)+Q(A_0).
\]

By noting $P(A_0)=Q(A_0)$, we obtain
\[
|P(A_+)-Q(A_+)| = |P(A_-)-Q(A_-)| = \frac{1}{2}\sum_{i=0}^{\infty} |P(\{i\})-Q(\{i\})|.
\]

The proof for the continuous case is similar. \hfill $\square$
-/

-- WRITE FINAL LEAN CODE BELOW


open MeasureTheory Set
open scoped BigOperators ENNReal
noncomputable section

lemma totalVariationIntegralCore {α : Type*} [MeasurableSpace α]
    (μ : Measure α) (h : α → ℝ) (hh : Integrable h μ) (hm : Measurable h)
    (hz : ∫ x, h x ∂μ = 0) :
    sSup {d : ℝ | ∃ A : Set α, MeasurableSet A ∧ d = |∫ x in A, h x ∂μ|} =
      (1 / 2 : ℝ) * ∫ x, |h x| ∂μ := by
  let S : Set α := {x | 0 < h x}
  have hS : MeasurableSet S := measurableSet_lt measurable_const hm
  have hbound : ∀ A : Set α, MeasurableSet A →
      |∫ x in A, h x ∂μ| ≤ ∫ x in S, h x ∂μ := by
    intro A hA
    have hindicator : ∀ B : Set α, B.indicator h ≤ S.indicator h := by
      intro B x
      by_cases hxS : x ∈ S
      · change 0 < h x at hxS
        by_cases hxB : x ∈ B
        · simp [Set.indicator, hxB, show x ∈ S from hxS]
        · simp [Set.indicator, hxB, show x ∈ S from hxS, le_of_lt hxS]
      · have hxnon : h x ≤ 0 := by
          apply le_of_not_gt
          intro hx
          exact hxS hx
        by_cases hxB : x ∈ B
        · simpa [Set.indicator, hxB, hxS] using hxnon
        · simp [Set.indicator, hxB, hxS]
    have hpos : ∫ x in A, h x ∂μ ≤ ∫ x in S, h x ∂μ := by
      rw [← integral_indicator hA, ← integral_indicator hS]
      exact integral_mono (hh.indicator hA) (hh.indicator hS) (hindicator A)
    have hcomp : ∫ x in Aᶜ, h x ∂μ = -(∫ x in A, h x ∂μ) := by
      have := integral_add_compl hA hh
      linarith
    have hneg0 : ∫ x in Aᶜ, h x ∂μ ≤ ∫ x in S, h x ∂μ := by
      rw [← integral_indicator hA.compl, ← integral_indicator hS]
      exact integral_mono (hh.indicator hA.compl) (hh.indicator hS) (hindicator Aᶜ)
    have hneg : -(∫ x in A, h x ∂μ) ≤ ∫ x in S, h x ∂μ := by
      rw [← hcomp]
      exact hneg0
    rw [abs_le]
    constructor <;> linarith
  let T : Set ℝ := {d : ℝ | ∃ A : Set α, MeasurableSet A ∧ d = |∫ x in A, h x ∂μ|}
  have hTne : T.Nonempty := by refine ⟨0, ∅, MeasurableSet.empty, by simp⟩
  have hTbdd : BddAbove T := by
    refine ⟨∫ x in S, h x ∂μ, ?_⟩
    intro d hd
    rcases hd with ⟨A, hA, rfl⟩
    exact hbound A hA
  have hsup : sSup T = ∫ x in S, h x ∂μ := by
    apply le_antisymm
    · exact csSup_le hTne fun d hd => by
        rcases hd with ⟨A, hA, rfl⟩
        exact hbound A hA
    · apply le_csSup hTbdd
      refine ⟨S, hS, ?_⟩
      rw [abs_of_nonneg]
      exact integral_nonneg_of_ae
        (ae_restrict_of_forall_mem hS fun x hx => le_of_lt hx)
  have habs : (fun x => |h x|) = fun x => 2 * S.indicator h x - h x := by
    funext x
    by_cases hx : x ∈ S
    · change 0 < h x at hx
      simp [Set.indicator, show x ∈ S from hx, abs_of_pos hx]
      ring
    · have hx' : h x ≤ 0 := by
        apply le_of_not_gt
        intro hp
        exact hx hp
      simp [Set.indicator, hx, abs_of_nonpos hx']
  have hSI : ∫ x, S.indicator h x ∂μ = ∫ x in S, h x ∂μ := integral_indicator hS
  change sSup T = _
  rw [hsup, habs, integral_sub ((hh.indicator hS).const_mul 2) hh,
    integral_const_mul, hz, hSI]
  ring

lemma withDensity_real_eq_setIntegral {α : Type*} [MeasurableSpace α]
    (μ : Measure α) (f : α → ℝ) (hf : Integrable f μ) (hn : 0 ≤ᵐ[μ] f)
    (A : Set α) (hA : MeasurableSet A) :
    (μ.withDensity (fun x => ENNReal.ofReal (f x))).real A = ∫ x in A, f x ∂μ := by
  rw [measureReal_def, withDensity_apply _ hA,
    ← ofReal_integral_eq_lintegral_ofReal hf.integrableOn (ae_restrict_of_ae hn)]
  rw [ENNReal.toReal_ofReal]
  exact integral_nonneg_of_ae (ae_restrict_of_ae hn)

theorem thm_8_6_density {α : Type*} [MeasurableSpace α]
    (μ : Measure α) (f g : α → ℝ)
    (hf : Integrable f μ) (hg : Integrable g μ)
    (hmf : Measurable f) (hmg : Measurable g)
    (hfn : 0 ≤ᵐ[μ] f) (hgn : 0 ≤ᵐ[μ] g)
    (hf1 : ∫ x, f x ∂μ = 1) (hg1 : ∫ x, g x ∂μ = 1) :
    sSup {d : ℝ | ∃ A : Set α, MeasurableSet A ∧ d =
      |(μ.withDensity (fun x => ENNReal.ofReal (f x))).real A -
       (μ.withDensity (fun x => ENNReal.ofReal (g x))).real A|} =
      (1 / 2 : ℝ) * ∫ x, |f x - g x| ∂μ := by
  have hfg : Integrable (fun x => f x - g x) μ := hf.sub hg
  have hz : ∫ x, (f x - g x) ∂μ = 0 := by
    rw [integral_sub hf hg, hf1, hg1]
    ring
  have hset :
      {d : ℝ | ∃ A : Set α, MeasurableSet A ∧ d =
        |(μ.withDensity (fun x => ENNReal.ofReal (f x))).real A -
          (μ.withDensity (fun x => ENNReal.ofReal (g x))).real A|} =
      {d : ℝ | ∃ A : Set α, MeasurableSet A ∧ d = |∫ x in A, f x - g x ∂μ|} := by
    ext d
    constructor
    · rintro ⟨A, hA, rfl⟩
      refine ⟨A, hA, ?_⟩
      rw [withDensity_real_eq_setIntegral μ f hf hfn A hA,
        withDensity_real_eq_setIntegral μ g hg hgn A hA,
        ← integral_sub hf.integrableOn hg.integrableOn]
    · rintro ⟨A, hA, rfl⟩
      refine ⟨A, hA, ?_⟩
      rw [withDensity_real_eq_setIntegral μ f hf hfn A hA,
        withDensity_real_eq_setIntegral μ g hg hgn A hA,
        ← integral_sub hf.integrableOn hg.integrableOn]
  rw [hset, totalVariationIntegralCore μ (fun x => f x - g x)
    hfg (hmf.sub hmg) hz]

theorem thm_8_6_of_pmf (p q : ℕ → ℝ)
    (hp : Summable p) (hq : Summable q)
    (hpn : ∀ n, 0 ≤ p n) (hqn : ∀ n, 0 ≤ q n)
    (hp1 : ∑' n, p n = 1) (hq1 : ∑' n, q n = 1) :
    sSup {d : ℝ | ∃ A : Set ℕ, MeasurableSet A ∧ d =
      |(Measure.count.withDensity (fun n => ENNReal.ofReal (p n))).real A -
       (Measure.count.withDensity (fun n => ENNReal.ofReal (q n))).real A|} =
      (1 / 2 : ℝ) * ∑' n, |p n - q n| := by
  have hpI : Integrable p Measure.count := by
    rw [integrable_count_iff]
    simpa [Real.norm_eq_abs] using hp.norm
  have hqI : Integrable q Measure.count := by
    rw [integrable_count_iff]
    simpa [Real.norm_eq_abs] using hq.norm
  have hpInt : ∫ n, p n ∂Measure.count = ∑' n, p n := by
    rw [integral_countable hpI]
    simp [measureReal_def]
  have hqInt : ∫ n, q n ∂Measure.count = ∑' n, q n := by
    rw [integral_countable hqI]
    simp [measureReal_def]
  have hdiffI : Integrable (fun n => |p n - q n|) Measure.count := (hpI.sub hqI).abs
  have hdiffInt : ∫ n, |p n - q n| ∂Measure.count = ∑' n, |p n - q n| := by
    rw [integral_countable hdiffI]
    simp [measureReal_def]
  rw [← hdiffInt]
  exact thm_8_6_density Measure.count p q hpI hqI (by fun_prop) (by fun_prop)
    (ae_of_all _ hpn) (ae_of_all _ hqn) (hpInt.trans hp1) (hqInt.trans hq1)


/-- The discrete statement of Theorem 8.6 for arbitrary probability measures on `ℕ`.
The left side is Definition 8.5 expanded, so this bundle does not fork that public object. -/
theorem thm_8_6 (P Q : Measure ℕ) [IsProbabilityMeasure P] [IsProbabilityMeasure Q] :
    sSup {d : ℝ | ∃ A : Set ℕ, MeasurableSet A ∧ d = |P.real A - Q.real A|} =
      (1 / 2 : ℝ) * ∑' n, |P.real {n} - Q.real {n}| := by
  let p : ℕ → ℝ := fun n => P.real {n}
  let q : ℕ → ℝ := fun n => Q.real {n}
  have hPmass : ∑' n, P {n} = 1 := by
    simpa only [Measure.toPMF_apply] using PMF.tsum_coe P.toPMF
  have hQmass : ∑' n, Q {n} = 1 := by
    simpa only [Measure.toPMF_apply] using PMF.tsum_coe Q.toPMF
  have hp : Summable p := by
    have ht : (∑' n, P {n}) ≠ ⊤ := by rw [hPmass]; simp
    simpa only [p, measureReal_def] using ENNReal.summable_toReal ht
  have hq : Summable q := by
    have ht : (∑' n, Q {n}) ≠ ⊤ := by rw [hQmass]; simp
    simpa only [q, measureReal_def] using ENNReal.summable_toReal ht
  have hp1 : ∑' n, p n = 1 := by
    simp only [p, measureReal_def]
    rw [← ENNReal.tsum_toReal_eq (fun n => measure_ne_top P {n}), hPmass]
    simp
  have hq1 : ∑' n, q n = 1 := by
    simp only [q, measureReal_def]
    rw [← ENNReal.tsum_toReal_eq (fun n => measure_ne_top Q {n}), hQmass]
    simp
  have hPreconstruct :
      P = Measure.count.withDensity (fun n => ENNReal.ofReal (p n)) := by
    rw [Measure.ext_iff_singleton]
    intro n
    rw [withDensity_apply _ (measurableSet_singleton n)]
    simp [p, measureReal_def, ENNReal.ofReal_toReal, measure_ne_top]
  have hQreconstruct :
      Q = Measure.count.withDensity (fun n => ENNReal.ofReal (q n)) := by
    rw [Measure.ext_iff_singleton]
    intro n
    rw [withDensity_apply _ (measurableSet_singleton n)]
    simp [q, measureReal_def, ENNReal.ofReal_toReal, measure_ne_top]
  simpa only [p, q, ← hPreconstruct, ← hQreconstruct] using
    thm_8_6_of_pmf p q hp hq (fun n => measureReal_nonneg) (fun n => measureReal_nonneg)
      hp1 hq1
