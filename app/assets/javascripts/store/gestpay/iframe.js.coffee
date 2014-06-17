class iframe
  constructor: (selector) ->
    @$container = $(selector)

  generate: ->
    # probably not on the correct page
    return if @$container.length < 1

    $.ajax
      type: "POST"
      url:  @$container.data("token-path")
      data:
        transaction: @$container.data("transaction")
        amount:      @$container.data("amount")
      dataType: "json"
    .done (response) ->
      token = response.token
      console.log(token)
    .fail (response) ->
      json = $.parseJSON(response.responseText)
      console.log(json.error)

$ ->
  new iframe(".gestpay-token-data").generate()
