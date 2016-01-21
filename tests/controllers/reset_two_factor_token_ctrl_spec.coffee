describe "ResetTwoFactorTokenController", ->
  scope = undefined

  beforeEach angular.mock.module("walletApp")

  beforeEach ->
    angular.mock.inject ($injector, $rootScope, $controller) ->
      MyWalletTokenEndpoints = $injector.get("MyWalletTokenEndpoints")
      $state = $injector.get("$state") # This is a mock
      Alerts = $injector.get("Alerts")

      spyOn(MyWalletTokenEndpoints, "resetTwoFactor").and.callThrough()
      spyOn($state, "go").and.callThrough()

      spyOn(Alerts, "displayError").and.callFake(() ->)
      spyOn(Alerts, "displayResetTwoFactor").and.callFake(() ->)

      return

    return

  describe "with token", ->
    beforeEach ->
      angular.mock.inject ($controller, $rootScope) ->

        scope = $rootScope.$new()

        $controller "ResetTwoFactorTokenCtrl",
          $scope: scope,
          $stateParams: {token: "token"}

    it "should show call MyWalletTokenEndpoints.resetTwoFactor)", inject((MyWalletTokenEndpoints) ->
      expect(MyWalletTokenEndpoints.resetTwoFactor).toHaveBeenCalled()
    )

    it "should pass the token parameter along", inject((MyWalletTokenEndpoints) ->
      expect(MyWalletTokenEndpoints.resetTwoFactor).toHaveBeenCalledWith("token")
    )

    it "should redirect to the login page", inject(($state)->
      expect($state.go).toHaveBeenCalledWith("public.login-uid", { uid : '1234' })
    )

    it "should request a modal success message", inject((Alerts) ->
      expect(Alerts.displayResetTwoFactor).toHaveBeenCalled()
    )

  describe "with wrong token", ->
    beforeEach ->
      angular.mock.inject ($controller, $rootScope) ->

        scope = $rootScope.$new()

        $controller "ResetTwoFactorTokenCtrl",
          $scope: scope,
          $stateParams: {token: "wrong-token"}

    it "should display an error message", inject((Alerts)->
      expect(Alerts.displayError).toHaveBeenCalled()
    )

    it "should redirect to the login page", inject(($state)->
      expect($state.go).toHaveBeenCalledWith("public.login-no-uid")
    )
