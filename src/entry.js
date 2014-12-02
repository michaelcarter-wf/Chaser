// should put the stores on the window
require('./css/style.css');
require('react');
var Routes = require('./components/routes');
var github,
	constants = require('./constants'),
	chromeApi = require('./chrome'),
	viewService = require('./viewService'),
	Login = require('./components/login');


function fireItUp() {
	Routes.render();
}

chromeApi.get('viewObjects', function(results) {
	if (!results.viewObjects) {
		chromeApi.get(constants.githubTokenKey, function(results) {
			if (results[constants.githubTokenKey]) {
				// viewService.prepViewObjects(results[constants.githubTokenKey], fireItUp);
			} else {
				Login.start();
			}
		});
	} else {
		fireItUp();
	}
});
