<div align="center">

# asdf-tutor [![Build](https://github.com/tecoholic/asdf-tutor/actions/workflows/build.yml/badge.svg)](https://github.com/tecoholic/asdf-tutor/actions/workflows/build.yml) [![Lint](https://github.com/tecoholic/asdf-tutor/actions/workflows/lint.yml/badge.svg)](https://github.com/tecoholic/asdf-tutor/actions/workflows/lint.yml)

[tutor](https://docs.tutor.edly.io/index.html) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

**TODO: adapt this section**

- `bash`, `curl`, `tar`, and [POSIX utilities](https://pubs.opengroup.org/onlinepubs/9699919799/idx/utilities.html).
- `SOME_ENV_VAR`: set this environment variable in your shell config to load the correct version of tool x.

# Install

Plugin:

```shell
asdf plugin add tutor
# or
asdf plugin add tutor https://github.com/tecoholic/asdf-tutor.git
```

tutor:

```shell
# Show all installable versions
asdf list-all tutor

# Install specific version
asdf install tutor latest

# Set a version globally (on your ~/.tool-versions file)
asdf global tutor latest

# Now tutor commands are available
tutor --version
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/tecoholic/asdf-tutor/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [Arunmozhi](https://github.com/tecoholic/)
