library src.components.chaser_container;

import 'dart:html';

import 'package:react/react.dart' as react;
import 'package:web_skin_dart/ui_core.dart' show Dom;
import 'package:w_flux/w_flux.dart';

import 'package:wChaser/src/actions/actions.dart';
import 'package:wChaser/src/stores/chaser_stores.dart';
import 'package:wChaser/src/stores/chaser_store.dart';
import 'package:wChaser/src/components/header.dart';
import 'package:wChaser/src/components/login.dart';
import 'package:wChaser/src/components/loading.dart';
import 'package:wChaser/src/components/chaser_grid.dart';
import 'package:wChaser/src/components/footer.dart';
import 'package:wChaser/src/constants.dart';

var ChaserContainer = react.registerComponent(() => new _ChaserContainer());

class _ChaserContainer extends FluxComponent {
  ChaserActions get chaserActions => props['actions'];
  ChaserStores get chaserStores => props['store'];
  AtMentionStore get atMentionStore => chaserStores.atMentionStore;

  redrawOn() =>
      [chaserStores.userStore, chaserStores.atMentionStore, chaserStores.locationStore, chaserStores.pullRequestsStore];

  getInitialState() {
    return {'pullRequests': atMentionStore.atMentionPullRequests};
  }

  componentDidMount(Element rootNode) {
    window.onKeyDown.listen((KeyboardEvent keyboardEvent) {
      if (keyboardEvent.keyCode == leftArrowKey) {
        chaserActions.locationActions.changeViewPrevious();
      } else if (keyboardEvent.keyCode == rightArrowKey) {
        chaserActions.locationActions.changeViewNext();
      }
    });
  }

  renderChaserCore() {
    ChaserStore chaserStore = null;

    if (chaserStores.locationStore.currentView == ChaserViews.pullRequests) {
      chaserStore = chaserStores.pullRequestsStore;
    } else {
      chaserStore = chaserStores.atMentionStore;
    }

    return [
      Header({'actions': chaserActions, 'loading': atMentionStore.displayPullRequests == null}),
      ChaserGrid({'chaserStore': chaserStore, 'actions': chaserActions}),
      Footer({'chaserStore': chaserStore, 'actions': chaserActions})
    ];
  }

  renderLogin() {
    return [
      Header({'loading': true}),
      Login({'actions': chaserActions})
    ];
  }

  renderLoading() {
    return [
      Header({'loading': true}),
      Loading({})
    ];
  }

  render() {
    if (!chaserStores.userStore.isReady) {
      return (Dom.div()..className = 'chaser-container')(renderLoading());
    }

    return (Dom.div()
      ..className = 'chaser-container')(chaserStores.userStore.authed ? renderChaserCore() : renderLogin());
  }
}
