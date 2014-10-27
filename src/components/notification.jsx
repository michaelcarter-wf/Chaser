/** @jsx React.DOM */
var React = require('react/addons'),
	github = require('../github'),
	moment =require('moment');

var badgeStyle = {}; 

var Notification = React.createClass({

	getInitialState: function () {
		var unread = this.props.notification.unread ? 'unread': '';

		if (this.props.notification.unread){
			badgeStyle = {'color':'red'};
		}

		return {
			notifications: [],
			pullRequest: null,
			unread: unread,
			badgeText: ''
		};
	},

    componentDidMount : function(){
    	github.setToken(this.props.githubToken);
    	var that = this;
    	// get the pull request
		github.getUrl(this.props.notification.subject.url).done(function(pullRequest){
			if (pullRequest.state === 'open') {
				that.setState({'pullRequest': pullRequest});
				
				if (!that.state.unread.length) {
					that.isPlusOneNeeded(pullRequest.comments_url); 
				} else {
					that.setState({'badgeText': that.state.unread + ' '});
				}
			}
		});

    },

    isPlusOneNeeded : function(url) {
    	var that = this;
		chrome.storage.local.get('login', function(results){
			github.isPlusOneNeeded(url, results.login).done(function(plusOneNeeded){
				var text = plusOneNeeded ? '+1 needed ': '';
				that.setState({'badgeText': text});
			});
		});
    },

    // need a chrome API file
    openNewTab : function(){
		chrome.tabs.create({ url: this.state.pullRequest.html_url });
    },

    render: function () { 
    	var that = this; 
    	if (this.state.pullRequest) {
	    	var pr = this.state.pullRequest;

	        return <div className="media" onClick={this.openNewTab}>
			  <span className="pull-left">
			    <img className="media-object avatar-image" src={pr.head.user.avatar_url} alt="avatar_url"/>
			  </span>
			  <div className="media-body">
			    <h5 className="media-heading">{ pr.title } <small className='created-date' style={badgeStyle}>{ this.state.badgeText }</small> </h5>
			    <small className="created-date">{moment.utc(pr.created_at).fromNow()} | last updated: {moment.utc(pr.updated_at).fromNow()}</small>
			  </div>
			</div>
    	} else {
    		return false;
    	}
    }
});

module.exports = Notification;