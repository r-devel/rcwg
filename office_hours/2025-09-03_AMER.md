# Welcome to the R Contributor Office Hour (AMER)!
2025-09-03

## Useful links

 * R Development Guide: https://contributor.r-project.org/rdevguide/ 
 * R Dev Container: https://github.com/r-devel/r-dev-env
 * R's Bugzilla: https://bugs.r-project.org 
 * R Dev Day Issues: https://github.com/r-devel/r-dev-day/issues
 * R Project Weblate server: https://translate.rx.studio/projects/r-project 
 * R sources - SVN repo: https://svn.r-project.org/R/trunk/ 
 * GitHub mirror: https://github.com/r-devel/r-svn/ 
 * GitHub Codespace (R Dev Container) https://github.com/r-devel/r-dev-env 
 * R-devel mailing list archives: https://stat.ethz.ch/pipermail/r-devel/, searchable GitHub repo: https://github.com/MichaelChirico/r-mailing-list-archive/tree/master/r-devel 
 * Minutes from previous office hours: https://github.com/r-devel/rcontribution/tree/main/office_hours 
 * Annotated list of bugs: https://docs.google.com/spreadsheets/d/1bhfPIJQXeKpydigMH79FKIkdHO9NxlBSB_bTRoCFnPY/edit#gid=0
  
## Keeping in contact

Twitter: https://twitter.com/R_Contributors  
Mastodon: https://hachyderm.io/@R_Contributors  
Slack: https://contributor.r-project.org/slack  
BlueSky https://bsky.app/profile/r-contributors.hachyderm.io.ap.brid.gy 

## Facilitators

Heather Turner 
Gabe Becker


## Warm up 

Please tell us a bit about yourself, following the template below: 

Name: Heather Turner  
Country I am currently in: UK  
Something we could do or discuss together today: 
Will be at R Dev Day

Name:  Gabe Becker  
Country I am currently in: UK  
Facilitator, will be at Warwick Dev Day
 
Name: Andrea Gomez Vargas  
Country I am currently in: Argentina  
Something we could do or discuss together today:  issues and task for RDevDay at Warwick and preparations for the session (users, accesses)

Name:  Kevin Ushey  
Country I am currently in: USA  
Something we could do or discuss together today: Editor / IDE setup for development with R sources
I will not be at the dev day. :(

Name: Emanuel Ciardullo  
Country I am currently in: Argentina  
I will be at Warwick next week
 
Name: Eren Ozberk  
Country I am currently in: UK  
I will be at Warwick next week

Name: Mikael Jagan  
Country I am currently in: Canada  
Something we could do or discuss together today: 

Name: Kylie Bemis  
Country I am currently in: USA  
I will not be at dev day    

## Discussion

## Setting Editor /IDE for R dev

* Which IDEs do people use?
    - Mikael: Emacs + ESS
    - Gabe: Emacs + ESS
    - Heather: RStudio, Positron, VS Code
    - Andrea: Rstudio, VS Code sometimes
    - Emanuel: RStudio
    - Kevin: RStudio, Positron, VS Code, Vim
    - Eren: Rstudio, VS Code
    - Kylie: Sublime Text
* Related R Dev Day issues:
    - [Bug 18757 - Refine and test .editorconfig to set R Core style](https://github.com/r-devel/r-dev-day/issues/104)
    - [R Dev Guide: Document VS Code and Positron settings for working on R sources](https://github.com/r-devel/r-dev-day/issues/105)
    - [Document coding style used by R Core](https://github.com/r-devel/r-dev-day/issues/56)
* Current codebase is inconsistent, but fixing in bulk would make a lot of whitespace/trivial changes, making the svn/git blame less useful as a historic record.
* Would be good to at least document how to view whitespace characters, e.g. 
    * Whitespace mode in Emacs
    * In RStudio: Tools -> Global Options... -> Code -> Display -> "Show whitespace characters"

## R Dev Day @ RSECon25, University of Warwick 

## Preparation

In the run-up to the event, Heather will
* Share working group allocation spreadsheet (shared the one used for R Dev Day @ useR! 2025 as an example) so people can express interest
* Add people as collaborators to the r-dev-day repo so people can be assigned to issues.

## Reviewing bugs

* https://contributor.r-project.org/rdevguide/chapters/reviewing_bugs.html

    * We have an example in this chapter: contributions of more good examples welcome!

* Can also look at closed bugs to see how a bug was reviewed in practice.

    * Link for closed bugs: https://bugs.r-project.org/buglist.cgi?query_format=advanced&resolution=FIXED&resolution=INVALID&resolution=NOT%20REPRODUCIBLE&resolution=SPAM&resolution=WONTFIX&resolution=Works%20as%20documented&resolution=WISHLIST&resolution=DUPLICATE&resolution=WORKSFORME&resolution=CONTRIBUTED%20PACKAGE&resolution=MOVED

* A recent example looked at by Gabe and Heather: reviewing and fixing https://bugs.r-project.org/show_bug.cgi?id=18258

    1. First confirm bug is still present in R-devel

    2. Work out what the real bug is (clarify what works as expected and what doesn't)

    3. Dig into code to understand which lines cause the buggy behaviour

    4. Propose how to change code to fix buggy behaviour

Steps 1-3 are bug analysis. Any of those steps would be a useful contribution to the discussion. Step 4 is bug fixing and could be done by same person or someone else.


