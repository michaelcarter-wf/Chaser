/** @jsx React.DOM */
var React = require('react/addons'),
	Github = require('../github'),
	moment =require('moment'),
	constants = require('../constants'),
	chromeApi = require('../chrome');

var badgeStyle = {'color':'red'}; 

var PullRequest = React.createClass({
	
	getInitialState: function () {
		var unread = this.props.notification.unread; 
		return {
			'badgeText': '',
			'unread': unread,
			'accessToken': ''
		};
	},

	componentDidMount : function(){
		var that = this; 
		chromeApi.get(constants.githubTokenKey, function(results) {
			if (results[constants.githubTokenKey].length) {
				that.isPlusOneNeeded(that.props.pullRequest.comments_url, results[constants.githubTokenKey]);
			}
		});
    },

    isPlusOneNeeded : function(url, accessToken) {
    	var that = this,
    		github = Github(accessToken);

		chromeApi.get('login', function(results){
			github.isPlusOneNeeded(url, results.login).done(function(result){
				var plusOneNeeded = result.plusOneNeeded ? '+1 needed ': '';
				that.setState({'badgeText': plusOneNeeded});
			});
		});
    },

    // need a chrome API file
    openNewTab : function(){
		chrome.tabs.create({ url: this.props.pullRequest.html_url });
    },

    // check for last commit for updated
    render: function () { 
    	var that = this,
    		pr = this.props.pullRequest,
    		note = this.props.notification;

	        return <div className="media" onClick={this.openNewTab}>
			  <span className="pull-left">
			    <img className="media-object avatar-image" src={pr.head.user.avatar_url} alt="avatar_url"/>
			  </span>
			  <div className="media-body">
			    <h5 className="media-heading">{ pr.title } <small className='created-date' style={badgeStyle}> {this.state.badgeText} {this.state.unread} </small> </h5>
			    <small className="created-date">{moment.utc(pr.created_at).fromNow()} | updated {moment.utc(pr.updated_at).fromNow()}</small>
			  </div>
			</div>
    }
});

module.exports = PullRequest;