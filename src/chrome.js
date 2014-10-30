function ChromeApi() {
	var API = {}; 

	// get an item from local storage by key
	function get(key, callback) {
		chrome.storage.local.get(key, callback); 
	}
	API.get = get; 

	// set an item to local storage
	function set(object, callback) {
		chrome.storage.local.set(object, callback); 	
		return callback
	}
	API.set = set;

	return API; 
}

module.exports = ChromeApi(); 