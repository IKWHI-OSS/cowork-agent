# LOOP.md — 학습 루프 운영 프로토콜

> `Solve → Document → Retrieve → Improve → Repeat` 루프의 구체적인 운영 방법.
> 스킬 생성 기준, 메모리 업데이트 빈도, 매 작업 후 자가 점검 체크리스트를 정의한다.
> 이 파일이 학습 루프의 "엔진"이다 — 앱이 자주 누락하는 부분이니 충실히 유지한다.

## How It Works — 5단계 (영상 기준)

1. **세션 시작** — `SOUL.md`, `memories/MEMORY.md`, `memories/USER.md`를 읽고 부팅한다.
2. **작업 수행** — 관련 스킬이 있으면 로드하고, 없으면 처음부터 해결한다.
3. **기록** — 배운 것을 `MEMORY.md`에, 사용자 정보를 `USER.md`에 기록한다.
4. **스킬 추출** — 복잡한 작업이 성공하면 `skills/`에 스킬로 저장한다.
5. **개선** — 기존 스킬에 문제가 있으면 패치하고 버전을 올린다.

## 스킬 생성 기준 (언제 스킬로 추출하는가)

다음 중 하나라도 해당하면 스킬로 추출한다:

- 3단계 이상의 절차가 필요한 작업을 **성공적으로** 끝냈을 때
- 같은 유형의 요청이 **두 번째** 들어왔을 때 (반복 신호)
- 사용자가 "이거 다음에도 이렇게 해줘"라고 명시했을 때
- 시행착오 끝에 **재현 가능한 해결 경로**를 찾았을 때

추출하지 않는 경우: 한 줄짜리 단순 작업, 일회성·맥락 의존적이라 재사용 불가한 작업.

## 메모리 업데이트 빈도

- `MEMORY.md` — **매 작업 종료 시** 점검. 새 교훈/패턴/도구 특성이 있으면 추가.
- `USER.md` — 사용자에 대해 **새로 알게 된 사실이 생길 때마다** 즉시 추가.
- 둘 다 append 우선. 기존 항목 수정은 가능하되, 통째 삭제는 사용자 확인 후.

## 작업 후 자가 점검 체크리스트 (매 작업 종료 시 실행)

```
[ ] 이번에 배운 교훈/패턴이 있는가?      → MEMORY.md에 추가
[ ] 실수→해결 경로가 있었는가?           → MEMORY.md 또는 스킬 Pitfalls에 기록
[ ] 사용자에 대해 새로 알게 된 게 있는가? → USER.md에 추가
[ ] 재사용 가능한 절차를 완성했는가?      → skills/에 스킬 추출 (생성 기준 참조)
[ ] 사용한 기존 스킬에 결함이 있었는가?   → 해당 SKILL.md 패치 + Version History 갱신
[ ] 큰 산출물/세션메타/로그가 있는가?     → knowledge/ , sessions/ , logs/에 저장
```

## 스킬 추출 절차

1. `skills/_templates/SKILL.md`를 복사한다.
2. `skills/<category>/<skill-name>/SKILL.md`에 배치한다. (category: research / writing / coding / data)
3. `Trigger`, `Procedure`, `Pitfalls`, `Version History`를 채운다.
4. 이후 사용하며 결함이 보이면 패치하고 Version History에 한 줄 남긴다.

## 자동화 — 주기적 메모리 정리 (Periodic Nudge)

헤르메스의 "주기적 메모리 넛지" 원칙에 따라, **매주 일요일 메모리 자동 정리(consolidate)** 예약 작업이 걸려 있다.
- 대상: `memories/MEMORY.md`(Lessons / Patterns / Tool Notes), `memories/USER.md`
- 동작: `consolidate-memory` 스킬로 중복 병합, 낡은 항목 정리, 상대 시점 → 절대 날짜 변환, 인덱스 정돈
- 목적: append 위주로 쌓인 메모리가 비대해지거나 낡지 않게 유지 (루프가 스스로를 청소)
- 관리: 코워크 사이드바의 "Scheduled" 섹션에서 일시정지/수정 가능.

> 이 자동화는 루프의 5단계(Solve→Document→Retrieve→Improve→Repeat)를 장기적으로 건강하게 유지하는 안전장치다.
