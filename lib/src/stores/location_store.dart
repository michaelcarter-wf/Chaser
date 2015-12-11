part of wChaser.src.stores.chaser_stores;

class LocationStore extends Store {
  static final String NAME = 'locationStore';

  ChaserViews currentView;

  ChaserActions _chaserActions;

  LocationStore(this._chaserActions) {
    currentView = ChaserViews.pullRequests;

    _chaserActions.locationActions.changeViewNext.listen((e) {
      int newIndex = ChaserViews.values.indexOf(currentView) + 1;
      currentView = newIndex > ChaserViews.values.length - 1 ? ChaserViews.values[0] : ChaserViews.values[newIndex];
      trigger();
    });

    _chaserActions.locationActions.changeViewPrevious.listen((e) {
      int newIndex = ChaserViews.values.indexOf(currentView) - 1;
      currentView = newIndex < 0 ? ChaserViews.values[ChaserViews.values.length - 1] : ChaserViews.values[newIndex];
      trigger();
    });

  }

}
