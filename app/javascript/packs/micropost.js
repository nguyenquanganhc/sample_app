$(function() {
  $('#micropost_image').on('change', function () {
    var size_in_megabytes = this.files[0].size / 1024 / 1024;
    var max = parseInt($('#data_passing').attr('max'));
    if (size_in_megabytes > max) {
      alert(I18n.t("message_image"))
    }
  });
})
