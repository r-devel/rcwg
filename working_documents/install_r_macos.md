Installing R from Source on macOS
================
2023-12-20

## Prerequisites

Some details and notes are hidden by default - click the black arrowhead
to expand or collapse these sections.

### Set up R installation directory

If you do not have an existing version of R installed on your computer,
download the installer for the latest release of R from the [CRAN macOS
page](https://cran.r-project.org/bin/macosx/) and install this pre-built
(binary) version with the default settings.

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

4.  Make your account own the R framework folder (created when
    installing R from the binary)

    ``` sh
    sudo chown -R $USER /Library/Frameworks/R.framework/
    ```

### Install prerequisites

For the following instructions, run the code within R:

1.  Use the helper R script to install commonly required prerequisites

    ``` r
    source("https://mac.R-project.org/bin/install.R")
    install.libs("r-base-dev")
    ```

2.  (Optional), install Pango for full Cairo support

    ``` r
    install.libs("pango")
    ```

3.  Check if you already have Subversion installed:

    ``` r
    system2("which", "svn")
    ```

    This will print a path where Subversion is installed. If nothing is
    printed, install Subversion:

    ``` r
    install.libs("subversion", dep = FALSE)
    ```

    <details>
    <summary>

    <i>Troubleshooting…</i>

    </summary>

    If this does not work, try installing Subversion via your preferred
    package manager, e.g. with Homebrew: <code>brew install svn</code>.

    </details>

For the remaining instructions, run the code within Terminal.app

1.  Install GNU Fortran (gfortran) from the binary at
    <https://mac.r-project.org/tools/>. This version is prepared
    specifically for R and will be used in preference to any other
    version on your system.

2.  From the terminal, install Xcode Command Line Tools

    ``` sh
    xcode-select --install
    ```

    (If already installed, shows “xcode-select: error: command line
    tools are already installed”).

3.  Check if you have a current version of MacTeX installed:

    ``` sh
    ls /usr/local/texlive
    ```

    If the `/usr/local/texlive` directory exists, you will see one or
    more subdirectories named by year, e.g.

        2022            2023            texmf-local

    If this check doesn’t show a subdirectory for the current year,
    install MacTex from the binary at
    <https://tug.org/mactex/mactex-download.html>.

4.  Check if you have XQuartz installed:

    ``` sh
    mdls -name kMDItemVersion /Applications/Utilities/XQuartz.app
    ```

    This will show the version number or
    `could not find /Applications/Utilities/XQuartz.app`. If missing,
    install XQuartz from the binary at <https://www.xquartz.org/>.
    **Restart your computer** for XQuartz to work!  

5.  (Recommended) If you are not already using a tool such as
    [rig](https://github.com/r-lib/rig) to install and manage multiple R
    versions, install RSwitch from <https://rud.is/rswitch/>. These
    third-party tools are not part of the R Project, but are recommended
    here as they provide an easy way to switch R versions.

## Build R

Run the following commands within Terminal.app:

0.  Retrieve R source code into `TOP_SRCDIR`, note that we retrieve the
    `r-devel` source code:

    ``` sh
    export TOP_SRCDIR="$HOME/R-devel/svn"
    svn checkout https://svn.r-project.org/R/trunk/ "$TOP_SRCDIR"
    ```

1.  Download the latest recommended packages:

    ``` sh
    $TOP_SRCDIR/tools/rsync-recommended
    ```

2.  Create the build directory in the `BUILDDIR`:

    ``` sh
    export BUILDDIR="$HOME/R-devel/build"
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

4.  Configure the R installation with `--enable-R-framework` to prepare
    for installation as an App:

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

    `make` will exit with an error if there are any problems. You can
    start the built version of by running the command `bin/R` from the
    build directory, but we recommending installing as an App, as
    described next.

    <details>
    <summary>

    <i>Note if you are using RStudio terminal…</i>

    </summary>

    `make check` will fail unless you run `unset R_HOME` first

    </details>

7.  Install the built version of R and reset permissions on the R
    framework folder to include the new directories.

    ``` sh
    make install
    sudo chown -R $USER /Library/Frameworks/R.framework/
    ```

    The built version of R will now be your default version of R, which
    you can start by typing `R` in the terminal, or restarting the R
    session in RStudio, etc. To switch versions, use RSwitch or rig,
    then restart your R session.

## Re-build R

After making changes to the source files in `$TOP_SRCDIR` (via
`svn update` or making your own modifications), you can re-build R
incorporating the changed components by running the following commands
in the terminal:

``` sh
export BUILDDIR="$HOME/build/R-devel"
cd $BUILDDIR
make
```

If you followed the recommended steps to install R as an App, you can
install the re-built version as follows:

``` sh
make install
```
