Axialize.FocusedTextField = Ember.TextField.extend
  didInsertElement: ->
    @$().focus()