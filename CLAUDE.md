# CLAUDE.md — 코워크 작업 명세 (Operating Specification)

> **이 문서의 지위:** 이 파일은 단순 안내가 아니라 이 작업 공간의 **작업 명세(spec)**다.
> 코워크가 세션마다 자동으로 읽으며, 여기 적힌 절차는 **선택이 아니라 준수 대상**이다.
> 충돌 시 우선순위: **이 CLAUDE.md > LOOP.md > SOUL.md > memories/**.
> 헤르메스(NousResearch/hermes-agent)의 폐쇄형 학습 루프를 이식한 "성장하는 에이전트"의 단일 진실 원천(single source of truth)이다.
>
> **정본 위치:** `/Users/karla/cowork` (유일한 에이전트 홈). 

---

## 0. 매 세션 시작 시 — 필수 부팅 시퀀스 (MUST)

새 작업을 시작하기 전에 **반드시 아래 파일을 순서대로 읽고** 맥락을 복원한다.
이 단계를 건너뛰면 학습 루프가 작동하지 않는다 — 가장 중요한 단계다.

1. `SOUL.md` — 나는 누구이며 어떤 원칙으로 행동하는가
2. `LOOP.md` — 루프 운영 프로토콜 (Solve→Document→Retrieve→Improve→Repeat)
3. `memories/MEMORY.md` — 지금까지 배운 교훈·패턴·도구 특성
4. `memories/USER.md` — 사용자 프로필·선호·맥락
5. `skills/` — 이번 작업과 관련된 스킬이 이미 있는지 훑어본다

읽은 뒤 **반드시** 한 줄로 보고한다: `부팅 완료: 관련 메모리 N건, 후보 스킬 M개 확인`.

## 1. 작업 중 (MUST)

- 관련 스킬이 있으면 **로드해서 그 Procedure를 그대로 따른다.** 없으면 처음부터 해결한다.
- 사용자의 수정·피드백은 그 자리에서 반영하고, **종료 시 기록할 항목으로 메모**해 둔다.
- 산출물은 정본 폴더 안의 알맞은 위치에 저장한다 (아래 4절 디렉토리 규약).

## 2. 작업 종료 시 — 자가 점검 (MUST)

작업을 마치면 `LOOP.md`의 "작업 후 자가 점검 체크리스트"를 **빠짐없이** 실행한다. 요약:

- 배운 교훈/패턴/**도구 특성** → `memories/MEMORY.md` (Lessons / Patterns / Tool Notes)
- 사용자에 대해 새로 알게 된 것 → `memories/USER.md`
- 복잡한 작업을 성공적으로 끝냈다면 → `skills/<category>/<name>/SKILL.md`로 추출 (`_templates/SKILL.md` 복사)
- 기존 스킬에서 문제가 드러났다면 → 해당 SKILL.md 패치 + Version History 갱신
- 큰 리서치 산출물 → `knowledge/`, 세션 메타 → `sessions/`, 작업 로그 → `logs/`

## 3. 원칙 (요약 — 상세는 SOUL.md)

- 메모리와 스킬은 **에이전트가 자율적으로 편집**한다. 매번 허락받지 않는다.
- 단, **파괴적 변경(삭제/덮어쓰기)** 전에는 반드시 한 번 더 확인한다.
- 같은 실수를 두 번 하지 않는 것이 이 구조의 목적이다. **기록이 곧 성장이다.**

## 4. 디렉토리 규약 (정본 구조)

```
cowork/
├── CLAUDE.md   ← 이 작업 명세 (부팅 엔트리포인트)
├── SOUL.md     ← 정체성·원칙
├── LOOP.md     ← 루프 운영 프로토콜(엔진) + 자동화
├── memories/   ← MEMORY.md(Lessons/Patterns/Tool Notes) · USER.md
├── skills/     ← _templates/ + research·writing·coding·data 카테고리
├── knowledge/  ← 리서치 산출물·참고 자료
├── sessions/   ← 세션 메타데이터
└── logs/       ← 작업 로그
```

## 5. 자동화

매주 일요일 `consolidate-memory` 스킬로 `memories/`를 자동 정리하는 예약 작업이 걸려 있다 (헤르메스의 "주기적 넛지"). 상세는 `LOOP.md` 자동화 섹션 참조.

## 6. 명세 준수 확인 (Spec Compliance)

각 세션 종료 시 스스로 묻는다: **부팅 시퀀스를 지켰는가? 자가 점검을 실행했는가?** 둘 중 하나라도 빠졌다면 그 자체를 다음 세션을 위한 교훈으로 `MEMORY.md`에 남긴다.

---
_버전: 2026-06-09 — 안내 문서에서 작업 명세로 격상. 정본을 `/Users/karla/cowork`로 단일화._
