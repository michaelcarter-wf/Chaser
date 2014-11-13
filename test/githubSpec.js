var responses = require('./githubResponses'),
	Github= require('../src/github'),
	prs = require('./userPullRequests'),
	gutil = require('gulp-util');


var github = Github();

describe("getActionsNeeded", function() {
  it("should say a plus one isnt needed", function() {
    expect(github.getActionsNeeded(responses.comments, 'bradybecker-wf').plusOneNeeded).toBe(false);
  });
});


describe('should sort array', function(){
	for (var i=0; i<prs.length; i++) {
		if (prs[i]) {
			gutil.log(Date.parse(prs[i].created_at));
		}
	}

});