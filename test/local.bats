#!/usr/bin/env bats

load test_helper

setup() {
  mkdir -p "${ISTIOENV_TEST_DIR}/myproject"
  cd "${ISTIOENV_TEST_DIR}/myproject"
}

@test "no version" {
  assert [ ! -e "${PWD}/.istio-version" ]
  run istioenv-local
  assert_failure "istioenv: no local version configured for this directory"
}

@test "local version" {
  echo "1.2.3" > .istio-version
  run istioenv-local
  assert_success "1.2.3"
}

@test "discovers version file in parent directory" {
  echo "1.2.3" > .istio-version
  mkdir -p "subdir" && cd "subdir"
  run istioenv-local
  assert_success "1.2.3"
}

@test "ignores ISTIOENV_DIR" {
  echo "1.2.3" > .istio-version
  mkdir -p "$HOME"
  echo "2.0-home" > "${HOME}/.istio-version"
  ISTIOENV_DIR="$HOME" run istioenv-local
  assert_success "1.2.3"
}

@test "sets local version" {
  mkdir -p "${ISTIOENV_ROOT}/versions/1.2.3/bin"
  run istioenv-local 1.2.3
  assert_success ""
  assert [ "$(cat .istio-version)" = "1.2.3" ]
}

@test "changes local version" {
  echo "1.0-pre" > .istio-version
  mkdir -p "${ISTIOENV_ROOT}/versions/1.2.3/bin"
  run istioenv-local
  assert_success "1.0-pre"
  run istioenv-local 1.2.3
  assert_success ""
  assert [ "$(cat .istio-version)" = "1.2.3" ]
}

@test "unsets local version" {
  touch .istio-version
  run istioenv-local --unset
  assert_success ""
  assert [ ! -e .istio-version ]
}
