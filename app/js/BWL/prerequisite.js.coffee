#= require md5
#= require ender
#= require easyXDM
#= require_self

BWL.$ = ender if BWL?
BWL.Plugins = {} unless BWL.Plugins?
BWL.Plugins.easyXDM = easyXDM
