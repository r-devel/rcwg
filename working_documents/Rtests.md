Tests in R
================
2024-01-16

If you are set up to [build R from source](link), you can run R’s tests
with the shell command `make check`. If everything is OK, the tests will
run with various informational messages e.g. 

``` sh
Testing examples for package ‘tools’
  comparing ‘tools-Ex.Rout’ to ‘tools-Ex.Rout.save’ ... OK
```

and eventually return to the command prompt. Any error should be clearly
apparent from the returned error messages, e.g. the following messages
indicate an issue with the example code in the **stats** package.

``` sh
Testing examples for package ‘stats’
Error: testing 'stats' failed
Execution halted
make[3]: *** [test-Examples-Base] Error 1
make[2]: *** [test-Examples] Error 2
make[1]: *** [test-all-basics] Error 1
make: *** [check] Error 2
```

You can find more about the erro by looking in the `$BUILDDIR/tests`
directory, where `$BUILDDIR` is the build directory you defined before
building R.

## R’s Test Suite

When you run `make check`, various types of test are run:

- Testing example code in all the packages
- Tests stored in `$TOP_SRCDIR/tests`
  - General tests, of e.g., arithmetic functions, data structures, etc.
    The corresponding files have names indicating the focus of the
    tests, e.g., `datetime.R`, `lm-tests.R`.
  - Regression tests, added after a bug has been fixed. The
    corresponding file names are ordered, from oldest to newest:
    `reg-tests-1a.R`, `reg-tests-1b.R`, …, `reg-tests-3.R`.

Typically tests are maintained by R Core and contributors will not need
to add tests unless requested when working on a patch. A contributor may
be asked to add a “reprex” (minimal reproducible example) to the latest
regression test file that will test the behaviour corrected in the bug
fix, to ensure it is not broken in later updates to R.

## Types of test

There are two types of test: code that directly throws an error if
something is wrong and code that produces output that can be compared to
reference output to check for changes.

Tests files may include both types of test. When the test file is run,
an `.Rout` file is created in `$BUILDDIR/tests/` and similarly when the
example code for a package is run, an `.Rout` file is created in
`$BUILDDIR/tests/Examples`. The `.Rout` file is simply a copy of the
input and output created when the test code is run in a fresh R session.
This file is compare to the corresponding `.Routsave` file in
`$TOP_SRCDIR/tests/` and an error is thrown if there is a change.

If the change is expected, e.g. because the example in a help file has
been updated, the `.Routsave` file may be replaced with the `.Rout`
file.

### Direct testsThese immediately
