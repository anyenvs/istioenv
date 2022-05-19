#!/usr/bin/env bats

load test_helper

create_executable() {
  name="${1?}"
  shift 1
  bin="${ISTIOENV_ROOT}/versions/${ISTIOENV_VERSION}/bin"
  mkdir -p "$bin"
  { if [ $# -eq 0 ]; then cat -
    else echo "$@"
    fi
  } | sed -Ee '1s/^ +//' > "${bin}/$name"
  chmod +x "${bin}/$name"
}

@test "fails with invalid version" {
  export ISTIOENV_VERSION="0.0.0"
  run istioenv-exec version
  assert_failure "istioenv: version \`0.0.0' is not installed"
}

@test "fails with invalid version set from file" {
  mkdir -p "$ISTIOENV_TEST_DIR"
  cd "$ISTIOENV_TEST_DIR"
  echo 0.0.1 > .istio-version
  run istioenv-exec rspec
  assert_failure "istioenv: version \`0.0.1' is not installed (set by $PWD/.istio-version)"
}
