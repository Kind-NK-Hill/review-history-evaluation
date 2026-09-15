import ProbabilityTheory.chapter_09.thm_9_5
import ProbabilityTheory.chapter_03.thm_3_9
import Mathlib.MeasureTheory.Measure.CharacteristicFunction.Basic
import Mathlib.MeasureTheory.Measure.Typeclasses.SFinite

open Filter MeasureTheory Set

/-- Removing the (at most countable) common discontinuity/atom set leaves the
dense endpoint set used in the textbook interval argument. -/
theorem dense_continuity_endpoints_of_countable (s₁ s₂ : Set ℝ)
    (h₁ : s₁.Countable) (h₂ : s₂.Countable) : Dense (s₁ ∪ s₂)ᶜ := by
  exact (h₁.union h₂).dense_compl ℝ

/-- Equality on all half-lines determines a probability law.  This records the
last measure-determination step of the textbook uniqueness proof. -/
theorem probabilityMeasure_eq_of_Iic_eq
    (μ ν : Measure ℝ) [IsProbabilityMeasure μ] [IsProbabilityMeasure ν]
    (h : ∀ x, μ (Iic x) = ν (Iic x)) : μ = ν :=
  thm_3_9 μ ν h

/-- Atoms of a finite real measure form a countable set. -/
noncomputable def measureAtoms (μ : Measure ℝ) : Set ℝ := {x | μ {x} ≠ 0}

theorem countable_measureAtoms (μ : Measure ℝ) [IsFiniteMeasure μ] :
    (measureAtoms μ).Countable := by
  have h := Measure.countable_meas_level_set_pos (μ := μ) (g := fun x : ℝ ↦ x) measurable_id
  simpa [measureAtoms, pos_iff_ne_zero] using h

theorem dense_common_nonatom_endpoints (μ ν : Measure ℝ)
    [IsFiniteMeasure μ] [IsFiniteMeasure ν] :
    Dense (measureAtoms μ ∪ measureAtoms ν)ᶜ :=
  dense_continuity_endpoints_of_countable _ _ (countable_measureAtoms μ)
    (countable_measureAtoms ν)

/-- The inversion formula makes the two laws agree on every open interval whose
endpoints are non-atoms of both laws. -/
theorem inversion_interval_eq_of_charFun_eq
    (μ ν : Measure ℝ) [IsFiniteMeasure μ] [IsFiniteMeasure ν]
    (h : ∀ t : ℝ, characteristicFunction μ t = characteristicFunction ν t)
    {a b : ℝ} (hab : a < b)
    (haμ : a ∉ measureAtoms μ) (hbμ : b ∉ measureAtoms μ)
    (haν : a ∉ measureAtoms ν) (hbν : b ∉ measureAtoms ν) :
    μ.real (Ioo a b) = ν.real (Ioo a b) := by
  have hma : μ {a} = 0 := not_ne_iff.mp haμ
  have hmb : μ {b} = 0 := not_ne_iff.mp hbμ
  have hna : ν {a} = 0 := not_ne_iff.mp haν
  have hnb : ν {b} = 0 := not_ne_iff.mp hbν
  let Fμ : ℝ → ℂ := fun T ↦ (2 * Real.pi : ℂ)⁻¹ * (∫ t in -T..T,
    ((Complex.exp (-(t : ℂ) * (a : ℂ) * Complex.I) -
      Complex.exp (-(t : ℂ) * (b : ℂ) * Complex.I)) / ((t : ℂ) * Complex.I)) *
      characteristicFunction μ t)
  let Fν : ℝ → ℂ := fun T ↦ (2 * Real.pi : ℂ)⁻¹ * (∫ t in -T..T,
    ((Complex.exp (-(t : ℂ) * (a : ℂ) * Complex.I) -
      Complex.exp (-(t : ℂ) * (b : ℂ) * Complex.I)) / ((t : ℂ) * Complex.I)) *
      characteristicFunction ν t)
  have heq : Fμ = Fν := by
    funext T
    unfold Fμ Fν
    congr 2
    funext t
    rw [h t]
  have hm := CharacteristicFunctionInversion.thm_9_5_normalized μ hab
  have hn := CharacteristicFunctionInversion.thm_9_5_normalized ν hab
  have hm' : Tendsto Fμ atTop (nhds ((μ.real (Ioo a b) : ℝ) : ℂ)) := by
    convert hm using 1
    simp [Measure.real, hma, hmb]
  have hn' : Tendsto Fν atTop (nhds ((ν.real (Ioo a b) : ℝ) : ℂ)) := by
    convert hn using 1
    simp [Measure.real, hna, hnb]
  rw [heq] at hm'
  exact_mod_cast tendsto_nhds_unique hm' hn'

