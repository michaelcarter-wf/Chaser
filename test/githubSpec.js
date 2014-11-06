var responses = require('./githubResponses'),
	Github= require('../src/github');

var github = Github();

describe("getActionsNeeded", function() {
  it("should say a plus one isnt needed", function() {
  	console.log(github.getActionsNeeded(responses.comments, 'bradybecker-wf'));
    expect(github.getActionsNeeded(responses.comments, 'bradybecker-wf').plusOneNeeded).toBe(false);
  });
});