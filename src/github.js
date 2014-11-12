function github(accessToken) {
    var $ = require('jquery'),
        moment = require('moment'),
        constants = require('./constants');

    var API = {};

    API.githubToken = accessToken;

    function _requestAuthed(requestType, url, data){
        data = data || {};
        data.timestamp = new Date().getTime();
        data.access_token = API.githubToken;

        return $.ajax({
            type: requestType,
            url: url,
            data: data
        });
    }

    function _request(requestType, url, data){
        data = data || {};
        data.timestamp = new Date().getTime();

        return $.ajax({
            type: requestType,
            url: url,
            data: data
        });
    }

    function getPullRequest(url) {
        return _requestAuthed(constants.http.get, url);
    }
    API.getPullRequest = getPullRequest; 

    function getNotifications(all, reason) {
        var dfd = new $.Deferred(),
            startDate = moment().subtract(1, 'month').toISOString();

        var data = {
            all: all,
            since: startDate
        };

        return _requestAuthed(constants.http.get, constants.githubUrl + 'notifications', data);
    }
    API.getNotifications = getNotifications; 

    function getUrl(url) {
        return _requestAuthed(constants.http.get, url, data);
    }

    function verifyUserToken() {
        return _requestAuthed(constants.http.get, constants.githubUrl + 'user');
    }
    API.verifyUserToken = verifyUserToken;

    // TODO Check for FYI. 
    function getActionsNeeded(comments, userId) {
        var plusOneNeeded = true;
        var plusOneComment,
            atMentionedComment; 

        for (var i=0; i < comments.length; i++) {
            if (comments[i].body.indexOf('@' + userId) > 0) {
                plusOneNeeded = true;
                atMentionedComment = comments[i]; 
            } else if (plusOneNeeded && comments[i].user.login === userId) {
                if (comments[i].body.indexOf('+1') >= 0) {
                    // can get the plus on date here!
                    // action needed maybed?
                    plusOneNeeded = false;
                    plusOneComment = comments[i];
                }
            }
        }

        return {
            'plusOneComment': plusOneComment,
            'plusOneNeeded': plusOneNeeded,
            'atMentionedComment': atMentionedComment
        };
    }
    API.getActionsNeeded = getActionsNeeded; 

    // TODO only check the comments since the VERY last commit (use updated_at?)
    function isPlusOneNeeded(commentsUrl, userId) {
        var dfd = new $.Deferred();
        var atMentionedComment,
            plusOneComment,
            data = {'per_page': 100}; 

        _requestAuthed(constants.http.get, commentsUrl, data).done(function(comments){
            var actions = getActionsNeeded(comments, userId);
            dfd.resolve(actions);
        });
        return dfd.promise();
    }
    API.isPlusOneNeeded = isPlusOneNeeded;

    function getUsersRepos(){
        return _requestAuthed(constants.http.get, constants.githubUrl + 'user/repos');
    }
    API.getUsersRepos = getUsersRepos; 

    function getUserPullRequests(url) {
        var params = {'state': 'open'};
        return _requestAuthed(constants.http.get, url, params);
    }
    API.getUserPullRequests = getUserPullRequests;


    // https://api.github.com/repos/bradybecker-wf/wf-home-html/pulls?access_token=29ed73c4694450b7b11c864484806856fd2a3490

    return API;

}


module.exports = github; 
