Axialize.ApplicationRoute = Ember.Route.extend
  #setupController: (controller, model) ->
  #  @_super(controller, model)
  #  controller.set('recordTypes', [{id: '123', name: 'Test 1'}, {id: '1234', name: 'Test 2'}])
  #  @get('store').find('recordType').then (result) ->
  #    console.log result
  #  , (error) ->
  #    console.log error
  actions:
    loading: ->
      return true