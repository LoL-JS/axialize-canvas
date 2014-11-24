Axialize.DatePicker = Ember.TextField.extend
  value: (->
    unless @get('date')?
      @set('date', new Date())
    moment(@get('date')).format(Ember.I18n.t('date.format'))
  ).property()
  valueDidChange: (->
    @set('value', moment(@get('date')).format(Ember.I18n.t('date.format')))
  ).observes('date')
  didInsertElement: ->
    @$().datepicker
      dateFormat: Ember.I18n.t('date.formatdatepicker')
      firstDay: 1
      onClose: (d, i) =>
        @set('date', new Date(i.currentYear, i.currentMonth, i.currentDay))

  willDestroyElement: ->
    @$().datepicker('destroy')