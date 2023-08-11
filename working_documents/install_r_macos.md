Installing R from Source on macOS
================
2023-08-11

## Prerequisites

### Set up R installation directory

Open Terminal.app and follow these instructions:

1.  Set `LOCAL` as an environment variable to match your architecture

    ``` sh
    set LOCAL=/opt/R/x86_64 # Intel
    set LOCAL=/opt/R/arm64  # Apple Silicon (e.g. M1)
    ```

2.  Make your account own `/opt/R` so that we can install prerequisites
    for building from source with the helper R script described in the
    next subsection.

    ``` sh
    sudo chown -R $USER /opt/R
    ```

    <details>
    <summary>

    Details

    </summary>

    If this is skipped, get errors when running
    `install.libs("r-base-dev")`, e.g. ” Can’t restore time”, “Can’t
    unlink already-existing object”

    </details>

3.  Add `$LOCAL/bin` to your path

    ``` sh
    cat << EOF >> /Users/$USER/.zprofile
    # Add R bin directory to PATH
    export PATH="$LOCAL/bin:\${PATH}"
    EOF
    ```

4.  If you have previously installed R on the computer, make your
    account own the existing R framework folder

    ``` sh
    sudo chown -R /Library/Frameworks/R.framework/
    ```

    Otherwise, download the installer for the latest release of R from
    CRAN and install with the default settings.

### Install prerequisites

It is best to install prerequisites before first building R from source,
even if you think you may have installed some of the prerequisites
before.

1.  Install Xcode Command Line Tools from the terminal

    ``` sh
    xcode-select --install
    ```

    (If already installed, shows “xcode-select: error: command line
    tools are already installed”).

2.  Install GNU Fortran (gfortran) from the binary at
    <https://mac.r-project.org/tools/>.

3.  Install XQuartz from the binary <https://www.xquartz.org/>.
    **Restart your computer** for XQuartz (and components that depend on
    it) to work!

4.  Within R, use the helper R script to install commonly required
    prerequisites

    ``` r
    source("https://mac.R-project.org/bin/install.R")
    install.libs("r-base-dev")
    ```

5.  (Optional), within R, install Pango for full Cairo support

    ``` r
    install.libs("pango")
    ```

6.  TODO, guidance for installing MacTex for those that need it

7.  NEEDS CHECKING - Do we also need subversion or is this in
    r-base-dev? If so,

    ``` r
    install.libs("subversion", dep = FALSE)
    ```

8.  (Recommended) Install RSwitch from <https://rud.is/rswitch/>.

## Build R

Run the following commands within Terminal.app:

<details>
<summary>
Note if you prefer to use an RStudio terminal
</summary>
The PATH setting in `~/.zprofile` will only work for a zsh terminal, so
you may need to change your Global Options or add the PATH setting to
`~/.bash_profile`
</details>

0.  Retrieve R source code into `TOP_SRCDIR`, note that we retrieve the
    `r-devel` source code:

    ``` sh
    export TOP_SRCDIR="$HOME/svn/R-devel"
    svn checkout https://svn.r-project.org/R/trunk/ "$TOP_SRCDIR"
    ```

1.  Download the latest recommended packages:

    ``` sh
    $TOP_SRCDIR/tools/rsync-recommended
    ```

2.  Create the build directory in the `BUILDDIR`:

    ``` sh
    export BUILDDIR="$HOME/build/R-devel"
    mkdir -p "$BUILDDIR"
    cd "$BUILDDIR"
    ```

3.  Create `config.site` within the build directory to set some
    configuration flags as recommended by the [R-admin
    manual](https://cran.r-project.org/doc/manuals/r-devel/R-admin.html#Prerequisites).

    ``` sh
    cat << EOF > config.site
    CC=clang
    OBJC=\$CC
    FC="/opt/gfortran/bin/gfortran -mtune=native"
    CPPFLAGS='-isystem $LOCAL/include'
    CXX=clang++
    PKG_CONFIG_PATH=$LOCAL/lib/pkgconfig:/usr/lib/pkgconfig
    EOF
    ```

    If you are on Apple Silicon, also run the following to add some more
    configuration flags

    ``` sh
    cat << EOF >> config.site
    CFLAGS="-falign-functions=8 -g -O0"
    FFLAGS="-g -O2 -mmacosx-version-min=11.0"
    FCFLAGS="-g -O2 -mmacosx-version-min=11.0"
    LDFLAGS=-L/opt/R/arm64/lib
    EOF
    ```

    <details>
    <summary>

    Details

    </summary>

    Some modifications: `-O0` to enable debugging symbols and disable
    compiler optimisations for better debugging experience;
    `-mmacos-version-min` corrected \[?\] to `-mmacosx-version-min`;
    `LDFLAGS=-L/opt/R/arm64/lib` added so that liblzma can be found.

    </details>

4.  Configure the R installation with `--enable-R-framework` to install
    as an application framework so that we can switch between R versions
    with Rswitch:

    ``` sh
    "$TOP_SRCDIR/configure" --enable-R-framework
    ```

    <details>
    <summary>

    Details

    </summary>

    This assumes you only want to work with one development version of R
    that will be identified by the Major.Minor version number. To
    customize the version name use `--enable-R-framework FW=VERSION`
    where e.g. VERSION=4.4-dev. The compilation options in [R-admin
    manual](https://cran.r-project.org/doc/manuals/r-devel/R-admin.html#Prerequisites)
    to define the location of X11 and tcltk libraries do not seem to be
    necessary.

    </details>

5.  Build R :

    ``` sh
    make
    ```

6.  Check that R works as expected:

    ``` sh
    make check
    ```

    `make` will exit with an error if there are any problems.

    <details>
    <summary>

    Note if you are using RStudio terminal

    </summary>

    `make check` will fail unless you run `unset R_HOME` first

    </details>

The built version of R will now be your default version of R. To switch
versions, use Rswitch.
