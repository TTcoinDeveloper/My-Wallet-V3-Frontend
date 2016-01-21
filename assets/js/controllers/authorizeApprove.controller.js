angular
  .module('walletApp')
  .controller("AuthorizeApproveCtrl", AuthorizeApproveCtrl);

function AuthorizeApproveCtrl($window, $scope, MyWalletTokenEndpoints, $stateParams, $state, Alerts, $translate, $rootScope) {
  const success = (res) => {
    $scope.checkingToken = false;
    $scope.busyApproving = false;
    $scope.busyRejecting = false;

    // If differentBrowser is called, success will be null:
    if (res.success == null) return;

    $window.close(); // This is sometimes ignored, hence the code below:

    $translate('AUTHORIZE_APPROVE_SUCCESS').then(translation => {
      $state.go("public.login-uid", {uid: res.guid}).then(() => {
        Alerts.displaySuccess(translation)
      });
    });
    $rootScope.$safeApply();
  }

  const error = (res) => {
    $scope.checkingToken = false;
    $scope.busyApproving = false;
    $scope.busyRejecting = false;

    $state.go("public.login-no-uid");
    Alerts.displayError(res.error, true);
    $rootScope.$safeApply();
  }

  const differentBrowser = (details) => {
    $scope.checkingToken = false;

    $scope.differentBrowser = true;
    $scope.details = details;
    $rootScope.$safeApply();
  }

  $scope.checkingToken = true;

  MyWalletTokenEndpoints.authorizeApprove($stateParams.token, differentBrowser, null)
    .then(success)
    .catch(error);

  $scope.approve = () => {
    $scope.busyApproving = true;
    MyWalletTokenEndpoints.authorizeApprove($stateParams.token, () => {}, true)
      .then(success)
      .catch(error);
  }

  $scope.reject = () => {
    $scope.busyRejecting = true;

    const rejected = () => {
      $scope.busyRejecting = false;

      $translate('AUTHORIZE_REJECT_SUCCESS').then(translation => {
        $state.go("public.login-no-uid").then(() => {
          Alerts.displaySuccess(translation)
        });
      });
    };

    MyWalletTokenEndpoints.authorizeApprove($stateParams.token, () => {}, false)
      .then(rejected)
      .catch(error);
  }
}
