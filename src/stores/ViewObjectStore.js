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
function loadList() {
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

	init: function() {
		var that = this;
		chromeApi.get(constants.githubTokenKey, function(results) {
			that.githubToken = results[constants.githubTokenKey]; 
		}); 

		loadList();
	},

	// basically give me a new list and trigger the event
	onRefresh: function() {
		var that = this; 
		chromeApi.get(constants.githubTokenKey, function(results) {
			if (results[constants.githubTokenKey]) {
				viewService.prepViewObjects(results[constants.githubTokenKey], function(results){
					// Pass on to listeners
					fireItUp();
				});
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
			
			that.list = newList; 
			that.trigger(newList);
		});
	},

	// take the PR and put it in the cache
	onHidePR: function(prID){
		var newList = this.list.filter(function(viewObj){
			var show = viewObj.pullRequest.id !== prID;

			if (show) {
				chromeApi.get('hiddenPRs', function(results) {
					var objectToStore = {
						'id': prID,
						'timeStamp': moment().format()
					};
					if (results.hiddenPRs) {
						results.hiddenPRs.push(objectToStore);
					} else {
						chromeApi.set({
							'hiddenPRs': [objectToStore]
						});
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
		viewService.getUserPrs(this.githubToken, function(newList) {
			that.trigger(newList);
		});
	},




});

module.exports = ViewObjectStore;