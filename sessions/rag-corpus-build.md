# 세션 메타 — RAG 코퍼스 구축 (Pred-FirefromElec)

> 기간: 2026-06-20~21. 프로젝트: 기상기후×전력설비×가연환경 화재위험도 예측.

## 한 일
- 71918(배터리 열폭주)·71921(산불 확산 추론)·외부 RAG 7종 GCS 적재 완료(639건 0실패).
- 3레포 분리(cowork-agent / Building-Infra / Pred-FirefromElec) + 라우팅 정본 REPO-MAP.
- RAG 임베딩 결정: 오픈(BGE-m3 1024) + ToT 구조 청킹 + IVF-PQ + 버킷보관·온디맨드(복기노트로 박제).
- RAG 파이프라인 코드: build_rag_units → measure_corpus_tokens → build_eval_set → eval_matrix → eval_recall.
- 71921 정제: 246,789 case / 643M 토큰(수치·메타 제외).

## 추출된 스킬
- skills/data/aihub-ingest, skills/data/rag-corpus-build.

## 진행 중 / 다음
- 설정 행렬 평가(청킹×인덱스 recall@k) → 청킹·PQ 확정 → 전량 색인 러너 → orc 인스턴스 장착(검색·추론).
- 진단(case/flat): R@1=0.108(긴 case 통째 임베딩은 신호 희석) → tot/win 비교 대기.

## 핵심 교훈(메모리 박제됨)
- 코워크 AI Hub 403 → 맥 실행. RAG 점유 3레버. bge-m3+MPS 세그폴트→CPU+KMP. 포트폴리오 문서는 git 미게시·로컬.
