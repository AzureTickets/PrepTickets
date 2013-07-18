'use strict';

describe 'storeCtrl', ->
  scope = ctrl = undefined

  beforeEach module('prepTickets')
  beforeEach inject(($rootScope, $controller) ->
    scope = $rootScope.$new()
    ctrl = $controller('storeCtrl', {$scope: scope})
  )

  it 'says hello', inject(->
    expect(scope.greeting).toEqual("Hola!")
  )
