function __fish_istioenv_needs_command
  set cmd (commandline -opc)
  if [ (count $cmd) -eq 1 -a $cmd[1] = 'istioenv' ]
    return 0
  end
  return 1
end

function __fish_istioenv_using_command
  set cmd (commandline -opc)
  if [ (count $cmd) -gt 1 ]
    if [ $argv[1] = $cmd[2] ]
      return 0
    end
  end
  return 1
end

complete -f -c istioenv -n '__fish_istioenv_needs_command' -a '(istioenv commands)'
for cmd in (istioenv commands)
  complete -f -c istioenv -n "__fish_istioenv_using_command $cmd" -a \
    "(istioenv completions (commandline -opc)[2..-1])"
end
