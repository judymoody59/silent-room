<!--
이 파일은 프로젝트가 소유한다. 하네스 갱신이 덮지 않는다.
**실재하는 명령만 적는다.** 없는 명령을 적으면 에이전트가 그것을 실행하려다 멈춘다.
여기 적은 lint·test 명령은 `script/verify-project.sh` 에도 들어가야 검증 루프가 돈다.
-->

| 작업 | 명령 |
|---|---|
| 빌드 | `./mvnw -q -DskipTests package` |
| 테스트 전체 | `./mvnw test` |
| 단일 테스트 | `./mvnw -Dtest=<클래스명> test` |
| 포맷 검사 / 자동 수정 | `./mvnw spotless:check` / `./mvnw spotless:apply` |
| 검증 일괄 | `script/run-lint-test.sh` |

`script/verify-project.sh` 가 JDK 21 을 직접 잡는다. 셸의 `JAVA_HOME` 이 다른 버전을
가리켜도 검증은 `stack.md` 가 정한 런타임으로 돈다.
