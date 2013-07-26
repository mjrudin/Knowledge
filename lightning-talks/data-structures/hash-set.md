# Hash set

A tree set is relatively fast; you need to examine `log(n)`
elements. This grows very slowly as you add more elements. However, we
can go even faster.

We talked about keeping elements in a dynamic array, but even if we
kept the array in sorted order (which made insertions/removals
costly), we had to jump around as much as if we jumped around a tree
set.

## Storing numbers in a range

Let's talk about a special case where we can avoid jumping. Imagine we
want to store a subset of the numbers `(0...4)`. Not all of them will
be in the set, but no numbers outside the range will appear. Then we
can represent the set `{1, 3}` like so:

```
# indices [  0,   1,   2,   3,   4]
   set =  [nil,   1, nil,   3, nil]
```

At each index, we store `nil` if the object isn't in the set;
otherwise we store the item itself.

Because array indexing and assignment are fast, we can very quickly
lookup whether a number is present (`not set[num].nil?`), add it
(`set[num] = num`), or remove it (`set[num] = nil`).

Of course, this has the major limitation that we can only store
numbers in a limited range. It may also use a lot of memory; if we
wanted to store numbers in `(1..1_000_000)`, we'd have to use an array
of a million nils, even if we only had a few elements in the set.

## Using less space

Let's fix the space problem first. The trick is to use a smaller
array. Instead of placing `num` at position `num`, we place it at
position `num % store.length`. This array represents `{11, 15 25}`:

```
# indices = [ 0,   1,   2,  3,  4,        5,  6,  7,  8,  9]
      set = [[], [11], [], [], [], [15, 25], [], [], [], []]
```

As we see from above, we need to allow the possibility that multiple
items are placed in the same spot. We implement the set methods like
so:

```
contains?: set[num % set.length].include?(num)
      add: set[num % set.length] << num if set.contains?(num)
   remove: set[num % set.length].delete(num)
```

## Bucket size, speed, resizing

The inner arrays in the store are called *buckets*. If all of the
buckets contain at most one element, this new version is basically as
fast as our original, space hungry version.

Things slow down as the buckets fill up. Let's say we put `1_000_000`
elements into our set. Each bucket would have about `100_000` elements
in each bucket. Doing an `include?` on an array of 100k elements
involves looking at them all; that's way worse than a tree set
`log_2(100_000) == 16.61`.

The trick is to every once in a while resize the hash map to grow the
number of buckets as we add more items. We refer to `num_elements /
store_size` as the *load factor*; a typical load factor limit is
90%. Most of the buckets should have one or two items.

Whenever we add an item that would push us past the load factor limit,
we allocate a new store with twice as many buckets, then go through
all the items in the old store and place them in their new
location. Note that some of the previous *colliding pairs* (different
numbers that were placed in the same bucket) may be broken up into
different buckets.

This keeps buckets small and fast to search through, but it also
doesn't use too much space. Because we only resize (double in size)
when load hits 90%, the load is never less than `.90 * .50 == .45`.

## Storing arbitrary objects

This worked for numbers, but what about other objects (e.g., strings)?
We used the number-item itself to compute the bucket number; we need a
new way to comute a bucket number.

To do this, we use a *hash function*. A hash function takes an object
and produces a random-looking, scrambled number from it. Essentially,
the computed hash value is stable; it is not actually random, so
`obj.hash` won't ever change (for the same object). Because the hash
value is stable, we can use it as a bucket id.
