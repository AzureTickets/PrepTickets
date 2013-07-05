describe "BWL.DataAccess", ->
  describe "JSON2Obj", ->
    it "should return array from string", ->
      strObj = '["bob", "sam"]'
      expect(BWL.DataAccess.JSON2Obj(strObj)).toEqual(["bob", "sam"])
    it "should return obj from string", ->
      strObj = '{"Code": "0"}'
      expect(BWL.DataAccess.JSON2Obj(strObj)).toEqual({Code: "0"})
  describe "Obj2JSON", ->
    it "should convert obj to JSON string", ->
      obj = {data:"Cool"}
      expect(BWL.DataAccess.Obj2JSON(obj)).toEqual('{"data":"Cool"}')
    it "should convert array to JSON string", ->
      arr = [1, 5, "test"]
      expect(BWL.DataAccess.Obj2JSON(arr)).toEqual('[1,5,"test"]')