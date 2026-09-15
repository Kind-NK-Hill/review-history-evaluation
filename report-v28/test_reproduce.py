"""Reject malformed panels and ungrounded changed outcomes before aggregation."""
import copy,unittest
from reproduce import HERE,read,outcome_summary
class OutcomeValidationTests(unittest.TestCase):
    def setUp(self):self.data=read(HERE/'evaluation/assessment.json')
    def test_frozen_panel(self):self.assertEqual(outcome_summary(self.data),self.data['summaries'])
    def test_duplicate_replacing_missing_task(self):
        self.data['rows'][1]=copy.deepcopy(self.data['rows'][0])
        with self.assertRaisesRegex(ValueError,'66 unique'):outcome_summary(self.data)
    def test_changed_verdict_requires_basis(self):
        row=next(r for r in self.data['rows'] if r['outcome']!=r['recorded_outcome'])
        row.pop('correction_basis')
        with self.assertRaisesRegex(ValueError,'justification'):outcome_summary(self.data)
    def test_nonfinite_time(self):
        self.data['rows'][0]['minutes']=float('nan')
        with self.assertRaisesRegex(ValueError,'elapsed'):outcome_summary(self.data)
if __name__=='__main__':unittest.main()
