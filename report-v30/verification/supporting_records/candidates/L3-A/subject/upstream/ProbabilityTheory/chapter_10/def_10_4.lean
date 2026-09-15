import Mathlib

/-
TASK ID: def_10_4
TYPE: Definition
SOURCE PLAN: chapter10-distribution-total-variation
TASK CONTENT:
\begin{defbox}{10.4 (Convergence in Distribution)}
Let $(F_n)_{n=1}^{\infty}$ be a sequence of cumulative distribution functions, and let $F$ be another cumulative distribution function. We say that $(F_n)_{n=1}^{\infty}$ converges in distribution, or in law, if
\[
\lim_{n\to\infty}F_n(x)=F(x)
\]
at every continuity point of $F(x)$. We use the notation
\[
F_n\xrightarrow{D}F
\qquad\text{or}\qquad
F_n\xrightarrow{L}F
\]
for convergence in distribution.

Given a sequence of probability measures $\mu_n$'s and another probability measure $\mu$, all defined on the real number line, we say that $(\mu_n)_{n=1}^{\infty}$ converges to $\mu$ in distribution if the corresponding Stieltjes measure functions
\[
F_n(x)=\mu_n((-\infty,x])
\qquad\text{and}\qquad
F(x)=\mu((-\infty,x])
\]
converge in distribution.

A sequence of random variables $X_n$'s, for $n=1,2,3,\ldots$, is said to be converging to a random variable $X$ in distribution, or in law, if the cumulative distribution functions of the $X_n$'s converge to the cumulative distribution function of $X$ in distribution.
\end{defbox}
-/

-- WRITE FINAL LEAN CODE BELOW

open Filter MeasureTheory ProbabilityTheory Set
open scoped Topology

noncomputable section

/-- The genuine cdf of a probability measure on the real line. -/
def measureCdf (μ : ProbabilityMeasure ℝ) (x : ℝ) : ℝ :=
  (μ : Measure ℝ).real (Iic x)

/-- The textbook cdf criterion, restricted to actual probability laws. -/
def CdfConvergesInDistribution
    (μn : ℕ → ProbabilityMeasure ℝ) (μ : ProbabilityMeasure ℝ) : Prop :=
  ∀ x : ℝ, ContinuousAt (measureCdf μ) x →
    Tendsto (fun n : ℕ => measureCdf (μn n) x) atTop (𝓝 (measureCdf μ x))

/-- Law-first convergence in distribution: weak convergence in Mathlib's
space of probability measures. -/
def MeasuresConvergeInDistribution
    (μn : ℕ → ProbabilityMeasure ℝ) (μ : ProbabilityMeasure ℝ) : Prop :=
  Tendsto μn atTop (𝓝 μ)

/-- A continuity point of a probability cdf is not an atom of its law. -/
theorem measure_singleton_eq_zero_of_measureCdf_continuousAt
    (μ : ProbabilityMeasure ℝ) {x : ℝ}
    (hcont : ContinuousAt (measureCdf μ) x) :
    (μ : Measure ℝ) {x} = 0 := by
  have hcont_cdf :
      ContinuousAt (fun y : ℝ => cdf (μ : Measure ℝ) y) x := by
    rw [show (fun y : ℝ => cdf (μ : Measure ℝ) y) = measureCdf μ by
      funext y
      exact cdf_eq_real (μ : Measure ℝ) y]
    exact hcont
  have hleft :
      Function.leftLim (fun y : ℝ => cdf (μ : Measure ℝ) y) x =
        cdf (μ : Measure ℝ) x :=
    hcont_cdf.continuousWithinAt.leftLim_eq
  rw [← measure_cdf (μ : Measure ℝ), StieltjesFunction.measure_singleton]
  simp [hleft]

private theorem weakConvergence_implies_cdfConvergence
    (μn : ℕ → ProbabilityMeasure ℝ) (μ : ProbabilityMeasure ℝ)
    (hWeak : Tendsto μn atTop (𝓝 μ)) :
    CdfConvergesInDistribution μn μ := by
  intro x hx
  have hAtom : (μ : Measure ℝ) {x} = 0 :=
    measure_singleton_eq_zero_of_measureCdf_continuousAt μ hx
  have hFrontier : μ (frontier (Iic x)) = 0 := by
    rw [ProbabilityMeasure.null_iff_toMeasure_null]
    simpa [frontier_Iic] using hAtom
  have hNN :=
    ProbabilityMeasure.tendsto_measure_of_null_frontier_of_tendsto
      hWeak hFrontier
  have hReal :
      Tendsto (fun n : ℕ => (μn n (Iic x) : ℝ)) atTop
        (𝓝 (μ (Iic x) : ℝ)) :=
    NNReal.tendsto_coe.2 hNN
  simpa [measureCdf] using hReal

