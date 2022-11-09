
# Software Requirement Specification
> **Project name**: `qu2s`
> **Date**: `2022-11-01`
> **Version**: `0.3`
> **By**: `dev_7g94`

## 1 Introduction
This document describes the software requirements of `qu2s` that need to be completed for the project to be considered finished.

## 2 General description
`qu2s` is a combination of multiple concepts. These mainly include communication, management and knowledge/information database. It's a highly customizable and integrated system that focuses on performance and user experience.

### 2.1 Purpose
- To provide a unified and free interface for all communication on all platforms.

### 2.2 Intended audience
- experienced or semi experienced internet users

## 3 Functional requirements

### 3.1 Account
- security
- optional 2 factor authentication

#### 3.1.1 Account page
- a page where you can see and change accounts information that are logged in, and view accounts that are not
- can be set to show different things by default to users who go to it. These include blog, tweets, ...
- user friendly customization of layout and style (inspiration website builders)

#### 3.1.2 Multi account
- accounts can be connected and be used at the same time
- the connected nature of the accounts can be public or private
- notification sharing options
- quick account changing
- account aliases, has the same options as an account, but a level lower

#### 3.1.3 Email
- email is not required for registering an account
- multiple accounts can use the same email address for identification
- for recovery purposes
- notifications only if enabled

#### 3.1.4 Profile picture
- storing past few pictures
- profile pictures can be set for a preset amount of time, after the time is over the previous profile picture is reapplied

#### 3.1.5 Roles
- admin / moderator / user / bot
- community defined roles

#### 3.1.6 Notifications
- user notifications
- management notifications
- calendar event notifications
- push to different devices
- notification to email only if enabled

#### 3.1.7 Status
- short note of text
- can be temporary that is automatically removed after a set amount of time
- easily changeable
- shows software or game playing

#### 3.1.8 Settings
- extensive settings menu
- multiple premade style sheets or custom style
- custom scripts
- documentation for styling / scripting

### 3.2 Meta-text
- language
- source
	- date
	- link / site / file
- date of creation, modification
- how certain that the information is; what is the information is based on; whos theory is it
- markdown / custom markdown
	- bootstrap and Wikipedia for inspiration
	- syntax highlight
	- shortcuts
- easy generating links/cites to any text
- custom markdown features
	- progress bar
	- side panel
	- graphs
	- diagrams

### 3.3 Graph editor
- auto place nodes and edges based on graph type
- multiple graph types (treelike, cluster)
- nodes can be: text, documents, wiki pages, another graph

### 3.4 Cloud storage
- security
- easy gallery
- complete filesystem
- sharable for reading or editing
- easy sending and embed
- file viewer for some file formats (like images or text files)
- version control for selected folders

### 3.5 Communication
- communities
- integrate popular communication sites (discord, twitter, ...)

#### 3.5.1 Forum
for slow communication
- forums > threads > posts > comments

#### 3.5.2 Chat
for fast communication
- actively updating chat room
- threads, can be split, abandoned
- emojis, stickers (system / custom), images, gifs, embeds
- servers
	- channels (and folders for organization)
	- roles and permissions
	- voice / video channels
- instant update
- writing status
- read status (only in dm)
	- only set to read after clicked in the input OR tapping on "read" in phone notification
- unique alias (profile name and picture) for servers and dm-s
	- handled with a popup to the user when joining a server where the user can choose to use an existing alias or create a new one
	- can also change alias at any time afterwards
	- aliases name and profile picture can be changed
- themes (light / dark / black / custom)
- notifications
- Discord, Messenger, Twitter (, ...) integration

#### 3.5.3 Blog
for posting
- blog > posts > comments
- comments can be turned off (by default they are on)
- reading time

### 3.6 Management

#### 3.6.1 Tasks
- hierarchy
- dependencies
- tags
- status
	- state is a directional graph
	- high level states (e.g. there can be multiple status that is considered "in progress")
- start and end date (time zone)
	- have to be within parents timeframe
- color (that is inherited to its children)
- assignee
- priority
- custom fields
- time tracking
- work in progress limit; and others ...
- sprints
- sprint points
- prevent closing task that have incomplete subtask, dependencies
- auto reschedule
- milestones
- description
- duplicate / merge / move ...
- automations
- multiple views (clickup for insperation)
- one task can have many events
- projects
	- private / public
	- statistics
	- documents
		- system / user defined templates

#### 3.6.2 Events
- part of tasks
- dependencies
- status
- start and end date (time zone)
- reoccurring (by any complex logic)
- custom fields
- independent events (that do not have a task parent) for miscellaneous events

#### 3.6.3 Statistics

#### 3.6.4 Calendar
- different views
	- day
	- week
	- month
	- based on today, from -x day from before, to +y ahead
- different calendars (Gregorian, b36)
- different time zones
- changeable height of one hour
- drag and drop events
- quick create events
- quick edit events
- quick split or merge events
- auto arrange event based on preferences
	- how much hour per project per timeframe
	- as soon as possible / as late as possible / balanced
- auto tracks app and web usage for later event logging

### 3.7 Knowledge/Information database
- pages
	- title
	- language translations
	- alias names
	- author, contributor
	- sources
	- connected topics
	- timeline
- auto links, backlinks
- integrate Baka-updates, VNDB, AniDB, ...
- auto graph connections

### 3.8 API
- documentation

## 4 Interface requirements
- multiple apply able stylesheets
- user can define custom stylesheet
- accessibility features
	- multiple languages

## 5 Performance Requirements  
- can handle 1'000'000'000 users at once
- fast response time
	- no function can take more then 1ms
	- app loading is within 1s
- all time 60 fps (except on web)

## 6 Non-Functional Attributes
- quick error recovery
- low memory mode
- low battery mode

### 6.1 Security
- accounts
- cloud storage
- wiki pages

### 6.2 Operating systems
- Web
- Windows
- Android
- Linux
- MacOS
- IOS

## 7 Preliminary Schedule and Budget
- there is no budget, only the amount `the_dev` can spend on it
- the first estimate that the 80% of the project should be finished before `1k8`
- proper schedule TBD (to be determined)
- continuous development, new development always available to public