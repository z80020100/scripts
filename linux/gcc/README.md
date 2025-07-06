## GCC

### Install GCC on Debian-based OS by APT

#### Ubuntu 22.04 (Jammy)

| Jammy (aarch64) | gcc | gcc-x86-64-linux-gnu |
| :-------------: | :-: | :------------------: |
|        9        |  O  |          O           |
|       10        |  O  |          O           |
|       11        |  O  |          O           |
|       12        |  O  |          O           |

| Jammy (x86_64) | gcc | gcc-aarch64-linux-gnu |
| :------------: | :-: | :-------------------: |
|       9        |  O  |           O           |
|       10       |  O  |           O           |
|       11       |  O  |           O           |
|       12       |  O  |           O           |

#### Ubuntu 20.04 (Focal)

| Focal (aarch64) | gcc | gcc-x86-64-linux-gnu |
| :-------------: | :-: | :------------------: |
|        9        |  O  |          O           |
|       10        |  O  |          O           |

| Focal (x86_64) | gcc | gcc-aarch64-linux-gnu |
| :------------: | :-: | :-------------------: |
|       9        |  O  |           O           |
|       10       |  O  |           O           |

## Scripts Usage Guide

### APT-based Installation

#### `install_gcc_debian.sh`

Install GCC packages via APT on Debian-based systems.

**Usage:**

```bash
./install_gcc_debian.sh --version <version> --arch <architecture>
./install_gcc_debian.sh -v <version> -a <architecture>
```

**Options:**

- `--version, -v`: GCC version to install (9, 10, 11, 12)
- `--arch, -a`: Target architecture (x86_64, aarch64)
- `--help, -h`: Display help

**Examples:**

```bash
./install_gcc_debian.sh --version 11 --arch x86_64
./install_gcc_debian.sh -v 9 -a aarch64
```

#### `install_gcc_build_deps_debian.sh`

Install GCC build dependencies and configure Git.

**Usage:**

```bash
./install_gcc_build_deps_debian.sh
```

**Description:**

- Installs essential build tools: bison, build-essential, flex, zlib1g-dev, git, wget
- Configures Git global username and email if not set
- Required before building GCC from source

### GCC 4.9 from Source

#### Complete Build Workflow

**Step 1: Install Dependencies**

```bash
./install_gcc_build_deps_debian.sh
```

**Step 2: Download Source Code**

```bash
./gcc4.9/get_gcc4.9_source.sh
```

**Step 3: Build GCC 4.9**

```bash
./gcc4.9/build_gcc4.9.sh
```

**Step 4: Install GCC 4.9**

```bash
./gcc4.9/install_gcc4.9.sh
```

**Step 5: Use GCC 4.9**

```bash
./gcc4.9/use_gcc4.9.sh <mode>
```

#### Individual Script Details

#### `gcc4.9/get_gcc4.9_source.sh`

Download GCC 4.9 source code from Git repository.

**Usage:**

```bash
./gcc4.9/get_gcc4.9_source.sh
```

**Description:**

- Clones GCC 4.9 source from official GNU Git repository
- Creates build directory structure in `$HOME/build/gcc4.9/`
- Removes existing source directory before download

#### `gcc4.9/build_gcc4.9.sh`

Build GCC 4.9 from source code.

**Usage:**

```bash
./gcc4.9/build_gcc4.9.sh
```

**Description:**

- Applies patches if available (\*.patch files)
- Downloads GCC prerequisites automatically
- Configures build with optimized settings
- Builds GCC 4.9 with bootstrap process
- Times the build process

**Prerequisites:** Run `get_gcc4.9_source.sh` first

#### `gcc4.9/install_gcc4.9.sh`

Install built GCC 4.9 to system location.

**Usage:**

```bash
./gcc4.9/install_gcc4.9.sh
```

**Description:**

- Installs GCC 4.9 to `/opt/gcc-4.9/`
- Creates environment setup script
- Sets up PATH and library paths

**Prerequisites:** Run `build_gcc4.9.sh` first

#### `gcc4.9/use_gcc4.9.sh`

Comprehensive GCC 4.9 usage and management tool.

**Usage:**

```bash
./gcc4.9/use_gcc4.9.sh <mode>
```

**Modes:**

- `version`: Show version info and installation status
- `shell`: Start interactive shell with GCC 4.9 environment
- `compile`: Interactive compilation with user prompts
- `env`: Output environment variables (use with source)
- `help`: Display help information

**Examples:**

```bash
./gcc4.9/use_gcc4.9.sh version
./gcc4.9/use_gcc4.9.sh shell
./gcc4.9/use_gcc4.9.sh compile
source <(./gcc4.9/use_gcc4.9.sh env)
```

### Testing

#### `test_gcc_version.c`

Test program to display GCC version and compilation information.

**Usage:**

```bash
gcc test_gcc_version.c -o test_gcc_version
./test_gcc_version
```

**Description:**

- Prints GCC version used for compilation
- Shows C standard version
- Displays GCC major and minor version numbers
- Useful for verifying any GCC installation
