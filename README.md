wChaser ![travis-ci](https://travis-ci.org/bradybecker-wf/wChaser.svg?branch=master) [![Coverage Status](https://coveralls.io/repos/bradybecker-wf/Chaser/badge.svg?branch=master&service=github)](https://coveralls.io/github/bradybecker-wf/Chaser?branch=master)
==========
> wChaser is a chrome extension that:
* finds Pull Requests that you've been [at mentioned in](https://github.com/pulls/mentioned)
* finds Pull Requests that you've [created](https://github.com/pulls)
* Displays and links build statuses of that repo. 

![wChaser Screen Shot](https://cloud.githubusercontent.com/assets/6053448/12072320/a4cc05d0-b09e-11e5-9685-26cf97393ed8.png)

#### Protips: 
* Use the arrow keys to switch views
* `Alt+Shift+K` Is a hot key to open the extension
* Click on the build status circle to take you to the passed/failed/loading build

#### Installing wChaser *(until it's out on the chrome store)*
* The [Dart SDK](https://www.dartlang.org/downloads/) is required.
* `pub get`
* `pub build`
* `./build.sh`
* In Chrome navigate to: `chrome://extensions/`
* Make sure `Developer Mode` is checked
* Click `Load Unpacked Extension` and select your wChaser repo
* Happy Chasing
