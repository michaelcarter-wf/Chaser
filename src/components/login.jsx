/** @jsx React.DOM */
var React = require('react/addons'),
    Github = require('../github'),
    constants = require('../constants'),
    viewService = require('../viewService'),
    chromeApi = require('../chrome'),
    Reflux = require('reflux');

var divStyle = {
  'height': '200px',
  'width': '100%',
  'padding': '10px'
};

var Login = React.createClass({
    mixins: [Reflux.ListenerMixin],
    getInitialState: function () {
        return {
            'viewObjects': [],
            'githubTokenValid': false,
            'loading': false
        };
    },

    handleChange : function(e){
        var newState = this.state; 
        newState[e.currentTarget.id] = e.currentTarget.value;
        newState['disabled'] = e.currentTarget.value.length ? true : false;  
        this.setState(newState);
    },

    handleSubmit : function(e){
        var that = this,
            github = Github(that.state.githubToken);

        function onSuccess(success) {
            var obj= {};
            obj[constants.githubTokenKey] = that.state.githubToken;
            obj[constants.userKey] = success.login;
            obj[constants.currentUser] = success;
            
            chromeApi.set(obj);
            that.setState({
                'githubToken': that.state.githubToken,
                'loading': true
            });

            viewService.prepViewObjects(that.state.githubToken, function(results){
                that.setState({
                    'viewObjects': results,
                    'githubTokenValid': true
                });
            });
        }

        function onError(error) {
            that.setState({'error': error.responseJSON.message});
        }

        var newState = this.state;
        github.verifyUserToken().then(onSuccess, onError);
        
    },

    render: function () {
        var errorNode ='';
        if (this.state.error) {
            errorNode = <div className="alert alert-danger text-center" role="alert"> {this.state.error}</div>
        }

        if (!this.state.githubTokenValid){
            return (<div style={divStyle}>
                {errorNode}
               <div className="form-group">
                <label className="sr-only" for="githubToken">Github Token</label>
                <input className="form-control" id="githubToken" placeholder="Enter Gitub Token" onInput={this.handleChange} />                
              </div>
              <button type="submit" className="btn btn-primary pull-right" onClick={this.handleSubmit}>Submit</button>
            </div>); 
        } else {
            return  <App viewObjects={this.state.viewObjects}/>;
        }
    }
});

// let it roll
Login.start = function () {
    React.renderComponent(<Login />, document.getElementById('app'));
};

module.exports = window.Login = Login;