# Protocols

## 20.10.2023, 15:45 - 16:00: Project Proposal

Present: All, Place: Zoom-Meeting

Feedback to presentation:
 * Functionality of algorithms must be transparent and shown in tests
 * Provide notifications in the web browser

## 23.10.2023, 18:00 - 19:00: Weekly Meeting

Present: All, Place: Zoom-Meeting

### Topics

Moritz and Tobias role switch
* Tobias: Documentation coordinator
* Moritz: Test Coordinator

#### Plan overview

* Monday, 18:00: Small summary of what was done during the weekend
  * 30min review, then ...
* Tuesday, 16:00: Sprint review with the tutor
* Friday, 14:00: Sprint Grooming (Everyone summarizes what they have done)

#### Project planning

**Milestones:** Epics - contains multiple tickets

**Labels:** 
1. Sprints - Will contain tickets
2. Story Points

Initiating first issues:
 * User creation
 * Login Page
 * Authorization
 * Create with Figma our first design, based on which functionalities can be derived
 * CI/CD 

#### Commit convention
 * Create Branches with the same name, as made by GitLab under "Issues".

```
[issue-<issue_nr>] short summary

what was implemented
```

#### Language convention

All comments and commits to be done in English.

### TODO's until next week
 * Bartek:
   1. Databases
   2. CI/CD
 * Anna, Moritz, Tobias: Figma Design
 * Moritz, Christoph: Project Planning
 * User Stories: Define all important functionalities

### Questions for next meeting: 
* How to get a time tracking table that provides a summary, just like during SEPM?

## 24.10.2023, 16:00 - 17:00: Weekly Meeting with the Tutor

Present: All, Place: Zoom-Meeting

Important to have a metric, based on which it can be determined if people
are a good match.
 * Points system would be a viable option
 * Anzahl von matches
 * Distanz
 * Interests
   * Maybe add option to weigh, how much an algorithm would determine matches.
     E.g., you don't want to match people say from Vorallberg, even if
     they are perfect, same goes the other way, meaning if the person is from
     Vienna, but does not match at all.

Uncertainty regarding the calendar from the tutor side:
 * Idea: You chat with a person and if you want to schedule a date, you can
   open your calendar and receive suggestions instantly from the application
    * When matching with someone, you can send over the calendar when the meeting
      would occur
    * You could make it more calendar-centric by setting days on which ones
      you would

It would be appreciated if it were also a phone application
 * Flutter
 * React, React Native

If the application would be also a mobile phone, then the elaborate calendar
feature could be left out.

Technology transfer suggestion: 
 * Backend using Java, could be also Python (Flask, FastAPI)
 * Frontend using React, Angular, Svelte, etc.

MR1 Project Contract
 * Presentation of each team member
 * Present each point in the project contract in a PowerPoint presentation

MR2: 2/3 of the project should be finished

MR3: The whole project should be finished and presentable.

Monday, 30.10 - Friday 03.11
Monday till Thursday from 18 o'clock, Friday from 15 o'clock
Official date: Friday 17 - 19 o'clock
1. Alternative date:	Friday 15 - 17 o'clock
2. Alternative date:	Monday	18 - 20 o'clock

### Dates

IR1 20.11 - 24.11
MR2 11.12 - 15.12
IR2 08.01 - 12.01
MR3 22.01 - 25.01

### TODO's
 * Bartek:
   1. Databases
   2. CI/CD
 * Anna, Moritz, Tobias: Figma Design
 * Moritz, Christoph: Project Planning
 * User Stories: Define all important functionalities

#### New TODO's
 * Slides

## 27.10.2023, 14:00 - 15:15: Weekly Meeting

Present: All, Place: Zoom-Meeting

### Topics

* Tech Stack
* Strategies / Algorithms
* Project Contract

#### Tech Stack

* **Backend: Python FastAPI**
  * Python Pro's: Simplicity, tutor can help out quickly
  * Python Con's: Potential Spaghetti code
  * Java SpringBoot Pro's: Everyone is familiar with it
  * Java SpringBoot Con's: Over the top complicated
  * Kotlin Pro's: Standard in mobile app development? 
  * Kotlin Con's: Only 1/5 team members familiar with Kotlin 
* **Frontend (mobile + web app): Flutter**
* **Database: PostgreSQL**

##### Responsibilities of Backend & Frontend
* **Backend**
  * Returns a list of people based on the location
  * Retrieves the amount of swipes left for the user
* **Frontend** 
  * Calls for the swipes and the data from the data and would calculate and sort

Querying people based on location has to be done in the database.

Location would be set by the users in the settings

#### Strategies

3 strategies:
1. Distance based strategy (always applied)
2. Interest based strategy
   * For every person we would calculate the preference 
3. Decision based strategy
   * Based on the swipes of a user
   * Would be computed based on, for example, text length, the preferences, etc.

The order in which the people would appear in your area would be randomized.

In order to prove, the tutor suggested that we could use dev mode to have a clearer view of the utilized strategies.
* For now will be omitted for now.

#### Database

User
* Each user has 5 pictures

### TODO's

* Team members should suggest additional attributes or objects
* Project Contract: 
  * Do the part they have been assigned to in the project in the corresponding Latex Project
  * Each team member should add their part to the presentation, after everything is added then finish
    the design
* Python backbone + Flutter frontend to be pushed onto Git
