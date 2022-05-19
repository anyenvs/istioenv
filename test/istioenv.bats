#!/usr/bin/env bats

load test_helper

@test "blank invocation" {
  run istioenv
  assert_failure
  assert_line 0 "$(istioenv---version)"
}

@test "invalid command" {
  run istioenv does-not-exist
  assert_failure
  assert_output "istioenv: no such command \`does-not-exist'"
}

@test "default ISTIOENV_ROOT" {
  ISTIOENV_ROOT="" HOME=/home/mislav run istioenv root
  assert_success
  assert_output "/home/mislav/.istioenv"
}

@test "inherited ISTIOENV_ROOT" {
  ISTIOENV_ROOT=/opt/istioenv run istioenv root
  assert_success
  assert_output "/opt/istioenv"
}
