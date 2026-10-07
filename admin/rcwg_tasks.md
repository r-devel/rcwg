# Review admin tasks

## Setting up R Contribution Working Group Meeting (scripts/rcwg.R)

### Set up recurring meeting

Usually do for 6 months Oct-Mar / Apr-Sep in two series. Zoom can 
cope with clocks changing if set local time, e.g. in PST, but good to review 
every 6 months anyway.

1. Set up recurring meetings on Zoom
    - Adjust/delete dates in each series here before moving on
2. Note dates in scripts/rcwg.R
    - Use code in script to update GitHub README with dates for next two months
    - Copy over Zoom links for future promo
3. Add to Forwards Google calendar
    - Add each series to R Contribution Working Group Calendar
    - Update event content (see example below)
    - Use code in script to get current RCWG subscribers and invite to series
        - Uncheck "can see guest list"
4. Will automatically show on Team up in 12 hours, or
    - Login to Team up 
    - R Contributor Events > Settings > Calendars (https://teamup.com/c/fb4ohx/settings/calendars/edit/10129900)
    - Edit RCWG meetings refresh interval, save, then change back.
5. Add reminder on personal calendar one week before event to promote
    
Notes

 - If change event in recurring series (on Zoom) will send invite for series 
and invite for each changed event. Therefore it may be better to note intended 
change for self and just adjust individual event when advertising 
meeting/writing up minutes of previous meeting
 - Guests are not shown on Teamup
    
#### Example meeting details

Working agenda is here: https://developer.r-project.org/etherpad/p/rcwg, this month including:

TBA

Minutes of previous meetings: https://github.com/r-devel/rcwg/tree/main/team_minutes

Issues: https://github.com/r-devel/rcwg/issues

Calendar invites are sent to subscribers of the R-Contribution-WG mailing list, please visit 
https://stat.ethz.ch/mailman/listinfo/r-contribution-wg if you wish to unsubscribe.

### Promote single meeting ~1 week in advance

1. Update GitHub README with dates for next month via R script (scripts/rcwg.R)
2. Prepare agenda https://developer.r-project.org/etherpad/p/rcwg
    - check minutes were saved from last meeting: https://github.com/r-devel/rcwg/tree/main/team_minutes
3. Add agenda items to Google calendar event (will send update acting as 
reminder)
4. Promote via Zulip and Mastodon as in scripts/rcwg.R
    
## Setting up Office Hours

1. Set up recurring meetings on Zoom
    - Adjust/delete dates in each series here before moving on
2. Add to Forwards Google calendar
    - Add to Forwards Office Hours calendar
    - Update event content (see example below)
3. Create event on Teamup
    - Copy past event and update title if necessary (description also given below)
    - Update Zoom link (add hyperlink)
    - Update recurring times for this series **in UTC** (timezone feature does not work)
    - Edit specific event/times as necessary
    - Check on https://contributor.r-project.org/events/ (updates immediately)
4. Once all looks good add invitees to Forwards Google Calendar event
    - Invite facilitators directly
    - Use code in script to get current RCWG subscribers and invite to series
        - Uncheck "can see guest list"
5. Add reminder on personal calendar (gmail) one week before office hours to promote
    
### Promote single meeting ~1 week in advance

Post on social media with help from scripts/office_hours.R

### Content for Forwards calendar

Join the online Office Hour to

- discuss how to get started contributing to R
- get help/feedback on contributions you are working on
- look at open bugs/work on translations together

<zoom details>

Etherpad
https://developer.r-project.org/etherpad/p/office-hour-EMEA-APAC
https://developer.r-project.org/etherpad/p/office-hour-AMER

Calendar invites are sent to subscribers of the R-Contribution-WG mailing list, please visit
https://stat.ethz.ch/mailman/listinfo/r-contribution-wg if you wish to unsubscribe.

### Content for Teamup calendar

Join the online Office Hour to

- discuss how to get started contributing to R
- get help/feedback on contributions you are working on
- look at open bugs/work on translations together
---
**Please sign up to let us know you plan to attend and to receive a calendar invite by email.**
---
Join Zoom Meeting

### Considering meetup alternatives

- Zoom registration: okay, but then everyone must register, too much overhead 
for people invited via mailing list
- Pretix: better for workshop or similar where commit people commit to dates 
up front - else need to register for each event, not as easy as RSVP on Meetup
- Google series - can only use invite link on main calendar
- LinkedIn - people often sign up as attending then don't show
- Teamup can enable signups but need to put all detail in event (including Zoom) 
so people probably wouldn't bother signing up.
     - Need to create events directly on Teamup else have to enable signup on 
     all events to add signup to events generate from Google calendar feed.
     - Trial and see if signup used/preferred to Meetup
     
#### Previous instructions for Meetup

* Create event on Meetup https://www.meetup.com/r-contributors/events/ 
[cannot automate this part without paying, e.g. https://integrately.com/integrations/meetup/zoom] **or announce if not yet done**.
    - [Consider editing current recurring meeting to extend end date]
    - Copy past event
    - Don't require registration
    - Make a recurring event
    - Set end date
    - Don't integrate Zoom - for a recurring event it created a duplicated zoom meeting, on the wrong day, that does not recur!
    - Don't announce till one week before (only announces one event at a time in any case)
    
Also as previously created Teamup message from Google calendar, there was an extra step:

* [Automated] Add to contributor.r-project.org/events
    - If need to force change refresh settings on Teamup
