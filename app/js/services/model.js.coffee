# model service
@prepTickets.factory 'modelService', [
  '$q', ($q) ->
    #
    # Returns a new instance of the specified model.
    # @param modelName Model instance to retrieve
    # @param tmpAttrs Additional attributes to add to the new instance.
    # @param alias Alias used in BWL, used to retrieve loaded instance.
    # @param force Force to load a new & clean copy of the model.
    # @returns
    #
    getInstanceOf: (modelName, tmpAttrs, alias, force) ->
      model = {}
      force = if force? then force else false
      alias = if alias? then alias else modelName

      model = if (!force && BWL[alias]?)
              BWL[alias]
            else if BWL.Models[modelName]?
              angular.copy(BWL.Models[modelName])
        
      angular.extend(model, tmpAttrs) if tmpAttrs?
      model
    
    find : ->
      $q.defer()
    
    nonNull : (model) ->
      for value, idx in model
        (delete model[idx]) unless value?
      model
]