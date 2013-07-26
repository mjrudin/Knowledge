# Intro to Algorithms and Data Structures

## Goals

* Know what an algorithm is.
* Know what a data structure is.
* Know what a tree is.
* Know what DFS and BFS are

This class won't focus heavily on abstract algorithms: we will not
become experts in every algorithm under the sun. We are going to cover
the basic algorithms that *will* prove useful in your career.

Coding up algorithms is a good way to practice the skills we've been
learning. It gives you practice thinking like a programmer. Given a
description of an algorithm, you should be able to translate that into
Ruby code. That's our primary goal in this chapter.

## Trees

Ruby provides an Array class which is a "linear" collection of
elements. But there are other ways to represent collections and
organize data.

[*Trees*](http://en.wikipedia.org/wiki/Tree_data_structure) store data in a *hierarchy* of layers. An element, or *node*
at each layer can have links to lower level nodes. One simple example
is a file system:

* /
    * Users
        * ruggeri
            * Desktop
            * Documents
            * Downloads
        * patel
            * Desktop
            * Downloads
  * System
        * Library

The top-level *node* is called the *root*. Each node can hold a value:
here the root holds '/'. The *children* of a node are the nodes one
level deeper. The children of the 'Users' node hold 'ruggeri' and
'patel'. The lowest level nodes (the ones with no children) are called
*leaves*.

In general, nodes can have any number of children. In the special case
of *binary trees*, nodes can have at most two children. These children
are called the *left* and *right* children.

An array and a tree are two kinds of *data structures*. A data
structure is a way of storing and organizing data in a computer so
that it can be used efficiently. Depending on how you will use the
data, different data structures may be appropriate.

## Depth First Search ([DFS](http://en.wikipedia.org/wiki/Depth-first_search))

Given a tree, we may wish to enumerate all the values held by nodes in
the tree. For instance, we may wish to go through the files/folders of
the tree and print each one.

One common way to traverse (i.e., visit all the nodes) a tree is depth
first search. The nodes are numbered in the order that we visit them:

          1
         / \
        2   5
       /   / \
      3   6   9
     /   / \
    4   7   8

Each time, we try to visit the left child, if it exists and hasn't
been visited yet. If it has, we try to visit the right child, if it
exists and hasn't been visited yet. If all the children have been
visited, then we move up one level and repeat.

## Breadth first search ([BFS](http://en.wikipedia.org/wiki/Breadth-first_search))

Breadth first search is an alternative to depth-first search.

          1
         / \
        2   3
       /   / \
      4   5   6
     /   / \
    7   8   9

Here we visit a node, then each of its children, then each of their
children, etc.

An advantage of breadth-first search is that it considers shallower
nodes before deeper ones.

## Algorithm

DFS and BFS are *algorithms*. An algorithm can be written in any
language; we'll write Ruby methods that *implement* DFS and BFS
shortly. What's the difference between an algorithm and a method? An
algorithm is the *concept*, an unambiguous but unrealized version of a 
process that solves a problem and which potentially could be written in any 
language. A method is the *implementation*, a conversion of an algorithm 
into Ruby code which can then be run.

## Exercises

Estimated time: 8hrs

### Implement a TreeNode class

Write a class named `TreeNode` which represents a node in a binary
tree. It should have the following interface:

* A `#parent` method to get the node's parent (if any)
* Setters and getters for the `left` and `right` child nodes
  * `parent_node.left = child_node` should also set the
    `child_node.parent` to `parent_node`
  * if there was a previous `left` child node that was replaced, the
    original `left` child should have its parent reset to `nil`
* Setter and getters for the node's `value`

* Write a method `dfs` which takes a value to search for and performs
  the search.
  * Write this recursively
    * first check the value at this node
    * next recursively check left node
    * next recursively check the right node
  * If a node's value matches the target value, return the node.

* Write a method `bfs` to implement breadth first search
  * You will use a local `Array` variable to implement this
  * First insert the current node (`self`) into the array
  * Then, in a loop that lasts while the array is not empty
    * remove the first node
    * check its value
    * push the node's children to the end of the array
  * Prove to yourself that this will check the nodes in the right
    order

* Improve your `TreeNode` to handle an arbitrary number of children
* Improve your searches to optionally take a block that will return
  true when an acceptable value is found (i.e., find the first node 
  that makes the block return true.)

## References

* Wikipedia: [Data structure](http://en.wikipedia.org/wiki/Data_structure)
* Wikipedia: [Algorithm](http://en.wikipedia.org/wiki/Algorithm)
* Cool Ruby Algorithm Library: https://github.com/kanwei/algorithms
* Wikipedia: [http://en.wikipedia.org/wiki/Minimax]
* Depth First Youtube video [http://www.youtube.com/watch?v=CIm6RzdoPCI]
* One Tree To Rule Them All (great page/tutorial on tree structure!) [http://ruby.about.com/od/textadventure/ss/One-Tree-To-Rule-Them-All.htm]

