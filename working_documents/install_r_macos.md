Installing R from Source on macOS
================
2023-12-11

## Prerequisites

Some details and notes are hidden by default - click the black arrowhead
to expand or collapse these sections.

### Set up R installation directory

Open Terminal.app and follow these instructions:

1.  Set `LOCAL` as a temporary environment variable to match your
    architecture

    ``` sh
    # Intel
    export LOCAL=/opt/R/x86_64 
    ```

    ``` sh
    # Apple Silicon (e.g. M1)
    export LOCAL=/opt/R/arm64  
    ```

2.  Make your account own `/opt/R` so that we can install prerequisites
    for building from source with the helper R script described in the
    next subsection.

    ``` sh
    sudo chown -R $USER /opt/R
    ```

    <details>
    <summary>

    <i>Details…</i>

    </summary>

    If this is skipped, you get errors when running
    `install.libs("r-base-dev")`, e.g. “Can’t restore time”, “Can’t
    unlink already-existing object”.

    </details>

3.  Add `$LOCAL/bin` to your path

    ``` sh
    cat << EOF >> /Users/$USER/.zprofile
    # Add R bin directory to PATH
    export PATH="$LOCAL/bin:\${PATH}"
    EOF
    ```

    <details>
    <summary>

    <i>Note if using RStudio terminal, or using Terminal.app on macOS \<
    10.15 (Catalina)…</i>

    </summary>

    The code above assumes you are using a Zsh shell (the default on
    macOS ≥ 10.15). If you are using a bash shell, replace
    <code>.zprofile</code> with <code>.bash_profile</code>. The type of
    terminal in RStudio can be set in Terminal Options from the terminal
    or in Global Options.

    </details>
    </details>

4.  If you have previously installed R on the computer, make your
    account own the existing R framework folder

    ``` sh
    sudo chown -R $USER /Library/Frameworks/R.framework/
    ```

    Otherwise, download the installer for the latest release of R from
    CRAN and install with the default settings first.

### Install prerequisites

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

6.  Check if you have a current version of MacTeX installed:

    ``` sh
    ls /usr/local/texlive
    ```

    If the `/usr/local/texlive` directory exists, you will see one or
    more subdirectories named by year, e.g.

        2022            2023            texmf-local

    If this check doesn’t show a subdirectory for the current year,
    install MacTex from the binary at
    <https://tug.org/mactex/mactex-download.html>.

7.  In the terminal, check if you already have Subversion installed:

    ``` sh
    which svn
    ```

    This will show a path where Subversion is installed, or
    `svn not found`. If necessary, install Subversion from within R:

    ``` r
    install.libs("subversion", dep = FALSE)
    ```

    <details>
    <summary>

    <i>Troubleshooting…</i>

    </summary>

    If this does not work, try installing via your preferred package
    manage, e.g. with Homebrew: <code>brew install svn</code>.

    </details>

8.  (Recommended) If you are not already using a tool such as
    [rig](https://github.com/r-lib/rig) to install and manage multiple R
    versions, install RSwitch from <https://rud.is/rswitch/>. These
    tools are not part of the R Project, but make it easy to switch R
    versions.

## Build R

Run the following commands within Terminal.app:

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
    mkdir -p $BUILDDIR
    cd $BUILDDIR
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
    LDFLAGS="-L$LOCAL/lib -L/opt/gfortran/lib"
    CPPFLAGS="-isystem $LOCAL/include -I$LOCAL/include"
    EOF
    ```

    <details>
    <summary>

    <i>Details…</i>

    </summary>

    Some modifications to the recommendations in R-admin: `-O0` to
    enable debugging symbols and disable compiler optimisations for
    better debugging experience; `-mmacos-version-min` corrected \[?\]
    to `-mmacosx-version-min`;
    `LDFLAGS="-L$LOCAL/lib -L/opt/gfortran/lib"` added so that liblzma
    (in `$LOCAL/lib`) and gfortran libraries can be found. CPPFLAGS
    modified for Apple Silicon to link to the headers for liblzma.

    </details>

4.  Configure the R installation with `--enable-R-framework` to install
    as an application framework so that we can switch between R versions
    with RSwitch:

    ``` sh
    "$TOP_SRCDIR/configure" --enable-R-framework
    ```

    <details>
    <summary>

    <i>Working with multiple devel versions…</i>

    </summary>

    The code above assumes you only want to work with one development
    version of R that will be identified by the Major.Minor version
    number. To customize the version name use
    `--enable-R-framework FW=VERSION` where e.g. `VERSION=4.4-dev`. The
    configure options in [R-admin
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

    <i>Note if you are using RStudio terminal…</i>

    </summary>

    `make check` will fail unless you run `unset R_HOME` first

    </details>

7.  Install the built version of R

    ``` sh
    make install
    ```

The built version of R will now be your default version of R, which you
can start by typing `R` in the terminal, or restarting the R session in
RStudio, etc. To switch versions, use RSwitch or rig, then restart your
R session.
