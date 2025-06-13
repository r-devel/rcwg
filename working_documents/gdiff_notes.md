# Graphical testing with the {gdiff} package

Notes on comparing graphical output from an unpatched and a patched version of 
R-devel, using the {gdiff} package. This is to check for differences caused by 
a proposed patch to graphics related code in base R.

## Testing examples in base /recommended packages

### Setup 

1. Build an unpatched version of R-devel from a fresh svn checkout in a clean 
build directory, `R-devel-control` (if updating a previous build, use 
`make distclean` before building).
2. Build a patched version of R-devel from a fresh svn checkout with the 
proposed patch applied via `svn patch path/to/patch.diff`, in a clean 
build directory, `R-devel-test` (or re-build your patched version after 
`svn update`).
3. Still in the terminal, start R-devel-control (via `$BUILDDIR/bin/R`) and 
install {gdiff}[^binaries] [^pkg-config].
4. Open the release version of R in your preferred IDE, run `update.packages()` 
and install {gdiff}.

[^binaries]: By default, the package will be installed from source. 
Binaries are not available for R-devel for macOS or Windows. 
For Linux, see https://docs.r-universe.dev/install/binaries.html#how-to-install-linux-binary-packages.

[^pkg-config]: When installing from source, installing from the terminal can 
avoid issues with finding external C libraries used by the {magick} and 
{poppler} packages (which {gdiff} depends on).

    If you get messages relating to `pkg-config` when installing {gdiff}, 
    try adding `pkg-config` to the path, e.g. on macOS
    ```sh
    echo 'export PATH="/opt/homebrew/opt/pkg-config/bin:$PATH"' >> ~/.zshrc
    ```
    and restarting the terminal.

### Tests

In the release version of R, run the code in `gdiff_base_tests.R`[^permissions]

[^permissions]: Running this code from R-devel-control running in the terminal 
rather than R-release running in RStudio resulted in permissions issues from 
`set_magick_tempdir(tempdir())`.

## Testing examples in ggplot2

### Setup

To do a full test of the examples in ggplot2, the dependencies from "Suggests" 
as well as the dependencies from "Depends" and "Imports" should be installed.

1. Install system requirements for {sf} and install {sf} as documented on 
https://r-spatial.github.io/sf/#installing.[^gdal].
2. Install {ggplot2} and its remaining dependencies (including "Suggests") 
via[^systemfonts] [^ragg]
    ```r
    install.packages("ggplot2", dependencies = TRUE)
    ```

### Tests

In the release version of R, run the code in `gdiff_ggplot2_tests.R`.

### `R CMD check`

We can also run `R CMD check` on {ggplot2} using the patched version of R-devel, 
to run {ggplot2}'s tests and vignettes, as well as the examples.

1. Copy the URL to the latest tarball of the {ggplot2} sources, and download 
   using `curl` in a terminal, e.g.
   ```sh
    curl -O https://cran.r-project.org/src/contrib/ggplot2_3.5.2.tar.gz
    ```
2. Still in the terminal, run R command check with the patched version of 
R[^suggests]
   ```sh
   $BUILDDIR/bin/R CMD check --as-cran ggplot2_3.5.2.tar.gz
   ```

[^suggests]: If you were unable to install all of ggplot2's suggested packages 
from source, run `export _R_CHECK_FORCE_SUGGESTS_=FALSE` before running
`R CMD check`
[^gdal]: Installing gdal on macOS takes some time!
[^systemfonts]: {systemfonts} and {textshaping} can fail to build from source
on macOS with `symbol not found` errors, see e.g 
[systemfonts issues #108](https://github.com/r-lib/systemfonts/issues/108). 
This can be solved by creating a local `Makevars` file, e.g. in 
`$BUILDDIR/R-devel-control/Makevars` with these lines
```sh
PKG_CPPFLAGS += -I/opt/homebrew/include -I/opt/homebrew/opt/freetype/include/freetype2 -I/opt/homebrew/include/harfbuzz -I/opt/homebrew/include/fribidi
PKG_LIBS += -L/opt/homebrew/lib -lharfbuzz -lfreetype -lfontconfig -lpng16 -lfribidi
```
and then in R
```r
Sys.setenv(R_MAKEVARS_USER="~/build/R-devel-control/Makevars")
install.packages(c("systemfonts", "textshaping"))
```
[^ragg]: {ragg} can fail to build from source on macOS with `symbol not found` 
errors. Using a similar trick to [^systemfonts]:
```sh
PKG_CPPFLAGS += -I/opt/homebrew/include -I/opt/homebrew/include/libwebp
PKG_LIBS += -L/opt/homebrew/lib -lwebp
```
only partially solved the issue. Reinstalling webp with Homebrew did not help.
Installing the libraries from https://mac.R-project.org:
```r
source("https://mac.R-project.org/bin/install.R") # has udunits, gdal, webp, etc
install.libs("libwebp")
```
and using the following Makevars
```sh
PKG_CPPFLAGS += -I/opt/R/arm64/include
PKG_LIBS += -L/opt/R/arm64/lib -lwebp
```
did not work any better than using the Homebrew libraries. The error was 
`symbol not found in flat namespace '_SharpYuvConvert'` which is related to the 
WebP library. 

## References

* Test code adapted from https://github.com/r-devel/r-project-sprint-2023/issues/74#issuecomment-1699978736
* Setup adapted from https://github.com/r-devel/r-dev-day/issues/47#issuecomment-2456783667


