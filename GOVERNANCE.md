Note: this document was written by Toby Dylan Hocking (not a part of R
Core, nor R Foundation), with advice from Heather Turner and Dirk
Eddelbuettel (members of R Foundation). Toby led the community
development project for `data.table`, which resulted in a
[GOVERNANCE.md](https://github.com/Rdatatable/data.table/blob/master/GOVERNANCE.md)
document that codifies the normal operation of that community.
Writing a formal governance document was an essential step toward
building a self-sustaining community of people that maintain the
software, and accept outside contributions. This is an analogous
document for base R development, of which Toby is not an expert, so it
is most likely incomplete/incorrect (corrections/suggestions are
welcome; please comment on the PR). Hopefully this document can serve
as inspiration, or a starting point, if R core ever wanted to adopt a
formal governance document.

Governance for R Core Development

# Purpose and scope

## This document

The purpose of this document is to define how people related to the
project work together, so that the project can expand to handle a
larger and more diverse group of contributors.

## The R Core Development

The objective of the R Core Development is to "Advance the R project
for statistical computing to provide a free and open source software
environment for data analysis and graphics." -- this is item (a) from
[R Foundation Statutes](https://www.r-project.org/foundation/Rfoundation-statutes.pdf).

The maintenance of the system is guided by the following principles:

* Consistency with the classic textbooks
* Stable code base, strong preference to make changes that are backwards-compatible
* Comprehensive and accessible documentation and run-time signals (errors, warnings)
* Time & memory efficiency

To prioritize developer time, we define what is in and out of current
scope of functionality maintained by The R Core Development
Team. Feature requests that are out of current scope should be closed
immediately, because they are not the current priority. If someone
wants to contribute code that is currently out of scope, it is
suggested to write a package.

The current scope of functionality maintained by The R Core Development includes:
* basic data reading, manipulation and analysis 
* parallel programming
* repository management and package installation
* statistical functions discussed in the classic books
* graphics

Functionality that is out of current scope:
* Manipulating out-of-memory data, e.g. data stored on disk or remote SQL DB, (as opposed e.g. to sqldf / dbplyr)
* Reading/writing of data from/to binary files like parquet

# Roles 

The R Core Development includes three somewhat overlapping but distinct teams:

* CRAN
* base R code + essential packages
* R Foundation

## Contributor

* Definition: a user who has written emails on R-devel, posted issues to bugzilla, submitted a patch, etc. 
* How this role is recognized: there is no central list of Contributors / no formal recognition for Contributors.

## R Core member

TODO

## R Foundation member

TODO

## CRAN maintainer

TODO

# Decision-making processes

TODO

## Changing this GOVERNANCE.md document

TODO

# Finances and Funding

The R Foundation has donation instructions on the [One-off Donation Form](https://www.r-project.org/foundation/donations.html) page.

Funds acquired by the R Foundation will be disbursed at the discretion of the **R Core Team**, defined as above.  TODO consensus.

# Code of conduct

TODO this section was only included to satisfy NumFOCUS requirements, should we delete?

The full Code of Conduct can be found [here](CONDUCT.md), including details for reporting violations.

# Version numbering

R version typically has the following meanings.

* x.y.z where x=major, y=minor, z=patch.
* TODO add more details or delete?

# Governance history

May 2025: First version drafted by Toby Dylan Hocking.
