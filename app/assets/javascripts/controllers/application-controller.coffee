Axialize.ApplicationController = Ember.Controller.extend
  needs: ['transactions']
  searchTerm: ''
  recordType: ''
  showCosts: true
  period: 'month+2'
  periodList: (->
    [
      {label: Ember.I18n.t('transaction.filters.all'), value: 'all'},
      {label: Ember.I18n.t('transaction.filters.quarter'), value: 'quarter'},
      {label: Ember.I18n.t('transaction.filters.month'), value: 'month'},
      {label: Ember.I18n.t('transaction.filters.month+1'), value: 'month+1'},
      {label: Ember.I18n.t('transaction.filters.month+2'), value: 'month+2'},
      {label: Ember.I18n.t('transaction.filters.month+3'), value: 'month+3'},
      {label: Ember.I18n.t('transaction.filters.week'), value: 'week'},
      {label: Ember.I18n.t('transaction.filters.day'), value: 'day'},
    ]
  ).property()

  click: (e) ->
    e.stopPropagation()

  actions:
    clearSearchTerm: ->
      @set 'searchTerm', ''