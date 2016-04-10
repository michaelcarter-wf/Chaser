library src.components.chaser_app;

import 'dart:html';

import 'package:react/react.dart' as react;
import 'package:w_flux/w_flux.dart';

import 'package:wChaser/src/actions/actions.dart';
import 'package:wChaser/src/components/alert.dart';
import 'package:wChaser/src/services/status_service.dart';
import 'package:wChaser/src/stores/chaser_stores.dart';
import 'package:wChaser/src/stores/chaser_store.dart';
import 'package:wChaser/src/components/header.dart';
import 'package:wChaser/src/components/login.dart';
import 'package:wChaser/src/components/loading.dart';
import 'package:wChaser/src/components/chaser_grid.dart';
import 'package:wChaser/src/components/footer.dart';
import 'package:wChaser/src/constants.dart';

var ChaserApp = react.registerComponent(() => new _ChaserApp());

class _ChaserApp extends FluxComponent {
  ChaserActions get chaserActions => props['actions'];
  ChaserStores get chaserStores => props['store'];

  StatusService get statusService => props['statusService'];
  AtMentionStore get atMentionStore => chaserStores.atMentionStore;

  redrawOn() =>
      [chaserStores.userStore, chaserStores.atMentionStore, chaserStores.locationStore, chaserStores.pullRequestsStore];

  getInitialState() {
    return {'pullRequests': atMentionStore.atMentionPullRequests};
  }

  componentDidMount() {
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
      Header({'actions': chaserActions, 'loading': chaserStore.loading}),
      Alert({'statusService': chaserStores.statusService}),
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
      return react.div({'className': 'chaser-container'}, renderLoading());
    }

    return react.div(
        {'className': 'chaser-container'}, chaserStores.statusService.authed ? renderChaserCore() : renderLogin());
  }
}
