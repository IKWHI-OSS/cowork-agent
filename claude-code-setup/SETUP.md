# Claude Code 부팅·세션훅 설치

> 목적: cowork 학습 루프를 Cursor의 Claude Code에서 **강제**(문서=요청, 훅=보장).
> ⚠ Claude Code 훅 `settings.json` 스키마는 버전에 따라 바뀝니다 — 아래 형식은 템플릿이니
> 적용 전 `code.claude.com/docs/en/hooks`(또는 `/hooks` 도움말)로 현재 스키마 1회 확인할 것.

## 1. 부팅 명세 = 단일 원천에 심볼릭 링크 (사본 금지)
정본은 `/Users/karla/cowork/CLAUDE.md` **하나**다. Claude Code 전역 진입점을 거기로 링크:
```bash
mkdir -p ~/.claude
ln -sf /Users/karla/cowork/CLAUDE.md ~/.claude/CLAUDE.md
ls -l ~/.claude/CLAUDE.md     # → /Users/karla/cowork/CLAUDE.md 화살표 확인
```
→ Claude Code가 부팅 시 이 링크(=cowork 정본)를 읽는다. 사본 0, 드리프트 불가.
(이 폴더의 옛 `claude-code-setup/CLAUDE.md`는 staging이라 **삭제**. 링크가 대체함.)

## 2. 세션 훅 (강제력)
훅 스크립트 2개 + `~/.claude/settings.json` 등록.

`~/.claude/hooks/session-start.sh`:
```bash
#!/usr/bin/env bash
echo "부팅: /Users/karla/cowork/{SOUL,LOOP,memories/MEMORY,memories/USER}.md 를 읽고,"
echo "현 워크스페이스에 CHECKPOINT.md 가 있으면 그것부터 읽어 이어가라. 부팅 보고 한 줄 출력."
[ -f "./CHECKPOINT.md" ] && { echo "=== CHECKPOINT ==="; sed -n '1,40p' ./CHECKPOINT.md; }
```

`~/.claude/hooks/session-end.sh`:
```bash
#!/usr/bin/env bash
echo "세션 종료 체크리스트(LOOP §2): "
echo "1) 교훈/패턴/도구특성→MEMORY(승인제 후보 나열) 2) 사용자정보→USER"
echo "3) 재사용절차→skills/ 추출 4) 세션메타→sessions/ 5) 새파일→INFO.md 갱신"
echo "6) git 변경은 일괄 push 준비(위험만 게이트). 메모리만 갱신하고 끝내지 말 것."
```
```bash
chmod +x ~/.claude/hooks/session-start.sh ~/.claude/hooks/session-end.sh
```

`~/.claude/settings.json`(템플릿 — 스키마 확인 후 병합):
```json
{
  "hooks": {
    "SessionStart": [
      { "hooks": [ { "type": "command", "command": "~/.claude/hooks/session-start.sh" } ] }
    ],
    "SessionEnd": [
      { "hooks": [ { "type": "command", "command": "~/.claude/hooks/session-end.sh" } ] }
    ]
  }
}
```

## 3. 한계 (정직히)
- 훅은 **결정적 셸 출력**만 강제 주입한다. "무엇을 스킬로 추출/승인제 박제" 같은 **판단**은 여전히 CLAUDE.md 지시를 에이전트가 따라야 함(완전 자동 아님).
- Claude Code 자체 auto-memory와 섞이지 않게, 위 CLAUDE.md가 정본임을 명시.
- 세션 연속성 = 채팅 세션이 아니라 **파일**(MEMORY/USER/CHECKPOINT). `/clear` 후에도 CHECKPOINT가 잇는다.
