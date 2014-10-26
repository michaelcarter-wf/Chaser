//var githubToken = 'e7e66722a80a5cd4815e8dafee36a5483cbdbc64';
function github() {
	$ = require('jquery');
	this.githubToken = ''; 

	function setToken(newToken){
		this.githubToken = newToken;
	}

	//TODO get access token here
	function _request(requestType, url, data){
		data = data || {};
		// this will prevent caching until I handle it
		data['timestamp'] = new Date().getTime(); 

		return $.ajax({
			type: requestType,
			url: url,
			data: data
		});
	}

	function getNotifications(all) {
		var data = { 
			access_token: this.githubToken,
			all: all,
		};
		return _request('GET', 'https://api.github.com/notifications', data);
	}

	function getPullRequest(url) {
		var data = { 
			access_token: this.githubToken
		};

		return _request('GET', url, data);
	}

	function verifyUserToken(token) {
		var data = {
			access_token: token
		}; 

		return _request('GET', 'https://api.github.com/user', data);
	}

	// get comments on a PR 
	// get commit history on PR

	return {
		'getNotifications': getNotifications,
		'getPullRequest': getPullRequest,
		'verifyUserToken': verifyUserToken,
		'setToken': setToken	
	};
}


module.exports = github(); 
