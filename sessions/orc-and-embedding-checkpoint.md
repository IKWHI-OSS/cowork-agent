# 세션 체크포인트 — orc 인프라 + 화재예측 임베딩 (통합 인덱스)

> 2026-06-22~23 세션. 스레드 3개(임베딩·레포정리·인프라설계)를 한눈에 + 실행 대기 목록.
> 각 스레드 상세 재개점은 per-레포 체크포인트로 포인터. 이 문서 = '전부 한눈에' 인덱스.

## 세션 개요 (스레드 3)
1. **임베딩(Pred-FirefromElec):** tot 청킹 확정, BGE-m3 전량 임베딩을 클라우드 L4로. 현재 정지·인덱스0 → fp16+batch1024로 재개 대기.
2. **레포 정리:** `constgx→Building-Infra` 개명 잔재로 프로젝트가 인프라 폴더에 섞임 → Pred-FirefromElec로 정리, Building-Infra=`agents/`(인프라)만 남김.
3. **인프라 설계(Building-Infra/orc):** orc를 'LLM 서비스 PoC 빠른 구현·검증' 작업틀로 평가. 갭2(프로젝트지식 누적·체커독립) 식별. 메모리 가치기준=우선과제 확정, 체커=보류.

## 핵심 결정·정정
- **자동화 vs 게이트:** 싼 학습루프(평가·검색·추론)=인프라 자동화 / 비싼 일회성(GPU임베딩·유료API)=HITL+cost_notice 게이트. (cowork MEMORY 박제됨)
- **orc 분류:** 단일 클로즈드 루프(역할분담) + 런내 자기교정. 플릿/트리 아님(확장 여지).
- **레포 경계:** cowork(에이전트 작업기억)는 orc의 프로젝트지식 저장소 아님 → orc 자체 영속 Store 필요.
- **메모리 적재기준:** 승인제 불가(자동화 위반) → 비용기반 자동 가치점수.
- **USER:** PM 포지셔닝 제거.

## 저장 내역 (이 세션 산출·변경)
### Pred-FirefromElec (프로젝트)
- `scripts/build_rag_index.py` — 전량 색인 러너(스트리밍 2-pass, tot, IVF-PQ, fp16 적용)
- `scripts/vm_embed_startup.sh` — 범용 자가종료 GPU startup(수정4건)
- `scripts/eval_matrix.py` — `--device`/`--faiss-threads` 추가
- `scripts/INFO.md`·`scripts/eval_matrix_e5_fixed.log`(유효 재측정)·`knowledge/rag-검색품질-오픈임베딩-결정-복기노트.md`
- `CHECKPOINT.md` — ★최우선 'GPU 임베딩 재개' 섹션(검증된 VM 레시피·수정4건·fp16·재개절차·run-cmd)
### Building-Infra (인프라)
- `agents/docs/checkpoint-orc-memory-value.md` — 메모리 가치기준 + 구현·검증계획(V1~V6)
- `agents/INFO.md` — docs 줄 갱신
- (삭제) 루트 `scripts/`·`knowledge/`·`CHECKPOINT.md`·`progress.log`·`result.txt` = 프로젝트 잔재
### cowork (에이전트)
- `memories/MEMORY.md` — 인프라 자동화vs게이트 패턴 박제
- `memories/USER.md` — PM 포지셔닝 제거
- `sessions/orc-and-embedding-checkpoint.md` — 이 문서
### 클라우드
- 버킷 `gs://constgx_electrofire/rag_build/`(rag_units.jsonl·build_rag_index.py)·`/rag_index/run.log`
- VM 전부 삭제 → **컴퓨팅 과금 0** (GCS ~$0.4/월만)

## 실행 대기 목록 (우선순위)
1. **[승인 대기] orc 메모리 가치기준 구현·검증** — 4단계 + V1~V6 오프라인(무과금). 상세=`Building-Infra/agents/docs/checkpoint-orc-memory-value.md`. (= '빠른 구현·검증' 실측 슬라이스)
2. **[승인 대기] 임베딩 재개** — 러너 재업로드→스모크(`--limit 10000`,~$0.3)→ETA 판정→전량 1회. 상세=`Pred-FirefromElec/CHECKPOINT.md` ★섹션.
3. **[보류] orc 체커 독립(점 b)** — 과한 검증폭→무한반려 위험. 우선과제 후 재개.
4. **[후속] 임베딩 완료 후:** RETRIEVE 인스턴스(가)·EMBED 게이트 TaskSpec(나)·로드맵(다) = 인덱스 있어야 실검증.
5. **[미결] USER.md '서비스기획/PM'(취업타깃 분류 줄)** 제거 여부 — 사용자 결정.

## 박제 후보 (승인 대기, 세션 교훈)
- GPU VM 자가종료 레시피 4수정(python탐색→symlink·메타 `curl -f`·torchaudio/torchvision 제거·실패시 보존) — 재발방지 가치 큼.
- bge-m3+MPS 세그폴트 재확인(기존 MEMORY 줄47 정확) + **faiss 멀티스레드 macOS 세그폴트(신규)** — darwin은 1스레드.
- BGE-m3 L4 fp32·batch256=474건/s→20h(저활용) → fp16+큰배치 필요.
