# Bug BBQ 2022 Retrospective

## Bugs prepared for the BBQ

Bugs from R's Bugzilla were were added as issues to the [Bug BBQ GitHub repo](https://github.com/r-devel/bug-bbq) for working on during the event. Bugs were labelled with the component from Bugzilla (e.g. "Analyses", "S4 methods") and the action required (e.g. "needs reprex", "discuss fix")

The table below summarises the 22 issues add to the BBQ repo:

| Contributor     | Number of bugs |
|-----------------|----------------|
| Gabriel Becker  | 12             |
| Sebastian Meyer | 5              |
| Martin Maechler | 3              |
| Heather Turner  | 1              |
| Davis Vaughan   | 1              |

Of these:
 - 1 added by a contributor (Davis Vaughan) who wanted to work on the bug during the BBQ.
 - 1 a combination of 3 related bugs.
 - 1 a new bug added from an old R-devel mailing list post.
 - 1 a new issue identified during BBQ.

## Participants

There were 3 sessions organized at different time zones. Unfortunately, we did not retain the registration data, so the following numbers are approximate. Participants are grouped as follows:

- R Core members (or ex members)
- Facilitators: members of the R Contribution Working Group that had volunteered to facilitate the session (overlaps with contributors!)
- Contributors: members of the R community not involved in organizing the session that came to contribute (joined the Zoom session and/or contributed via the GitHub repo)

| Session | R Core | Facilitators | Contributors |
|---------|--------|--------------|--------------|
| APAC    | 1      | 4            | 4            |
| EMEA    | 2      | 3            | 0            |
| AMER    | 5      | 2            | 5            |

There was some overlap, so overall around 5 R Core members and 15 outside contributors participated.

## Contributions and Outcomes

Below is a summary of the contributions and outcomes for the 22 bugs one month after the event:

| Addressed in BBQ? | Outcome?              | Number of issues |
|-------------------|-----------------------|------------------|
| No                | None                  | 9                |
| Yes               | Discussion unresolved | 3                |
| Yes               | Proposed fix/close    | 3                |
| Yes               | Fixed                 | 4                |
| Shortly after     | Proposed fix          | 2                |
| Shortly after     | Volunteer to fix      | 1                |

Nearly a half of bugs were not addressed at all by the Bug BBQ:
 - 4 seem accessible to newcomers: [Bug 17278](https://bugs.r-project.org/show_bug.cgi?id=17278), [Bug 17185](https://bugs.r-project.org/show_bug.cgi?id=17185), [Bug 18258](https://bugs.r-project.org/show_bug.cgi?id=18258), [Bug 15242](https://bugs.r-project.org/show_bug.cgi?id=15242),
 - 2 require deep work [Bug 17695](https://bugs.r-project.org/show_bug.cgi?id=17695), [Bug 17680](https://bugs.r-project.org/show_bug.cgi?id=17680)
 - 3 have already been considered by R Core with no clear resolution or strong support for a fix [Bug 17476](https://bugs.r-project.org/show_bug.cgi?id=17476), [Bug 17646](https://bugs.r-project.org/show_bug.cgi?id=17646), [Issue 10](https://github.com/r-devel/bug-bbq/issues/10)

Over a third of bugs were addressed during the Bug BBQ:
 - 3 were discussed with no resolution, but typically an analysis was posted on the GitHub repo: [Bug 17279](https://bugs.r-project.org/show_bug.cgi?id=17279), [Bug 15027](https://bugs.r-project.org/show_bug.cgi?id=15027), [Bug 18226](https://bugs.r-project.org/show_bug.cgi?id=18226)
 - 3 proposed to close or proposed at least a partial fix: [Bug 4073](https://bugs.r-project.org/show_bug.cgi?id=4073) (close?), [Issue 24](https://github.com/r-devel/bug-bbq/issues/24), (proposal on GitHub), [Issue 2](https://github.com/r-devel/bug-bbq/issues/2), (patches submitted on Bugzilla, one accepted)
 - 4 were fixed: [Bug 18008] (https://bugs.r-project.org/show_bug.cgi?id=18008), [Bug 17616](https://bugs.r-project.org/show_bug.cgi?id=17616), [Bug 18367](https://bugs.r-project.org/show_bug.cgi?id=18367), [Bug 18174](https://bugs.r-project.org/show_bug.cgi?id=18174)

A few were addressed shortly afterwards as a result of reviewing the status of bugs selected for the BBQ:
 - 2 with analysis and proposed fix on Bugzilla, [Bug 18281](https://bugs.r-project.org/show_bug.cgi?id=18281), [Bug 16629](https://bugs.r-project.org/show_bug.cgi?id=16629)
 - 1 with a volunteer but no apparent progress [Bug 18362](https://bugs.r-project.org/show_bug.cgi?id=18362)
The first two of these were identified as ones for more experienced volunteers, where help was welcome.

## What went well

- The event attracted a range of participants: new contributors, experienced contributors, R Core members
- There was a lot of collaboration across different levels of experience on all types on contribution: bug confirmation, analysis and fixing/closing.
- The selected bugs gave enough material to work on
- Progress was made on around a third of the bugs, with about half of these fixed during or shortly after the BBQ and the other half waiting to be reviewed/committed by R Core.

## What could be improved

- The AMER session might have been overwhelming - it seems one or two people dropped out without engaging.
- There were no participants from among the Collaborative Campfire attendees - we could do more targeted promotion.
- Reviewing the bugs status earlier could help a few more bugs to progress.

## General observations

- The EMEA session had no participants beyond R Core/facilitators. However, this did give space to review the work from the APAC session and lay some groundwork for the AMER session.
- The BBQ acted as a prompt for both R Core and experienced contributors to address bugs.
- Novice contributors generally participated in bug analysis that was unresolved or discussion of a bug that a more experienced contributor was working on: more of a learning experience.





