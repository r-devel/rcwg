# Adapted from https://github.com/r-devel/r-project-sprint-2023/issues/74#issuecomment-1699978736
# See also https://github.com/r-devel/r-dev-day/issues/47#issuecomment-2456783667

# ggplot2 -----------------------------------------------------------------

## Use manual approach

## Rcontrol

library(gdiff)
pkg <- "ggplot2"
gdiffPackageOutput(pkg,
                   paste0("/tmp/", pkg, "Control"),
                   device=list(pngDevice()))
## Rtest
library(gdiff)
pkg <- "ggplot2"
gdiffPackageOutput(pkg,
                   paste0("/tmp/", pkg, "Test"),
                   device=list(pngDevice()))
## R release
pkg <- "ggplot2"
assign(paste0(pkg, "Result"),
       gdiffCompare(paste0("/tmp/", pkg, "Control"),
                    paste0("/tmp/", pkg, "Test"),
                    paste0("/tmp/", pkg, "Compare")))

print(ggplot2Result, detail=FALSE)

## Look at detail if any files are different
print(graphicsResult, detail = TRUE)

## Delete all test directories when you are done!
unlink(c("/tmp/ggplotControl",
         "/tmp/ggplotTest",
         "/tmp/ggplotCompare"),
       recursive = TRUE, force = TRUE)
