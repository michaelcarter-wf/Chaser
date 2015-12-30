/** @jsx React.DOM */
var React = require('react/addons'),
    Actions = require('../actions');

var style = {
    'width': '100%',
    'textAlign': 'center',
    'paddingTop': '150px'
    };

var Loading = React.createClass({

    refreshList: function(){
        var that = this; 
        Actions.refresh();
    },

    render: function () {
        /* jshint ignore:start */
        return <div style={style}>
            <img src="../src/images/octocat-spinner-32.gif"/>
        </div>
        /* jshint ignore:end */

    }
});


module.exports = Loading;