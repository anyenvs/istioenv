#!/usr/bin/env bats

load test_helper

export GIT_DIR="${ISTIOENV_TEST_DIR}/.git"

setup() {
  mkdir -p "$HOME"
  git config --global user.name  "Tester"
  git config --global user.email "tester@test.local"
  cd "$ISTIOENV_TEST_DIR"
}

git_commit() {
  git commit --quiet --allow-empty -m "empty"
}

@test "default version" {
  assert [ ! -e "$ISTIOENV_ROOT" ]
  run istioenv---version
  assert_success
  [[ $output == "istioenv "?.?.? ]]
}

@test "doesn't read version from non-istioenv repo" {
  git init
  git remote add origin https://github.com/homebrew/homebrew.git
  git_commit
  git tag v1.0

  run istioenv---version
  assert_success
  [[ $output == "istioenv "?.?.? ]]
}

@test "reads version from git repo" {
  git init
  git remote add origin https://github.com/istioenv/istioenv.git
  git_commit
  git tag v0.4.1
  git_commit
  git_commit

  run istioenv---version
  assert_success "istioenv 0.4.1-2-g$(git rev-parse --short HEAD)"
}

@test "prints default version if no tags in git repo" {
  git init
  git remote add origin https://github.com/istioenv/istioenv.git
  git_commit

  run istioenv---version
  [[ $output == "istioenv "?.?.? ]]
}
