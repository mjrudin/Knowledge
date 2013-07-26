# Tic-tac-toe AI

*You should have extended your TreeNode to have multiple children before
you implement this.

Extend your tic-tac-toe AI player so that is is unbeatable.

You can imagine representing the possibilities of the game in a
tree. Each node has a value representing a grid. There would be one
child node for each possible move. For convenience, we may want to
also store who moves next in the `TreeNode`'s `value` (maybe we could
use a hash `{:grid => grid, :next_move => :x}`).

The leaves of the tree are the winning, losing, and drawing grids.

Let us define a *winning grid* for a player:

* the grid is a complete game where the player has won
* it is a grid that, no matter the opponent's move, the resulting
  position is a winning grid

A winning move is one which leads to a winning grid. A losing move is
one which allows the opponent to reply with a winning move.

You should write your AI so that it

1. makes a winning move if possible
2. avoids any losing moves
3. otherwise moves randomly

The crux of your task is in implementing a `is_winning_node?(node,
player)`. Intuitively, this should check that every child (grid after
opponent's move) has a child (grid after our next move) which
`is_a_winning node?`. To be clear, a winning node is one that absolutely
wins, regardless of what your opponent plays.

`is_losing_node?` should then be easy to define; none of the child
nodes should be a winning node for the opponent. If a move results in
your opponent having a winning node, you must trim that move.

Final note: since the kind of search we're doing to evaluate
`is_winning_node?` is a little sophisticated, it doesn't fit under DFS
or BFS. That's okay; you'll have to figure out the proper recursion.

Another note: when building the game tree, if you do not trim it, it could
take upwards of 10 minutes (if not more). Think of ways to reduce branching. For example,
if there is a winning move one could make, there is no way they would choose
any other move.
