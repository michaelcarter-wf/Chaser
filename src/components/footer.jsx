/** @jsx React.DOM */
var React = require('react/addons'),
    constants = require('../constants'),
    chromeApi = require('../chrome'),
    Actions = require('../actions'),
    moment = require('moment');

var Footer = React.createClass({

    getInitialState: function() {
        return {
            'showAll': true
        }
    },

    componentDidMount: function() {
        var that = this; 
        chromeApi.get('showAll', function(results) {
            var state = true; 
            if (results.hasOwnProperty('showAll')) {
                state = results.showAll;
            } else {
                chromeApi.set({'showAll': true});
            }
            that.setState({'showAll': state});
        });

    },

    refreshList: function() {
        Actions.refresh();
    },

    showActionNeeded: function() {
        var newShowAll = this.state.showAll ? false: true; 
        this.setState({'showAll': newShowAll});
        chromeApi.set({'showAll': newShowAll});
        Actions.showActionNeeded(newShowAll); 
    },

    /* jshint ignore:start */
    render: function () {
        var buttonText = this.state.showAll ? 'Show Few': 'Show All';
        var lastUpdatedDate = moment.utc(this.props.lastUpdatedDate).fromNow();

        return <div className='footer'>
            <div className='small-text text-left col-xs-6'>
                <a href='#' onClick={this.showActionNeeded}>
                    <small> {buttonText}</small>
                </a>
            </div>
            <div className='small-text text-right col-xs-6'>
                <span>
                    <small><em> updated {lastUpdatedDate} </em></small><br/>
                </span>
            </div>
            <div className='clear'></div>
        </div>
    }
    /* jshint ignore:end */

});


module.exports = Footer;