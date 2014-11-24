Axialize.TransactionsController = Ember.ArrayController.extend
  needs: ['application']
  contentChanged: (->
    Ember.run.debounce @, @notifyPropertyChange, 'arrangedContent', 500
  ).observes 'model.@each.amount', 'model.@each.stageName', 'model.@each.closeDate', 'model.@each.owner', 'controllers.application.searchTerm',
  'controllers.application.period'
  scrollToToday: (->
    today = @get('arrangedContent').find (item, index) ->
      item.get('isTodayBefore') || item.get('isTodayAfter')
    @get('arrangedContent').indexOf(today)
  ).property('arrangedContent')

  arrangedContent: (->
    sum = 0

    usersRegExp = new RegExp(/\S*@(?:\[([^\]]+)\]|(\S+))/gi)
    hashtagsRegExp = new RegExp(/\S*#(?:\[([^\]]+)\]|(\S+))/gi)
    searchTerm = @get('controllers.application.searchTerm').replace(/[\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|]/g, "\\$&")
    users = while u = usersRegExp.exec(searchTerm)
      (u[1] || u[2]).toLowerCase()
    usersRegex = new RegExp(users.join('|'), 'i')
    words = (searchTerm || '').replace(usersRegExp, ' ').replace(hashtagsRegExp, ' ').replace(/^\s\s*/, '').replace(/\s\s*$/, '').replace(/\s{2,}/g, ' ').split(' ')
    wordsRegex = new RegExp(words.join('|'), 'i')
    filtered = @get('model').filter((item) ->
      !(item.get('isNew') || item.get('isDeleted'))
    ).sortBy('closeDate', 'id')
    .filter((item) =>
      period = @get('controllers.application.period')

      inPeriod = false
      switch period
        when 'all'
          inPeriod = true
        when 'quarter'
          mom =  moment(item.get('closeDate'))
          start = moment().subtract(1, 'month').startOf('month')
          end = moment().add(1, 'month').endOf('month')
          inPeriod = (mom.isAfter(start) && mom.isBefore(end)) || mom.isSame(start) || mom.isSame(end)
        when 'month'
          mom =  moment(item.get('closeDate'))
          start = moment().startOf('month')
          end = moment().endOf('month')
          inPeriod = (mom.isAfter(start) && mom.isBefore(end)) || mom.isSame(start) || mom.isSame(end)
        when 'month+1'
          mom =  moment(item.get('closeDate'))
          start = moment().startOf('month')
          end = moment().add(1, 'month').endOf('month')
          inPeriod = (mom.isAfter(start) && mom.isBefore(end)) || mom.isSame(start) || mom.isSame(end)
        when 'month+2'
          mom =  moment(item.get('closeDate'))
          start = moment().startOf('month')
          end = moment().add(2, 'month').endOf('month')
          inPeriod = (mom.isAfter(start) && mom.isBefore(end)) || mom.isSame(start) || mom.isSame(end)
        when 'month+3'
          mom =  moment(item.get('closeDate'))
          start = moment().startOf('month')
          end = moment().add(3, 'month').endOf('month')
          inPeriod = (mom.isAfter(start) && mom.isBefore(end)) || mom.isSame(start) || mom.isSame(end)
        when 'week'
          mom =  moment(item.get('closeDate'))
          start = moment().startOf('week')
          end = moment().endOf('week')
          inPeriod = (mom.isAfter(start) && mom.isBefore(end)) || mom.isSame(start) || mom.isSame(end)
        when 'day'
          mom =  moment(item.get('closeDate'))
          start = moment().startOf('day')
          end = moment().endOf('day')
          inPeriod = (mom.isAfter(start) && mom.isBefore(end)) || mom.isSame(start) || mom.isSame(end)

      (wordsRegex.test(item.get('name')) || wordsRegex.test(item.get('description'))) && usersRegex.test(item.get('owner')) && inPeriod
    ).map((item) ->
      unless item.get('isLate')
        sum += parseFloat(item.get('amount')) if ['Quote sent', 'Negociation', 'Verbal agreement', 'Closed won'].contains item.get('stageName')
      item.set 'sum', sum
      item
    )
    return filtered if Ember.isEmpty filtered

    recap = [0, 0, 0, 0, 0, 0, filtered[0].get('closeDate').getMonth()]
    total = [0, 0, 0, 0, 0, 0, null]
    final = [[null, recap]]
    today = false
    lastItem = null
    filtered.forEach (item) =>
      item.setProperties
        'isTodayBefore': null
        'isTodayAfter': null
      if !today && moment().isBefore(moment(item.get('closeDate')))
        today = true
        item.set('isTodayBefore', true)


      if recap[6] != item.get('closeDate').getMonth()
        newRecap = [0, 0, 0, 0, 0, 0, item.get('closeDate').getMonth()]
        final.push [recap, newRecap]
        total[0] += parseFloat(recap[0])
        total[1] += parseFloat(recap[1])
        total[2] += parseFloat(recap[2])
        total[3] += parseFloat(recap[3])
        total[4] += parseFloat(recap[4])
        total[5] += parseFloat(recap[5])
        recap = newRecap
      index = @get('stageNames').map((stage) ->
        stage.get('masterLabel')
      ).indexOf(item.get('stageName'))
      recap[index] += parseFloat(item.get('amount'))
      final.push item
      lastItem = item
    if !today && lastItem
      lastItem.set('isTodayAfter', true)
    total[0] += parseFloat(recap[0])
    total[1] += parseFloat(recap[1])
    total[2] += parseFloat(recap[2])
    total[3] += parseFloat(recap[3])
    total[4] += parseFloat(recap[4])
    total[5] += parseFloat(recap[5])
    final.push [recap, total]
    final
  ).property()

  actions:
    editTransaction: (transaction) ->
      @transitionToRoute 'transactions.edit', transaction
    goToToday: ->
      Ember.$('.ember-list-view').scrollTop((@get('scrollToToday')-1)*86)
    add1Day: (transaction) ->
      transaction.set('closeDate', moment(transaction.get('closeDate')).add(1, 'day').toDate())
      transaction.save()
    add7Days: (transaction) ->
      transaction.set('closeDate', moment(transaction.get('closeDate')).add(7, 'day').toDate())
      transaction.save()