# SKILL: detection-rehearsal (torchvision 객체탐지 파이프라인 리허설)

> 대용량 OD 데이터셋 본학습 전, 최소 슬라이스로 데이터→모델 파이프라인 무결성을 검증하는 절차.
> category: coding. 코워크 리눅스 샌드박스(CPU, 디스크·네트워크 제약) 환경 기준.

## Trigger
- 객체탐지(이미지+어노테이션) 데이터셋으로 PyTorch/torchvision 학습을 시작할 때, 전량 학습 전 "리허설"로 파이프라인을 디버깅.
- AI Hub류 라벨 JSON을 torchvision detection 포맷으로 매핑해야 할 때.

## Procedure
1. **스키마 실측 확정 먼저** (추정 금지). zip은 풀지 말고 스트리밍 inspect:
   `unzip -Z1`로 이미지/JSON 개수·1:1 대응 확인 → 샘플 200~300개 JSON을 통계로:
   지오메트리 필드(bbox? polygon? points?)·좌표계(절대/정규화)·클래스 표기·파일당 객체수 분포(0개/다수 엣지케이스)·경계초과 여부. 한 파일로 단정하지 말 것.
2. **Dataset 구현**: `__getitem__ → (image_tensor, target)`. target=`{boxes:Float[N,4] xyxy 절대픽셀, labels:Int64[N], ...}`.
   - polygon이면 `xyxy=(min xs,min ys,max xs,max ys)`, xs=poly[0::2]. 경계 클리핑 + degenerate(zero-area) 박스 필터(FasterRCNN가 거부).
   - 빈 어노테이션 → `boxes=zeros(0,4), labels=zeros(0)`로 처리하거나 스킵.
   - zip 스트리밍(`zipfile`)으로 디스크 0. 핸들은 프로세스별 lazy open(fork-safe), num_workers=0 권장.
   - 클래스 매핑 `{name:1,...}`, background=0.
3. **Stage A — DataLoader**: `collate_fn=lambda b: tuple(zip(*b))`. 배치 1개 받아 형태/타겟 dict assert.
4. **Stage B — bbox 시각화**: 박스 있는 샘플 1장에 `draw_bounding_boxes` → PNG 저장 후 **육안으로 박스가 객체에 정합하는지 확인**(좌표변환·라벨매핑·EXIF 검증).
5. **Stage C — 1 epoch 디버그**: `fasterrcnn_resnet50_fpn` 헤드 클래스수 교체, 소수 샘플 CPU. loss dict 유한·NaN 없음, `loss.backward()` 후 grad합>0, optimizer step 동작 assert.
6. 통과 기준 3종(배치 정상형태 / bbox 시각 정합 / loss 유한·역전파) 충족 → 파이프라인 검증 완료. 기록(MEMORY·스키마노트).

## Pitfalls
- **추정 스키마로 코드 작성** → 반드시 §1 실측 먼저. (AI Hub 71388은 bbox가 아니라 polygon이었음.)
- **EXIF 자동회전**: 라벨이 stored(EXIF 미적용) 좌표면 `ImageOps.exif_transpose()` 부르면 dims 회전돼 박스가 어긋남. JSON width/height가 stored JPEG 크기와 같은지 확인 후, 같으면 transpose 금지.
- **degenerate/경계초과 박스** → 클리핑+필터 안 하면 FasterRCNN가 런타임 에러.
- **코워크 샌드박스 torch 설치**: pytorch.org 인덱스·사전학습weights는 프록시 차단. 기본 PyPI + `torch==2.2.2 torchvision==0.17.2`(CPU aarch64) + `numpy<2`. 리허설은 `weights=None`. CPU 속도 위해 `min_size/max_size` 축소.
- **백그라운드 생존 가정**: 샌드박스 호출은 die-with-parent → nohup이 호출 종료 시 죽음. 한 호출 ~44초 안에 끝내거나 단계 분리(env 플래그). sleep+polling 반복은 헛돌이.

## Version History
- 2026-06-15 — v1 생성. AI Hub 71388 brailleBlock 리허설 성공 절차에서 추출.
