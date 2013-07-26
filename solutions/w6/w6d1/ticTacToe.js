var _ = require('underscore');

function Game() {
  this.player = 'X';
  this.board = this.makeBoard();
}

Game.prototype.switchPlayer = function() {
  (this.player === 'X') ? (this.player = 'O') : (this.player = 'X');
}

Game.prototype.makeBoard = function() {
  var matrix = [];

  _.times(3, function(i) {
    matrix.push([]);
    _.times(3, function() {
      matrix[i].push(" ");
    });
  });

  return matrix;
}

Game.prototype.valid = function(coords) {
  // Check to see if the space is an empty spot. 
  // Also check to see if the co-ords are actually on the board.
  return ( this.board[coords[0]][coords[1]] === " " &&
  _.range(0, this.board[0].length).indexOf(coords[0]) != -1 &&
  _.range(0, this.board[0].length).indexOf(coords[1]) != -1 );
}

Game.prototype.placeMove = function(coords) {
  this.board[coords[0]][coords[1]] = this.player;
}

Game.prototype.win = function() {
  return (this.diagonalWin() || this.horizontalWin() || this.verticalWin());
}

Game.prototype.horizontalWin = function() {
  var verticalPositions = [0, 1, 2];
  var board = this.board;
  var pieces = ['X', 'O'];
  var winner;
  _.each(pieces, function(piece) {
    _.each(verticalPositions, function(i) {
      if (_.every(verticalPositions, function(j) {
        return board[i][j] === piece;
       })) {
          winner = piece;
        }
    });
  });

  return winner;
}

Game.prototype.verticalWin = function() {
  var verticalPositions = [0, 1, 2];
  var board = this.board;
  var pieces = ['X', 'O'];
  var winner;
  _.each(pieces, function(piece) {
    _.each(verticalPositions, function(i) {
      if (_.every(verticalPositions, function(j) {
        return board[j][i] === piece;
      })) {
          winner = piece;
        }
    });
  });

  return winner;
}

Game.prototype.diagonalWin = function() {
  var diagonalPositions1 = [[0, 0], [1, 1], [2, 2]];
  var diagonalPositions2 = [[2, 0], [1, 1], [0, 2]];
  var pieces = ['X', 'O'];
  var board = this.board;
  var winner;
  _.each(pieces, function(piece) {
    if ( _.every(diagonalPositions1, function(coords) {
      return board[coords[0]][coords[1]] === piece;
    })) {
      winner = piece;
    } else if ( _.every(diagonalPositions2, function(coords) {
      return board[coords[0]][coords[1]] === piece;
    })) {
      winner = piece;
    }
  });
  return winner;
}

//g = new Game();
  //console.log(g.valid(['0','0']));

