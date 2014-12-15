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
    moment = require('moment'),
    OverlayTrigger = require('react-bootstrap/OverlayTrigger'),
    Button = require('react-bootstrap/Button'),
    Tooltip = require('react-bootstrap/Tooltip');

var divStyle = {
  'height': '400px',
  'overflowY':'scroll',
  'width': '100%',
  'backgroundolor': '#FBFBFB'
};

var AtMentions = React.createClass({
    mixins: [Reflux.ListenerMixin],
    getInitialState: function() {
        return {
            'viewObjects': [],
            'loading': true,
            'showOnlyActionNeeded': true,
            'updatedDate': ''
        };
    },

    componentWillMount: function() {
        ViewObjectStore.init(constants.views.atMentions);
    },

    componentDidMount: function() {
        ViewObjectStore.listen(this.refreshList);
    },

    refreshList: function(data){
        var that = this;
        // get the most recent updated date
        // TODO update the constants value to each corresponding list...
        // unless we just updated both when that button is pushed...meh, why not
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
            <div style={divStyle}> {pullRequests} </div>
            <Footer lastUpdatedDate={that.state.updatedDate} leftCol={true}/>
        </div>);
        /* jshint ignore:end */

    }
});

function render() {
    // let it roll
    React.render(<AtMentions />,document.getElementById('app'));
}
AtMentions.render = render; 


module.exports = AtMentions;