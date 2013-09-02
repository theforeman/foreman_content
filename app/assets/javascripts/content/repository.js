$(function () {
  // Disable repository sync input based on checkbox
  $('#content_repository_schedule').click(function () {
    $('#sync_schedule_form select').attr('disabled', !$(this).is(':checked'));
  });

});