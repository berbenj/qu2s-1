---
number headings: first-level 2, 1.1., auto
---
# Schedule
### 0.1. 
- [x] release build is running on
	- [x] web (`flutter build web`)
	      (`build\web`)
	- [x] windows (`flutter build windows`)
	      (`build\windows\runner\Release`)
	- [x] android (`flutter build apk`) 
	      (`build\app\outputs\flutter-apk\app-release.apk`)
### 0.2. 
- [ ] icon for all platforms
- [ ] custom frame for windows
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
- [ ] user page
	- [ ] changeable password
	- [ ] changeable name
### 0.4. 
- [ ] blog
	- [ ] adding new posts
	- [ ] editing posts
	- [ ] removing posts
	- [ ] viewing posts in user page
### 0.5. 
- [ ] calendar
	- [ ] display Gregorian calendar
		- [ ] week
		- [ ] day
		- [ ] +- day
### 0.6. 
- [ ] calendar
	- [ ] display b36 calendar
		- [ ] week
		- [ ] day
		- [ ] +- day
	- [ ] time zones
### 0.7. 
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
### 0.8. 
- [ ] management
	- [ ] drag'n'drop
		- [ ] moving events
		- [ ] duplicate event
	- [ ] splitting events
### 0.9. 
- [ ] management
	- [ ] event repeat
		- [ ] every n days, weeks, ...
		- [ ] for n days; till date, forever
		- [ ] ghost events in the future
		- [ ] change all / change this / change all future
		- [ ] delete all / delete this / delete all future
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
