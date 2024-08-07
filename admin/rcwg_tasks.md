# Review admin tasks

## Setting up R Contribution Working Group Meeting (scripts/rcwg.R)

Tues 18:30 UTC: Jun 18, Aug 20, Oct 15, Dec 17
Fri 14:00 UTC: Jul 19, Sep 20, Nov 15
 
1. Update GitHub README with dates for next month via R script
   - Based on usual pattern (n'th day of month at particular times)
   - Check dates and adjust if necessary
2.  Prepare agenda (check minutes were saved from last meeting: https://github.com/r-devel/rcwg/tree/main/team_minutes)
     - https://hackmd.io/@hturner/HyISuE97D/edit.
3.  Create Google event +Zoom (use Method 2)
    - Method 1: Create event on Google calendar, make Zoom event. Makes a mess of Zoom instructions in description on Teamup, but just about usable.
    - Method 2: Create event on Zoom, add to Google calendar. Need to make sure on Forwards account
        - Add to Forward Calendar (RSVPs work better from main calender - at least Outlook and fastmail, RSVPs don't work to (public?) group calendar). DO NOT INVITE ANYONE YET!!
        - Copy event to R Contribution Working Group calendar for sharing on public calendar without any invitees.
        - Add guest: r-contribution-wg@r-project.org on Forwards Calendar event.
    - Cannot log in to Zoom or Gmail with RSelenium.
4.  Will automatically show on Team up in 12 hours, or
    - Login to Team up 
    - R Contributor Events > Settings > Calendars (https://teamup.com/c/fb4ohx/r-contributor-events/settings/calendars/edit/10129900)
    - Edit RCWG meetings refresh interval, save, then change back.
    Guests are not shown on Teamup (but are on shared google calendar, if added)
5. Add to Slack

:loudspeaker: R Contribution Working Group
:date: Mon 24 July, 15:00 - 16:00 UTC - UPDATED DATE AND TIME
Agenda includes:
- Preparation for R Project Sprint 2023
- Updates on GSoC projects (R Development Container, Translations Dashboard)
Details: https://contributor.r-project.org/events
    
6. 1-2 days before meeting:
    - Update event with highlights from agenda: will send reminders to people.
    - Post reminder on Slack, Twitter and Mastodon.
    - Also advertise on R-devel mailing list?
    
    
## Content for calendar event

R Contribution Working Group
    
Set date and time in UTC
    
Make it a Zoom meeting (make sure title, date and time set first!)
    
Add to R Contribution Working Group Calendar

Working agenda is here: https://hackmd.io/@hturner/HyISuE97D/edit including
 - Preparation for R Project Sprint 2023
 - Updates on GSoC projects (R Development Container, Translations Dashboard)

Issues: https://github.com/r-devel/rcwg/issues

Minutes of previous meetings: https://github.com/r-devel/rcwg/tree/main/team_minutes
    
## Setting up Office Hours

1. Create event on Zoom
    - Set up to recur until clocks change (can always edit specific date)
    - Seems that it can cope with clocks changing if set local time in PST,
    but stick with doing it this way for now.
2. Create event on Meetup [cannot automate this part without paying, e.g. https://integrately.com/integrations/meetup/zoom] **or announce if not yet done**.
    - [Consider editing current recurring meeting to extend end date]
    - Copy past event
    - Don't require registration
    - Make a recurring event
    - Set end date
    - Don't integrate Zoom - for a recurring event it created a duplicated zoom meeting, on the wrong day, that does not recur!
    - Don't announce till one week before (only announces one event at a time in any case)
3. Add to Forwards Calendars
    - Add to Forward Calendar from Zoom and edit description. DO NOT INVITE ANYONE YET!!
    - Copy event to Office Hours calendar for sharing on public calendar without any invitees.
    - Add guests: r-contribution-wg@r-project.org on Forwards Calendar event. FOR ALL EVENTS!!
4. [Automated] Add to contributor.r-project.org/events
    - If need to force change refresh settings on Teamup
5. Create events on LinkedIn (https://www.linkedin.com/company/64851099/admin/)
    - See https://docs.google.com/document/d/1CsZrpwEsaSjIRi1o3Nw3g1QOJPlMJZgp62s5FFVDOaU/edit
6. Post on social media with help from scripts/office_hours.R
