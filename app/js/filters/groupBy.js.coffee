@prepTickets.filter('groupBy', ->
  (items, groupSize, fillInBlankWith) ->
    return unless items?.length > 0
    groups = []
    for item, idx in items
      if idx % groupSize is 0
        inner = []
        groups.push(inner)
      inner.push(item)

    if fillInBlankWith
      lastGroup = groups[groups.length - 1]
      if lastGroup.length < groupSize
        while lastGroup.length < groupSize
          lastGroup.push(fillInBlankWith)

    groups
)
