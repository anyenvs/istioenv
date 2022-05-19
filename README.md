# istioenv

[Bazel](https://github.com/istiobuild/istio/releases) version manager.

Inspired by and adopted from the tools below:

* [helmenv](https://github.com/yuya-takeyama/helmenv)
* [tfenv](https://github.com/Zordrak/tfenv)

## Installation

1. Add `variables` into `~/.bash_profile` or `~/.bashrc` and source the file

  ```sh
  $ echo 'export ISTIOENV_ROOT=${HOME}/.istioenv' >> ~/.bash_profile
  $ echo "export PATH=${ISTIOENV_ROOT}/bin:$PATH" >> ~/.bash_profile
  $ . ~/.bash_profile
  ```

2. Check out istioenv into any path (here is `${HOME}/.istioenv`)
  ```sh
  $ git clone --branch=main --depth=1 https://github.com/anyenvs/istioenv.git ${ISTIOENV_ROOT}
  ```

## Usage

```
Usage: istioenv <command> [<args>]

Some useful istioenv commands are:
   local       Set or show the local application-specific Bazel version
   global      Set or show the global Bazel version
   install     Install the specified version of Bazel
   uninstall   Uninstall the specified version of Bazel
   version     Show the current Bazel version and its origin
   versions    List all Bazel versions available to istioenv

See `istioenv help <command>' for information on a specific command.
For full documentation, see: https://github.com/anyenvs/istioenv#readme
```

## License

* istioenv
  * The MIT License
* [helmenv](https://github.com/yuya-takeyama/helmenv)
  * The MIT License
* [tfenv](https://github.com/Zordrak/tfenv)
  * The MIT License
