/** @jsx React.DOM */
var React = require('react/addons'),
	github = require('../github'),
	Notification = require('./notification');

var divStyle = {
  'height': '400px',
  'overflow-y':'scroll'
};

var PR = React.createClass({

	getInitialState: function () { 
		return {
			notifications: [],
			loading: true,
			githubToken: this.props.githubToken
		};
	},

    componentDidMount : function(){
    	var that = this; 
    	var newNotifications = [];
    	github.setToken(this.props.githubToken);
		github.getNotifications(true).done(function( notifications ) {
			for (var i=0; i < notifications.length; i++){
				if (notifications[i].reason === 'mention') {
					newNotifications.push(notifications[i]);
				}
			}
			that.setState({
				'notifications': newNotifications,
				'loading': false
			});
		});
    },

    render: function () {
    	var that = this; 
    	var loading = <div className="progress">
  			<div className="progress-bar progress-bar-striped active"  role="progressbar" aria-valuenow="45" aria-valuemin="0" aria-valuemax="100" style={{'width': '100%'}}>
  			</div>
		</div>;

	    var notificationNodes = this.state.loading ? loading : this.state.notifications.map(function (notification) {
	    	return (<Notification githubToken={that.props.githubToken} notification={notification} />);
	    });

        return (<div style={divStyle}> 
        	{notificationNodes}
        </div>);
    }
});

module.exports = PR;