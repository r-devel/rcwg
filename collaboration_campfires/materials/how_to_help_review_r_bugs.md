Session 02: How to Help Review R Bug Reports

 ***** We are @R_Contributors on Twitter ****
 
Date: 22 March 2022  
Time: 15:30 - 17:00 UTC (see in your time zone: https://arewemeetingyet.com/UTC/2022-03-22/15:30/Session%2002:%20Collaboration%20Campfires#eyJ1cmwiOiJodHRwczovL3VzMDJ3ZWIuem9vbS51cy9tZWV0aW5nL3JlZ2lzdGVyL3RaMHFmLXVxcWpvdkU5UnFENmh2akFJaWdTOW5RYjY5V0dSZiJ9)  
Duration: 90 minutes  
Hosts: Heather Turner, Saranjeet Kaur Bhogal  
Webpage: https://contributor.r-project.org/events/collaboration-campfires   
Zoom: https://us02web.zoom.us/meeting/register/tZ0qf-uqqjovE9RqD6hvjAIigS9nQb69WGRf  

--------------------------------------------------------------------------------------------------------------------------------------

## Warm-up  
10 mins  
[Saranjeet]  
[Hosts to turn on captioning]  
Join the campfire session  
* If you drop out or need to leave and come back, the Zoom link is at the top of this pad.  
* Please note that this session will NOT be recorded.
* Turn on your webcam if you don’t mind sharing your face (or off if you do!).
* Later in the session we will be using breakout rooms. Please edit/rename your Zoom name and add one of the following letters in front of your name.
    * W for written reflection-based exercise in the main room.
    * S for Spoken Discussion Breakout Room. This will help us assign you to the breakout room with the format of your choice.
* If you are ok with both, please choose one for this session so that the hosts can assign you to a breakout room for this session.
* If you would like to, you can add your pronouns to your names
* Guidelines for community participation & Code of Conduct: (https://eventfund.codeforscience.org/code-of-conduct/).
* If you have any questions then you could use the 'Raise Hand' feature on Zoom or type your question in the Zoom chat.

During this session, we will:
* Share some background information on the campfires and today's topic
* Conduct collaborative activity
* Feedback
Thank you note

--------------------------------------------------------------------------------------------------------------------------------------

## General Links:
1. Digital Infrastructure Incubator: https://incubator.codeforscience.org/cohort
2. R Development Guide: https://contributor.r-project.org/rdevguide/
3. R-devel Slack: https://contributor.r-project.org/slack 
4. R Contribution Working Group: https://contributor.r-project.org/working-group 

--------------------------------------------------------------------------------------------------------------------------------------

## Links relevant to this session:
1. R Developer Blog: https://developer.r-project.org/Blog/public/2019/10/09/r-can-use-your-help-reviewing-bug-reports/
2. Bugzilla: https://bugs.r-project.org/ (We will repeatedly refer to Bugzilla in our today's activities)

--------------------------------------------------------------------------------------------------------------------------------------

[Saranjeet]  
Roll Call & Opt in for Certificate of Attendance  
Time: 5 minutes  
Use this spreadsheet to find your name and fill in the corresponding columns: <link removed>
(If you do not find your name in the spreadsheet, please add it).

Note: If you are unable to open/edit/access the spreadsheet then you can share your responses to the following questions, here in the etherpad or via the Zoom chat. We will add it to the spreadsheet for you. The questions are:

	1. If you use Twitter, what is your Twitter handle?
	2. If you use GitHub, what is your GitHub username?
	3. What is your Affiliation?
	4. Are you part of any R community? If so, which one(s)?
	5. Share something that made you feel happy recently.
	6. Would you like to have a certificate of attendance?

--------------------------------------------------------------------------------------------------------------------------------------

[Heather]  
Introductory Remarks  
Time: 10 minutes  

Intro to the Campfires
* Introduction to the Incubator and the R Contribution Working Group
* Notes from Session 1: https://developer.r-project.org/etherpad/p/collaboration_campfire_february 
* Remaining sessions; aims
R Development Guide: https://contributor.r-project.org/rdevguide/

Poll 1: Did you come to the first session of the Collaboration Campfires (in February)? (Yes/No)

Discuss take-home activities from session 1 - if anyone posted a plot/table

Poll 2: Did you sign up for Bugzilla? (Yes/No)
    
Poll 3: Have you read any more of the R Development Guide?
* Yes, I read Chapter 3 on "Bug Tracking".
* Yes, I read Chapter 4 on "Reviewing Bugs".
* Yes, I read both Chapter 3 and Chapter 4.
* Yes, I read other parts of the guide, except Chapter 3 and Chapter 4.
* No, I did not get a chance to read the guide yet.



--------------------------------------------------------------------------------------------------------------------------------------

## Activites in Breakout Rooms:

Breakout rooms description by Saranjeet (Spoken/ Written)  
Timer for breakout rooms: https://cuckoo.team/collaboration-campfire-activities  

--------------------------------------------------------------------------------------------------------------------------------------
## Activity 1: Browsing bugs on Bugzilla  
Time: 15 minutes

If we want to contribute by reviewing or fixing a bug, we need to find bugs that need attention and that we may be able to help with.

1. Select Browse from the menu and look at the topics in "R" product category. Select a topic your group is interested in/feels comfortable with.
2. Scroll to the bottom and use "Change Columns" to remove "Product" and "Resolution",  and add "Opened" and "Number of comments".
3. Order the bug reports by date, with the most recent at the top.
4. Pick a bug with 3-4 comments (one that has received some response). Discuss in your group - can you categorise it as one of the following:
* Bug Reporter misunderstands the function/documentation.
* Bug can not be reproduced.
* Cause of bug is still being worked out.
* Fix to bug is still being worked out/under debate.
* A solution has been proposed by Bug Reporter or a Bug Reviewer and is waiting approval from R Core.
* An R Core member has committed to implement the fix, but not yet done this.
* Something else - please specify! 
    * Feature request!
    If you are in a written room, share the bug number and your category. Look at ones shared by others - do you agree with the category chosen?
5. Pick a bug with 1-2 comments (one that has had little response). Discuss in your group - can you categorise it as one following, according to what action needs to be taken next?
* Bug is actually a wish list item (suggested new feature) and should be recategorised/discussed.
* Bug needs a (simpler) reproducible example.
* Cause of the bug is not clear from the report and needs investigation.
* There is a proposed fix from the Bug Reporter that needs to be checked and reviewed.
* Needs input on the best way to fix it from Bug Reviewer or R Core member.
* How to fix it is clear, but there is not yet a patch or commitment to fix.
* Bug report has received a negative response (not a bug/not a welcome change) and should be closed.
* Something else - please specify!
    If you are in a written room, share the bug number and your category. Look at ones shared by others - do you agree with the category chosen?

Feedback from the Activity 1 as participants return to the main room  
Time: 10 minutes

For more on bug review, see https://contributor.r-project.org/rdevguide/reviewing-bugs.html  
For more on bug fixing, see https://contributor.r-project.org/rdevguide/FixBug.html   
In future, when reviewing bugs use #work-out-loud channel on the R-devel slack  
Link to Contributing to R tutorial (https://youtu.be/CZmldTOdlRM?list=PL4IzsxWztPdnCC_kMCYKrd_t6cViMhBrD, https://github.com/gmbecker/contributing_to_r_lesson)  
If you find anything to follow up on (e.g. a possible comment to add to bug report), post on #getting-started channel to discuss how to move forward.  

TIP: You can find bugs where R Core has asked for a code/documentation patch by using the Advanced Search to find bugs with the keyword HELPWANTED. 
Here's a shortcut: https://bugs.r-project.org/buglist.cgi?bug_status=__open__&keywords=HELPWANTED&columnlist=bug_id%2Ccomponent%2Cbug_status%2Cshort_desc%2Cchangeddate%2Clongdescs.count

--------------------------------------------------------------------------------------------------------------------------------------
[Heather]  
Time: 30 minutes

Introduction of the Guests  
Discussion with Guests & Experts: Examples of good and bad bug reports (bit of discussion from participants with experience)

Activity 2: Review a bug report [Activity will be done in the main room, with experts demonstrating]
1. Does the bug report have a reprex? 
2. Does the bug report have session info? 
3. Does the bug report mention the OS/machine architecture? 
4. Is the bug/issue clearly reported?
5. Confirm the bug on your machine.
6. Diagnose the cause of the bug if possible (or discuss!)

Task shared by Elin Waring:
Confirm on Windows whether the following issue/bug was present in older versions with method = “libcurl”.
 issue/bug: https://bugs.r-project.org/show_bug.cgi?id=18315

--------------------------------------------------------------------------------------------------------------------------------------

[Heather]  
Feedback:  
Time: 5 mins  
You can share your feedback either publicly on this etherpad by answering the questions that follow or you can share it on this google form: https://forms.gle/NpKaY9K2qL8nb9dV8

What worked?


 
What didn’t work?
 


What would you change?
 
 
What surprised you?
 
 


--------------------------------------------------------------------------------------------------------------------------------------

[Saranjeet]  
Time: 5 mins  
Thank you!   
Invite your friends and colleagues:  
* https://r-podcast.org/034-collaborative-campfires/
* https://twitter.com/R_Contributors
* https://www.linkedin.com/company/64851099/admin/
Register for other sessions -- next one will be about exploring R’s Process for Localization (Translation) : https://contributor.r-project.org/events/collaboration-campfires  
Join the R-devel Slack: https://contributor.r-project.org/slack  ... introduce yourself in the #0_welcome channel

--------------------------------------------------------------------------------------------------------------------------------------

[Saranjeet]  
Take home activity: Repeat Activity 2 on a different bug listed on Bugzilla!
--------------------------------------------------------------------------------------------------------------------------------------

[Saranjeet]  
Q&A for after the call:  
Have any questions? Add them below. We will respond to these here, on the R-Devel Slack channel or cover them in a future Collaboration Campfire session.

--------------------------------------------------------------------------------------------------------------------------------------

Organizers and partners:  
The Collaboration Campfires are part of the project "Building Community around the R Development Guide", supported by the Digital Infrastructure Incubator at Code for Science & Society (CS&S). The project is led by Saranjeet Kaur Bhogal and Heather Turner, and mentored by Rayya El Zein.

--------------------------------------------------------------------------------------------------------------------------------------
