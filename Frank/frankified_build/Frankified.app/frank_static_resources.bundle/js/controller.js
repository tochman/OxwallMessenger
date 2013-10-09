(function() {
  var RELOAD_INTERVAL,
    __slice = [].slice;

  RELOAD_INTERVAL = 500;

  define(['frank'], function(frank) {
    var createController;
    createController = function(_arg) {
      var $asplodeButton, $liveButton, $reloadButton, accessibleViewsView, boot, detailsView, ersatzView, experimentBarModel, liveTimeout, reload, reloadLoop, reportActionOutcome, tabsController, toastController, treeView, validateViewSelector;
      tabsController = _arg.tabsController, toastController = _arg.toastController, treeView = _arg.treeView, ersatzView = _arg.ersatzView, detailsView = _arg.detailsView, accessibleViewsView = _arg.accessibleViewsView, experimentBarModel = _arg.experimentBarModel, $asplodeButton = _arg.$asplodeButton, $reloadButton = _arg.$reloadButton, $liveButton = _arg.$liveButton;
      treeView.model.on('active-view-changed', function(viewModel) {});
      treeView.model.on('selected-view-changed', function(viewModel) {
        detailsView.updateModel(viewModel);
        return tabsController.selectViewDetailsTab();
      });
      treeView.model.on('accessible-view-selected', function(viewModel) {
        viewModel.setActive();
        return experimentBarModel.set({
          selector: viewModel.getShelleySelector()
        });
      });
      reportActionOutcome = function(action, numViews) {
        var message;
        message = (function() {
          switch (numViews) {
            case 0:
              return "Sorry, no views matched that selector so none were " + action;
            case 1:
              return "1 view was " + action;
            default:
              return "" + numViews + " views were " + action;
          }
        })();
        return toastController.showToastMessage(message);
      };
      validateViewSelector = function(selector) {
        if (selector.length === 0) {
          toastController.showToastMessage("You haven't provided a view selector. Please enter one below.");
          return false;
        } else {
          return true;
        }
      };
      experimentBarModel.on('flash-clicked', function(model) {
        var selector, selectorEngine, _ref;
        _ref = [model.get('selector'), model.get('selectorEngine')], selector = _ref[0], selectorEngine = _ref[1];
        if (!validateViewSelector(selector)) {
          return;
        }
        return frank.sendFlashCommand(selector, selectorEngine).done(function(data) {
          return reportActionOutcome("flashed", data.length);
        });
      });
      experimentBarModel.on('touch-clicked', function(model) {
        var selector, selectorEngine, views, _ref;
        _ref = [model.get('selector'), model.get('selectorEngine')], selector = _ref[0], selectorEngine = _ref[1];
        if (!validateViewSelector(selector)) {
          return;
        }
        return views = frank.sendTouchCommand(selector, selectorEngine).done(function(data) {
          return reportActionOutcome("touched", data.length);
        });
      });
      experimentBarModel.on('highlight-clicked', function(model) {
        var selector, selectorEngine, views, _ref;
        _ref = [model.get('selector'), model.get('selectorEngine')], selector = _ref[0], selectorEngine = _ref[1];
        if (!validateViewSelector(selector)) {
          return;
        }
        return views = frank.getAccessibilityFramesForViewsMatchingSelector(selector, selectorEngine).done(function(data) {
          ersatzView.model.highlightSomeFramesForABit(data);
          return reportActionOutcome("highlighted", data.length);
        });
      });
      $asplodeButton.on('click', function() {
        var isAsploded;
        isAsploded = ersatzView.model.toggleAsploded();
        return $asplodeButton.toggleClass('down', isAsploded);
      });
      $reloadButton.on('click', function() {
        return reload().done(function() {
          return toastController.showToastMessage('views reloaded');
        });
      });
      liveTimeout = void 0;
      reloadLoop = function() {
        reload();
        return liveTimeout = window.setTimeout(reloadLoop, RELOAD_INTERVAL);
      };
      $liveButton.on('click', function() {
        if (liveTimeout != null) {
          window.clearTimeout(liveTimeout);
        }
        if ($liveButton.hasClass('down')) {
          toastController.showToastMessage('leaving live mode');
          return $liveButton.removeClass('down');
        } else {
          reloadLoop();
          toastController.showToastMessage('entering live mode');
          return $liveButton.addClass('down');
        }
      });
      reload = function() {
        var deferable;
        deferable = $.Deferred();
        $.when(frank.fetchViewHierarchy(), frank.fetchResolution(), frank.fetchOrientation(), frank.fetchDevice()).done(function(_arg1, resolution, orientation, deviceFamily) {
          var accessibleViews, rawHier;
          rawHier = _arg1[0];
          if (deviceFamily == 'mac') {
            $liveButton.hide();
          }
          treeView.model.resetViewHier(rawHier);
          ersatzView.model.resetViews(treeView.model.get('allViews'), resolution, deviceFamily, orientation);
          accessibleViews = treeView.model.getAccessibleViews();
          accessibleViewsView.collection.reset(accessibleViews);
          ersatzView.render();
          return deferable.resolve();
        }).fail(function() {
          var args;
          args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
          toastController.showToastMessage('encountered an error while talking to Frank');
          window.alert("Ruh roh. Encountered an error while talking to Frank.\nSee the javascript console for all the details");
          return console.log("Failed while talking to Frank.", args);
        });
        return deferable.promise();
      };
      boot = function() {
        tabsController.selectLocatorTab();
        return reload();
      };
      return {
        boot: boot
      };
    };
    return createController;
  });

}).call(this);
