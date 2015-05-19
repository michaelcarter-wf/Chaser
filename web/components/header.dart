library header;

import 'package:react/react.dart' as react;
import 'package:web_skin_react/web_skin_react.dart' show DropdownButton, MenuItem;

var Header = react.registerComponent(() => new _Header());

var buttonStyle = {
  'padding': '8px 0px 0px 0px',
  'fontSize': '11px'
};

var fontSize = {
  'fontSize': '11px'
};

class _Header extends react.Component {

  getInitialState() {
    return {
      'userLogin': 'Big Fella'
    };
  }

  render() {
    print(DropdownButton);
    var title = 'link';
    return (
        react.div({'className':'header'}, [
          react.div({'className':'col-xs-4'}, [
            DropdownButton({'style':buttonStyle, 'bsStyle':title.toLowerCase(), 'title':state['userLogin']}, [
              MenuItem({'style':fontSize, 'eventKey':'atMentions'}, '@Mentions'),
              MenuItem({'style':fontSize, 'eventKey':'myPullRequests'}, 'Pull Requests')
            ])
          ]),
          react.div({'className':'col-xs-4 text-center'}, [
            react.img({'className': 'text-center github-title pointer', 'src': 'src/images/github.png'})
          ]),
          react.div({'className':'col-xs-4 text-center'}, [
            react.button({'className': 'btn btn-default btn-xs pull-right refresh-btn'}, [
              react.span({'className':'glyphicon glyphicon-refresh'})
            ])
          ])
        ])
    );
  }

}