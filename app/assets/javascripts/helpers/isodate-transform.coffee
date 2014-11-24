Axialize.IsodateTransform = DS.Transform.extend
  deserialize: (serialized) ->
    if serialized
      moment(serialized).toDate()
    else
      null

  serialize: (date) ->
    if date then moment(date).format("YYYY-MM-DD") else null