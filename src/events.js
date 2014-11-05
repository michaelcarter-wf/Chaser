var chromeApi = require('./chrome'),
	viewService = require('./viewService'),
	constants = require('./constants'),
	Github = require('./github'),
	github,
	tenMinutes = 10;


function checkForNotifications(){
	console.log('checking for checkForNotifications');
	chrome.alarms.create('refresh', {periodInMinutes: tenMinutes});
  		viewService.prepViewObjects(github.githubToken, function(results){
	  		var actionItems = 0; 
	  		// TODO move this to the view service
	  		for (var i=0; i < results.length; i++) {
	  			if (results[i].commentInfo.plusOneNeeded) {
	  				actionItems++; 
	  			}
	  		}
	  		chrome.browserAction.setBadgeText({'text':actionItems.toString()});
  	});
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