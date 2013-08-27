'use strict'
describe "BWL", ->
  describe "Core Extensions", ->
    describe "String", ->
      it "adds format", ->
        expect("string {0} filled{1}".format("to be", "!")).toEqual("string to be filled!")
    describe "Array", ->
      it "adds last", ->
        expect(["1", "2", "3"].last()).toEqual("3")


