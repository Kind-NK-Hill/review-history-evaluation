set -eu
mkdir -p /tmp/supplement-l6/ProbabilityTheory/chapter_12
export LEAN_PATH="/tmp/supplement-l6:$LEAN_PATH"
lean --root=/checks/checks/L6_historical -o /tmp/supplement-l6/ProbabilityTheory/chapter_12/prob_12_5.olean /checks/checks/L6_historical/ProbabilityTheory/chapter_12/prob_12_5.lean
lean --root=/checks/checks/L6_historical -o /tmp/supplement-l6/ProbabilityTheory/chapter_12/prob_12_5_affine.olean /checks/checks/L6_historical/ProbabilityTheory/chapter_12/prob_12_5_affine.lean
lean /checks/checks/L6_B_composition.lean
