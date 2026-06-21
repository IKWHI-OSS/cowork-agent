# Cowork Agent — Hermes-Inspired Growing Agent

> Solve → Document → Retrieve → Improve → Repeat

이 폴더는 [NousResearch/hermes-agent](https://github.com/NousResearch/hermes-agent)의
폐쇄형 학습 루프(Closed Learning Loop) 원칙을 코워크 환경에 적용한
**에이전트 홈 디렉토리**다. 쓸수록 메모리와 스킬이 쌓여 점점 더 맞춤형이 된다.

## Structure

```
cowork/
├── CLAUDE.md        ← 코워크가 매 세션 읽는 지침(부팅 엔트리포인트)
├── SOUL.md          ← 에이전트 아이덴티티 & 원칙
├── LOOP.md          ← 학습 루프 운영 프로토콜
├── README.md        ← 이 파일
│
├── memories/
│   ├── MEMORY.md    ← 교훈, 도구 특성, 패턴 (에이전트 자율 편집)
│   └── USER.md      ← 사용자 프로필 (에이전트 자율 편집)
│
├── skills/
│   ├── _templates/
│   │   └── SKILL.md ← 새 스킬 생성 시 복사하는 템플릿
│   ├── research/    → web-deep-dive/ , competitor-analysis/
│   ├── writing/     → sns-post/ , blog-draft/
│   ├── coding/      → debug-loop/ , refactor/
│   └── data/        → csv-cleanup/ , chart-gen/
│
├── knowledge/       ← 리서치 결과, 참고 자료 저장소
├── sessions/        ← 세션 메타데이터
└── logs/            ← 작업 로그
```

## How It Works

1. **세션 시작** — 에이전트가 SOUL.md, MEMORY.md, USER.md를 읽고 부팅한다
2. **작업 수행** — 관련 스킬이 있으면 로드하고, 없으면 처음부터 해결한다
3. **기록** — 배운 것을 MEMORY.md에, 사용자 정보를 USER.md에 기록한다
4. **스킬 추출** — 복잡한 작업이 성공하면 스킬로 저장한다
5. **개선** — 기존 스킬에 문제가 있으면 패치하고 버전을 올린다

## Adding a New Skill

1. `skills/_templates/SKILL.md`를 복사한다
2. `skills/<category>/<skill-name>/SKILL.md`에 배치한다
3. 작성하며 `Pitfalls`와 `Version History`를 업데이트한다

## Sources

- NousResearch/hermes-agent GitHub
- Hermes Agent Architecture / Skills System
