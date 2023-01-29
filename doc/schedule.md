---
number headings: first-level 2, 1.1., auto
---
# Schedule
### 0.1. setup
- [x] release build is running on
	- [x] web (`flutter build web`)
	      (`build\web`)
	- [x] windows (`flutter build windows`)
	      (`build\windows\runner\Release`)
	- [x] android (`flutter build apk`) 
	      (`build\app\outputs\flutter-apk\app-release.apk`)

**LEARNING** 
- [ ] https://docs.flutter.dev
	- [x] Get started
	- [ ] Samples & tutorials
		- [x] Flutter gallery
		- [x] Sample apps on Github
		- [x] Cookbook
		- [ ] Codelabs
		- [ ] Tutorials
	- [ ] Development
		- [ ] user interface
		- [ ] Data & backend
		- [ ] Accessibility & internatialization
		- [ ] Platform integration
		- [ ] Package & plugins
		- [ ] Add Flutter to an existing app
		- [ ] Tools & features
	- [ ] Testing & debugging
		- [ ] Debugging tools
		- [ ] Debugging apps programmatically
		- [ ] Using an OEM debugger
		- [ ] Flutter build modes
		- [ ] Common Flutter errors
		- [ ] Handling errors
		- [ ] Testing
		- [ ] Integration testing
		- [ ] Migration from flutter_driver
	- [ ] Performance & optimization
		- [ ] Overview
		- [ ] Performance best practices
		- [ ] App size
		- [ ] Deferred components
		- [ ] Performance profiling
		- [ ] Shader compalation jank
		- [ ] Performance metrics
		- [ ] Performance FAQ
		- [ ] Appendix
	- [ ] Deployment
		- [ ] Obfuscating Dart code
		- [ ] Creating flavors for Flutter
		- [ ] Build and release an Android app
		- [ ] Build and release an iOS app
		- [ ] Build and release a macOS app
		- [ ] Build and release a Linux app
		- [ ] Build and release a Windows app
		- [ ] Build and release a web app
		- [ ] Continuous deployment
	- [ ] Resources
		- [ ] Architectural overview
		- [ ] Books
		- [ ] Compatibility policy
		- [ ] Contributing to Flutteropen_in_new
		- [ ] Creating useful bug reports
		- [ ] Dart resources
		- [ ] Design Documents
		- [ ] FAQ
		- [ ] Casual Games Toolkit
		- [ ] Google Fonts packageopen_in_new
		- [ ] Inside Flutter
		- [ ] Official brand assetsopen_in_new
		- [ ] Platform adaptations
		- [ ] Videos and online courses
	- [ ] Reference
		- [ ] Widget index
		- [ ] API referenceopen_in_new
		- [ ] flutter CLI reference
		- [ ] Package siteopen_in_new
- [ ] git-sql
- [ ] firebase
	- [ ] desktop?
	- [ ] hosting elsewhere?
	- [ ] firebase+flutter fireship.io tutorial
### 0.2. 
- [ ] icon for all platforms
- [ ] devlog page + send an email to me
- [ ] download page only on the web for windows and android versions
	- [ ] warning that these are non singend versions, meaning they probably will be detected to be not secure programs and the windows and android will try to stop you from installing/running
- [ ] connect to database form all platform
- [ ] async read and write from database
- [ ] auto update based on database change
- [ ] setup auto command for [[development cycle#Deployment|deployment]]
### 0.3. 
- [ ] login
	- [ ] validation from database
	- [ ] secure password
### 0.4. 
- [ ] calendar
	- [ ] display Gregorian calendar
		- [ ] week
### 0.5. 
- [ ] management
	- [ ] standalone events
		- [ ] title, start time, end time, description
	- [ ]  event crud
		- [ ] viewing events in calendar
			- [ ] single day event
			- [ ] multi day event
		- [ ] adding events
		- [ ] deleting events
		- [ ] editing events properties
### 0.6. 
- [ ] management
	- [ ] drag'n'drop
		- [ ] moving events
		- [ ] duplicate event
	- [ ] splitting events
### 0.7. 
- [ ] management
	- [ ] event repeat
		- [ ] every n days, weeks, ...
		- [ ] for n days; till date, forever
		- [ ] ghost events in the future
		- [ ] change all / change this / change all future
		- [ ] delete all / delete this / delete all future
### 0.8. 
- [ ] management
	- [ ] auto plan event placement
		- [ ] end time
		- [ ] dependencies
		- [ ] priority
		- [ ] overdue ( time since last event / frequency ) * priority
		- [ ] balance work / relax / sleep
### 0.9. 
- [ ] calendar
	- [ ] different views
		- [ ] day
		- [ ] +- day
	- [ ] time zones
- [ ] management
	- [ ] event / task description
### 0.10. 
- [ ] blog
	- [ ] adding new posts
	- [ ] editing posts
	- [ ] removing posts
	- [ ] viewing posts in user page
### 0.11. refining
- [ ] custom frame for windows
      https://www.youtube.com/watch?v=bee2AHQpGK4
- [ ] management
	- [ ] statistics

**LEARNING** 
- [ ] https://docs.flutter.dev
## 1. 
### 1.1. 
- [ ] management
	- [ ] event status
		- [ ] add, edit, remove statuses
		- [ ] style differences
		- [ ] status hierarchy 
- [ ] account
	- [ ] registration
	- [ ] guest login
	- [ ] recheck user pages
### 1.2. 
- [ ] calendar
	- [ ] display b36 calendar
		- [ ] week
- [ ] user page
	- [ ] changeable password
	- [ ] changeable name
### 1.3. 
- [ ] management
	- [ ] tasks
		- [ ] hierarchy
		- [ ] title, color, description
		- [ ] start time, end time
		- [ ] dependencies
		- [ ] status
			- [ ] directional states
			- [ ] high level states
		- [ ] events
