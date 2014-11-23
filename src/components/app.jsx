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
    EmptyList = require('./emptyList'),
    Footer = require('./footer'),
    moment = require('moment');

var divStyle = {
  'height': '400px',
  'overflowY':'scroll',
  'width': '100%',
  'backgroundColor': '#FBFBFB'
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
            that.setState({
                'viewObjects': data,
                'loading': false,
                'updatedDate': updatedDate
            });
        });
    },

    render: function () {
        var that = this,
            pullRequests; 
        /* jshint ignore:start */
        if (this.state.loading) {
            pullRequests = <Loading />; 
        } else {
            pullRequests = this.state.viewObjects.map(function (viewObject) {
                return (<PullRequest notification={viewObject.notification} key={viewObject.pullRequest.id} pullRequest={viewObject.pullRequest} commentInfo={viewObject.commentInfo}/>);
            });
            pullRequests = pullRequests.length > 0 ? pullRequests : <EmptyList/>; 
        }

    	return	(<div>
            <Header/>
            <div style={divStyle}> {pullRequests} </div>
            <Footer lastUpdatedDate={that.state.updatedDate}/>
        </div>);
        /* jshint ignore:end */

    }
});

function render() {
    // let it roll
    React.render(<App />,document.getElementById('app'));
}
App.render = render; 


module.exports = window.App = App;