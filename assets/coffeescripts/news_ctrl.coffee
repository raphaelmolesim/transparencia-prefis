#app = angular.module('Tranperenciaprefis', ['ngSanitize'])
app = angular.module('TranparenciaPrefis', ['ngResource'])

@NewsCtrl = ($scope, $resource) ->
  News = $resource("/news/:id", {id : "@id"})
  $scope.news_list = News.query()
  