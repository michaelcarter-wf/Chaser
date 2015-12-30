/** @jsx React.DOM */
var React = require('react/addons'),
    PullRequest = require('./pullRequest'),
    constants = require('../constants'),
    chromeApi = require('../chrome'),
    Reflux = require('reflux'),
    ViewObjectStore = require('../stores/ViewObjectStore'),
    Actions = require('../actions'),
    Loading = require('./loading'),
    EmptyList = require('./emptyList'),
    Footer = require('./footer'),
    moment = require('moment');

var divStyle = {
  'height': '400px',
  'overflowY':'scroll',
  'width': '100%',
  'backgroundolor': '#FBFBFB'
};

var MyPullRequests = React.createClass({
    mixins: [Reflux.ListenerMixin],
    getInitialState: function() {
        return {
            'viewObjects': ViewObjectStore.pullRequests || [],
            'loading': true,
            'showOnlyActionNeeded': true,
            'updatedDate': ''
        };
    },

    componentWillMount: function() {
        ViewObjectStore.init(constants.views.pullRequests);
    },

    componentDidMount: function() {
        ViewObjectStore.listen(this.refreshList);
    },

    refreshList: function(data){
        var that = this;
        // get the most recent updated date
        chromeApi.get(constants.lastUpdatedDate, function(result) {
            var updatedDate = result[constants.lastUpdated] || moment().format(); 
            that.setState({
                'viewObjects': data,
                'loading': false,
                'updatedDate': updatedDate
            });
        });
    },

    handleKeyPress: function(key) {
        console.log(key);
    },

    render: function () {
        var that = this,
            pullRequests; 
        /* jshint ignore:start */
        if (this.state.loading) {
            pullRequests = <Loading />; 
        } else {
            pullRequests = this.state.viewObjects.map(function (viewObject) {
                return (
                    <PullRequest 
                        notification={viewObject.notification} 
                        key={viewObject.pullRequest.id} 
                        pullRequest={viewObject.pullRequest} 
                        commentInfo={viewObject.commentInfo}/>
                );
            });
            pullRequests = pullRequests.length > 0 ? pullRequests : <EmptyList/>; 
        }

    	return	(<div>
            <div style={divStyle} onKeyPress={that.handleKeyPress}> {pullRequests} </div>
            <Footer lastUpdatedDate={that.state.updatedDate}/>
        </div>);
        /* jshint ignore:end */

    }
});


module.exports = MyPullRequests;