//var githubToken = 'e7e66722a80a5cd4815e8dafee36a5483cbdbc64';
function github() {
	$ = require('jquery');
	this.githubToken = ''; 

	function setToken(newToken){
		this.githubToken = newToken;
	}

	function request(request, url, data){
		var dfd = new $.Deferred();

		$.ajax({
			type: "GET",
			url: url,
			data: { 
		  		access_token: this.githubToken,
		  		// adding until the cache is setup
		  		timestamp : new Date().getTime() 
		  	}
		}).done(function(PR) {
			dfd.resolve(PR);
		});

		return dfd.promise();
	}


	function getNotifications(all) {
		var dfd = new $.Deferred();
		console.log(this.githubToken);
		$.ajax({
			type: "GET",
			url: 'https://api.github.com/notifications',
			data: { 
		  		access_token: this.githubToken,
		  		all: all,
		  		// adding until the cache is setup
		  		timestamp : new Date().getTime() 
		  	}
		  }).done(function(notifications) {
		  	dfd.resolve(notifications);
		  });

		return dfd.promise();
	}

	function getPullRequest(url) {
		var dfd = new $.Deferred();

		$.ajax({
		  type: "GET",
		  url: url,
		  data: { 
		  	access_token: this.githubToken,
		  	// adding until the cache is setup
		  	timestamp : new Date().getTime() 
		  }
		}).done(function(PR) {
			dfd.resolve(PR);
		});

		return dfd.promise();
	}

	function verifyUserToken(token) {
	
		var promise = $.ajax({
		  type: "GET",
		  url: 'https://api.github.com/user',
		  data: { 
		  	access_token: token,
		  	// adding until the cache is setup
		  	timestamp : new Date().getTime() 
		  }
		});


		return promise;
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
