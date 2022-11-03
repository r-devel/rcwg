# Session 01: Welcome to Collaboration Campfires!

***** We are @R_Contributors on Twitter ****

## CollabCampfires

Date: 22 February 2022  
Time: 15:30 - 17:00 UTC (see in your time zone:  https://arewemeetingyet.com/UTC/2022-02-22/15:30/Session%2001:%20Collaboration%20Campfires#eyJ1cmwiOiJodHRwczovL3VzMDJ3ZWIuem9vbS51cy9tZWV0aW5nL3JlZ2lzdGVyL3RaMHFmLXVxcWpvdkU5UnFENmh2akFJaWdTOW5RYjY5V0dSZiJ9).  
Duration: 90 minutes.  
Hosts: Heather Turner, Saranjeet Kaur Bhogal.  
Webpage: https://contributor.r-project.org/events/collaboration-campfires    
Zoom: https://us02web.zoom.us/meeting/register/tZ0qf-uqqjovE9RqD6hvjAIigS9nQb69WGRf. 

--------------------------------------------------------------------------------------------------------------------------------------

## Warm-up
10 mins
[Saranjeet]
Join the campfire session
* If you drop out or need to leave and come back, the Zoom link is at the top of this pad.
* Please note that this session will NOT be recorded.
* Turn on your webcam if you don’t mind sharing your face (or off if you do!).
* Later in the session we will be using breakout rooms. Please edit/rename your Zoom name and add one of the following letters in front of your name.
    * W for written reflection-based exercise in the main room.
    * S for Spoken Discussion Breakout Room. This will help us assign you to the breakout room with the format of your choice.
    If you are ok with both, please choose one for this session so that the hosts can assign you to a breakout room for this session.
* If you would like to, you can add your pronouns to your names
* Guidelines for community participation & Code of Conduct: (https://eventfund.codeforscience.org/code-of-conduct/).
* If you have any questions then you could use the 'Raise Hand' feature on Zoom or type your question in the Zoom chat.

During our first session, we will:
* Share some background information on the campfires and today's topic
* Conduct collaborative activities 1 -- 3
* Feedback
* Thank you note

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

## Roll Call:
Time: 5 minutes  
Use this spreadsheet to find your name and fill in the corresponding columns: <link removed>  
(If you do not find your name in the spreadsheet, please add it)   

Note: If you are unable to open/edit/access the spreadsheet then you can share your responses to the following questions, here in the etherpad or via the Zoom chat. We will add it to the spreadsheet for you. The questions are:

    1. If you use Twitter, what is your Twitter handle?
    2. If you use GitHub, what is your GitHub username?
    3. What is your Affiliation?
    4. Are you part of any R community? If so, which one(s)?
    5. Share something that made you feel happy recently.
    6. Would you like to have a certificate of attendance?

<responses removed>

--------------------------------------------------------------------------------------------------------------------------------------

[Heather]    
## Introductory Remarks  
Time: 15 minutes  

Intro to the Campfires
* 4 sessions; aims
* Introduction to the Incubator and the R Contribution Working Group
* R Development Guide: https://contributor.r-project.org/rdevguide/

Poll 1: Have you heard of the R Development Guide before? 

Intro to the R development process
* Where is R developed? https://svn.r-project.org/R
* Intro to Bugzilla (https://bugs.r-project.org/) and bug tracking process

Polls 2: Do you have Bugzilla account? 

--------------------------------------------------------------------------------------------------------------------------------------

## Activites in Breakout Rooms:

Breakout rooms description by Saranjeet (Spoken/ Written)  
Timer for breakout rooms: https://cuckoo.team/collaboration-campfire-activities

--------------------------------------------------------------------------------------------------------------------------------------

## Activity 1: Exploring R's Bugzilla (https://bugs.r-project.org/)
Time: 15 minutes

Bugzilla has some simple functionality to create tabular/graphical reports. Let's use these to explore R's bug database.

1. Go to reports and select Graphical Reports (or if you prefer, Tabular Reports - just ignore chart-specific instructions).
2. On the horizontal axis, select "Resolution". Go to the Resolution selection box, scroll to the end, press the Shift key as you click "MOVED", so that all resolutions are selected. Click the "Generate Report" button to create a bar chart. Review the different resolutions. How many bugs are open (have resolution "---")?
3. Start a new report. On the horizontal axis, select "Component", check the box to specify vertical labels, select only Resolution "---" and generate a bar chart. Discuss the result in your group - Which are the components with most/least open bugs? What do all the components mean? Which topics are the people in your group most interested in?
4. Start a new report. On the horizontal axis, select "Version", check the box to specify vertical labels, select only Resolution "---" and generate a bar chart. What is the oldest version of R in an open bug report? What year was this from?
5. Start a new report. On the vertical axis select "Status", on the horizontal axis select "Number of comments" and generate a Line Graph. Discuss in your group - what can you infer from this summary?

BONUS Q: Start a new report. On the horizontal axis, select "Assignee Real Name" and generate a bar chart. Who is the odd one out?! Clue: https://www.r-project.org/contributors.html.

Feedback from Activity 1 as participants return to the main room  
Time: 5 minutes  

--------------------------------------------------------------------------------------------------------------------------------------

## Activity 2: Searching bugs on Bugzilla (https://bugs.r-project.org/)
Time: 10 minutes

Before reporting a bug, we should first check if it has already been reported. Suppose you want to report a bug related to using `rbind()` with data.frames.

1. Search "rbind data.frame" using the search box in the navigation bar of Bugzilla. How many bugs are returned?
2. Search "rbind data.frame" using the Simple Search function. How many bugs are returned? Can you work out why it is different from part 1?
3. Search "rbind data.frame" using the Advanced Search function. How many bugs are returned? Can you work out why it is different from part 2?

BONUS Q: can you get Advanced Search to return the same results as part 1?  

Feedback from Activity 2 as participants return to the main room    
Time: 5 minutes  

For more on bug-reporting, see https://contributor.r-project.org/rdevguide/bug-tracking.html.  
TIP: You can also search the R-Devel mailing lists by Googling "{search terms} site:/stat.ethz.ch/pipermail/r-devel/".  

--------------------------------------------------------------------------------------------------------------------------------------

Activity 3: Browsing bugs on Bugzilla (https://bugs.r-project.org/)  
Time: 10 minutes   

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
5. Pick a bug with 1-2 comments (one that has had little response). Discuss in your group - can you categorise it as one following, according to what action needs to be taken next?
    * Bug is actually a wish list item (suggested new feature) and should be recategorised/discussed.
    * Bug needs a (simpler) reproducible example.
    * Cause of bug not clear from report and needs investigation.
    * There is a proposed fix from the Bug Reporter that needs to be checked and reviewed.
    * Needs input on best way to fix from Bug Reviewer or R Core member.
    * How to fix is clear, but there is not yet a patch or commitment to fix.
    * Bug report has received a negative response (not a bug/not a welcome change) and should be closed.
    * Something else - please specify!

Feedback from Activity 3 as participants return to the main room 
Time: 5 minutes 

For more on bug review, see https://contributor.r-project.org/rdevguide/reviewing-bugs.html 
For more on bug fixing, see https://contributor.r-project.org/rdevguide/FixBug.html 

TIP: You can find bugs where R Core have asked for a code/documentation patch by using the Advanced Search to find bugs with the key word HELPWANTED. Here's a shortcut: https://bugs.r-project.org/buglist.cgi?bug_status=__open__&keywords=HELPWANTED&columnlist=bug_id%2Ccomponent%2Cbug_status%2Cshort_desc%2Cchangeddate%2Clongdescs.count

--------------------------------------------------------------------------------------------------------------------------------------

[Heather]   
Feedback:   
You can share your feedback either publicly on this etherpad by answering the questions that follow or you can share it on this google form: https://forms.gle/NpKaY9K2qL8nb9dV8

What worked?

 
What didn’t work?
 

What would you change?
 
 
What surprised you?
 
 

--------------------------------------------------------------------------------------------------------------------------------------

[Saranjeet]  
Thank you!   
Invite your friends and colleagues:
* https://r-podcast.org/034-collaborative-campfires/
* https://twitter.com/R_Contributors
* https://www.linkedin.com/company/64851099/admin/
Register for other sessions -- next one will be about reviewing bugs: https://contributor.r-project.org/events/collaboration-campfires  
Join the R-devel Slack: https://contributor.r-project.org/slack  ... introduce yourself in the welcome channel

--------------------------------------------------------------------------------------------------------------------------------------

[Saranjeet]  
*Take home activity:* Get a bugzilla account (https://contributor.r-project.org/rdevguide/bug-tracking.html#RCorePkgBug). Use the reason that applies:  
* "I want to be able to report bugs in R"
* "I would like to contribute to reviewing bugs in R"
* "I would like to contribute to reviewing and fixing bugs in R"

Bonus take home activity:   
Would you like to create a tabular/graphical summary as in Activity 1 using your favourite packages in R?   
You can download the data from the Bugzilla report as a CSV to do this. 
You can post your results on Twitter/LinkedIn with the #CollabCampfires hashtag - feel fee to tag @R_Contributors/
The R Foundation for Statistical Computing so we can like it! 
Don't forget to add alt text (https://medium.com/nightingale/writing-alt-text-for-data-visualization-2a218ef43f81, 
  https://help.twitter.com/en/using-twitter/picture-descriptions, 
  https://www.linkedin.com/help/linkedin/answer/a519856/adding-alternative-text-to-images-for-accessibility?lang=en)

--------------------------------------------------------------------------------------------------------------------------------------

[Saranjeet]   
Q&A for after the call:   
Have any questions? Add them below. We will respond to these here, on the R-Devel Slack channel or cover them in a future Collaboration Campfire session.   
Q: Why are there certificates for attendance? A: This is for people that attended on work time or for other reasons want a record of time spent on continuous professional development. We'll aim to email these out to people by the end of the week!

--------------------------------------------------------------------------------------------------------------------------------------

Organizers and partners:  
The Collaboration Campfires are part of the project "Building Community around the R Development Guide", supported by the Digital Infrastructure Incubator at Code for Science & Society (CS&S). The project is led by Saranjeet Kaur Bhogal and Heather Turner, and mentored by Rayya El Zein.

--------------------------------------------------------------------------------------------------------------------------------------

