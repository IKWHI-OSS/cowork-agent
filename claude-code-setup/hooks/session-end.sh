#!/usr/bin/env bash
# Claude Code SessionEnd 훅 — 정리·로깅용(에이전트 컨텍스트 주입 불가). 발화 검증용 로그.
mkdir -p "$HOME/.claude/logs"
echo "[hook] SessionEnd fired: $(date)" >> "$HOME/.claude/logs/hooks.log"
cat <<'EOF'
[세션 종료 체크리스트 — LOOP §2, 빠짐없이 실행]
1) 교훈/패턴/도구특성 → MEMORY.md (승인제: 후보 나열·설명, 승인분만 유지)
2) 실수→해결 → MEMORY 또는 스킬 Pitfalls
3) 사용자 새 정보 → USER.md
4) 재사용 절차 완성 → skills/<category>/ 추출
5) 세션 메타 → sessions/  · 큰 산출물 → knowledge/
6) 새 파일 → 해당 폴더 INFO.md 갱신
7) git 변경 → 세션말 일괄 push 준비(위험만 게이트)
※ 메모리만 갱신하고 끝내지 말 것 — skills/sessions 추출까지.
EOF
