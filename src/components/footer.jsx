/** @jsx React.DOM */
var React = require('react/addons'),
    constants = require('../constants'),
    chromeApi = require('../chrome'),
    Actions = require('../actions'),
    moment = require('moment'),
    StatusStore = require('../stores');

var Footer = React.createClass({

    getInitialState: function () {
        return {
            'lastUpdated': '',
        };
    },

    onRefresh: function(info) {
        this.setState({'lastUpdated': info});
    },

    componentDidMount: function() {
        var that = this; 
        chromeApi.get(constants.lastUpdated, function(results) {
            that.onRefresh(results[constants.lastUpdated]); 
        }); 
    },

    refreshList: function(){
        Actions.refresh();
    },
    /* jshint ignore:start */
    render: function () {
        var date = this.state.lastUpdated.length ? moment.utc(this.state.lastUpdated).fromNow() : ''; 

        return <div className='footer'>
            <div className='col-xs-6'>
                <button className="btn btn-default btn-xs pull-left">
                    <span className="glyphicon glyphicon-filter"></span><small> Show Action Needed</small>
                </button>
            </div>
            <div className='col-xs-6'>
                <p className='small-text pull-right'>
                    <em> updated {date} </em><br/>
                </p>
            </div>
            <div className='clear'></div>
        </div>
    }
    /* jshint ignore:end */

});


module.exports = Footer;