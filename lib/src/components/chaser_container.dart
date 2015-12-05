library src.components.chaser_container;

import 'package:react/react.dart' as react;
import 'package:web_skin_dart/ui_components.dart';
import 'package:web_skin_dart/ui_core.dart' show Dom;
import 'package:w_flux/w_flux.dart';

import 'package:wChaser/src/models/models.dart';
import 'package:wChaser/src/actions/actions.dart';
import 'package:wChaser/src/stores/chaser_stores.dart';
import 'package:wChaser/src/components/header.dart';
import 'package:wChaser/src/components/login.dart';
import 'package:wChaser/src/components/at_mentions.dart';
import 'package:wChaser/src/components/footer.dart';

Map<String, dynamic> divStyle = {
  'height': '400px',
  'overflowY': 'scroll',
  'width': '100%',
  'backgroundolor': '#FBFBFB'
};

var ChaserContainer = react.registerComponent(() => new _ChaserContainer());

class _ChaserContainer extends FluxComponent {
  ChaserActions get chaserActions => props['actions'];
  ChaserStores get chaserStores => props['store'];
  AtMentionStore get atMentionStore => chaserStores.atMentionStore;

  redrawOn() => [chaserStores.userStore, chaserStores.atMentionStore];

  getInitialState() {
    return {'pullRequests': atMentionStore.atMentionPullRequests};
  }

  renderChaserCore() {
    return [
      Header({'actions': chaserActions, 'loading': atMentionStore.displayAtMentionPullRequests == null}),
      AtMentions({'pullRequests': atMentionStore.displayAtMentionPullRequests, AtMentionActions.NAME: chaserActions.atMentionActions}),
      Footer({AtMentionStore.NAME: atMentionStore, 'actions': chaserActions})
    ];
  }

  renderLogin() {
    return [
      Header({'loading': true}),
      Login({'actions':chaserActions})
    ];
  }

  renderLoading() {
    return [
      Header({'loading': true}),
      react.div({'className': 'text-center', 'style': {'margin': '154px'}}, [
        react.img({
          'className': 'text-center github-title pointer',
          'src': '/packages/wChaser/images/octocat-spinner-32.gif',
        })
      ])
    ];
  }

  render() {
    if (!chaserStores.userStore.isReady) {
      return (Dom.div()..className='chaser-container')(renderLoading());
    }

    return (Dom.div()..className='chaser-container')(
      chaserStores.userStore.authed ? renderChaserCore() : renderLogin()
    );
  }
}
