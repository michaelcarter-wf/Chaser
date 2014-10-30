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
		github.setToken(this.props.githubToken);
		return {
			notifications: [],
			loading: true,
			githubToken: this.props.githubToken
		};
	},

    componentDidMount : function(){
    	var that = this; 
		github.getNotifications(true, 'mention').done(function( notifications ) {
			that.setState({
				'notifications': notifications,
				'loading': false
			});
		});
    },

    render: function () {
    	var that = this; 
    	var loading = <div className="progress text-center">
        	<img src="../src/images/octocat-spinner-32.gif"/>
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