/** @jsx React.DOM */
var React = require('react/addons'),
    PullRequest = require('./pullRequest'),
    constants = require('../constants'),
    viewService = require('../viewService'),
    chromeApi = require('../chrome'),
    Reflux = require('reflux'),
    ViewObjectStore = require('../stores/ViewObjectStore'),
    Header = require('./header'),
    Loading = require('./loading'),
    Footer = require('./footer'),
    moment = require('moment');

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
            'viewObjects': [],
            'loading': true,
            'showOnlyActionNeeded': true,
            'updatedDate': ''
        };
    },

    componentDidMount: function() {
        var that = this; 
        ViewObjectStore.listen(this.refreshList);
    },

    refreshList: function(data){
        var that = this;
        this.setState({
            'viewObjects': [],
        });
        // get the most recent updated date
        chromeApi.get(constants.lastUpdatedDate, function(result) {
            var updatedDate = result[constants.lastUpdated] || moment().format(); 
            console.log(updatedDate);
            that.setState({
                'viewObjects': data,
                'loading': false,
                'updatedDate': updatedDate
            });
        });
    },

    render: function () {
        var that = this;
        /* jshint ignore:start */
        var pullRequests = this.state.loading ? <Loading/> : this.state.viewObjects.map(function (viewObject) {
                return (<PullRequest notification={viewObject.notification} pullRequest={viewObject.pullRequest} commentInfo={viewObject.commentInfo}/>);
            });

    	return	<div>
            <Header/>
            <div style={divStyle}> {pullRequests} </div>
            <Footer lastUpdatedDate={that.state.updatedDate}/>
        </div>
        /* jshint ignore:end */

    }
});

// let it roll
App.start = function () {
    /* jshint ignore:start */
    React.renderComponent(<App/>, document.getElementById('app'));
    /* jshint ignore:start */
};

module.exports = window.App = App;