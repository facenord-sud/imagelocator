$.rails.allowAction = (link) ->
  return true unless link.attr('data-confirm')
  $.rails.showConfirmDialog(link) # look bellow for implementations
  false # always stops the action since code runs asynchronously

$.rails.confirmed = (link) ->
  link.removeAttr('data-confirm')
  link.trigger('click.rails')

$.rails.showConfirmDialog = (link) ->
  message = link.attr 'data-confirm'
  swal({
    title: message,
    text: '',
    type: "warning",
    showCancelButton: true,
    allowOutsideClick: true,
    confirmButtonColor: "#DD6B55",
    confirmButtonText: "YES",
    closeOnConfirm: false },
    handleClick = (isConfirm) ->
      if isConfirm
        $.rails.confirmed(link)
  )