<!--
이 파일은 프로젝트가 소유한다. 하네스 갱신이 덮지 않는다.
**값을 적지 않는다.** 항목명과 취득 경로만 적는다 — 시크릿은 리포에 남기지 않는다.
-->

### 필요한 도구

| 도구 | 용도 | 확인 |
|---|---|---|
| JDK 21 | 빌드·실행. `script/verify-project.sh` 가 `/usr/libexec/java_home -v 21` 로 찾는다 | `java -version` |
| Maven Wrapper | 빌드. 리포에 포함돼 별도 설치가 필요 없다 | `./mvnw -v` |
| `git` | 훅 활성화는 클론마다 1회 — `git config core.hooksPath script/githooks` | `git --version` |
| `gh` | 이슈·리뷰 요청 조회와 생성 | `gh auth status` |
| `harness` | 생성 파일 관리 | `harness version` |
| `codex` | 리뷰 러너. `script/review-mr.sh` 가 부른다 | `codex login status` |
| `adr` (adr-tools) | 결정 기록 생성 | `adr help` |

### 환경 변수

| 이름 | 용도 | 어디서 얻나 |
|---|---|---|
| `HARNESS_USAGE_LOG` | 하네스 사용 기록 경로. **설정하지 않아도 된다** | 직접 정한다. 비우면 `$HOME/.harness/silent-room/usage.log` |

**서비스 자체가 요구하는 환경 변수는 없다.** 시크릿도 없다.

### 외부 시스템

없음. 외부 API·데이터베이스·메시지 브로커에 붙지 않는다.

`gh` 와 `codex` 는 각각 GitHub 과 OpenAI 에 붙지만 **서비스가 아니라 하네스가 쓰는 것**이고,
인증은 각 CLI 가 자기 방식으로 갖는다 — 이 리포에 자격증명을 두지 않는다.
