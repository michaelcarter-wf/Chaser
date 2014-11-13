function viewService() {
	var Github = require('./github'),
		constants = require('./constants'),
		chromeApi = require('./chrome'),
		API = {},
		moment = require('moment');

	function updateBadgeText(viewObjects) {
		var actionItems = 0;
		// TODO move this to the view service
		for (var i = 0; i < viewObjects.length; i++) {
			if (viewObjects[i].commentInfo.plusOneNeeded) {
				actionItems++;
			}
		}
		chrome.browserAction.setBadgeText({
			'text': actionItems.toString()
		});
	}

	function prepViewObjects(accessToken, successCallback){
		var viewObjects = [],
			prepped = 0,
			tokenObj = {},
			github = Github(accessToken);

		// are all items prepped and ready
		function isFinished() {
			prepped--;
			if (prepped === 0) {
				// put the action needed objects at the top of the list
				viewObjects.sort(function(x, y) {
					return y.commentInfo.plusOneNeeded - x.commentInfo.plusOneNeeded;
				});
				var viewObjectsToStore = {
					'viewObjects': viewObjects,
					'_lastUpdated_': moment().format()
				};
				chromeApi.set(viewObjectsToStore);
				updateBadgeText(viewObjects);

				successCallback(viewObjects);
			}
		}

		// check for commit after plus one needed
		function prepItemForView(notification, callback) {
			github.getPullRequest(notification.subject.url).then(function(pullRequest) {
				if (pullRequest.state === 'open') {
					chromeApi.get('login', function(results) {
						github.isPlusOneNeeded(pullRequest.comments_url, results.login).done(function(result) {
							viewObjects.push({
								'notification': notification,
								'pullRequest': pullRequest,
								'commentInfo': result
							});
							isFinished();
						});
					});
				} else {
					isFinished();
				}
			}, function() {
				prepped--;
			});
		}

		// start off by getting all notifications that are @mentions
		github.getNotifications(true, 'mention').done(function( notifications ) {
			for(var i=0; i < notifications.length; i++){
	            if (notifications[i].reason === 'mention') {
	            	prepped++;
					prepItemForView(notifications[i]);
				}
			}
		});	
	}
	API.prepViewObjects = prepViewObjects; 


	function getUserPrs(accessToken, callback) {
		var viewObjects = [],
			github = Github(accessToken);

		github.getUsersRepos().then(function(repos) {
			var counter = 0;
			repos.forEach(function(repo) {
				var url = constants.githubUrl + 'repos/' + repo.full_name + '/pulls';
				github.getUserPullRequests(url).then(function(prs) {
					counter++; 
					prs.forEach(function(pr) {
						viewObjects.push({
							'notification': null,
							'pullRequest': pr,
							'commentInfo': null
						});
					});
					if (counter === repos.length) {
						viewObjects.sort(function(a,b){
  							return Date.parse(b.pullRequest.created_at) - Date.parse(a.pullRequest.created_at);
						});
						callback(viewObjects);
					}
				});
			});
		});
	}
	API.getUserPrs = getUserPrs; 


	return API;
}

module.exports = viewService(); 