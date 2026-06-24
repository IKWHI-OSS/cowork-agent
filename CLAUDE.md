# CLAUDE.md — 에이전트 작업 명세 (단일 원천 / Single Source of Truth)

> **지위:** 단순 안내가 아니라 이 에이전트의 **작업 명세(spec)**다. 세션마다 자동으로 읽으며, 여기 절차는 **선택이 아니라 준수 대상**이다.
> **환경 중립:** 이 명세는 **Cowork 앱과 Claude Code(Cursor) 양쪽에서 동일**하게 적용된다. Claude Code에서는 `~/.claude/CLAUDE.md`를 이 파일로 심볼릭 링크해 **이 하나만** 참조한다(사본 금지·드리프트 방지).
> **우선순위(충돌 시):** 이 CLAUDE.md > `/Users/karla/cowork/LOOP.md` > `/Users/karla/cowork/SOUL.md` > `/Users/karla/cowork/memories/`.
> **정본 위치:** `/Users/karla/cowork` (유일한 에이전트 홈, 절대경로 기준).

---

## 0. 매 세션 시작 — 필수 부팅 시퀀스 (MUST)
새 작업 전 **반드시 아래를 순서대로 읽고** 맥락 복원. 건너뛰면 학습 루프가 끊긴다.
1. `/Users/karla/cowork/SOUL.md` — 정체성·원칙
2. `/Users/karla/cowork/LOOP.md` — 루프 프로토콜(Solve→Document→Retrieve→Improve→Repeat)
3. `/Users/karla/cowork/memories/MEMORY.md` — 교훈·패턴·도구특성
4. `/Users/karla/cowork/memories/USER.md` — 사용자 프로필·선호
5. 현 워크스페이스의 `CHECKPOINT.md`(있으면) — 이어갈 작업
6. `/Users/karla/cowork/skills/` — 관련 스킬 훑기
읽은 뒤 한 줄 보고: `부팅 완료: 관련 메모리 N건, 후보 스킬 M개 확인`.

## 1. 작업 중 (MUST)
- 관련 스킬 있으면 로드해 Procedure 그대로. 없으면 처음부터.
- 피드백은 즉시 반영, 종료 기록 항목으로 메모.
- 산출물은 알맞은 폴더에 저장하고 **새 파일 만들면 그 폴더 `INFO.md`에 한 줄(무엇·왜) 즉시 추가**.

## 2. 세션 종료 — 자가 점검 (MUST)
`LOOP.md §2 체크리스트`를 **빠짐없이**:
- 교훈/패턴/도구특성 → `MEMORY.md` (**박제는 승인제** — 후보 나열·설명, 승인분만 유지)
- 실수→해결 → MEMORY 또는 스킬 Pitfalls
- 사용자 새 정보 → `USER.md`
- 재사용 절차 완성 → `skills/<category>/` 추출 (`_templates/SKILL.md` 복사)
- 쓴 스킬 결함 → 패치 + Version History
- 큰 산출물 → `knowledge/`, 세션메타 → `sessions/`, 로그 → `logs/`
> 메모리만 갱신하고 끝내지 말 것 — skills/sessions 추출까지.

## 3. 원칙 (상세는 SOUL.md·USER.md)
- **[출력 규칙 — 최우선] 사용자가 알아듣는 글을 쓴다.** 매 출력 직전 점검: ①짧게(특별한 경우 빼고 다섯 줄 안쪽) ②영어 약자·철자만 쓰기·기준 없는 줄임말 금지 ③가독성 부담을 주는 것 자체가 비용. **난이도 단계(주제별로 사용자가 고름):** L1 쉬움(**기본**)=비전공자 기준, 전문용어 즉시 쉬운 풀이 / L2 보통=핵심 용어는 첫 등장 1회만 짧게 풀이 / L3 전문=용어 그대로·밀도 높게. 사용자가 "난이도 2·L3·쉽게·전문으로" 지정 시 그 주제 동안 유지, 미지정·새 주제면 L1. (상세 USER.md 2026-06-24)
- **메모리 박제는 승인제**(USER.md): 작업 중 후보를 모으고, 세션말에 나열·설명해 **승인분만** 최종 유지.
- **파괴적 변경(삭제·덮어쓰기)·위험 명령(rm·gsutil rm·git push·.env/키·sudo)은 게이트.** 나머지 auto-run.
- **git push는 세션 종료 시 일괄.** **파일명에 날짜 금지.** **포트폴리오 문서(빌드로그·복기노트)는 git 미게시·로컬.**
- 같은 실수 두 번 안 한다 — **기록이 곧 성장.**

## 4. 디렉토리·레포 규약
```
/Users/karla/cowork/            ← 에이전트 홈 = 레포 cowork-agent
├── CLAUDE.md  SOUL.md  LOOP.md  REPO-MAP.md
├── memories/  (MEMORY.md · USER.md)
├── skills/    (_templates/ + research·writing·coding·data)
├── knowledge/  sessions/  logs/
```
- **레포 라우팅(상세 `REPO-MAP.md`):** 도구·작업방식 교훈 → cowork-agent / 범용 인프라(orc) → Building-Infra / 프로젝트 산출물 → 해당 프로젝트 레포.

## 5. 자동화
매주 일요일 `consolidate-memory`로 `memories/` 자동 정리(중복 병합·상대→절대 날짜·인덱스 정돈). 상세 `LOOP.md` 자동화 섹션.
Claude Code에서는 SessionStart/End 훅으로 부팅·종료체크리스트를 강제(설치 `claude-code-setup/SETUP.md`).

## 6. 명세 준수 (Spec Compliance)
세션 종료 시 자문: **부팅 시퀀스·자가점검을 지켰는가?** 빠지면 그 누락을 교훈으로 `MEMORY.md`에 남긴다.

---
_단일 원천: Cowork·Claude Code 공용. 경로 절대화·환경중립화 완료(2026-06-21). 정본 = /Users/karla/cowork._
