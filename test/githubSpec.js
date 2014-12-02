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

var hiddenPrs = [{"id":24471515,"timeStamp":1416608952560}];


