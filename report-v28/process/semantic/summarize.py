"""Aggregate preserved semantic annotations and explicit evidence addenda.

Does not infer semantic labels from logs. End-state counts describe recorded
endpoints; annotators may stop after a declaration or a later local check.
"""
from pathlib import Path
import collections,copy,hashlib,json,re
B=Path(__file__).resolve().parent
PROGRESS={'local_check_passed':'局部检查通过','usable_declaration_found':'定位到候选声明或资料','implementation_advanced':'部分实现推进','substituted':'改用其他接口','no_resolution_observed':'本段未见解决'}
ADOPTION={'explicit_final_source_use':'明确源码使用','final_source_present':'相关实现或部分成果保留','replaced':'被后续成果替代','unknown':'未确认联系'}

def main():
    originals=sorted(B.glob('annotations_[ABC].json'))
    aa=sum([json.loads(p.read_text(encoding='utf-8')) for p in originals],[])
    bykey={(a['run_id'],a['sample_kind']):a for a in aa}
    changes=[]
    add=json.loads((B/'review_B_addendum.json').read_text(encoding='utf-8'))
    for c in add['checks']:
        a=bykey[c['run_id'],c['sample_kind']]
        # Add source witnesses; retain original scope and final-adoption class.
        for ev in c['final_evidence']:
            if not any((x['path'],x['line'])==(ev['path'],ev['line']) for x in a['final_evidence']):
                a['final_evidence'].append({k:ev[k] for k in ['path','line','detail_zh']})
        a['review_addendum']='review_B_addendum.json'
    for c in add['name_corrections']:
        a=bykey[c['run_id'],c['sample_kind']]
        m=re.fullmatch(r'(\w+)\[(\d+)\]\.(\w+)',c['field'])
        assert m
        target=a[m[1]][int(m[2])]
        assert target[m[3]]==c['old']
        target[m[3]]=c['replacement'];changes.append(c)
    assert len(aa)==66 and len(bykey)==66
    result={'runs':33,'annotation_records':66,'selection':'two fixed retrospective starts per run; not a census or random sample','overlapping_need_runs':sum(len({a['linked_need'] for a in aa if a['run_id']==r})==1 for r in {a['run_id'] for a in aa}),'cohorts':{},'interpretation':'Recorded progress endpoints have different stopping levels and are not comparable recovery rates. Adoption concerns the followed process, not every first-returned declaration.'}
    for k in ['first_lean_feedback','first_math_retrieval']:
        rr=[a for a in aa if a['sample_kind']==k]
        result['cohorts'][k]={'records':len(rr), **{f:dict(collections.Counter(a[f] for a in rr)) for f in ['context_kind','progress','final_adoption','confidence']}}
    rows=['# 33项运行的双起点证据表','','每个单元对应一条固定起点记录，两列可能跟踪同一需要。进展写的是标注所跟踪到的位置，不能把定位到资料理解为后来没有通过。最终采用另行核对。','','| 运行 | 首次证明/接口诊断：进展；最终联系 | 首次数学检索：进展；最终联系 |','|---|---|---|']
    order={v:i for i,v in enumerate(['l1','l2','l3','l4','l5','l6','l7','m1','m2','m3','h1'])}
    for rid in sorted({a['run_id'] for a in aa},key=lambda r:(order[r.split('-')[1]],r[-1])):
        cells=[]
        for kind in ['first_lean_feedback','first_math_retrieval']:
            a=bykey[rid,kind];cells.append(PROGRESS[a['progress']]+'；'+ADOPTION[a['final_adoption']])
        rows.append('| '+rid+' | '+' | '.join(cells)+' |')
    for name,value in [('adjudicated_annotations.json',aa),('summary.json',result),('adjudication_changes.json',changes)]:
        (B/name).write_text(json.dumps(value,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
    (B/'run_matrix.zh-CN.md').write_text('\n'.join(rows)+'\n',encoding='utf-8')
    review_files=[B/'review_A.json',B/'review_C.json',B/'review_B.zh-CN.md',B/'review_B_addendum.json']
    assert all(p.is_file() for p in review_files)
    (B/'summary_provenance.json').write_text(json.dumps({'review_scope':'44 A/C records checked by another agent; 22 B records checked by the lead investigator; all nonblind; no population accuracy estimate', 'second_agent_records':44, 'lead_investigator_records':22,'inputs':{p.name:hashlib.sha256(p.read_bytes()).hexdigest() for p in originals+review_files+[Path(__file__).resolve()]}},indent=2)+'\n',encoding='utf-8')
    print(json.dumps(result,ensure_ascii=False,indent=2))
if __name__=='__main__':main()
