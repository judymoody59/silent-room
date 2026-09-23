#!/usr/bin/env bash
# 이 프로젝트의 검증. **프로젝트 소유 파일이다** — 하네스 갱신이 덮지 않는다.
#
# `script/run-lint-test.sh` 가 하네스 검사를 마친 뒤 이것을 부른다.
# 하나라도 실패하면 0이 아닌 종료 코드로 끝낸다.
#
# 순서가 중요하다. **계층 의존 검사를 포맷·테스트보다 먼저 둔다** — 싸고, 위반이면
# 어차피 설계를 고쳐야 한다. 포맷 위반은 자동 수정으로 끝나지만 의존 위반은 아니다.
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"

# JDK 21 을 직접 잡는다. 셸의 JAVA_HOME 이 다른 버전을 가리켜도 이 검증은 stack.md 가
# 정한 런타임으로 돈다. 받아서 돌리는 사람의 셸 설정에 기대지 않는다.
if JAVA_21="$(/usr/libexec/java_home -v 21 2>/dev/null)"; then
  JAVA_HOME="$JAVA_21"
  export JAVA_HOME
else
  echo "error: JDK 21 not found" >&2
  echo "help: .ai/project/stack.md requires Java 21 — install it and retry" >&2
  exit 1
fi

# ── 1. 계층 의존 검사 ────────────────────────────────────────────────────────
# 기준은 `.ai/project/architecture.md` 가 갖는다.
# `domain` 은 순수 함수와 값 객체다. `java.*` 외의 것을 import 하면 프레임워크가
# 규칙 안으로 들어온 것이고, 그 순간 domain 을 프레임워크 없이 시험할 수 없게 된다.
DOMAIN_DIR=src/main/java/com/judymoody59/silentroom/domain

if [ -d "$DOMAIN_DIR" ]; then
  # `import static java.util.Objects.requireNonNull;` 도 허용하므로 `static ` 을 먼저 지운다.
  violations="$(
    grep -rn --include='*.java' -E '^[[:space:]]*import[[:space:]]' "$DOMAIN_DIR" \
      | sed -E 's/import[[:space:]]+static[[:space:]]+/import /' \
      | grep -vE 'import[[:space:]]+java\.' \
      || true
  )"
  if [ -n "$violations" ]; then
    echo "error: domain layer must import nothing but java.*" >&2
    echo "$violations" >&2
    echo "help: .ai/project/architecture.md — domain is pure. move the dependency to application or adapter" >&2
    exit 1
  fi
fi

# ── 2. 포맷 검사 ─────────────────────────────────────────────────────────────
# 명령은 `.ai/project/commands.md` 가 갖는다. 위반은 `./mvnw spotless:apply` 로 고친다.
./mvnw -q spotless:check

# ── 3. 테스트 ────────────────────────────────────────────────────────────────
./mvnw -q test
