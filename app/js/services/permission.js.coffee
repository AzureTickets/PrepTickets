# permission service
@prepTickets.factory 'permissionService', ['authService', (authService) ->
  canRead: (model) ->
    if model.Type? && BWL.Models[model.Type]? && BWL.Models[model.Type].Meta?
      meta = BWL.Models[model.Type].Meta
      return true if meta.__perms.Read == 0
      return authService.getDomainProfile()?.ProfileRole >= meta.__perms.Read
    false
]