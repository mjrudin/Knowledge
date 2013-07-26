# Data structures: Abstract data types

## ADT

## Sequence

* Stores a linear sequence of data.
    * The `Array` class represents a sequence.
* `seq[index]`, `seq.front`, `seq.back`
* `seq[index] = item`
* `seq.insert(index, item)`, `seq.remove(index)`
    * `seq.push(item)`, `seq.pop`

## Sets

* `set.add(item)`
    * No duplicates!
* `set.remove(item)`
* `set.contains?(item)`
    * This is the heart of a set
    * `add` needs to know if an item is already inserted
    * `remove` needs to know where to find an item to remove.

Unlike sequences, sets do not keep track of the order of their
elements. This will allow us to make sets that are much faster for the
limited subset of methods we list here.

## Map

* `map.set(key, value)`
* `map.get(key)`
