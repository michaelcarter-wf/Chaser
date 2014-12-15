/** @jsx React.DOM */
var React = require('react/addons'),
	Github = require('../github'),
	moment =require('moment'),
	constants = require('../constants'),
	chromeApi = require('../chrome'),
	Actions = require('../actions'),
	OverlayTrigger = require('react-bootstrap/OverlayTrigger'),
	Button = require('react-bootstrap/Button'),
	Tooltip = require('react-bootstrap/Tooltip');

var badgeStyle = {'color':'red'};
var mediaWidth = {'width': '70%'};

var cx = React.addons.classSet;

var PullRequest = React.createClass({
	
	getInitialState: function () {
		var newState = {};
		newState['unread'] = this.props.notification ? this.props.notification.unread : false; 
		newState['accessToken'] = ''; 
		if (this.props.commentInfo) {
			newState['badgeText'] = this.props.commentInfo.plusOneNeeded ? 'Action Needed ': '';
		}
		newState['redX'] = false; 

		return newState;
	},

    // need a chrome API file
    openNewTab : function(){
		chrome.tabs.create({ url: this.props.pullRequest.html_url });
    },

    handleHover : function(){
    	this.setState({'redX': !this.state.redX});
    },

    removeThisGuy : function(){
    	Actions.hidePR(this.props.pullRequest.id);
    },

    // check for last commit for updated
    render: function () { 
		var redX = cx({
			'red': this.state.redX,
			'glyphicon': true,
			'glyphicon-remove': true,
			'x-small-text': true
		});

    	var that = this,
    		pr = this.props.pullRequest;
    		var toolTip; 
    		if (this.props.commentInfo && this.props.commentInfo.atMentionedComment) {
    			toolTip = <Tooltip> {this.props.commentInfo.atMentionedComment.body} </Tooltip>
    		}

	        return <OverlayTrigger placement="bottom" overlay={toolTip}>
	        <div className="media">
			  <span className="pull-left" onClick={this.openNewTab}>
			  		<img className="media-object avatar-image" src={pr.head.user.avatar_url} alt="avatar_url"/>
			  </span>
			  <div className="media-body pull-left" style={mediaWidth} onClick={this.openNewTab}>
			  		<small className="small-text created-date"><em>{pr.base.repo.full_name}</em></small>
			    	<h6 className="media-heading">
						{ pr.title } <br/>
			    		<small className="small-text">
			    			updated {moment.utc(pr.updated_at).fromNow()} <span style={badgeStyle}> {this.state.badgeText} {this.state.unread} </span>
			    		</small>
			    	</h6>
			  </div>
			  <div className='pull-right' onMouseOver={this.handleHover} onMouseOut={this.handleHover} onClick={this.removeThisGuy}><i className={redX}></i></div>
			  <div className='pull-right'><small className='small-text'>{moment.utc(pr.created_at).format('MM/DD')} </small></div>
			</div>
			</OverlayTrigger>
    }
});

module.exports = PullRequest;