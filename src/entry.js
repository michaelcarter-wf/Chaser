// should put the stores on the window
require('./css/style.css');
require('react')
var github,
	App = require('./components/app');

var Github = require('./github'),
	constants = require('./constants'),
	chromeApi = require('./chrome'),
	viewService = require('./viewService'),
	Login = require('./components/login');


function fireItUp() {
	App.render();
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
