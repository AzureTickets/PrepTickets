'use strict';

describe 'homeCtrl', ->
  scope = ctrl = undefined

  beforeEach module('prepTickets')
  beforeEach inject(($rootScope, $controller) ->
    scope = $rootScope.$new()
    ctrl = $controller('homeCtrl', {$scope: scope})
  )

  it 'says hello', inject(->
    expect(scope.greeting).toEqual("Hola!")
  )
