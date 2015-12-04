library src.components.chaser_container;

import 'package:react/react.dart' as react;
import 'package:web_skin_dart/ui_components.dart';
import 'package:web_skin_dart/ui_core.dart' show Dom;
import 'package:w_flux/w_flux.dart';

import 'package:wChaser/src/models/models.dart';
import 'package:wChaser/src/actions/actions.dart';
import 'package:wChaser/src/stores/at_mention_store.dart';
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
  AtMentionStore get atMentionStore => props['atMentionStore'];
  List<GitHubPullRequest> get pullRequests => state['pullRequests'];

  getInitialState() {
    return {'pullRequests': atMentionStore.atMentionPullRequests};
  }

  getStoreHandlers() {
    return {
      atMentionStore: (_) {
        setState({'pullRequests': atMentionStore.displayAtMentionPullRequests});
      }
    };
  }

  renderChaserCore() {
    return [
      Header({'actions': chaserActions, 'loading': atMentionStore.displayAtMentionPullRequests == null}),
      AtMentions({'pullRequests': state['pullRequests'], AtMentionActions.NAME: chaserActions.atMentionActions}),
      Footer({AtMentionStore.NAME: atMentionStore, actions: chaserActions})
    ];
  }

  onLogin(String ghToken) {
    chaserActions.authActions.auth(ghToken);
  }

  render() {
    return (Dom.div()..className='chaser-container')(
      Login({'onLogin': onLogin})
    );
  }
}
