# Setting up a Matrix Space for R Contributors

Following up from initial work at the R Dev Day @ RSECon24: https://github.com/r-devel/r-dev-day/issues/53

## Discussion 2024-12-09

Present: Greg Sutcliffe, Ella Kaye, Mikael Jagan, Heather Turner

### Spaces and Rooms

* Rooms and spaces are technically the same, but a space is used to provide a directory of rooms
* Can nest spaces inside each other, so potentially could have "R Contributors", "useR! Conference" nested inside "R Community"
* Rooms can be private (invite only), public, or for space members only
  * The latter is closest to a slack workspace
  * Only public rooms can be bridged using the Element bridging bot (briding private rooms would require hosting on own server or renting one, e.g. from Element)
* Public rooms have an address like: https://app.element.io/#/room/#python:matrix.org. So we might want to use `r-` or `r-contributors` as a common prefix (like https://app.element.io/#/room/#python-meta:matrix.org)

### Code of Conduct

* For a private space, could invite people in a similar way to as we do for Slack
    * Have public room woth CoC pinned
    * People add message to say they agree
    * Moderator invites them to Space
    * Could use a support bot to help automate, or at least notify moderators
* For a public space, can pin CoC and/or add to description of each room.
    * Moderators can still ban people from public rooms
* Use "Mjolnir" bot to help enforce moderation decisions
    * May be able to use for free as an open source project
* If bridging, need to ensurce any bans are also enforced in Slack

### Bots

* Several bots to provide useful functionality
* Unlike Slack, generally need your own infrastructure to run bots, e.g. lightweight VM
* There are some hosted ones

### Admins

* Admins ~= Owner of Slack workspace; Moderator ~= Slack admin.
* Can use custom "power level" for finer control
* Being an admin of a space overall does not make you admin of each room! Need to set permissions per room.

### Tentative conclusions/TODO

* Stick with public rooms for greater discoverability/transparency
* Make links to CoC and posting guide clearly visible in all spaces/rooms, to help enforce
* Get Mjolnir for free if we can
* Continue setting up rooms to match Slack channels


