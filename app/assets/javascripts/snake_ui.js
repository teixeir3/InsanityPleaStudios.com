//= require snake

(function() {
  var UI = window.SnakeUI = (window.SnakeUI || {});

  var View = UI.View = function(htmlEl, max_x, max_y) {
    this.$el = htmlEl;
    this.length = max_x;
    this.width = max_y;
  };

  
  
  var handleKeyEvent = function(event) {


    switch(event.keyCode) {
      case 37:
        event.preventDefault();
        this.board.snake.turn('W');
        break;
      case 38:
        event.preventDefault();
        this.board.snake.turn('N');
        break;
      case 39:
        event.preventDefault();
        this.board.snake.turn('E');
        break;
      case 40:
        event.preventDefault();
        this.board.snake.turn('S');
        break;
      // default:
      //   alert("WTF");
    }
  };
  
  View.prototype.buildGrid = function() {
    for(var y = 0; y < this.width; y++) {
      for(var x = 0; x < this.length; x++) {
       this.$el.append("\<li data-id=\"[" + y + ", " + x + "]\">\<\/li>");
      }
    }
  };

  View.prototype.cleanUpSnake = function() {
    var removeCoord = _.last(this.board.snake.segments);
    var x = removeCoord.x;
    var y = removeCoord.y;
    return [removeCoord, (y * this.width) + x + 1];

  };

  View.prototype.render = function() {

    var that = this;

    this.board.snake.segments.forEach(function(segment) {
      var x = segment.x;
      var y = segment.y;
      var index = (y * that.width) + x + 1;
      that.$el.find('li:nth-child(' + index + ')').addClass('snake');
      // console.log(that.board.snake.segments);
    });


    this.board.apples.forEach(function(apple) {
      var x = apple.x;
      var y = apple.y;

      var index = (y * that.width) + x + 1;
      that.$el.find('li:nth-child(' + index + ')').addClass('apple');

    });


    // var gridArray = this.board.render();
 //    var str = ""
 //    gridArray.forEach(function(row) {
 //      str += '<pre>'
 //      str += row.join(" ");
 //      str += '</pre><br>'
 //    })
 //
 //    this.$el.html(str);

  };

  // var x = Math.floor(index / 3);
//   var y = index%3;

  View.prototype.step = function() {
    //stash in variable here.
    var cleanSnakeArr = this.cleanUpSnake();
    var removeIndex = cleanSnakeArr[1];
    var removeCoord = cleanSnakeArr[0];

    var lookForApple = this.board.snake.segments[0];

    var that = this;
    var shouldRemoveIndex = true;
    this.board.apples.forEach(function(apple) {
      if (lookForApple.equals(apple)) {
        var index = (apple.y * that.width) + apple.x + 1;
        that.$el.find('li:nth-child(' + index + ')').removeClass('apple');
        that.board.apples.splice(that.board.apples.indexOf(apple), 1);
        that.board.growMySnake(removeCoord);
        shouldRemoveIndex = false;
      }
    })

    this.board.snake.move();

    if (shouldRemoveIndex) {
      this.$el.find('li:nth-child(' + removeIndex + ')').removeClass('snake');
    }

    //clean up here
    this.render();

  }


  View.prototype.start = function() {
    this.buildGrid();
    
    this.board = new window.SnakeGame.Board();

    var that = this;
    $(function() {            //handleKeyEvent(event).bind(this)
      $(document).on('keydown', handleKeyEvent.bind(that)


    );
    });

    //interval with #step.
    this.timerId = setInterval(function() {
      that.step();
    },150);


  };



})();