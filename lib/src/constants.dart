library wChaser.src.constants;

var settings = {
	'githubTokenKey': 'github',
	'githubUrl': 'https://api.github.com/',
	'userKey': 'login',
	'currentUser': '_currentUser_',
	'viewObjects': '_viewObjects_',
	'lastUpdated': '_lastUpdated_',
	'http': {
		'get': 'GET'
	},
	'views': {
		'atMentions': '_atMentions',
		'pullRequests': 'pullRequests'
	}
};

enum views { atMentions, pullRequests }

final String localStorageKey = 'github';
