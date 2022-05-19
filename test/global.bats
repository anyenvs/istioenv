#!/usr/bin/env bats

load test_helper

@test "default" {
  run istioenv-global
  assert_success
  assert_output "system"
}

@test "read ISTIOENV_ROOT/version" {
  mkdir -p "$ISTIOENV_ROOT"
  echo "1.2.3" > "$ISTIOENV_ROOT/version"
  run istioenv-global
  assert_success
  assert_output "1.2.3"
}

@test "set ISTIOENV_ROOT/version" {
  mkdir -p "$ISTIOENV_ROOT/versions/1.2.3/bin"
  run istioenv-global "1.2.3"
  assert_success
  run istioenv-global
  assert_success "1.2.3"
}

@test "fail setting invalid ISTIOENV_ROOT/version" {
  mkdir -p "$ISTIOENV_ROOT"
  run istioenv-global "1.2.3"
  assert_failure "istioenv: version \`1.2.3' is not installed"
}
