function github(accessToken) {
    var $ = require('jquery'),
        moment = require('moment'),
        constants = require('./constants');

    var API = {};

    API.githubToken = accessToken;

    //TODO get access token here
    function _requestAuthed(requestType, url, data){
        data = data || {};
        data['timestamp'] = new Date().getTime();
        data['access_token'] = API.githubToken;

        return $.ajax({
            type: requestType,
            url: url,
            data: data
        });
    }

    //TODO get access token here
    function _request(requestType, url, data){
        data = data || {};
        data['timestamp'] = new Date().getTime();

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

    // TODO make sure this isn't called a bazillion times
    // TODO only check the comments since the VERY last commit (use updated_at?)
    function isPlusOneNeeded(commentsUrl, userId) {
        var dfd = new $.Deferred();
        var plusOneNeeded = true,
            atMentionedComment,
            plusOneComment,
            data = {}; 

        _requestAuthed(constants.http.get, commentsUrl, data).done(function(comments){
            for (var i=0; i < comments.length; i++) {
                // and author is the opener of the PR
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
            dfd.resolve({
                'plusOneComment': plusOneComment,
                'plusOneNeeded': plusOneNeeded,
                'atMentionedComment': atMentionedComment
            });
        });
        return dfd.promise();
    }
    API.isPlusOneNeeded = isPlusOneNeeded;

    // function getUsersRepos(){
    //     https://api.github.com/user/repos?access_token=29ed73c4694450b7b11c864484806856fd2a3490
    // }

    // https://api.github.com/repos/bradybecker-wf/wf-home-html/pulls?access_token=29ed73c4694450b7b11c864484806856fd2a3490

    return API;

}


module.exports = github; 
