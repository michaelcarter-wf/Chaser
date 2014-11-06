var Reflux = require('reflux'),
    actions = require('./actions');

// Creates a DataStore
var StatusStore = Reflux.createStore({
    listenables: actions,
    
    // Callback
    onRefresh: function() {
        // Pass on to listeners
        this.trigger(status);
    }

});

module.exports = StatusStore;

