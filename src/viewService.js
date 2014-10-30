function viewService() {
	var Github = require('./github'),
		constants = require('./constants'),
		chromeApi = require('./chrome'),
		API = {};

	function prepViewObjects(accessToken, successCallback){
		var viewObjects = [],
			prepped = 0,
			tokenObj = {},
			github = Github(accessToken);

		// todo check for plus one...
		// action needed
		function prepItemForView(notification, callback) {
			github.getPullRequest(notification.subject.url).then(function(pullRequest){
				prepped--; 
				if (pullRequest.state === 'open') {
					viewObjects.push({
						'notification': notification,
						'pullRequest': pullRequest
					});
				}
				// if all objects are prepped
				if (prepped === 0)  {
					var viewObjectsToStore = {'viewObjects': viewObjects};
					chromeApi.set(viewObjectsToStore, function(){
						successCallback(viewObjects);
					});
				}
			});
		}

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

	return API;
}

module.exports = viewService(); 