/-- The characteristic function uniquely determines a finite real measure. -/
theorem thm_9_6_law (μ ν : Measure ℝ) [IsFiniteMeasure μ] [IsFiniteMeasure ν]
    (h : ∀ t : ℝ, characteristicFunction μ t = characteristicFunction ν t) : μ = ν := by
  let D : Set ℝ := (measureAtoms μ ∪ measureAtoms ν)ᶜ
  have hD : Dense D := dense_common_nonatom_endpoints μ ν
  have hinter : ∀ {a b : ℝ}, a ∈ D → b ∈ D → a < b → μ (Ioo a b) = ν (Ioo a b) := by
    intro a b ha hb hab
    have hr := inversion_interval_eq_of_charFun_eq μ ν h hab
      (fun haμ ↦ ha (Or.inl haμ)) (fun hbμ ↦ hb (Or.inl hbμ))
      (fun haν ↦ ha (Or.inr haν)) (fun hbν ↦ hb (Or.inr hbν))
    apply (ENNReal.toReal_eq_toReal_iff' (measure_ne_top μ _) (measure_ne_top ν _)).mp
    simpa [Measure.real] using hr
  have hIoiD : ∀ d ∈ D, μ (Ioi d) = ν (Ioi d) := by
    intro d hd
    choose u huD hu using fun n : ℕ ↦ hD.exists_between
      (show d + (n : ℝ) + 1 < d + (n : ℝ) + 2 by linarith)
    have hu_strict : StrictMono u := by
      intro n m hnm
      have hnm' : (n : ℝ) + 1 ≤ (m : ℝ) := by exact_mod_cast hnm
      calc
        u n < d + (n : ℝ) + 2 := (hu n).2
        _ ≤ d + (m : ℝ) + 1 := by linarith
        _ < u m := (hu m).1
    have hmono : Monotone (fun n ↦ Ioo d (u n)) := fun _ _ hnm ↦
      Ioo_subset_Ioo_right (hu_strict.monotone hnm)
    have hunion : (⋃ n, Ioo d (u n)) = Ioi d := by
      ext z
      simp only [mem_iUnion, mem_Ioo, mem_Ioi]
      constructor
      · rintro ⟨n, hdz, -⟩
        exact hdz
      · intro hdz
        obtain ⟨n, hn⟩ := exists_nat_gt (z - d - 1)
        refine ⟨n, hdz, ?_⟩
        exact (show z < d + (n : ℝ) + 1 by linarith).trans (hu n).1
    have hm := MeasureTheory.tendsto_measure_iUnion_atTop (μ := μ) hmono
    have hn := MeasureTheory.tendsto_measure_iUnion_atTop (μ := ν) hmono
    rw [hunion] at hm hn
    apply tendsto_nhds_unique hm
    apply hn.congr'
    filter_upwards with n
    have hn_nonneg : (0 : ℝ) ≤ (n : ℝ) := Nat.cast_nonneg n
    have hdu : d < u n := by linarith [(hu n).1]
    exact (hinter hd (huD n) hdu).symm
  have hIoi : ∀ x : ℝ, μ (Ioi x) = ν (Ioi x) := by
    intro x
    obtain ⟨d, hdanti, hdxD, hdlim⟩ := hD.exists_seq_strictAnti_tendsto x
    have hmono : Monotone (fun n ↦ Ioi (d n)) := fun _ _ hnm ↦
      Ioi_subset_Ioi (hdanti.antitone hnm)
    have hunion : (⋃ n, Ioi (d n)) = Ioi x :=
      (isGLB_of_tendsto_atTop hdanti.antitone hdlim).iUnion_Ioi_eq
    have hm := MeasureTheory.tendsto_measure_iUnion_atTop (μ := μ) hmono
    have hn := MeasureTheory.tendsto_measure_iUnion_atTop (μ := ν) hmono
    rw [hunion] at hm hn
    apply tendsto_nhds_unique hm
    apply hn.congr'
    filter_upwards with n
    exact (hIoiD (d n) (hdxD n).2).symm
  have huniv : μ univ = ν univ := by
    have h0 := h 0
    simp only [characteristicFunction, charFun_zero] at h0
    apply (ENNReal.toReal_eq_toReal_iff' (measure_ne_top μ _) (measure_ne_top ν _)).mp
    simpa [Measure.real] using h0
  apply Measure.ext_of_Iic
  intro x
  rw [show Iic x = (Ioi x)ᶜ by ext y; simp]
  rw [MeasureTheory.measure_compl measurableSet_Ioi (measure_ne_top μ _)]
  rw [MeasureTheory.measure_compl measurableSet_Ioi (measure_ne_top ν _)]
  rw [huniv, hIoi x]
/-- Textbook Theorem 9.6 for random variables: equality of characteristic
functions implies equality of push-forward laws. -/
theorem thm_9_6
    {Ω Ω' : Type*} [MeasurableSpace Ω] [MeasurableSpace Ω']
    (P : Measure Ω) (Q : Measure Ω') [IsProbabilityMeasure P] [IsProbabilityMeasure Q]
    (X : Ω → ℝ) (Y : Ω' → ℝ) (hX : AEMeasurable X P) (hY : AEMeasurable Y Q)
    (h : ∀ t : ℝ,
      characteristicFunction (P.map X) t = characteristicFunction (Q.map Y) t) :
    P.map X = Q.map Y := by
  exact thm_9_6_law (P.map X) (Q.map Y) h
