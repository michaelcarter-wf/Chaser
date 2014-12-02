var prs = require('./userPullRequests'),
	gutil = require('gulp-util');

// this will give you all the global vars
var jasGlob = jasmine.getGlobal();

jasGlob.chrome = {
	'get': function(){},
	'set': function(){},
	'storage': {
		'local': {
			'get': function(){},
			'set': function(){}
		}
	}
}; 

describe("getActionsNeeded", function() {
	var viewObjects; 

	beforeEach(function() {
		viewObjects = []; 
		for (var i = 0; i < prs.length; i++) {
			viewObjects.push({
				'pullRequest': prs[i],
			});
		}
	});

	it("should return 4 pullRequests", function() {
		var viewService = require('../src/viewService');
		var test = {"24082522":"2014-11-26T15:20:40-06:00","24016199":"2014-11-26T15:21:09-06:00"};
		var newList = viewService.filterOutHiddenPrs(viewObjects, test);
		expect(newList.length).toBe(4);
	});

});