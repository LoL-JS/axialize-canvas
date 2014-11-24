Ember.Handlebars.helper 'format-month', (value) ->
  return Ember.I18n.t('month.total') if !value
  m = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ]
  Ember.I18n.t('month.'+m[value])