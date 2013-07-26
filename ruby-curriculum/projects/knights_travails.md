# Knight's Travails

In this problem we want to write a class that will find a path for a
Chess Knight from a starting position to an end position.

Write a class, `KnightPathFinder`. Initialize your `KnightPathFinder`
with a starting position. For instance

    kpf = KnightPathFinder.new([0, 0])

Ultimately, I want to be able to find paths to end positions:

```ruby
kpf.find_path([2, 1]) # => [[0, 0], [2, 1]]
kpf.find_path([3, 3]) # => [[0, 0], [2, 1], [3, 3]]
```

To help us find paths, we want to build a *move tree*. The values in
the tree will be positions. A parent is connected to a child if you
can move from the parent position to the child position. The root of
the tree should be the knight's starting position.

Write a method `KnightPathFinder#build_move_tree` to build the move
tree and store it in an instance variable. Call this method in
`initialize`; you'll use the move tree whenever we call `find_path`.

In building the move tree, you'll want to be able to find new
positions you can move to from a current position. Write a class
method `KnightPathFinder::new_move_positions(pos)`. There are up to
eight possible moves.

You'll also want to avoid repeating positions in the move tree. Inside
`build_move_tree`, keep track of the visited positions. You shouldn't
need an instance variable to do this; use a local variable. Note that
if you don't keep track of visited positions, you will probably get
caught in a loop (move back and forth between adjacent positions).

You want to make sure your tree will represent the shortest paths to
any position. Build your tree in a *breadth-first* manner. Find all
the positions that are one move away, then all the ones that are two
moves away, then three...

Now you are ready to write `#find_path(target_pos)`. Find path should
search in your move tree for the `target_pos`. You should use either
your `dfs` or `bfs` methods from the TreeNode exercises. This will
return a tree node which is the final destination.

This gives us a node, but not a path. Lastly, add an instance method
`TreeNode#path` to your `TreeNode` class. This should trace back from
the node to the root using `#parent`. As it goes up-and-up toward the
root, it should add each value to an array. `#path` should return the
values in order from the root down to the node.

Use `TreeNode#path` to finish up `KnightPathFinder#find_path`.
