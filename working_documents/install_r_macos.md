Installing R from Source on macOS
================
2025-10-08

## Prerequisites

Some details and notes are hidden by default - click the black arrowhead
to expand or collapse these sections.

### Set up installation directories

If you do not have an existing version of R installed on your computer,
download the installer for the latest release of R from the [CRAN macOS
page](https://cran.r-project.org/bin/macosx/) and install this pre-built
(binary) version with the default settings.

Open Terminal.app to run the shell commands in the instructions below:

1.  Make your account own the R framework folder (created when
    installing R from the binary)

    ``` sh
    sudo chown -R $USER /Library/Frameworks/R.framework/
    ```

2.  Make your account own `/opt/R` so that we can install prerequisites
    for building from source with the `install.libs` R function
    described in the next subsection.

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

3.  Open the profile for the Zsh shell

    ``` sh
    open /Users/$USER/.zprofile
    ```

    Add one of the following commands to the profile, selecting the one
    that matches your architecture:

    ``` sh
    # Intel
    export PATH="/opt/R/x86_64/bin:${PATH}"
    ```

    ``` sh
    # Apple Silicon (M1, M2, ...)
    export PATH="/opt/R/arm64/bin:${PATH}"
    ```

    This will add the `/opt/R/*/bin` directory to your `PATH` variable
    when you restart Terminal.app, so that the prerequisites installed
    with `install.libs` can be found.

    <details>

    <summary>

    <i>Note if using RStudio terminal, or using Terminal.app on macOS \<
    10.15 (Catalina)…</i>

    </summary>

    The code above assumes you are running shell commands in a Zsh shell
    (the default for Terminal.app on macOS ≥ 10.15). If you are using a
    bash shell, edit <code>.bash_profile</code> rather than
    <code>.zprofile</code>. The type of terminal in RStudio can be set
    in Terminal Options from the terminal or in Global Options.

    </details>

### Install prerequisites

Start a new R session. For the following instructions, run the code
within R:

1.  Use `install.libs` from <https://mac.R-project.org> to install
    commonly required prerequisites

    ``` r
    source("https://mac.R-project.org/bin/install.R")
    install.libs("r-base-dev")
    ```

2.  Check if you already have Subversion installed:

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

For the remaining instructions, code should be run within Terminal.app

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

<details>

<summary>

<i>Detail on selected prerequisites…</i>
</summary>

The following prerequisites have been installed by the above
instructions:
<ul>

<li>

jpeg, libpng, pkgconfig, tiff and zlib-system-stub from r-base-dev.
</li>

<li>

Objective C compiler from xcode command line tools.
</li>

<li>

Tcl/Tk and texinfo from standard installation of R binary.
</li>

</ul>

The following optional prerequisites have been skipped as they are
unlikely to be needed by R contributors
<ul>

<li>

readline5. Apple’s editline is sufficient. Can install with
`install.libs("readline5")`.
</li>

<li>

Cairo/Pango. Can install both with `install.libs("pango")`.
</li>

<li>

Java. See [Java subsection in R-admin macOS
instructions](https://cran.r-project.org/doc/manuals/r-patched/R-admin.html#Java-_0028macOS_0029)
to add Java support. You may have installed Java to use a Java-using R
package.
</li>

</ul>

</details>

## Build R

### Checking out a source code repository

Run the following commands within Terminal.app to check out a local copy
of the R Subversion (SVN) repository into `TOP_SRCDIR`:

``` sh
export TOP_SRCDIR="$HOME/svn/R-devel"
svn checkout https://svn.r-project.org/R/trunk/ "$TOP_SRCDIR"
```

This will retrieve the source code for the development version of R
(`r-devel`).

<details>

<summary>

<i>Alternatively create an RStudio SVN project…</i>
</summary>

You may prefer to create an RStudio project from the SVN repository. Set
`https://svn.r-project.org/R/trunk/` as the Repository URL; set
`R-devel` as the project directory name and create the project as a
subdirectory of `/Users/<username>/svn` (or adapt the definition of
`TOP_SRCDIR` to match where you create the project). This will create an
SVN pane in RStudio where you can track changes.
</details>

<details>

<summary>

<i>Alternatively checkout a fork of the r-svn GitHub repo…</i>
</summary>

You may prefer to use a fork of the
<a href="https://github.com/r-devel/r-svn">r-svn GitHub repo</a>. Set
the <code>TOP_SRCDIR</code> environment variable to the directory where
you checkout your fork of the repository.
</details>

### Building R from a new checkout

To build R from a local copy of the SVN repository for the first time,
run the following commands within Terminal.app:

1.  Download the source code for the recommended packages:

    ``` sh
    $TOP_SRCDIR/tools/rsync-recommended
    ```

2.  Create the build directory, `BUILDDIR` (you may wish to customise
    this path):

    ``` sh
    export BUILDDIR="$HOME/build/R-devel"
    mkdir -p $BUILDDIR
    cd $BUILDDIR
    ```

3.  Define the `LOCAL` environment variable to match your architecture

    ``` sh
    # Intel
    export LOCAL=/opt/R/x86_64 
    ```

    ``` sh
    # Apple Silicon (e.g. M1)
    export LOCAL=/opt/R/arm64  
    ```

    Create `config.site` within the build directory to set some
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

    Add the additional configuration flags if you are on Apple Silicon:

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

    <details>

    <summary>

    <i>Extra step if you are using the r-svn GitHub mirror…</i>

    </summary>

    You will need to update the Makefile template to infer the SVN
    revision number from the git mirror. Run the following line of code
    to replace an `svn` command in the template with a shell script that
    will infer the SVN revision number: <br> <code> sed -i.bak
    "s\|\\\$(GIT) svn info\|\$TOP_SRCDIR/.github/scripts/svn-info.sh\|"
    "\$TOP_SRCDIR/Makefile.in" </code>

    **N.B. This command all needs to be on one line** (copying and pasting from how it appears here on GitHub introduces a line-break that causes issues).

    </details>

4.  Configure the R installation with `--enable-R-framework` to prepare
    for installation as an App and `--disable-java` to skip configuring
    Java, which may not be installed. Use `FW_VERSION` to set the
    version name as “R-devel”:

    ``` sh
    $TOP_SRCDIR/configure --enable-R-framework --disable-java FW_VERSION=R-devel
    ```

    <details>

    <summary>

    <i>Multiple versions of R-devel…</i>

    </summary>

    If you want to build multiple versions of R-devel, customize
    `FW_VERSION` to give a unique name to each build. Be aware that if
    you install R-devel from an Intel Mac binary, e.g., from
    <url><https://mac.r-project.org/></url> or using rig, this will use
    the default name “Major.Minor”, using the major and minor numbers
    from the R version number (e.g. 4.4 for R 4.4.0 Under development
    version).

    </details>

<!-- -->

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
incorporating the changed components by switching to the build directory
in the terminal and running make:

``` sh
export BUILDDIR="$HOME/build/R-devel"
cd $BUILDDIR
make
```

If you are building a version with your own changes, you may wish to run
`make check` to check you haven’t broken any tests.

If you followed the recommended steps to install R as an App, you can
install the re-built version as follows:

``` sh
make install
```
