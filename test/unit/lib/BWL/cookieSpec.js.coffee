describe "Cookie", ->
  describe "read", ->
    it "should read cookie value", ->
      spyOn(BWL.$, 'cookie').andReturn("myValue")
      expect(BWL.Cookie.read("myToken")).toEqual("myValue")
  describe "write", ->
    it "should write cookie value", ->
      value = "myValue"
      token = "myToken"
      spyOn(BWL.$, 'cookie')
      expect(BWL.Cookie.write(token, value)).toEqual(value)
      expect(BWL.$.cookie).toHaveBeenCalledWith(token, value, {})
