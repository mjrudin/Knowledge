var Hanoi = {
  tower1: [3,2,1],
  tower2: [],
  tower3: [],

  won: function() {
    if (this.tower2.length === 3 || this.tower3.length === 3) {
      return true;
    } else {
      return false;
    }
  },

  move_valid: function(start_tower, end_tower) {
    if (start_tower.length === 0) {
      return false;
    } else if (end_tower.length === 0 || 
      start_tower[start_tower.length-1] < end_tower[end_tower.length - 1]) {
      return true;
    } else {
      return false;
    }
  },

  move: function(start_tower, end_tower) {
    end_tower.push(start_tower.pop());
  }
};