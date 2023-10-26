---
editor_options: 
  markdown: 
    wrap: 72
---

## Notes on Heather's notes

<https://github.com/r-devel/rcwg/blob/main/working_documents/install_r_macos.md>

I worked through Heather's notes during the RProject Sprint, on Sept 1st
2023, with assistance from George Stagg.

### Issues

1.  In Install Prerequisites section, point 7, it appears we do still
    need to install subversion, but
    `install.libs("subversion", dep = FALSE)` didn't work for me (at
    least then running `which svn` in the terminal didn't find it). So I
    installed it via brew instead: `brew install svn` which appears to
    have worked fine.

    > HT: I also had Subversion installed from Homebrew. I tried
    > uninstalling it (`brew uninstall subversion`) and installing with
    > `install.libs` and it worked fine (running `which svn` returned
    > `/opt/R/arm64/bin/svn` as expected). So possible a local issue,
    > will add installation via Homebrew as a troubleshooting
    > workaround.

2.  In Build R section, George reckons that the build directory looks
    strange. He would have

    ```         
    export TOP_SRCDIR="$HOME/R-devel/svn"
    svn checkout https://svn.r-project.org/R/trunk/ "$TOP_SRCDIR"
    ```

    and

    ```         
    export BUILDDIR="$HOME/R-devel/build"
    mkdir -p "$BUILDDIR"
    cd "$BUILDDIR"
    ```

    This way, build directory and source are both within the `R-devel`
    folder

    `build` rather than `bin/R` since building R will create `bin/R`

    > HT: Agree the current directories are not ideal - they were to
    > match what we currently have in the dev guide for Linux:
    > <https://contributor.r-project.org/rdevguide/GetStart.html#linux>.
    > But we had a similar discussion when working on the R Dev
    > Container and came up with
    >
    > /workspaces/r-dev-env/build
    >
    > /workspaces/r-dev-env/svn\
    > \
    > with the idea that if you had multiple builds of R you could have
    > them nested under those directories. Will poll R Contributors to
    > help decide what is best.

3.  In Build R, point 3 for Apple Silicon only, in line before `EOF`,
    need to add CPPFLAGS to link to the headers for liblzma:

    ```         
    CPPFLAGS="-isystem $LOCAL/include -I/opt/R/arm64/include"
    ```

    (This will take precedence over the CPPFLAGS in previous chunk, which is
what we want)

    > HT: Fine, added.
    
4. Why RSwitch and not `rig`?

    > HT: simplest tool for this purpose - enables switching while people can 
    carry on installing R as they have done before. But not needed if people 
    are already using rig, so have added some comments about this.

5. Getting stuck with gfortran. It's installed in
`/opt/gfortran/bin/gfortran` and the configure flag is set to
`FC="/opt/gfortran/bin/gfortran -mtune=native"` but `make` seems to be
looking for `/opt/R/arm64/gfortran/bin/gfortran`

    Issues with `gfortran` Getting error when running `make` related to
gfortran and nlme:

    ```         
    /opt/R/arm64/gfortran/bin/gfortran: No such file or directory
    ```

    Not sure why `nlme` is looking for gfortran there, rather than
`/opt/gfortran/bin/gfortran`. Have tried adding this to PATH with
`export PATH="/opt/gfortran/bin:$PATH"` and then removing the `FC` flag
from `config.site` (it's not needed once gfortran is in the PATH).

    Try a symlink:

    ```         
    mkdir -p /opt/R/arm64/gfortran/bin
    ln -s /opt/gfortran/bin/gfortran /opt/R/arm64/gfortran/bin/gfortran
    ```

    This works but it's hacky. To undo this,
    `rm /opt/R/arm64/gfortran/bin/gfortran`

    An alternative for gfortran, since the problem is when `nlme` is to not
    do step 1 of Build R, i.e. do not download recommended packages, then
    will also need additional config flag (need to check this)

    ```         
    --without-recommended-packages
    ```
    
    > HT: We should try to find a non-hacky way to build with recommended 
    packages.

6.  Need to install java or turn it off!

    ```         
    "$TOP_SRCDIR/configure" --enable-R-framework --disable-java
    ```

    I've gone with turning it off, but would probably be better to install!
    
    > HT: `--disable-java` just disables the check for Java, we could add this 
    option but it's not essential (keep instructions as simple as possible).
    I'm not sure if we need Java to work with base R and recommended packages 
    only. If we do, need to add instructions based on 
    https://cran.r-project.org/doc/manuals/r-patched/R-admin.html#Java-_0028macOS_0029 
    (Java cannot be installed with `install.lib`.) But instructions easier to 
    maintain if we can manage without.

### General notes

After `make check`, if still in `build` directory, need to run `bin/R`
to start newly build

> HT: Assume that people will switch with RSwitch/rig and then use RStudio/usual 
IDE.
