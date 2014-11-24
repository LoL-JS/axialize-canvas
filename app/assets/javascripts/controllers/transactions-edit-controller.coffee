Axialize.TransactionsEditController = Ember.Controller.extend
  needs: ['application', 'transactions']

  stageNames: Ember.computed.alias('controllers.transactions.stageNames')

  salesforceUrl: (->
    window.sr.client.instanceUrl+'/'+@get('model.id')
  ).property('model.id')

  actions:
    searchByName: ->
      user = '@' + if @get('model.owner').indexOf(' ') != -1 then '['+@get('model.owner')+']' else @get('model.owner')
      @set('controllers.application.searchTerm', user)
      @transitionToRoute('transactions')