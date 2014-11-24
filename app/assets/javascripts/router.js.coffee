Axialize.Router.map () ->
  @resource 'transactions', path: '/', ->
    @route 'edit', path: '/edit/:id'