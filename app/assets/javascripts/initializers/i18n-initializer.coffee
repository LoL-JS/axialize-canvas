Ember.Application.initializer
  name: 'i18n'
  initialize: (container, application) ->
    lang = window.location.pathname.split('/')[1] || 'en'
    Ember.I18n.translations = Ember.Languages[lang]
    CLDR.defaultLanguage = lang