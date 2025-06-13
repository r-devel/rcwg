# Adapted from https://github.com/r-devel/r-project-sprint-2023/issues/74#issuecomment-1699978736
# See also https://github.com/r-devel/r-dev-day/issues/47#issuecomment-2456783667

# set control and test versions -------------------------------------------

Rcontrol <- normalizePath("~/build/R-devel-control/bin/")
Rtest <- normalizePath("~/build/R-devel-7084/bin/")

# grid, graphics and grDevices --------------------------------------------

library(gdiff)

check_package <- function(pkg) {
  gdiffPackage(
    pkg,
    controlDir = file.path(tempdir(), paste0(pkg, "Control")),
    testDir = file.path(tempdir(), paste0(pkg, "Test")),
    compareDir = file.path(tempdir(), paste0(pkg, "Compare")),
    device = pngDevice(),
    session = list(
      control = localSession(Rpath = paste0(Rcontrol, "Rscript")),
      test = localSession(Rpath = paste0(Rtest, "Rscript"))
    )
  )
}

## Compare control with test output (runs in separate worker sessions)
gridResult <- check_package("grid")
graphicsResult <- check_package("graphics")
grDevicesResult <- check_package("grDevices")

print(gridResult, detail = FALSE)
print(graphicsResult, detail = FALSE)
print(grDevicesResult, detail = FALSE)

## Look at detail if any files are different
print(graphicsResult, detail = TRUE)

# lattice -----------------------------------------------------------------

## latticeResult <- check_package("lattice") 
## get unserialize error when running functions in R-devel-control
## Error in unserialize(node$con) : error reading from connection
## Called from: unserialize(node$con)

## More manual (run directly in relevant R sessions)
## Rcontrol
library(gdiff)
pkg <- "lattice"
gdiffPackageOutput(pkg,
                   paste0("/tmp/", pkg, "Control"),
                   device=list(pngDevice()))
## Rtest
library(gdiff)
pkg <- "lattice"
gdiffPackageOutput(pkg,
                   paste0("/tmp/", pkg, "Test"),
                   device=list(pngDevice()))
## R release
pkg <- "lattice"
assign(paste0(pkg, "Result"),
       gdiffCompare(paste0("/tmp/", pkg, "Control"),
                    paste0("/tmp/", pkg, "Test"),
                    paste0("/tmp/", pkg, "Compare")))

print(latticeResult, detail=FALSE)

## Look at detail if any files are different
print(graphicsResult, detail = TRUE)

## Remove temporary directories if everything is fine
unlink(paste0("/tmp/", pkg, 
              c("Control", "Test", "Compare")), 
       recursive = TRUE, force = TRUE)