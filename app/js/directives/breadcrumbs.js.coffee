@prepTickets.directive('breadcrumbs', ["BreadcrumbService",(BreadcrumbService) ->
  restrict: 'E' 
  replace: true
  scope: {}
  template: ' <ol class="breadcrumb">
                <li><a href="" ng-href="#/"><i class="icon-home icon-large"></i></a></li>
                <li ng-repeat="crumb in crumbs()" ng-class="{active:$last}" ng-switch on="$last">
                  <a href="" ng-href="{{crumb.link}}" ng-switch-when="false">{{crumb.name}}</a>
                  <span ng-switch-when="true">{{crumb.name}}</span>
                </li>
              </ol>'
  link: (scope, element, attr) ->
    scope.crumbs = () ->
      BreadcrumbService.crumbs()
])