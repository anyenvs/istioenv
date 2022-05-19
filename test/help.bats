#!/usr/bin/env bats

load test_helper

@test "without args shows summary of common commands" {
  run istioenv-help
  assert_success
  assert_line "Usage: istioenv <command> [<args>]"
  assert_line "Some useful istioenv commands are:"
}

@test "invalid command" {
  run istioenv-help hello
  assert_failure "istioenv: no such command \`hello'"
}

@test "shows help for a specific command" {
  mkdir -p "${ISTIOENV_TEST_DIR}/bin"
  cat > "${ISTIOENV_TEST_DIR}/bin/istioenv-hello" <<SH
#!shebang
# Usage: istioenv hello <world>
# Summary: Says "hello" to you, from istioenv
# This command is useful for saying hello.
echo hello
SH

  run istioenv-help hello
  assert_success
  assert_output <<SH
Usage: istioenv hello <world>

This command is useful for saying hello.
SH
}

@test "replaces missing extended help with summary text" {
  mkdir -p "${ISTIOENV_TEST_DIR}/bin"
  cat > "${ISTIOENV_TEST_DIR}/bin/istioenv-hello" <<SH
#!shebang
# Usage: istioenv hello <world>
# Summary: Says "hello" to you, from istioenv
echo hello
SH

  run istioenv-help hello
  assert_success
  assert_output <<SH
Usage: istioenv hello <world>

Says "hello" to you, from istioenv
SH
}

@test "extracts only usage" {
  mkdir -p "${ISTIOENV_TEST_DIR}/bin"
  cat > "${ISTIOENV_TEST_DIR}/bin/istioenv-hello" <<SH
#!shebang
# Usage: istioenv hello <world>
# Summary: Says "hello" to you, from istioenv
# This extended help won't be shown.
echo hello
SH

  run istioenv-help --usage hello
  assert_success "Usage: istioenv hello <world>"
}

@test "multiline usage section" {
  mkdir -p "${ISTIOENV_TEST_DIR}/bin"
  cat > "${ISTIOENV_TEST_DIR}/bin/istioenv-hello" <<SH
#!shebang
# Usage: istioenv hello <world>
#        istioenv hi [everybody]
#        istioenv hola --translate
# Summary: Says "hello" to you, from istioenv
# Help text.
echo hello
SH

  run istioenv-help hello
  assert_success
  assert_output <<SH
Usage: istioenv hello <world>
       istioenv hi [everybody]
       istioenv hola --translate

Help text.
SH
}

@test "multiline extended help section" {
  mkdir -p "${ISTIOENV_TEST_DIR}/bin"
  cat > "${ISTIOENV_TEST_DIR}/bin/istioenv-hello" <<SH
#!shebang
# Usage: istioenv hello <world>
# Summary: Says "hello" to you, from istioenv
# This is extended help text.
# It can contain multiple lines.
#
# And paragraphs.

echo hello
SH

  run istioenv-help hello
  assert_success
  assert_output <<SH
Usage: istioenv hello <world>

This is extended help text.
It can contain multiple lines.

And paragraphs.
SH
}
