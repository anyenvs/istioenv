#!/usr/bin/env bats

load test_helper

setup() {
  mkdir -p "$ISTIOENV_TEST_DIR"
  cd "$ISTIOENV_TEST_DIR"
}

@test "reports global file even if it doesn't exist" {
  assert [ ! -e "${ISTIOENV_ROOT}/version" ]
  run istioenv-version-origin
  assert_success "${ISTIOENV_ROOT}/version"
}

@test "detects global file" {
  mkdir -p "$ISTIOENV_ROOT"
  touch "${ISTIOENV_ROOT}/version"
  run istioenv-version-origin
  assert_success "${ISTIOENV_ROOT}/version"
}

@test "detects ISTIOENV_VERSION" {
  ISTIOENV_VERSION=1 run istioenv-version-origin
  assert_success "ISTIOENV_VERSION environment variable"
}

@test "detects local file" {
  echo "system" > .istio-version
  run istioenv-version-origin
  assert_success "${PWD}/.istio-version"
}

@test "doesn't inherit ISTIOENV_VERSION_ORIGIN from environment" {
  ISTIOENV_VERSION_ORIGIN=ignored run istioenv-version-origin
  assert_success "${ISTIOENV_ROOT}/version"
}
