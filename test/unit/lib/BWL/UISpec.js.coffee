describe "BWL.UI", ->
  describe "Alert", ->
    it "should show alert box", ->
      spyOn(window, "alert")
      BWL.UI.Alert("User Alert")
      expect(window.alert).toHaveBeenCalledWith("User Alert")