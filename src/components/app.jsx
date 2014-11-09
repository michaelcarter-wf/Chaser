/** @jsx React.DOM */
var React = require('react/addons'),
    PullRequest = require('./pullRequest'),
    constants = require('../constants'),
    viewService = require('../viewService'),
    chromeApi = require('../chrome'),
    Reflux = require('reflux'),
    ViewOjectStore = require('../stores/viewOjectStore'),
    Header = require('./header'),
    Loading = require('./loading'),
    Footer = require('./footer');

var divStyle = {
  'height': '400px',
  'overflow-y':'scroll',
  'width': '100%',
  'background-color': '#FBFBFB'
};

var App = React.createClass({
    mixins: [Reflux.ListenerMixin],
    getInitialState: function() {
        return {
            'viewObjects': this.props.viewObjects,
            'loading': false,
            'showOnlyActionNeeded': true
        };
    },

    componentDidMount: function() {
        ViewOjectStore.listen(this.refreshList);
    },

    refreshList: function(){
        var that = this; 
        that.setState({
            'viewObjects': [],
            'loading': true
        });
        chromeApi.get(constants.githubTokenKey, function(results) {
            if (results[constants.githubTokenKey].length) {
                viewService.prepViewObjects(results[constants.githubTokenKey], function(newViewObjects) {
                    that.setState({
                        'viewObjects': newViewObjects,
                        'loading': false
                    });
                    var actionItems = 0;
                    for (var i = 0; i < newViewObjects.length; i++) {
                        if (newViewObjects[i].commentInfo.plusOneNeeded) {
                            actionItems++;
                        }
                    }
                    chrome.browserAction.setBadgeText({
                        'text': actionItems.toString()
                    });
                });
            }
        });
    },

    render: function () {
        /* jshint ignore:start */
        var pullRequests = this.state.loading ? <Loading/> : this.state.viewObjects.map(function (viewObject) {
                return (<PullRequest notification={viewObject.notification} pullRequest={viewObject.pullRequest} commentInfo={viewObject.commentInfo}/>);
            });

    	return	<div>
            <Header/>
            <div style={divStyle}> {pullRequests} </div>
            <Footer/>
        </div>
        /* jshint ignore:end */

    }
});

// let it roll
App.start = function (viewObjects) {
    /* jshint ignore:start */
    React.renderComponent(<App viewObjects={viewObjects}/>, document.getElementById('app'));
    /* jshint ignore:start */
};

module.exports = window.App = App;