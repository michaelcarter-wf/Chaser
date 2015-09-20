library src.components.header;

import 'package:react/react.dart' as react;
import 'package:web_skin_dart/ui_components.dart';
import 'package:web_skin_dart/ui_core.dart' show Dom;


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
    var dropDownMenu = DropdownMenu()([
      MenuItem()('Binders'),
      MenuItem()('Certifications'),
      MenuItem()('Section 16'),
      MenuItem()('XBRL'),
    ]);

    var refreshIcon = (Icon()..glyph = IconGlyph.REFRESH)();
    var refresh = (Button()
      ..skin = ButtonSkin.DEFAULT
      ..size = ButtonSize.XSMALL
      ..className = 'pull-right refresh-btn')
    (refreshIcon);

    var title = 'link';
    return (
        react.div({'className':'header'}, [
          react.div({'className':'col-xs-4'}, [
            (DropdownButton()
              ..skin = ButtonSkin.LINK
              ..title = 'UserNAme'
            )
            (dropDownMenu)
          ]),
          react.div({'className':'col-xs-4 text-center'}, [
            react.img({'className': 'text-center github-title pointer', 'src': '/packages/wChaser/images/github.png'})
          ]),
          react.div({'className':'col-xs-4 text-center'}, [
            refresh
          ])
        ])
    );
  }

}