PT.Views.TaggingViewController = function(photo, backCallback) {
  this.photo = photo;
  this.backCallback = backCallback;
  this.$el = $("<div></div>");
  this.template = JST["templates/tagging"];
};

PT.Views.TaggingViewController.prototype.render = function() {
  this.$el.html(this.template({photo: this.photo}));
  this.installClickHandlers();
  return this;
};

PT.Views.TaggingViewController.prototype.installClickHandlers = function() {
  var that = this;
  this.$el.find('.back-btn').on('click', function() {
    that.backCallback();
  });
};