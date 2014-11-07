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
        var that = this; 
        if (info) {
            that.setState({'lastUpdated': info});
        } else {
            chromeApi.get(constants.lastUpdated, function(results) {
                that.setState({'lastUpdated': results[constants.lastUpdated]});
            }); 
        }
    },

    componentDidMount: function() {
        this.onRefresh(); 
        StatusStore.listen(this.onRefresh);
    },

    refreshList: function(){
        Actions.refresh();
    },
    /* jshint ignore:start */
    render: function () {
        var date = this.state.lastUpdated.length ? moment.utc(this.state.lastUpdated).fromNow() : ''; 

        return <div className='text-center footer'>
            <p className='small-text'><em> updated {date} </em><br/><a href='#' onClick={this.refreshList}>refresh</a></p>
        </div>
    }
    /* jshint ignore:end */

});


module.exports = Footer;