Axialize.TransactionBoxComponent = Ember.Component.extend
  classNames: ['transaction-box']
  classNameBindings: ['transaction.typeTransaction']
  didInsertElement: ->
    @$().draggable(
      scroll: false
      addClasses: false
      helper: =>
        clone = @$().clone()
        clone.offset(@$().offset())
        clone.removeClass('ember-view')
        clone.find('script[id^=metamorph]').remove()
        clone.removeAttr('id')
        clone.find('*').each ->
          $this = $(@)
          $.each $this[0].attributes, (index, attr) ->
            return if attr.name.indexOf('data-bindattr') == -1
            $this.removeAttr(attr.name)
        clone.find('[id^=ember]').removeAttr('id')
        clone.css(width: @$().css('width'), borderColor: @$().css('borderTopColor'), backgroundColor: @$().css('backgroundColor'))
        clone
      zIndex: 10000
      revert: 'invalid'
      appendTo: 'body'
      containment: 'body'
      start: (e, ui) ->
        $(ui.helper.context).css('opacity', 0.5)
      stop: (e, ui) ->
        $(ui.helper.context).css('opacity', 1)
    ).data('id', @get('transaction.id'))
  willDestroyElement: ->
    @$().draggable('destroy')
    return
  transactionChanged: (->
    @$().data('id', @get('transaction.id'))
  ).observes 'transaction'
  dateToShow: (->
    return @get('transaction.closeDate') if @get('transaction.stageName') == 'Closed won'
    null
  ).property('transaction.stageName', 'transaction.closeDate')

  click: ->
    @sendAction 'action', @get('transaction')
