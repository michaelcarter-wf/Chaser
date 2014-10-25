/** @jsx React.DOM */
var React = require('react/addons'),
	$ = require('jquery'),
	github = require('../github');

var badgeStyle = {}; 

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

	        return <li className="list-group-item">
	        	  <h5 className="list-group-item-heading"><a href='#' onClick={this.openNewTab}>{ pr.title }</a></h5>
	        	  <ul className="list-inline">
	        	  	  <li><small><em>{ pr.head.user.login }</em></small></li>
	        	  	  <li><small className="badge" style={badgeStyle}>{ this.state.unread }</small> </li>
	        	  </ul>
	        </li>
    	} else {
    		return false;
    	}
    }
});

module.exports = Notification;