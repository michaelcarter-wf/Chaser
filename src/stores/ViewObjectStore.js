var Reflux = require('reflux'),
	actions = require('../actions'),
	moment = require('moment'),
	chromeApi = require('../chrome'),
	viewService = require('../viewService'),
	constants = require('../constants');


function fireItUp(newList){
	chromeApi.get('showAll', function(results) {
		actions.showActionNeeded(results.showAll);
	});
}

// initially load the list and pass to consumer
function getAtMentions() {
	chromeApi.get('viewObjects', function(results) {
		if (!results.viewObjects) {
			chromeApi.get(constants.githubTokenKey, function(results) {
				if (results[constants.githubTokenKey]) {
					viewService.prepViewObjects(results[constants.githubTokenKey], fireItUp);
				}
			});
		} else {
			fireItUp(results.viewObjects);
		}
	});
}

// Creates a DataStore
var ViewObjectStore = Reflux.createStore({
	listenables: actions,

	// so on init in each function pass the view
	// get the corresponding list and save it to the cache
	init: function(view) {
		if (!view){
			return;
		}
		var that = this;
		chromeApi.get(constants.githubTokenKey, function(results) {
			that.githubToken = results[constants.githubTokenKey]; 
		}); 
		this.view = view;
		this.onSwitchTo(view);
	},

	onRefresh: function() {
		var that = this; 

		var viewObjectsToStore = {
			'_lastUpdated_': moment().format()
		};
		chromeApi.set(viewObjectsToStore);
		
		viewService.prepViewObjects(this.githubToken, function(results) {
			// Pass on to listeners
			fireItUp();
		});

		viewService.getUserPrs(this.githubToken, function(newList) {
			that.pullRequests = newList;
			if (that.view === constants.views.pullRequests) {
				that.trigger(newList);
			}
		});
	},

	newList: function(newList) {
		this.list = newList; 
		this.trigger(newList);
	},

	onShowActionNeeded: function(showAll) {
		var that = this;
		chromeApi.get('viewObjects', function(results) {
			if (!results.viewObjects) {
				that.trigger([]);
				return;
			}

			var newList = showAll ? results.viewObjects : results.viewObjects.filter(function(vObject) {
				return vObject.commentInfo.plusOneNeeded;
			});
			
			that.atMentions = newList;
			if (that.view === constants.views.atMentions) {
				that.trigger(newList);
			}
		});
	},

	// take the PR and put it in the cache
	onHidePR: function(prID){
		var newList = this.atMentions.filter(function(viewObj){
			var show = viewObj.pullRequest.id !== prID;

			if (show) {
				chromeApi.get('hiddenPRs', function(results) {
					debugger;
					if (results.hiddenPRs) {
						results.hiddenPRs[prID] = moment().format();
						chromeApi.set(results);
					} else {
						objectToStore = {'hiddenPRs': {}}; 
						objectToStore.hiddenPRs[prID] = moment().format();
						chromeApi.set(objectToStore);
					}
				});
			}

			return show; 
		});

		// put this in to it's own function
		var viewObjectsToStore = {
			'viewObjects': newList,
			'_lastUpdated_': moment().format()
		};

		// TODO set the list here.
		chromeApi.set(viewObjectsToStore);

		this.list = newList; 
		this.trigger(newList);
	},

	onSwitchTo: function(view) {
		var that = this;

		chromeApi.get('viewObjects', function(results) {
			if (!results.viewObjects) {

			} else {
				chromeApi.get('showAll', function(results) {
					actions.showActionNeeded(results.showAll);
				});		
			}
		});

		viewService.getUserPrs(this.githubToken, function(newList) {
			that.pullRequests = newList;
			if (view === constants.views.pullRequests) {
				that.trigger(newList);
			} 
		});
		
	},




});

module.exports = ViewObjectStore;