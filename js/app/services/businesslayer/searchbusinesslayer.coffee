###

ownCloud - Tasks

@author Raimund Schlüßler
@copyright 2015

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU AFFERO GENERAL PUBLIC LICENSE
License as published by the Free Software Foundation; either
version 3 of the License, or any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU AFFERO GENERAL PUBLIC LICENSE for more details.

You should have received a copy of the GNU Affero General Public
License along with this library.  If not, see <http://www.gnu.org/licenses/>.

###


angular.module('Tasks').factory 'SearchBusinessLayer',
['ListsModel', 'Persistence', 'TasksModel', '$rootScope',
'$routeParams', '$location',
(ListsModel, Persistence, TasksModel, $rootScope,
$routeParams, $location) ->

	class SearchBusinessLayer

		constructor: (@_$listsmodel, @_persistence,
		@_$tasksmodel, @_$rootScope, @_$routeparams, @_$location) ->
			@initialize()
			@_$searchString = ''

		attach: (search) =>
			search.setFilter('tasks', (query) =>
				@_$rootScope.$apply(
					@setFilter(query)
					)
			)
			search.setRenderer('task', @renderTaskResult.bind(@))
			search.setHandler('task',  @handleTaskClick.bind(@))

		setFilter: (query) =>
			@_$searchString = query

		getFilter: () =>
			return @_$searchString

		initialize: () ->
			@handleTaskClick = ($row, result, event) =>
				@_$location.path('/lists/'+ result.calendarid +
				'/tasks/' + result.id)

			@renderTaskResult = ($row, result) =>
				if !@_$tasksmodel.filterTasks(result,@_$routeparams.listID) ||
				!@_$tasksmodel.isLoaded(result)
					return $row
				else
					return null

			OC.Plugins.register('OCA.Search', @)


	return new SearchBusinessLayer(ListsModel, Persistence,
		TasksModel, $rootScope, $routeParams, $location)

]