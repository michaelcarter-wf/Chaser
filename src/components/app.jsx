/** @jsx React.DOM */
var React = require('react/addons'),
    PullRequest = require('./pullRequest'),
    constants = require('../constants'),
    viewService = require('../viewService'),
    chromeApi = require('../chrome'),
    Reflux = require('reflux'),
    StatusStore = require('../stores'),
    Header = require('./header'),
    Loading = require('./loading');

var divStyle = {
  'height': '400px',
  'overflow-y':'scroll',
  'width': '100%'
};


var App = React.createClass({
    mixins: [Reflux.ListenerMixin],
    getInitialState: function () {
        return {
            'viewObjects': this.props.viewObjects,
            'loading': false
        };
    },

    componentDidMount: function() {
        StatusStore.listen(this.refreshList);
    },

    refreshList: function(){
        var that = this; 
        that.setState({
            'viewObjects': [],
            'loading': true
        });
        chromeApi.get(constants.githubTokenKey, function(results) {
            if (results[constants.githubTokenKey].length) {
                viewService.prepViewObjects(results[constants.githubTokenKey], function(newViewObjects){
                    that.setState({
                        'viewObjects': newViewObjects,
                        'loading': false
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
            <Header />
            <div style={divStyle}> {pullRequests} </div>
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