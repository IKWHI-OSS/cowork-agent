# SKILL: aihub-ingest — AI Hub 데이터셋 GCS 적재

## Trigger
AI Hub(dataSetSn) 데이터셋을 GCS 버킷에 무결성 보장하며 적재할 때. "AI Hub 적재", "버킷에 올려", filekey 다운로드 등.

## Procedure
1. **filekey 맵 실측(1회)**: `aihubshell -mode l -datasetkey <SN>`을 **사용자 맥(한국 IP)**에서 실행 → 파일트리·filekey·크기를 맵 문서에 박제. 이후 `-mode l` 재조회 금지(비용).
2. **preflight(1회)**: API키·버킷 존재(`gsutil ls -b || mb -l asia-northeast3`)·디스크(≥최대FK×2)·패치본 aihubshell 확인.
3. **적재 루프 (filekey 1개 = 1 트랜잭션)**: DONE이면 skip →
   `download → unzip -t(무결성) → gsutil 업로드 → 로컬==GCS 크기 1:1 → OK면 로컬 삭제 → DONE/FAILED 기록`.
4. **자기검증**: 단계 실패 = DIAGNOSIS 표로 (재시도?·보정) 매핑. 미진단 에러는 재시도 말고 FAILED+halt. 연속 K회 실패 → 전체 halt(HITL).
5. 상태=`ingest_state.tsv`(filekey<TAB>STATUS, 멱등). 로그=`ingest_YYYYmmdd.jsonl`(감사).

## Pitfalls
- **코워크 샌드박스는 `api.aihub.or.kr` 프록시 403 차단** → 다운로드·`-mode l`은 사용자 맥에서만.
- **성공 판정 = 0바이트 아닌 zip 존재**(로그 텍스트 스크래핑 금지; curl 진행률의 "502" 등 오매칭 주의).
- macOS bash 3.2 `printf %q`가 한글 prefix를 8진수 이스케이프 → merge 0바이트 버그. **패치본 aihubshell** 사용(`ls prefix.part* | sort -n | cat` 방식), 재설치 시 패치 소실.
- `rm -rf 237*` 류는 직전본 삭제 → **다음 filekey 전 업로드 필수**. 삭제는 size-match 통과 후에만(dl_to_gcs_loop.sh 내장 게이트).
- 소요시간은 용량 아닌 **건수×건당 오버헤드** 지배(throttle 3~7배 변동). 일정은 filekey 건수 기준.

## Version History
- v1 — 71388(414GB)·71918·71921 적재로 검증(639건 무사고). 러너: constgx/scripts/{aihub_ingest.sh, dl_to_gcs_loop.sh, merge_parts.sh}, 정책: INGEST-AGENT.md.
