describe "BWL.Common", ->
  describe "getHost", ->
    it "should work with long URL", ->
      expect(BWL.Common.getHost("http://www.google.ca/searching/crazyness#output=search&sclient=psy-ab&q=test&oq=test")).toEqual("http://www.google.ca")
    it "should work with ports", ->
      expect(BWL.Common.getHost("http://localhost:3000/my/path")).toEqual("http://localhost:3000")