private theorem cdfConvergence_implies_weakConvergence
    (μn : ℕ → ProbabilityMeasure ℝ) (μ : ProbabilityMeasure ℝ)
    (hCdf : CdfConvergesInDistribution μn μ) :
    Tendsto μn atTop (𝓝 μ) := by
  have hmono : Monotone (measureCdf μ) := by
    intro a b hab
    exact measureReal_mono (μ := (μ : Measure ℝ)) (Iic_subset_Iic.2 hab)
  let D : Set ℝ := {x : ℝ | ContinuousAt (measureCdf μ) x}
  have hD : Dense D := by
    have hbad :
        Set.Countable {x : ℝ | ¬ ContinuousAt (measureCdf μ) x} :=
      hmono.countable_not_continuousAt
    change Dense {x : ℝ | ContinuousAt (measureCdf μ) x}
    convert hbad.dense_compl ℝ using 1
    ext x
    simp
  let C : Set (Set ℝ) :=
    {s : Set ℝ | ∃ᵉ (a ∈ D) (b ∈ D), a < b ∧ Ioc a b = s}
  refine (isPiSystem_Ioc_mem D D).tendsto_probabilityMeasure_of_tendsto_of_mem
    (S := C) (μ := μn) (ν := μ) (l := atTop) ?_ ?_ ?_
  · rintro s ⟨a, ha, b, hb, hab, rfl⟩
    exact measurableSet_Ioc
  · intro u hu x hx
    rcases mem_nhds_iff_exists_Ioo_subset.mp (hu.mem_nhds hx) with
      ⟨a, b, hxab, hab⟩
    rcases hD.exists_between hxab.1 with ⟨l, hlD, hla⟩
    rcases hD.exists_between hxab.2 with ⟨r, hrD, hrb⟩
    refine ⟨Ioc l r, ⟨l, hlD, r, hrD, hla.2.trans hrb.1, rfl⟩,
      Ioc_mem_nhds hla.2 hrb.1, ?_⟩
    intro y hy
    exact hab ⟨hla.1.trans hy.1, hy.2.trans_lt hrb.2⟩
  · rintro s ⟨a, ha, b, hb, hab, rfl⟩
    have hIoc (ν : ProbabilityMeasure ℝ) :
        (ν : Measure ℝ).real (Ioc a b) =
          (ν : Measure ℝ).real (Iic b) -
            (ν : Measure ℝ).real (Iic a) := by
      rw [← Iic_sdiff_Iic, measureReal_sdiff
        (Iic_subset_Iic.2 hab.le) measurableSet_Iic
        (measure_ne_top (ν : Measure ℝ) (Iic b))]
    rw [← NNReal.tendsto_coe]
    simpa only [← ProbabilityMeasure.measureReal_eq_coe_coeFn,
      hIoc, measureCdf] using (hCdf b hb).sub (hCdf a ha)

/-- On `ℝ`, weak convergence of probability laws is equivalent to convergence
of their cdfs at every continuity point of the limiting cdf. -/
theorem measuresConvergeInDistribution_iff_cdf
    (μn : ℕ → ProbabilityMeasure ℝ) (μ : ProbabilityMeasure ℝ) :
    MeasuresConvergeInDistribution μn μ ↔
      CdfConvergesInDistribution μn μ := by
  unfold MeasuresConvergeInDistribution
  constructor
  · exact weakConvergence_implies_cdfConvergence μn μ
  · exact cdfConvergence_implies_weakConvergence μn μ

/-- Convergence in distribution for real random variables on possibly
different probability spaces.  Mathlib's structure records a.e. measurability
and weak convergence of the induced probability laws. -/
def RandomVariablesConvergeInDistribution
    {Ωn : ℕ → Type*} [∀ n, MeasurableSpace (Ωn n)]
    {Ω : Type*} [MeasurableSpace Ω]
    (μn : (n : ℕ) → Measure (Ωn n))
    [∀ n, IsProbabilityMeasure (μn n)]
    (Xn : (n : ℕ) → Ωn n → ℝ)
    (μ : Measure Ω) [IsProbabilityMeasure μ] (X : Ω → ℝ) : Prop :=
  TendstoInDistribution Xn atTop X μn μ

/-- The random-variable definition is precisely convergence of the laws,
with the required a.e. measurability witnesses made explicit. -/
theorem randomVariablesConvergeInDistribution_iff_laws
    {Ωn : ℕ → Type*} [∀ n, MeasurableSpace (Ωn n)]
    {Ω : Type*} [MeasurableSpace Ω]
    (μn : (n : ℕ) → Measure (Ωn n))
    [∀ n, IsProbabilityMeasure (μn n)]
    (Xn : (n : ℕ) → Ωn n → ℝ)
    (μ : Measure Ω) [IsProbabilityMeasure μ] (X : Ω → ℝ) :
    RandomVariablesConvergeInDistribution μn Xn μ X ↔
      ∃ (hXn : ∀ n, AEMeasurable (Xn n) (μn n))
        (hX : AEMeasurable X μ),
        MeasuresConvergeInDistribution
          (fun n : ℕ =>
            (⟨(μn n).map (Xn n),
              Measure.isProbabilityMeasure_map (hXn n)⟩ :
              ProbabilityMeasure ℝ))
          (⟨μ.map X, Measure.isProbabilityMeasure_map hX⟩ :
            ProbabilityMeasure ℝ) := by
  constructor
  · intro h
    exact ⟨h.forall_aemeasurable, h.aemeasurable_limit, h.tendsto⟩
  · rintro ⟨hXn, hX, hLaw⟩
    exact ⟨hXn, hX, hLaw⟩

/-- Exported definition for Definition 10.4. -/
def def_10_4 :=
  (@MeasuresConvergeInDistribution, @CdfConvergesInDistribution,
    @RandomVariablesConvergeInDistribution)
