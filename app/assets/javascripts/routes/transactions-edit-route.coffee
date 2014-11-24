Axialize.TransactionsEditRoute = Ember.Route.extend
  model: (params) ->
    @get('store').find 'transaction', params.id

  deactivate: ->
    model = @modelFor 'transactions.edit'
    model.rollback() if model.get('isDirty')

  actions:
    save: ->
      model = @modelFor 'transactions.edit'
      model.get("errors").clear()

      model.save().then =>
        toastr.success Ember.I18n.t("transaction.edited")
        @transitionTo 'transactions'
      , (response) ->

    cancel: ->
      @transitionTo 'transactions'