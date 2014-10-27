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

	function getUrl(url) {
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

	function isPlusOneNeeded(commentsUrl, userId) {
		var dfd = new $.Deferred();
    	var plusOneNeeded = true;
		var data = {
			access_token: this.githubToken,
		}; 

    	_request('GET', commentsUrl, data).done(function(comments){
    		console.log(comments);
    		// for (var i=0; i < comments.length; i++) {
    		// 	// and author is the opener of the PR
    		// 	if (comments[i].body.indexOf('@' + userId) > 0) {
    		// 		plusOneNeeded = true; 
    		// 	} else if (plusOneNeeded && comments[i].user.login === userId) {
    		// 		plusOneNeeded = false; 
    		// 	}
    		// }
    		dfd.resolve(plusOneNeeded);
    	});
    	return dfd.promise();
    }

	// get comments on a PR 
	// get commit history on PR

	return {
		'getNotifications': getNotifications,
		'getUrl': getUrl,
		'verifyUserToken': verifyUserToken,
		'setToken': setToken,
		'isPlusOneNeeded': isPlusOneNeeded	
	};
}


module.exports = github(); 
