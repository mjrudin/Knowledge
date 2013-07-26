PT.Views.PhotosViewController = function(photos) {
  this.photos = photos;
  this.$el = $("<div></div>");
  this.template = JST["templates/photos"];
};

PT.Views.PhotosViewController.prototype.render = function() {
  this.$el.html(this.template({photos: this.photos}));
  this.installClickHandlers();
  return this;
};

PT.Views.PhotosViewController.prototype.installClickHandlers = function() {
  var that = this;
  this.$el.find("form").on('submit', function(event) {
    event.preventDefault();
    (new PT.Models.Photo({url: that.$el.find("#photo-url").val()})).save(function(){
      that.$el.find("#photo-url").val("");
      that.render();
    });
  });
  this.$el.find(".photo-thumb").on('click', function(event) {
    event.preventDefault();
    var id = $(event.currentTarget).attr('data-id');
    that.$el.html(
      new PT.Views.TaggingViewController(
        PT.Models.Photo.find(id),
        that.render.bind(that)
      ).render().$el
    );
  });
};