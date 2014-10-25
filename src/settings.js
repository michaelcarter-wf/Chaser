var githubToken = 'e7e66722a80a5cd4815e8dafee36a5483cbdbc64';
function settings() {

	function store(key, value, callback) {
		chrome.storage.sync.set({key: value}, callback);
	}

	function getGithubToken(callback) {

	}

	return {
		'getGithubToken': getGithubToken
	};
}

module.exports = settings(); 
