/** @jsx React.DOM */
var React = require('react/addons'),
	Github = require('../github'),
	moment =require('moment'),
	constants = require('../constants'),
	chromeApi = require('../chrome');

var badgeStyle = {'color':'red'}; 

var mediaWidth = {'width': '75%'};

var PullRequest = React.createClass({
	
	getInitialState: function () {
		var unread = this.props.notification.unread,
			badgeText = this.props.commentInfo.plusOneNeeded ? '+1 needed ': '';

		return {
			'badgeText': badgeText,
			'unread': unread,
			'accessToken': ''
		};
	},

    // need a chrome API file
    openNewTab : function(){
		chrome.tabs.create({ url: this.props.pullRequest.html_url });
    },

    // check for last commit for updated
    render: function () { 
    	var that = this,
    		pr = this.props.pullRequest,
    		note = this.props.notification,
    		commentInfo = this.props.commentInfo;


	        return <div className="media" onClick={this.openNewTab}>
			  <span className="pull-left">
			    <img className="media-object avatar-image" src={pr.head.user.avatar_url} alt="avatar_url"/>
			  </span>
			  <div className="media-body pull-left" style={mediaWidth}>
			  <small className="small-text created-date"><em>{pr.base.repo.full_name}</em></small>
			    <h6 className="media-heading">
					{ pr.title } <br/>
			    	<small className="small-text">
			    		updated {moment.utc(pr.updated_at).fromNow()} <span style={badgeStyle}> {this.state.badgeText} {this.state.unread} </span>
			    	</small>
			    </h6>
			  </div>
			  <div className='pull-left'><small className='small-text'>{moment.utc(pr.created_at).format('MM/DD')} </small></div>
			</div>
    }
});

module.exports = PullRequest;