#!/usr/bin/env bats

load test_helper

setup() {
  mkdir -p "$ISTIOENV_TEST_DIR"
  cd "$ISTIOENV_TEST_DIR"
}

create_file() {
  mkdir -p "$(dirname "$1")"
  echo "system" > "$1"
}

@test "detects global 'version' file" {
  create_file "${ISTIOENV_ROOT}/version"
  run istioenv-version-file
  assert_success "${ISTIOENV_ROOT}/version"
}

@test "prints global file if no version files exist" {
  assert [ ! -e "${ISTIOENV_ROOT}/version" ]
  assert [ ! -e ".istio-version" ]
  run istioenv-version-file
  assert_success "${ISTIOENV_ROOT}/version"
}

@test "in current directory" {
  create_file ".istio-version"
  run istioenv-version-file
  assert_success "${ISTIOENV_TEST_DIR}/.istio-version"
}

@test "in parent directory" {
  create_file ".istio-version"
  mkdir -p project
  cd project
  run istioenv-version-file
  assert_success "${ISTIOENV_TEST_DIR}/.istio-version"
}

@test "topmost file has precedence" {
  create_file ".istio-version"
  create_file "project/.istio-version"
  cd project
  run istioenv-version-file
  assert_success "${ISTIOENV_TEST_DIR}/project/.istio-version"
}

@test "ISTIOENV_DIR has precedence over PWD" {
  create_file "widget/.istio-version"
  create_file "project/.istio-version"
  cd project
  ISTIOENV_DIR="${ISTIOENV_TEST_DIR}/widget" run istioenv-version-file
  assert_success "${ISTIOENV_TEST_DIR}/widget/.istio-version"
}

@test "PWD is searched if ISTIOENV_DIR yields no results" {
  mkdir -p "widget/blank"
  create_file "project/.istio-version"
  cd project
  ISTIOENV_DIR="${ISTIOENV_TEST_DIR}/widget/blank" run istioenv-version-file
  assert_success "${ISTIOENV_TEST_DIR}/project/.istio-version"
}

@test "finds version file in target directory" {
  create_file "project/.istio-version"
  run istioenv-version-file "${PWD}/project"
  assert_success "${ISTIOENV_TEST_DIR}/project/.istio-version"
}

@test "fails when no version file in target directory" {
  run istioenv-version-file "$PWD"
  assert_failure ""
}
