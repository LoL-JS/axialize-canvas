Ember.Handlebars.helper 'format-date', (date) ->
  moment(date).format(Ember.I18n.t('date.format')) if date?