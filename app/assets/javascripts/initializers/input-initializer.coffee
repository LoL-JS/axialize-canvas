Ember.Application.initializer
  name: 'input'
  initialize: (container, application) ->
    Ember.TextField.reopen Ember.I18n.TranslateableAttributes
    Ember.LinkView.reopen Em.I18n.TranslateableProperties