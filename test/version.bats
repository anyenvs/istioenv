#!/usr/bin/env bats

load test_helper

setup() {
  mkdir -p "$ISTIOENV_TEST_DIR"
  cd "$ISTIOENV_TEST_DIR"
}

@test "no version selected" {
  assert [ ! -d "${ISTIOENV_ROOT}/versions" ]
  run istioenv-version
  assert_success "system (set by ${ISTIOENV_ROOT}/version)"
}

@test "set by ISTIOENV_VERSION" {
  create_version "1.11.3"
  ISTIOENV_VERSION=1.11.3 run istioenv-version
  assert_success "1.11.3 (set by ISTIOENV_VERSION environment variable)"
}

@test "set by local file" {
  create_version "1.11.3"
  cat > ".istio-version" <<<"1.11.3"
  run istioenv-version
  assert_success "1.11.3 (set by ${PWD}/.istio-version)"
}

@test "set by global file" {
  create_version "1.11.3"
  cat > "${ISTIOENV_ROOT}/version" <<<"1.11.3"
  run istioenv-version
  assert_success "1.11.3 (set by ${ISTIOENV_ROOT}/version)"
}
