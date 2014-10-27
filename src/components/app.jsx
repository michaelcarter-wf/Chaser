/** @jsx React.DOM */
var React = require('react/addons'),
	PR = require('./pr'),
    github = require('../github');

var githubToken = 'e7e66722a80a5cd4815e8dafee36a5483cbdbc64';
var _githubTokenKey = 'github',
    _userKey = 'login';

var App = React.createClass({
	getInitialState: function () {
		return {
			githubToken: '',
			loading: true,
            githubTokenValid: false
		};
	},

    componentDidMount : function(){
    	var that = this; 
    	// check for the stored github token
    	chrome.storage.local.get(_githubTokenKey, function(results){
    		if (results[_githubTokenKey].length) {
    			that.setState({
                    'githubToken': results[_githubTokenKey],
                    'githubTokenValid': true
                });
    		} else {
    			that.setState({loading: false});
    		}
		}); 
    },

    handleChange : function(e){
        var newState = this.state; 
        newState[e.currentTarget.id] = e.currentTarget.value;
        newState['disabled'] = e.currentTarget.value.length ? true : false;  
        this.setState(newState);
    },

    handleSubmit : function(e){
        var storage = chrome.storage.local;

        var that = this; 
        function onSuccess(success) {
            var obj= {};
            obj[_githubTokenKey] = that.state.githubToken;
            obj[_userKey] = success.login;
            storage.set(obj);                
            that.setState({
                'githubToken': that.state.githubToken,
                'githubTokenValid': true
            });
        }

        function onError(error) {
            that.setState({'error': error.responseJSON.message});
        }

        var newState = this.state;
        github.verifyUserToken(this.state.githubToken).then(onSuccess, onError);
        
    },

    render: function () {
        var errorNode ='';
        if (this.state.error) {
            errorNode = <div className="alert alert-danger text-center" role="alert"> {this.state.error}</div>
        }

    	if (!this.state.githubTokenValid){
			return (<div>
                {errorNode}
        	   <div className="form-group">
                <label className="sr-only" for="githubToken">Github Token</label>
                <input className="form-control" id="githubToken" placeholder="Enter Gitub Token" onInput={this.handleChange} />                
              </div>
              <button type="submit" className="btn btn-primary pull-right" onClick={this.handleSubmit}>Submit</button>
        	</div>); 
    	} else {
    		return	<PR githubToken={this.state.githubToken}/>
    	}
    }
});

// let it roll
App.start = function () {
    React.renderComponent(<App/>, document.getElementById('app'));
};

module.exports = window.App = App;