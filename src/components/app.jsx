/** @jsx React.DOM */
var React = require('react/addons'),
	PullRequest = require('./pullRequest'),
    github = require('../github'),
    constants = require('../constants');

var divStyle = {
  'height': '400px',
  'overflow-y':'scroll'
};

var App = React.createClass({

    render: function () {
        var pullRequests = this.props.viewObjects.map(function (viewObject) {
            return (<PullRequest notification={viewObject.notification} pullRequest={viewObject.pullRequest}/>);
        });
    	
    	return	<div style={divStyle}> {pullRequests} </div>
    }
});

// let it roll
App.start = function (viewObjects) {
    React.renderComponent(<App viewObjects={viewObjects}/>, document.getElementById('app'));
};

module.exports = window.App = App;