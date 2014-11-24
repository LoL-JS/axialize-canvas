Axialize.TransactionsRoute = Ember.Route.extend
  setupController: (controller, model) ->
    @_super(controller, model)
    controller.set('stageNames', @get('store').find('stage'))

  model: ->
    @get('store').find 'transaction'

  activate: ->
    Ember.$('body').addClass('transactions')
    Ember.$('#main-container').removeClass('container')

  deactivate: ->
    Ember.$('body').removeClass('transactions')
    Ember.$('#main-container').addClass('container')
