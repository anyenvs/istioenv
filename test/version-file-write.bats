#!/usr/bin/env bats

load test_helper

setup() {
  mkdir -p "$ISTIOENV_TEST_DIR"
  cd "$ISTIOENV_TEST_DIR"
}

@test "invocation without 2 arguments prints usage" {
  run istioenv-version-file-write
  assert_failure "Usage: istioenv version-file-write <file> <version>"
  run istioenv-version-file-write "one" ""
  assert_failure
}

@test "setting nonexistent version fails" {
  assert [ ! -e ".istio-version" ]
  run istioenv-version-file-write ".istio-version" "1.11.3"
  assert_failure "istioenv: version \`1.11.3' is not installed"
  assert [ ! -e ".istio-version" ]
}

@test "writes value to arbitrary file" {
  mkdir -p "${ISTIOENV_ROOT}/versions/1.10.8/bin"
  assert [ ! -e "my-version" ]
  run istioenv-version-file-write "${PWD}/my-version" "1.10.8"
  assert_success ""
  assert [ "$(cat my-version)" = "1.10.8" ]
}
