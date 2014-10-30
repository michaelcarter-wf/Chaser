require('./css/style.css');
var App = require('./components/app'),
	github; 

var Github = require('./github'),
	constants = require('./constants'),
	chromeApi = require('./chrome'),
	viewService = require('./ViewService');


function fireItUp(viewObjects) {
	// console.log(viewObjects);
	App.start(viewObjects);
}

chromeApi.get('viewObjects', function(results) {
	if (!results.viewObjects) {
		chromeApi.get(constants.githubTokenKey, function(results) {
			if (results[constants.githubTokenKey].length) {
				viewService.prepViewObjects(results[constants.githubTokenKey], fireItUp);
			} else {

			}
		});
	} else {
		fireItUp(results.viewObjects);
	}
});



