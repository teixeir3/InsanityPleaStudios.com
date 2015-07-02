

(function() {
  var SnakeGame = window.SnakeGame = (window.SnakeGame || {});

  var Snake = SnakeGame.Snake = function() {
    this.dir = "E";
    this.segments = [new Coord(6,6), new Coord(6,7)];


  };

  Snake.prototype.move = function() {

    var newCoord = this.segments[0].plus(this.dir);

    // move each segment
    this.segments.unshift(newCoord);
    this.segments.pop();


  };

  // Snake.prototype.moveBody = function() {
  //   this.segments.forEach(function(segment) {
  //
  //   });
  // };

  Snake.prototype.containsSegment = function(pos) {
    // returns true if a segment occupies a pos
    this.segments.forEach(function(segment) {
      console.log(pos);
      console.log(segment);
    });
  };

  Snake.prototype.turn = function(newDir) {
    this.dir = newDir;
  };

  var Coord = SnakeGame.Coord = function(x, y) {
    this.x = x;
    this.y = y;
  }
  //coord plus method.

  Coord.DELTA = {N: [0, -1], E: [1, 0], S: [0, 1], W: [-1, 0]}

  Coord.prototype.plus = function(dir) {
    var delta = Coord.DELTA[dir]
    var newCoord = new Coord(this.x + delta[0], this.y + delta[1]);
    return newCoord;

  };
  
  Coord.prototype.equals = function(coord) {
    if (this.x == coord.x && this.y == coord.y) {
      return true;
    }
    
    return false;
  };
  
  // Coord.prototype.valid = function() {
  //
  // }

  Snake.DIRS = ["N", "E", "S", "W"];

  var Board = SnakeGame.Board = function() {
    this.snake = new Snake();
    this.apples = [new Coord(3,3)]; //TODO make more apples spawn
  };

  Board.DIM_X = 20;
  Board.DIM_Y = 20;

  Board.prototype.growMySnake = function(newCoord) {

    this.snake.segments.push(newCoord);


  }

  Board.prototype.render = function() {


    var emptyGrid = _.times(Board.DIM_X, function (i) {
      return _.times(Board.DIM_Y, function (j) {
        return ".";
      });
    });


    var filledGrid = this.populate(emptyGrid);
    return filledGrid;

  };
  
  Board.prototype.validCoord = function(coord) {
    if (coord.x < 0 || coord.x > this.DIM_X || coord.y < 0 || coord.y > DIM_Y) {
      return false;
    } 
    
    return true;
  }

  Board.prototype.populate = function(grid) {

    this.snake.segments.forEach(function(segment) {
      grid[segment.y][segment.x] = 'S';
    });

    this.apples.forEach(function(apple) {
      grid[apple.y][apple.x] = 'A';
    });

    return grid;
  };
})();