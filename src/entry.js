// should put the stores on the window
require('./css/style.css');
var App = require('./components/app'),
	github; 

var Github = require('./github'),
	constants = require('./constants'),
	chromeApi = require('./chrome'),
	viewService = require('./viewService'),
	Login = require('./components/login');


function fireItUp() {
	App.start();
}

chromeApi.get('viewObjects', function(results) {
	if (!results.viewObjects) {
		chromeApi.get(constants.githubTokenKey, function(results) {
			if (results[constants.githubTokenKey]) {
				viewService.prepViewObjects(results[constants.githubTokenKey], fireItUp);
			} else {
				Login.start();
			}
		});
	} else {
		fireItUp();
	}
});
