describe "SignupCtrl", ->
  scope = undefined
  modalInstance =
    close: ->
    dismiss: ->
        
  beforeEach angular.mock.module("walletApp")
  
  beforeEach ->
    angular.mock.inject ($injector, localStorageService, $rootScope, $controller) ->
      localStorageService.remove("mockWallets")
      
      Wallet = $injector.get("Wallet")      
            
      MyWallet = $injector.get("MyWallet")
            
      scope = $rootScope.$new()
          
      $controller "SignupCtrl",
        $scope: scope,
        $stateParams: {},
        $modalInstance: modalInstance
      
      scope.isValid = [false, false]
      scope.fields = {email: "a@b.com", password: "testing", confirmation: "testing"}
      scope.validate()
    
      return

    return
    
  describe "first step", ->
    it "should be step 1", ->
      expect(scope.currentStep).toBe(1)
    
    it "should go to second step", ->
      scope.nextStep()
      expect(scope.currentStep).toBe(2)
      
    it "should have a list of languages", ->
      pending()
      expect(scope.languages.length).toBeGreaterThan(1)
    
    it "should have a list of currencies", ->
      pending()
      expect(scope.currencies.length).toBeGreaterThan(1)
      
    it "should guess the correct language", ->
      pending()
      
    it "should guess the correct currency", ->
      pending()
      
  describe "second step", ->
    beforeEach ->
      scope.currentStep = 2
    
    it "should not display an error if password is still empty", ->
      scope.fields.currentPassword = "test"
      scope.fields.password = ""
      scope.validate()
      expect(scope.isValid[1]).toBe(false)
      expect(scope.errors.password).toBeNull()
    
    it "should display an error if password is too short", ->
      scope.fields.currentPassword = "test"
      scope.fields.password = "1"
      scope.validate()
      expect(scope.isValid[1]).toBe(false)
      expect(scope.errors.password).not.toBeNull()
    
    it "should not display an error if password confirmation is still empty", ->
      scope.fields.currentPassword = "test"
      scope.fields.password = "testing"
      scope.fields.confirmation = ""
    
      scope.validate()
    
      expect(scope.isValid[1]).toBe(false)
      expect(scope.errors.confirmation).toBeNull()
    
    it "should not display an error if password confirmation matches", ->
      scope.fields.currentPassword = "test"
      scope.fields.password = "testing"
      scope.fields.confirmation = "testing"
    
      scope.validate()
    
      expect(scope.isValid[1]).toBe(true)
      expect(scope.errors.confirmation).toBeNull()
    
    it "should display an error if password confirmation does not match", ->
      scope.fields.currentPassword = "test"
      scope.fields.password = "testing"
      scope.fields.confirmation = "wrong"
    
      scope.validate()
    
      expect(scope.isValid[1]).toBe(false)
      expect(scope.errors.confirmation).not.toBeNull()
    
    it "should go to third step", ->
      scope.nextStep()
      expect(scope.currentStep).toBe(3)
    
    it "should not go to third step is invalid", ->
      scope.fields.password = "" # invalid
      scope.$digest()
      
      scope.nextStep()
      expect(scope.currentStep).toBe(2)
      
    it "should not go to third step is wallet creation fails", inject((MyWallet) ->
            
      MyWallet.mockShouldFailToCreateWallet()
      
      scope.nextStep()
      expect(scope.currentStep).toBe(2)
    )
    
    it "should show error if wallet creation fails", inject((MyWallet) ->
            
      MyWallet.mockShouldFailToCreateWallet()
      
      scope.nextStep()
      expect(scope.alerts.length).toBe(1)
    )
    
    it "should create a wallet", inject((MyWallet) ->
      pending()
    )
      
  describe "third step", ->
    beforeEach ->
      angular.mock.inject ($injector) ->
      
        Wallet = $injector.get("Wallet")      
      
        Wallet.login("test-unverified", "test") 
        scope.didLoad() 
      
    it "should be logged in", inject((Wallet) ->
      expect(Wallet.status.isLoggedIn).toBe(true)
    )

    it "should resume if account was created and popup closed", inject((Wallet) ->
      expect(scope.currentStep).toBe(3)
    )