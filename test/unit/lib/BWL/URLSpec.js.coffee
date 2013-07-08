describe "BWL.URL", ->
  describe "getHost", ->
    it "should work with long URL", ->
      expect(BWL.URL.getHost("http://www.google.ca/searching/crazyness#output=search&sclient=psy-ab&q=test&oq=test")).toEqual("http://www.google.ca")
    it "should work with ports", ->
      expect(BWL.URL.getHost("http://localhost:3000/my/path")).toEqual("http://localhost:3000")

  describe "getRootUrl", ->
    it "should return root URL", ->
      url = "http://preptickets.test"
      spyOn(BWL.URL, 'getWindowLocation').andReturn("#{url}/nested#location");
      expect(BWL.URL.getRootURL()).toEqual(url)
      expect(BWL.URL.getWindowLocation).toHaveBeenCalled()