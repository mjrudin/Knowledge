// Create a to-do list app created entirely with jQuery
// (1) Start by creating the container to hold your to-dos and to-do form
// (2) The container should hold an additional container of the to-dos
// (3) There should be a visual indication that a to-do has been completed
//     (new background color, etc)
// (4) A user can also delete a to-do, removing it from the list

$(function() {
  var toDo = (function() {
    // constructor for to-do container (app view)
    function AppView(el) {
      var that = this;

      that.render = function() {
        var form = new FormView();

        el.append(that.createHeader());
        el.append(that.createErrorMsg());
        el.append(form.render());
        el.append(that.createTodoList());
      };

      // view helpers
      that.createHeader = function() {
        var header = $("<h1>");

        header.html("My To-Dos!");

        return header;
      };

      that.createTodoList = function() {
        var container = $("<div>");

        container.attr("id", "item-index");

        return container;
      };

      that.createErrorMsg = function() {
        var container = $("<div>");

        container.attr("class", "error");
        container.html("Try that again");

        return container;
      };

      that.addItemListener = function() {
        $("#item-create").click(function() {
          var body = $("#item-body").val();

          if (body === "") {
            $(".error").show();
          } else {
            $(".error").hide();
            $("#item-body").val("");
            new ItemView($("#item-index"), body);
          }
        });
      };

      that.initialize = (function() {
        that.render();
        that.addItemListener();
      })();
    }

    // constructor for to-do creator
    function FormView() {
      var that = this;

      that.render = function() {
        var container = $("<div>");

        container.attr("id", "item-new");
        container.html(that.createForm());

        return container;
      };

      that.createForm = function() {
        var form = $("<form>");
        form.append(that.createInput()).append(that.createButton());

        return form;
      };

      that.createInput = function() {
        var input = $("<textarea>");

        input.attr("rows", "5");
        input.attr("id", "item-body");

        return input;
      };

      that.createButton = function() {
        var button = $("<button>");

        button.attr("id", "item-create");
        button.attr("type", "button");
        button.html("New To-Do");
        button.css("display", "block");

        return button;
      };
    }

    // constructor for each to-do item
    function ItemView(el, body) {
      var that = this;

      that.render = function() {
        var container = $("<div>");

        container.addClass("item");
        container.append(that.createDeleteButton());
        container.append(that.createBody());
        container.append(that.createStatusInput());

        el.append(container);
      };

      // view helpers
      that.createBody = function() {
        var paragraph = $("<p>");
        paragraph.html(body);

        return paragraph;
      };

      that.createStatusInput = function() {
        var container = $("<div>");
        var label = $("<label>");
        var checkbox = $("<input>");

        container.addClass("status");
        label.attr("for", "item-status");
        label.html("complete");
        checkbox.attr("type", "checkbox");
        checkbox.attr("name", "item-status");
        checkbox.attr("id", "item-status");
        container.append(label).append(checkbox);

        return container;
      };

      that.createDeleteButton = function() {
        var button = $("<button>");

        button.html("&times;");
        button.addClass("item-delete");
        button.attr("type", "button");

        return button;
      };

      // listeners
      that.toggleStatus = function() {
        $("#item-status").click(function() {
          var item = $(this).closest(".item");

          if (item.hasClass("complete")) {
            item.removeClass("complete");
          } else {
            item.addClass("complete");
          }
        });
      };

      that.deleteItemListener = function() {
        $(".item-delete").click(function() {
          $(this).closest(".item").remove();
        });
      };

      that.initialize = (function() {
        that.render();
        that.deleteItemListener();
        that.toggleStatus();
      })();
    }

    return {
      AppView: AppView,
      FormView: FormView,
      ItemView: ItemView
    };
  })();

  new toDo.AppView($(".todo-app"));
});