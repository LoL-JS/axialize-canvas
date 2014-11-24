Ember.Handlebars.helper 'format-currency', (value) ->
  value = if isNaN(value) then 0 else value
  numeral(value).format('0.00').replace(/\B(?=(\d{3})+(?!\d))/g, " ")