/** @jsx React.DOM */
var React = require('react/addons'),
	PullRequest = require('./pullRequest'),
    github = require('../github'),
    constants = require('../constants'),
    viewService = require('../ViewService'),
    chromeApi = require('../chrome');

var divStyle = {
  'height': '400px',
  'overflow-y':'scroll',
  'width': '100%'
};

var App = React.createClass({
    getInitialState: function () {
        return {
            'viewObjects': this.props.viewObjects
        };
    },

    refreshList: function(){
        var that = this; 
        chromeApi.get(constants.githubTokenKey, function(results) {
            if (results[constants.githubTokenKey].length) {
                viewService.prepViewObjects(results[constants.githubTokenKey], function(newViewObjects){
                    that.setState({'viewObjects': newViewObjects});
                });
            }
        });
    },

    render: function () {
        var pullRequests = this.state.viewObjects.map(function (viewObject) {
            return (<PullRequest notification={viewObject.notification} pullRequest={viewObject.pullRequest}/>);
        });
    	
    	return	<div>
        <div className='header'>
            <div className='col-xs-4'></div>
            <div className='col-xs-4 text-center'>
                <img className="text-center github-title" src="src/images/github.png"/>
            </div>
            <div className='col-xs-4'>
                <button className="btn btn-default btn-xs pull-right refresh-btn" onClick={this.refreshList}>
                    <span className="glyphicon glyphicon-refresh"></span>
                </button>
            </div>
        </div>
        <div style={divStyle}> {pullRequests} </div>
        </div>
    }
});

// let it roll
App.start = function (viewObjects) {
    React.renderComponent(<App viewObjects={viewObjects}/>, document.getElementById('app'));
};

module.exports = window.App = App;