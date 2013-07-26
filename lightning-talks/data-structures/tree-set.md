# Tree set

## "Array set"

* Store all items in an array.
* `contains?` goes through whole array, looks at each item.
    * Slow.
* Insert performs a `contains?`, and then just tacks on the item if it
  isn't already present.
    * Slow, because `contains?` is slow.

## Tree set

* Thought exercise: what if the array were sorted?
    * Then we could use binary search to quickly find the element.
* Binary search is much faster for lookup.
* But if we dynamically add elements, how do we preserve the order?
    * If the array becomes unordered, then we can't do binary search.
    * For each item, we'd have to look up where it goes, then try to
      insert it there.
    * But insertion into the middle of an array is slow.
    * So `add` is still slow.

A tree set stores items in a tree; each *node* in the tree has a left
and right child. The trick in a tree set is to always keep the left
child smaller than the parent, and the right child should always be
larger.

* `contains?` is still fast, because at each node we either go right
  or left, allowing us to disregard about half the tree.
    * Assumes a balanced tree.
* `add` is fast, too.
    * We do a `contains?` search for the item.
    * If we find the item, great. Do nothing (already in set).
    * If we don't, we get down to a node which either:
        1. is smaller than our item, but has no right child.
        2. is bigger than our item, but has no left child.
    * In either case, you just create a new node and add it as a
      child.

**TODO**: explain that the max search time is `log(n)`. This is easy;
they intuitively understand each level has `2^n` nodes.

**TODO**: if you take a tree and project it down onto the x-axis; it's
a sorted array, and your search is a binary search.
