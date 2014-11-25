Axialize.Transaction = DS.Model.extend
  name: DS.attr 'string'
  amount: DS.attr 'number'
  description: DS.attr 'string'
  stageName: DS.attr 'string'
  closeDate: DS.attr 'isodate'
  owner: DS.attr 'string'
  #recordTypeId: DS.attr 'string'

  sum: 0

  #define each late step (not closed)
  isLate: (->
    ['New', 'Analysis', 'Quote sent', 'Negociation', 'Verbal agreement'].contains(@get('stageName')) && (@get('closeDate') < moment().toDate())
  ).property 'stageName', 'closeDate'

  #define each waiting step (not counted in balance)
  isWaiting: (->
    ['New', 'Analysis'].contains(@get('stageName')) && (@get('closeDate') >= moment().toDate())
  ).property 'stageName', 'closeDate'

  #define here each step, in the good order
  isStatus1: (->
    @get('stageName') == 'New'
  ).property('stageName')
  isStatus2: (->
    @get('stageName') == 'Analysis'
  ).property('stageName')
  isStatus3: (->
    @get('stageName') == 'Quote sent'
  ).property('stageName')
  isStatusSigned: (->
    @get('stageName') == 'Negociation'
  ).property('stageName')
  isStatusInvoiced: (->
    @get('stageName') == 'Verbal agreement'
  ).property('stageName')
  isStatusIncPaid: (->
    @get('stageName') == 'Closed won'
  ).property('stageName')
  isTransaction: true