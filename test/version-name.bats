#!/usr/bin/env bats

load test_helper

setup() {
  mkdir -p "$ISTIOENV_TEST_DIR"
  cd "$ISTIOENV_TEST_DIR"
}

@test "no version selected" {
  assert [ ! -d "${ISTIOENV_ROOT}/versions" ]
  run istioenv-version-name
  assert_success "system"
}

@test "system version is not checked for existance" {
  ISTIOENV_VERSION=system run istioenv-version-name
  assert_success "system"
}

@test "ISTIOENV_VERSION has precedence over local" {
  create_version "1.10.8"
  create_version "1.11.3"

  cat > ".istio-version" <<<"1.10.8"
  run istioenv-version-name
  assert_success "1.10.8"

  ISTIOENV_VERSION=1.11.3 run istioenv-version-name
  assert_success "1.11.3"
}

@test "local file has precedence over global" {
  create_version "1.10.8"
  create_version "1.11.3"

  cat > "${ISTIOENV_ROOT}/version" <<<"1.10.8"
  run istioenv-version-name
  assert_success "1.10.8"

  cat > ".istio-version" <<<"1.11.3"
  run istioenv-version-name
  assert_success "1.11.3"
}

@test "missing version" {
  ISTIOENV_VERSION=1.2 run istioenv-version-name
  assert_failure "istioenv: version \`1.2' is not installed (set by ISTIOENV_VERSION environment variable)"
}
