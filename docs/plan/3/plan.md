# #3 방 입장과 재실 표시 — 분해 개요

명세: `docs/spec/3-room-entry-and-presence.md`.
관련 결정: `docs/adr/0001-close-occupant-labels-to-a-server-issued-animal-name-set.md`,
`docs/adr/0002-rooms-are-created-on-first-connection-and-destroyed-on-last-departure.md`.

## 분해

| task | 태그 | 요약 | 선행 |
|---|---|---|---|
| T1 | feat | `domain` 에 `Room`·`Occupant`·`Presence` 와 동물 이름 열거형·배정 규칙 | — |
| T2 | feat | `application` 에 입장·퇴장 유스케이스와 발행 포트 인터페이스 | T1 |
| T3 | feat | `adapter.in.ws` 에 WebSocket 어댑터와 발행 어댑터, 조립 | T2 |
| T4 | chore | `application → adapter` 역방향 import 금지 검사 추가 | T3 |
| T5 | feat | WebSocket 연결·구독·브로드캐스트 통합 테스트 | T3 |

`.ai/project/architecture.md` 의 계층 의존 방향(`domain` ← `application` ← `adapter`)을 따른다.
아래 계층부터 올린다 — 위 계층의 테스트가 아래 계층 계약을 그대로 쓸 수 있게 된다.

## 브랜치·MR·커밋

- 브랜치 하나: `feat/3-room-entry-presence` (요구사항 이슈 #3 이 단위)
- MR 하나 (`develop` 대상). task 마다 MR 을 쪼개지 않는다
- 커밋 하나가 task 하나. 커밋 제목 형식은 `.ai/AI_AGENT.md` 6-1 을 따른다 — 태그와 task 이슈
  번호를 제목에, `relates to #3` 을 본문 마지막 줄에 둔다
- 선행 이슈가 먼저 머지되지는 않는다 — 이 이슈는 브랜치·MR 이 하나이므로 rebase 재정렬 대상이
  아니다. 다른 요구사항 이슈의 머지로 `develop` 이 움직였을 때만 rebase 한다

## 전 task 공통

- `.ai/project/testing.md` 를 따른다. `domain` 과 `application` 은 스프링 컨텍스트 없이 단위,
  WebSocket 통합은 `@SpringBootTest` + 임의 포트
- `Thread.sleep` 을 쓰지 않는다. 비동기 대기는 `CountDownLatch` 에 타임아웃
- `domain` 은 `java.*` 외의 import 를 넣지 않는다 (`script/verify-project.sh` 가 검사)
- `application` 은 포트 인터페이스만 선언하고 `adapter` 를 참조하지 않는다. T4 가 이 규칙에
  기계 검사를 붙인다
- 관찰 가능한 값은 명세가 정한 두 종류뿐이다 — 재실 명단, 입장/퇴장 이벤트. 새 필드를 더하지
  않는다 (본문·타임스탬프·연결 메타 등)
- 커밋 하나로 끝나지 않는 크기가 나오면 그 task 를 두 개로 다시 쪼갠다

## 이 이슈에서 정하지 않는 값

명세와 결정 기록이 이번 범위를 확정한 뒤 남은 항목만 적는다. 해당 task 에서 다시 판단하지 않는다.

- **동물 이름 열거형의 구체 값과 개수** — 열거형에 값을 두는 것 자체는 이 이슈의 결정이지만,
  어느 이름을 몇 개 담을지는 `Capacity` 를 다루는 후속 이슈에서 함께 정한다. T1 은 규칙을
  검증할 최소 개수만 담고, 값 목록은 그 이슈에서 확장한다
- **`Capacity`** — 이 이슈에서는 상한을 두지 않는다. `Capacity` 개념을 도메인에 넣지 않는다
- **방 이름이 모두 소진되었을 때의 입장 거절 정책** — 이름 소진이 곧 상한이므로 위 후속 이슈와
  같이 다룬다. 이 이슈에서는 명세의 시나리오(S1~S4) 범위만 다룬다
- **`roomId` 형식 제약** — 이 이슈에서 검증 규칙을 두지 않는다. 클라이언트가 준 값을 그대로 방
  키로 쓴다
- **재접속 시 이전 이름 유지** — 이 이슈에서 다루지 않는다. 매 연결이 새 배정을 받는다
