$(function () {
  // Disable repository sync input based on checkbox
  $('#content_repository_schedule').click(function () {
    $('#sync_schedule_form select').attr('disabled', !$(this).is(':checked'));
  });
  // try to guess architecture based on the URL
  $('#content_repository_feed').focusout(function() {
    url = $(this).val();
    if (url == undefined || url == '')
      return;

    $('#content_repository_architecture_id option').each (function ( index, option) {
      if (url.match(option.text)) {
        $('#content_repository_architecture_id').val(option.value);
        return false;
      }
    })
  });
});