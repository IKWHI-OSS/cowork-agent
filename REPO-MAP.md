# REPO-MAP — 3개 레포 라우팅 규약 (스파게티 방지 정본)

> 작성 2026-06-20. 어떤 내용이 어느 레포로 가는지의 단일 기준. 새 산출물·메모리를 만들 때 여기 규칙으로 위치를 정한다.
> 판단기준: **도구·작업방식 교훈 → cowork / 범용 인프라 → Building-Infra / 이 프로젝트 산출물·상태 → Pred-FirefromElec.**

## 0. 세 레포
| 레포 | github | 로컬(현재) | 담는 것 |
|---|---|---|---|
| **cowork-agent** | IKWHI-OSS/cowork-agent | `/Users/karla/cowork` | 에이전트 메모리·스킬만 (SOUL/LOOP/MEMORY/USER/CLAUDE, skills/, REPO-MAP) |
| **Building-Infra** | IKWHI-OSS/Building-Infra | (미클론) | 범용 인프라 오케스트레이션 코드·설계지식 (orc 엔진, build-log, SPEC) |
| **Pred-FirefromElec** | IKWHI-OSS/Pred-FirefromElec | (미클론) | 기상기후×전력설비×가연환경 화재위험도 예측 **프로젝트** 산출물 |

## 1. 파일 라우팅 (현재 로컬 → 목적지 레포)

### → cowork-agent (`/Users/karla/cowork`)
- `CLAUDE.md`, `SOUL.md`, `LOOP.md`, `memories/MEMORY.md`, `memories/USER.md`, `skills/`, `REPO-MAP.md`
- ⚠ `cowork/knowledge/`는 **여기 속하지 않음** — 아래 인프라/프로젝트로 이동 후 폴더 비우기.

### → Building-Infra (범용 인프라)
- `constgx/agents/orc/` (엔진 코드 전체)
- `constgx/agents/SPEC.md`, `COST-MODEL.md`, `RUNBOOK-real-llm.md`, `mcp_model_tool.py`, `orchestrator_slice.ipynb`, `requirements-lock.txt`, `setup_env.sh`
- `constgx/agents/docs/orchestrator-poc-build-log.md` ← **정본**(§7에 cowork MEMORY 이관분 포함)
- `constgx/agents/docs/*인프라*checkpoint*.md`
- `cowork/knowledge/multiagent-orchestrator-template.md`

### → Pred-FirefromElec (프로젝트)
- `constgx/scripts/` 전체: filekey 맵(71918/71921), label-schema, `INGEST-AGENT.md`, `aihub_ingest.sh`, `dl_to_gcs_loop.sh`, `merge_parts.sh`, `aihub-rag-sources-manifest.md`, `aihub-ingest-status.md`, RUNBOOK-download, HANDOFF-*
- `constgx/vision/`, `constgx/knowledge/`(프로젝트분)
- `cowork/knowledge/`: `*checkpoint-데이터적재*`, `aihub-71388-*`, `construction-gx-project.md`, `download-batch-plan.md`

## 2. 중복 삭제 (게이트 — 사용자/Cursor가 직접)
- `cowork/knowledge/orchestrator-poc-build-log.md` = **구버전 중복** → 삭제. 정본은 `constgx/agents/docs/`판(§5-1·§7 최신).
- Building-Infra 레포에 이미 푸시된 것 중 위 라우팅과 안 맞는 프로젝트/메모리 파일 = **선택삭제**(원격 확인 후).
- 삭제는 전부 위험 게이트(`rm`/`git rm`) — auto 금지.

## 3. cowork MEMORY 추가 정리 후보 (다음 정리 — 미실행)
아직 cowork MEMORY에 남은 **프로젝트 상태 드리프트**(이관 후보, 승인 시 이동):
- Tool Notes의 `2026-06-15 [박제] 71388 filekey 맵`, `2026-06-16 [현황] 건설GX 71388 전량 적재 완료` → Pred-FirefromElec 상태문서로.
- (유지: aihubshell 동작·샌드박스 제약·디버깅 규칙 등 **도구·작업방식 교훈**은 cowork에 남김 — 정의상 에이전트 메모리.)

## 4. git 핸드오프 (게이트 — 직접 실행)
1. 세 레포 클론(또는 기존 워킹트리 확인). cowork은 `/Users/karla/cowork`를 cowork-agent로 init/push.
2. §1 라우팅대로 파일 이동(`git mv`), §2 중복 삭제.
3. orc/ 변경은 인프라 세션 미커밋분과 충돌 가능 → **브랜치/풀 먼저**, 그 후 커밋.
4. `git push`는 게이트 — 사용자가 직접.
