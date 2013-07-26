# Dynamic array

* A dynamic array stores (references to) Ruby objects in contiguous
  memory cells.
* A dynamic array keeps track of a *store* (where the references are
  stored), the total store space, and the number of items currently
  stored.
* **Indexing** into position `i` means looking up the object reference
  stored at memory address `store_start + (64 * i)`.
    * It is very fast for the computer to compute this memory address;
      computers are great at simple math like this.
    * Once the address is computed, it is very fast to load the
      reference stored at that address; RAM can be loaded very
      quickly.
* Therefore, dynamic arrays have **very fast index** lookup (`array[i]`).
* **Assignment is very fast**; you go to the index in the array (fast,
  like before), and then you just reset the reference at that location.
* **Push is often fast, but sometimes slow**
    * If there is free space in the store, then you just assign the
      pushed reference to index `length + 1` (and increment length).
    * If the store is full, you need to **reallocate** the store with
      more space; it is typical to double the store size.
    * Reallocation requires copying all the references over to the new
      store.
* **Pop is always fast**; you just erase one reference from the end
  and decrement the length
* **Insertion and removal in the middle of the array is slow**
    * You must shift over all the elements to the right of the
      inserted position.
    * This requires copying all the addresses
* NB: The store can keep extra space on both sides of the array for
  extra elements.

**TODO**: show an implementation.
