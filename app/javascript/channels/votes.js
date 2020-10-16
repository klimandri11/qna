$(document).on("turbolinks:load", function() {


  $(".vote_for_against").on("ajax:success", function(e) {
    var vote = e.detail[0]
    var model = "#vote-" + vote.klass + "-" + vote.id
    $(model + ' .difference').html('difference: ' + vote.value)
    $(model + ' .vote_for_against').addClass('hidden')
    $(model + ' .vote_unvote').removeClass('hidden')
  })

  $(".vote_unvote").on("ajax:success", function(e) {
    var vote = e.detail[0]
    var model = "#vote-" + vote.klass + "-" + vote.id
    $(model + ' .difference').html('difference: ' + vote.value)
    $(model + ' .vote_for_against').removeClass('hidden')
    $(model + ' .vote_unvote').addClass('hidden')
  })
})
