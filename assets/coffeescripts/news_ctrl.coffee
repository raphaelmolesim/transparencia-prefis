app = angular.module('TranparenciaPrefis', ['ngResource'])

app.config(['$routeProvider', ($routeProvider) ->
  $routeProvider.
    when('/o-que-e', {templateUrl: 'views/what_is.html'}).
    when('/', {templateUrl: 'views/news_index.html'})
])

@NewsCtrl = ($scope, $resource) ->
  News = $resource("/news/:id", {id : "@id"})
  $scope.news_list = News.query()
  