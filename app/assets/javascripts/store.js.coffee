Axialize.TransactionSerializer = DS.RESTSerializer.extend
  primaryKey: 'Id'

  normalizeHash:
    transactions: (hash) ->
      hash.owner = hash.owner.Name
      hash

  serialize: (record, options) ->
    json = record.toJSON()
    delete json.owner
    json

  keyForAttribute: (attr) ->
    Ember.String.classify(attr)

Axialize.StageSerializer = DS.RESTSerializer.extend
  primaryKey: 'Id'

  keyForAttribute: (attr) ->
    Ember.String.classify(attr)

Axialize.TransactionAdapter = DS.RESTAdapter.extend
  find: (store, type, id) ->
    new Promise (resolve, reject) ->
      resolve({transaction: {id: 1, label: 'test', value: 123, typeTransaction: 'in', status: 1, dateSigned: '2014-07-16', dateInvoiced: '2014-07-16', dateIncPaid: '2014-07-16', owner: 'Pierre Fraisse'}})

  findAll: (store, type, sinceToken) ->
    url = window.sr.context.links.queryUrl+'?q=SELECT+Id,+Name,+Amount,+CloseDate,+StageName,+Owner.Name,+Description+FROM+Opportunity'
    new Ember.RSVP.Promise (resolve, reject) ->
      Sfdc.canvas.client.ajax url,
        client: window.sr.client
        success: (data) ->
          if (data.status == 200)
            resolve transactions: data.payload.records
          else
            reject 'error'


  updateRecord: (store, type, record) ->
    url = window.sr.context.links.sobjectUrl+'Opportunity/'+record.get('id')
    new Ember.RSVP.Promise (resolve, reject) ->
      Sfdc.canvas.client.ajax url,
        client: sr.client
        method: 'PATCH'
        contentType: "application/json"
        data: JSON.stringify(record.serialize())
        success: (data) ->
          if (data.status == 201 || data.status == 204)
            resolve()
          else
            reject 'error'

Axialize.StageAdapter = DS.RESTAdapter.extend
  findAll: (store, type, sinceToken) ->
    url = window.sr.context.links.queryUrl+'?q=SELECT+Id,+MasterLabel,+DefaultProbability+FROM+OpportunityStage+ORDER+BY+DefaultProbability+ASC'
    new Ember.RSVP.Promise (resolve, reject) ->
      Sfdc.canvas.client.ajax url,
        client: window.sr.client
        success: (data) ->
          if (data.status == 200)
            resolve stages: data.payload.records
          else
            reject 'error'

Axialize.RecordTypeSerializer = DS.RESTSerializer.extend
  primaryKey: 'Id'

  keyForAttribute: (attr) ->
    Ember.String.classify(attr)

Axialize.RecordTypeAdapter = DS.RESTAdapter.extend
  findAll: (store, type, sinceToken) ->
    url = window.sr.context.links.queryUrl+'?q=SELECT+Id,+Name+FROM+RecordType+WHERE+SobjectType=\'Opportunity\''
    new Ember.RSVP.Promise (resolve, reject) ->
      Sfdc.canvas.client.ajax url,
        client: window.sr.client
        success: (data) ->
          if (data.status == 200)
            resolve recordTypes: data.payload.records
          else
            reject 'error'

Axialize.ApplicationStore = DS.Store.extend()
