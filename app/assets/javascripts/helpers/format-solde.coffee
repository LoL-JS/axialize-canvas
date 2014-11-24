Ember.Handlebars.helper 'format-solde', (value) ->
  value = if isNaN(value) then 0 else value
  format = numeral(value).format('0.00').replace(/\B(?=(\d{3})+(?!\d))/g, " ").split('.')
  new Ember.Handlebars.SafeString format[0]+',<span class="decimal">'+format[1]+'</span>'