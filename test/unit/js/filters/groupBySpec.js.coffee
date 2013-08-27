'use strict'

describe "Filters - groupBy", ->
  groupBy = null
  beforeEach module('prepTickets')

  beforeEach inject(($filter) =>
    groupBy = $filter('groupBy');
  )

  it 'exist', ->
    expect(groupBy).not.toEqual(null)

  it 'returns null if no items are given', ->
    expect(groupBy()).toBeNull
  
  it 'groups correctly when item is less than group size', ->
    source = ["test1", "test2"]
    expect(groupBy(source, 3)).toEqual([source])

  it 'groups correctly when item is larger than group size', ->
    source = ["test1", "test2", "test3", "test4", "test5"]
    expect(groupBy source, 3).toEqual([["test1", "test2", "test3"], ["test4", "test5"]])

  it 'works with objects', ->
    source = [{name: 'bob'}, {name: 'steve'}, {name: 'john'}]
    expect(groupBy source, 2).toEqual([[{name: "bob"}, {name: 'steve'}], [{name: 'john'}]])

  describe "blank item", ->
    it 'isnt add by default', ->
      source = ["test1", "test2"]
      group = groupBy(source, 3)[0]
      expect(group.length).toEqual(2)

    it 'is added when set', ->
      source = ["test1", "test2"]
      groupBySize = 3
      groups  = groupBy(source, groupBySize, "blank")
      group = groups.last()
      expect(group.length).toEqual(groupBySize)
      expect(group.last()).toEqual("blank")

    it 'works with objects', ->
      source = [{name: 'bob'}, {name: 'steve'}, {name: 'john'}]
      blankItem = {name: '', blank: true}
      groups = groupBy source, 2, blankItem
      expect(groups.length).toEqual(2)
      lastGroup = groups.last()
      expect(lastGroup.last()).toEqual blankItem



