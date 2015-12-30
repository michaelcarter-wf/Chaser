library src.components.header;

import 'package:react/react.dart' as react;
import 'package:web_skin_dart/ui_components.dart';

import 'package:wChaser/src/actions/actions.dart';

var Header = react.registerComponent(() => new _Header());
var buttonStyle = {'padding': '8px 0px 0px 0px', 'fontSize': '11px'};
var fontSize = {'fontSize': '11px'};

class _Header extends react.Component {
  ChaserActions get chaserActions => props['actions'];
  bool get loading => props['loading'];

  getInitialState() {
    return {'userLogin': 'Big Fella'};
  }

  getDefaultProps() => {'loading': false};

  refreshView([e]) {
    chaserActions.locationActions.refreshView();
  }

  render() {
//    react.img(
//          {'className': 'text-center github-title pointer', 'src': '/packages/wChaser/images/octocat-spinner-32.gif',})
    var dropDownMenu = DropdownMenu()(
        MenuItem()('Binders'), MenuItem()('Certifications'), MenuItem()('Section 16'), MenuItem()('XBRL'));

    var refresh = loading ? null : (Button()
      ..skin = ButtonSkin.DEFAULT
      ..size = ButtonSize.XSMALL
      ..onClick = refreshView
      ..className = 'pull-right refresh-btn')((Icon()..glyph = IconGlyph.REFRESH)());

    return (react.div({
      'className': 'header'
    }, [
      react.div({'className': 'col-xs-4'}),
      react.div({'className': 'col-xs-4 text-center'},
          react.img({'className': 'text-center github-title pointer', 'src': '/packages/wChaser/images/github.png'})),
      react.div({'className': 'col-xs-4 text-center'}, refresh)
    ]));
  }
}
