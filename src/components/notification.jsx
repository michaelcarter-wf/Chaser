/** @jsx React.DOM */
var React = require('react/addons'),
	$ = require('jquery'),
	github = require('../github'),
	moment =require('moment');



var badgeStyle = {}; 
var imageStyle = {

}; 

var Notification = React.createClass({

	getInitialState: function () {
		var unread = this.props.notification.unread ? 'unread': '';

		if (this.props.notification.unread){
			badgeStyle = {'background-color':'red'};
		}

		return {
			notifications: [],
			pullRequest: null,
			unread: unread,
		};
	},

    componentDidMount : function(){
    	github.setToken(this.props.githubToken);
    	var that = this;
		github.getPullRequest(this.props.notification.subject.url).done(function(pullRequest){
			if (pullRequest.state === 'open') {
				that.setState({'pullRequest': pullRequest});
			}
		});
    },

    openNewTab : function(){
		chrome.tabs.create({ url: this.state.pullRequest.html_url });
    },

    render: function () {
    	if (this.state.pullRequest) {
	    	var pr = this.state.pullRequest;


	        return <div className="media" onClick={this.openNewTab}>
			  <span className="pull-left">
			    <img className="media-object avatar-image" src={pr.head.user.avatar_url} alt="avatar_url"/>
			  </span>
			  <div className="media-body">
			    <h5 className="media-heading"><small className="badge" style={badgeStyle}>{ this.state.unread }</small> { pr.title } </h5>
			    <small className="created-date">{moment.utc(pr.created_at).fromNow()}</small>
			  </div>
			</div>
    	} else {
    		return false;
    	}
    }
});

module.exports = Notification;