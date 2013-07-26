window.PT = {
  Models: {},
  Views: {}
}

PT.Models.Base = function(attrs, baseUrl) {
  this.setAttributes(attrs);
  this.baseUrl = baseUrl;
};

PT.Models.Base.prototype.setAttributes = function (params) {
  var that = this;
  _(params).each(function (value, key) {
    that[key] = value;
  });
};

PT.Models.Base.prototype.save = function(callback) {
  if (this.id !== null && this.id !== undefined)
    this._update(callback);
  else
    this._create(callback);
};

PT.Models.Base.ajaxHelper = function(base, url, data, type, callback) {
  var ajaxParams = { url: url, type: type, success: callback };
  if (data) {
    ajaxParams.data = data;
    ajaxParams.contentType = "application/json; charset=utf-8";
  }
  $.ajax(ajaxParams);
};

PT.Models.Base.prototype._create = function(callback) {
  var that = this;
  PT.Models.Base.ajaxHelper(
    this, 
    this.baseUrl + ".json", 
    JSON.stringify(this), 
    "post",
    function(json) {
      that.setAttributes(json);
      that.constructor._all.push(that);
      if (callback) callback(that);
    }
  );
};

PT.Models.Base.prototype._update = function(callback) {
  var that = this;
  PT.Models.Base.ajaxHelper(
    this, 
    this.baseUrl + "/" + this.id + ".json", 
    JSON.stringify(this),
    "put",
    function(json) {
      that.setAttributes(json);
      if (callback) callback(that);
    }
  );
};

PT.Models.Base.prototype.fetch = function(callback) {
  var that = this;
  PT.Models.Base.ajaxHelper(
    this, 
    this.baseUrl + "/" + this.id + ".json", 
    null,
    "get",
    function(json) {
      that.setAttributes(json);
      if (callback) callback(that);
    }
  );
};

PT.Models.Base.prototype.destroy = function(callback) {
  var index = this.constructor._all.indexOf(this);
  var that = this;
  PT.Models.Base.ajaxHelper(
    this, 
    this.baseUrl + "/" + this.id + ".json", 
    null,
    "delete",
    function() {
      that.constructor._all.splice(index, 1);
      if (callback) callback();
    }
  );
};

PT.Models.Base.createSubClass = function(baseUrl) {
  var klass = function(attrs) {
    PT.Models.Base.call(this, attrs, baseUrl);
  };
  klass._all = [];
  klass.fetch = function(callback) {
    $.ajax({
      url: baseUrl + ".json",
      type: "get",
      success: function(dataJSON) {
        klass._all = [];
        _(dataJSON).each(function(data){
          klass._all.push(new klass(data));
        });
        if (callback) callback(klass._all);
      }
    });
  };
  klass.find = function(id, callback) {
    var f = _.findWhere(klass._all, {id: parseInt(id)});
    if (callback) callback(f);
    return f;
  };
  klass.prototype = new PT.Models.Base();
  klass.prototype.constructor = klass;
  return klass;
}

PT.Models.User = PT.Models.Base.createSubClass("/users");
PT.Models.Photo = PT.Models.Base.createSubClass("/photos");
PT.Models.Tag = PT.Models.Base.createSubClass("/tags");

$(function () {
  PT.Models.Photo.fetch(function (photos) {
    var indexView = new PT.Views.PhotosViewController(photos);
    $("#content").html(indexView.render().$el);
  });
});