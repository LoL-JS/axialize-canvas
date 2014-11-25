Axialize.TransactionCell = Ember.View.extend
  classNameBindings: ['typeTransaction']
  templateName: 'transaction-cell'
  typeTransaction: (->
    return 'col-1' if @get('stageName') == @get('controller.stageNames').objectAt(0).get('masterLabel')
    return 'col-2' if @get('stageName') == @get('controller.stageNames').objectAt(1).get('masterLabel')
    return 'col-3' if @get('stageName') == @get('controller.stageNames').objectAt(2).get('masterLabel')
    return 'col-signed' if @get('stageName') == @get('controller.stageNames').objectAt(3).get('masterLabel')
    return 'col-invoiced' if @get('stageName') == @get('controller.stageNames').objectAt(4).get('masterLabel')
    return 'col-inc-paid' if @get('stageName') == @get('controller.stageNames').objectAt(5).get('masterLabel')
  ).property()
  showTransaction: (->
    @get('stageName') == @get('transaction.stageName')
  ).property('transaction.stageName')

  dateToShow: (->
    #repeat here the closed stage name
    return @get('transaction.closeDate') if @get('stageName') == 'Closed won'
    null
  ).property('transaction.stageName', 'transaction.closeDate')

  didInsertElement: ->
    @$().droppable
      drop: (e, ui) =>
        @set('transaction.stageName', @get('stageName'))
        @get('transaction').save()
      accept: (draggable) =>
        $(draggable).data('id') == @get('transaction.id') && @get('stageName') != @get('transaction.stageName')
      hoverClass: 'hover-cell'

  willDestroyElement: ->
    @$().droppable('destroy')
