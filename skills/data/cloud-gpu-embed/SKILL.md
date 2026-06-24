# SKILL: cloud-gpu-embed — 자가종료 클라우드 GPU로 배치 임베딩/계산 (발열·비용 회피)

## Trigger
맥에서 무거운 GPU 계산(대량 임베딩·배치 추론)을 돌려야 하는데 발열·시간이 부담일 때. "클라우드 GPU", "L4로 임베딩", "VM 빌려 돌리기". 한 번 돌리고 끝나는 일회성 배치.

## Procedure
1. **러너·입력을 버킷에 올린다**: 실행 스크립트 + 입력 데이터를 GCS 한 폴더(gcs-in)에.
2. **VM 켜기 (검증된 레시피)**: `g2-standard-8` + `--accelerator=type=nvidia-l4,count=1` / 이미지 `--image-family=pytorch-2-9-cu129-ubuntu-2204-nvidia-580 --image-project=deeplearning-platform-release` / `--maintenance-policy=TERMINATE --scopes=cloud-platform`. **과금 상한 내장**: `--max-run-duration=<초> --instance-termination-action=DELETE`(백스톱). 작업값은 `--metadata`(gcs-in/gcs-out/run-cmd)로 주입, startup은 범용 자가종료 스크립트(vm_embed_startup.sh).
3. **자리 없으면 여러 zone 자동 순회**: L4는 STOCKOUT(ZONE_RESOURCE_POOL_EXHAUSTED) 잦음 → 후보 zone을 **배열로** 돌며 create 성공 시 break. create 실패는 무과금. ⚠ zsh는 unquoted `$VAR` 공백분할 안 함 → `ZONES=(a b c); for Z in "${ZONES[@]}"`.
4. **작게 먼저(스모크) → 예상시간 확인 → 전체**: `--limit`로 일부만 1회 돌려 run.log에서 실속도 측정 → 전체 ETA 계산 → 상한 안이면 사용자 승인 후 전체 1회. (비용 게이트.)
5. **완료는 산출물로 판정**: run.log 도착·버킷 객체·크기로 확인(로그 문구 아님). 성공 시 VM 자가삭제.
6. **과금 0 복귀 확인 (필수)**: `gcloud compute instances list`(0) + `disks list`(0) + `addresses list`(0). 남는 건 스토리지뿐.

## Pitfalls
- **startup 스크립트 필수 수정 4건(없으면 즉시 실패)**: ①torch 든 python 자동탐색 → `/usr/local/bin/python` 심볼릭(이미지에 `python`·conda 경로 없음) ②메타데이터는 `curl -f`(없는 키는 404 HTML 반환) ③`torchaudio torchvision` 제거(ABI 불일치로 sentence-transformers import 세그폴트) ④실패 시 self-delete 금지(보존·SSH 디버그; max-run-duration이 백스톱).
- **스모크 생략 금지**: 전체부터 돌리면 속도·품질 문제를 비싸게 발견. 항상 일부 먼저.
- **VM 끄는 신호를 로그로 믿지 말 것**: `instances list`로 0 확인해야 진짜 과금 종료. 디스크·예약 IP도 같이 확인(숨은 과금원).
- **일회성 실과금 = 사람 게이트(자동 루프 금지)**: 재시도로 배우는 것 없고 돈만 태움. 인프라가 정의하되 앞에 HITL 승인 + 비용가드.

## Version History
- 2026-06-24 — v1: Pred-FirefromElec RAG 임베딩으로 검증(24만 케이스 flat 색인 6분·~$0.3, 부팅실패 0). 코드: Pred-FirefromElec/scripts/{vm_embed_startup.sh(수정4건 반영), build_rag_index.py}. RAG 맥락은 [rag-corpus-build].
