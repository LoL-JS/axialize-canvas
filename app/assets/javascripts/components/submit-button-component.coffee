Axialize.SubmitButtonComponent = Ember.Component.extend Ember.I18n.TranslateableProperties,
  classNames: ['btn', 'btn-primary', 'pull-right']
  attributeBindings: ['type', 'disabled']
  type: 'submit'
  tagName: 'button'
  disabled: (->
    @get('model.isSaving') || !@get('model.isValid')
  ).property('model.isSaving')

  click: ->
    @sendAction('action', @get('param'))