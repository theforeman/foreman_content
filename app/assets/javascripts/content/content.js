$(function () {
  // Disable repository selection input based on checkbox
  $('.repository_selection input:checkbox').click(function () {
    var checked = $(this).is(':checked');
    $(this).parent().find($(':input')).each (function ( index, input) {
      $(input).attr('disabled', !checked);
    });

  });
  // toggle repository ID's to send based on the repo type
  $('.cv-repo-selection').change(function () {
      enable_selected_repository(this);
  });
  $('.cv-repo-selection').change();
});

function enable_selected_repository(element) {
  var select = $(element);
  var id = select.attr('id').replace(/[^\d]/g, '');
  var clone = select.val() == 'clone';
  $('#clone-' + id).attr('disabled', !clone);
  $('#latest-' + id).attr('disabled', clone);
};