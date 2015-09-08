module = angular.module('impac.components.widgets-settings.organizations',[])
module.controller('SettingOrganizationsCtrl', ($scope, $log) ->

  w = $scope.parentWidget
  $log.debug('SettingOrganizationsCtrl START', w);
  $scope.dashboardOrganizations = w.parentDashboard.data_sources
  w.selectedOrganizations = {}

  $scope.isOrganizationSelected = (orgUid) ->
    !!w.selectedOrganizations[orgUid]

  $scope.toogleSelectOrganization = (orgUid) ->
    w.selectedOrganizations[orgUid] = !w.selectedOrganizations[orgUid]

  # What will be passed to parentWidget
  setting = {}
  setting.key = "organizations"
  setting.isInitialized = false

  # initialization of selected organizations
  setting.initialize = ->
    $log.debug('SettingsOrganizationCtrl: settings.initialize START');
    if w.metadata? && w.metadata.organization_ids?
      angular.forEach(w.metadata.organization_ids, (orgUid) ->
        w.selectedOrganizations[orgUid] = true
      )
      setting.isInitialized = true

  setting.toMetadata = ->
    newOrganizations = _.compact(_.map(w.selectedOrganizations, (checked,uid) ->
      uid if checked
    ))
    return { organization_ids: newOrganizations }

  w.settings ||= []
  $log.debug('SettingOrganizationsCtrl FINISH', w.settings);
  w.settings.push(setting)
)

module.directive('settingOrganizations', ($templateCache) ->
  return {
    restrict: 'A',
    scope: {
      parentWidget: '='
    },
    template: $templateCache.get('widgets-settings/organizations.tmpl.html'),
    controller: 'SettingOrganizationsCtrl'
  }
)
