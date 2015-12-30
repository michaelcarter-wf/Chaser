/** @jsx React.DOM */
var React = require('react/addons'),
    Actions = require('../actions');

var style = {
    'width': '100%',
    'textAlign': 'center',
    'paddingTop': '100px'
    };

var EmptyList = React.createClass({

    refreshList: function(){
        Actions.refresh();
    },

    render: function () {
        /* jshint ignore:start */
        return <div style={style}>
            <h6> I have nothing for ya! </h6>
            <a className='small-text' href='#' onClick={Actions.refresh}>refresh</a>
        </div>
        /* jshint ignore:end */

    }
});


module.exports = EmptyList;