if [[ ! -o interactive ]]; then
    return
fi

compctl -K _istioenv istioenv

_istioenv() {
  local words completions
  read -cA words

  if [ "${#words}" -eq 2 ]; then
    completions="$(istioenv commands)"
  else
    completions="$(istioenv completions ${words[2,-2]})"
  fi

  reply=(${(ps:\n:)completions})
}
