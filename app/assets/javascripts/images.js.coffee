$(document).ready ->
  $("#images").infinitescroll
    navSelector: "ul.pagination" # selector for the paged navigation (it will be hidden)
    nextSelector: "ul.pagination a[rel=next]" # selector for the NEXT link (to page 2)
    itemSelector: "#images li.image" # selector for all items you'll retrieve
$(document).ready ->
  lastResult = []
  format = (record) ->
    record.text
  $('#tags').select2({
    placeholder: 'Add tags to your images'
    minimumInputLength: 1
    multiple: true
    ajax: #instead of writing the function to execute the request we use Select2's convenient helper
      url: '/tags/search'
      dataType: 'json'
      data: (term, page) ->
        q: term
      results: (data, page) ->
        results: data
    initSelection: (element, callback) ->
      id_string = element.val()
      tag_ids = id_string.split(',')
      datas = []
      for tag_id in tag_ids
        if not isNaN(tag_id)
          $.ajax('/tags/search.json?id='+tag_id).done((data) ->
            if data.length > 0
              datas.push(data[0])
              $.event.trigger({type:'init:done'})
          )
        $(document).on('init:done', ->
          callback(datas)
        )
    dropdownCssClass: "bigdrop"
  });