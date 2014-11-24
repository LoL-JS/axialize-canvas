Axialize.ListTransactions = Ember.ListView.extend
  height: 1
  rowHeight: 86
  didAdjustOnResize: (->
    Ember.$(window).resize(=>
      Ember.run(=>
        @adjustLayout()
      )
    )
    @$().prepend($('
      <div id="transaction-header">
          <div class="only header-1">'+@get('controller.stageNames').objectAt(0).get('masterLabel')+'</div><!--
          --><div class="only header-2">'+@get('controller.stageNames').objectAt(1).get('masterLabel')+'</div><!--
          --><div class="only header-3">'+@get('controller.stageNames').objectAt(2).get('masterLabel')+'</div><!--
          --><div class="only header-signed">'+@get('controller.stageNames').objectAt(3).get('masterLabel')+'</div><!--
          --><div class="only header-invoiced">'+@get('controller.stageNames').objectAt(4).get('masterLabel')+'</div><!--
          --><div class="only header-inc-paid">'+@get('controller.stageNames').objectAt(5).get('masterLabel')+'</div><!--
          --><div class="only header-sum">'+Ember.I18n.t('transaction.balance')+'</div>
      </div>
    '))
  ).on('didInsertElement')

  destroy: (->
    Ember.$(window).off('resize')
  ).on('willDestroyElement')

  didScroll: (->
    @$().on('scroll', (e) =>
      @$('#transaction-header').css('top', e.target.scrollTop+1)
    )
  ).on('didInsertElement')

  adjustLayout: (->
    @set('height', Ember.$('body').height())
  ).on('didInsertElement')

  itemViewClass: Ember.ReusableListItemView.extend
    templateName: "transaction-row"

    classNameBindings: ['stageName', 'today']

    today: (->
      return "today-before" if @get('context.isTodayBefore')
      return "today-after" if @get('context.isTodayAfter')
    ).property('context.isTodayBefore', 'context.isTodayAfter')

    todayDate: (->
      moment().format(Ember.I18n.t('date.format'))
    ).property()

    stageName: (->
      return "is-late" if @get('context.isLate')
      return "is-1" if @get('context.isStatus1')
      return "is-2" if @get('context.isStatus2')
      return "is-3" if @get('context.isStatus3')
      return "is-signed" if @get('context.isStatusSigned')
      return "is-invoiced" if @get('context.isStatusInvoiced')
      return "is-inc-paid" if @get('context.isStatusIncPaid')
    ).property 'context.isLate', 'context.isWaiting', 'context.stageName'

    isTransaction: (->
      @get('context.isTransaction')
    ).property('context')


