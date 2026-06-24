#!/usr/bin/env bash
# Claude Code SessionStart 훅 — stdout이 세션 컨텍스트로 주입됨(부팅 강제). 발화 검증용 로그.
mkdir -p "$HOME/.claude/logs"
echo "[hook] SessionStart fired: $(date)" >> "$HOME/.claude/logs/hooks.log"
cat <<'EOF'
[부팅] 아래를 순서대로 읽어 맥락 복원 후 한 줄 보고("부팅 완료: 메모리 N건, 후보 스킬 M개"):
1. /Users/karla/cowork/SOUL.md
2. /Users/karla/cowork/LOOP.md
3. /Users/karla/cowork/memories/MEMORY.md
4. /Users/karla/cowork/memories/USER.md
5. (현 워크스페이스) ./CHECKPOINT.md  ← 있으면 이걸로 이어간다
규칙: 메모리 박제=승인제 / 위험명령만 게이트 / git push=세션말 일괄 / 새 파일=폴더 INFO.md 갱신 / 파일명 날짜금지 / 포트폴리오 문서=git 미게시·로컬.
EOF
if [ -f ./CHECKPOINT.md ]; then
  echo "=== CHECKPOINT.md (앞부분) ==="
  sed -n '1,30p' ./CHECKPOINT.md
fi
