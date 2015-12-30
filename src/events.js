var chromeApi = require('./chrome'),
	viewService = require('./viewService'),
	constants = require('./constants'),
	Github = require('./github'),
	github,
	tenMinutes = 10;


function checkForNotifications() {
	chrome.alarms.create('refresh', {
		periodInMinutes: tenMinutes
	});
	viewService.prepViewObjects(github.githubToken);
}

function onAlarm(alarm) {
  if (alarm.name === 'refresh') {
	checkForNotifications();
  }
}

function init() {
  	chromeApi.get(constants.githubTokenKey, function(results) {
		if (results[constants.githubTokenKey]) {
			github = Github(results[constants.githubTokenKey]);
			checkForNotifications();
			chrome.alarms.onAlarm.addListener(onAlarm);
		} 
	});
}

init();