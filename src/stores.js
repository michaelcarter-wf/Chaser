var Reflux = require('reflux'),
    actions = require('./actions'),
    moment = require('moment');

// Creates a DataStore
var StatusStore = Reflux.createStore({
    listenables: actions,
    
    // Callback
    onRefresh: function() {
        // Pass on to listeners
        this.trigger(moment().format());
    }

});

module.exports = StatusStore;

