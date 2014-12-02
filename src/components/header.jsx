/** @jsx React.DOM */
var Router = Router = require('react-router');
var React = require('react/addons'),
	PullRequest = require('./pullRequest'),
    github = require('../github'),
    constants = require('../constants'),
    viewService = require('../viewService'),
    chromeApi = require('../chrome'),
    Reflux = require('reflux'),
    Actions = require('../actions'),
    DropdownButton = require('react-bootstrap/DropdownButton'),
    MenuItem = require('react-bootstrap/MenuItem'),
    Link = Router.Link,
    Navigation = Router.Navigation,
    Mousetrap = require('mousetrap');

var buttonStyle = {
    'padding': '8px 0px 0px 0px',
    'fontSize': '11px'
};

var fontSize = {
    'fontSize': '11px'
}

var Header = React.createClass({
    mixins: [Navigation],

    getInitialState: function () {
        return {
            'userLogin': '',
        };
    },

    componentDidMount: function() {
        var that = this;
        chromeApi.get(constants.userKey, function(results) {
            that.setState({'userLogin': results.login});
        });

        Mousetrap.bind(['r'], this.refreshList);
    },

    componentWillUnmount: function() {
        Mousetrap.unbind('r');
    },

    refreshList: function(){
        Actions.refresh();
    },

    //TODO get the count of each list and stick it in the dropdown
    changeView: function(newRoute) {
        this.replaceWith(newRoute);
    },
    
    /* jshint ignore:start */
    render: function () {
        var title = 'link';
        return <div className='header'>
            <div className='col-xs-4'>
                <DropdownButton style={buttonStyle} bsStyle={title.toLowerCase()} title={this.state.userLogin}>
                    <MenuItem style={fontSize} eventKey="atMentions" onSelect={this.changeView}>@Mentions</MenuItem>
                    <MenuItem style={fontSize} eventKey="myPullRequests" onSelect={this.changeView}>Pull Requests</MenuItem>
                </DropdownButton>
            </div>
            <div className='col-xs-4 text-center'>
                <img className="text-center github-title pointer" src="src/images/github.png" onClick={this.refreshList}/>
            </div>
            <div className='col-xs-4'>
                <button className="btn btn-default btn-xs pull-right refresh-btn" onClick={this.refreshList}>
                    <span className="glyphicon glyphicon-refresh"></span>
                </button>
            </div>
        </div>
    }
    /* jshint ignore:end */
});


module.exports = Header;