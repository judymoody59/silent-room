<!--
이 파일은 프로젝트가 소유한다. 하네스 갱신이 덮지 않는다.
**버전을 여기 복제하지 않는다.** 의존성 매니페스트를 가리킨다 — 복제하면 반드시 낡는다.
매니페스트만 봐서는 알 수 없는 대조 결과(예: 설계상 예정이나 아직 미도입인 것)만 여기 남긴다.
-->

Java · Spring Boot · Maven Wrapper(`./mvnw`). base package `com.judymoody59.silentroom`.
포맷터는 Spotless(google-java-format).

**정확한 버전과 의존성 목록은 `pom.xml` 이 정본이다.**

### 아직 도입하지 않은 것

영속 저장소, Redis, Testcontainers, Actuator 가 없다.
**방 상태는 인스턴스 로컬 메모리에만 있다** — 매니페스트만 봐서는 이것이 설계인지
누락인지 알 수 없으므로 여기 적는다. 인스턴스 간 공유가 필요해지면 결정 기록 대상이다.
