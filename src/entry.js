require('./css/style.css');
var App = require('./components/app'),
	github; 

var Github = require('./github'),
	constants = require('./constants'),
	chromeApi = require('./chrome'),
	viewService = require('./ViewService'),
	Reflux = require('reflux'),
	Login = require('./components/login');


function fireItUp(viewObjects) {
	// console.log(viewObjects);
	App.start(viewObjects);
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
		fireItUp(results.viewObjects);
	}
});

