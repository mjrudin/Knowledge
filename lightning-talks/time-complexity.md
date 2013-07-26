# Time complexity (big-oh)

## Basic complexity classes

Most of the time, when you have twice as much work to do, it takes you
twice as long to do the work. Take, for instance, adding up a list of
numbers. Twice as many numbers means twice as many numbers to add; it
should take twice as long to add them all. That seems fair; this is
called a **linear** problem.

Some tasks get harder and harder. Imagine a set of 5 switches where
only one combination of settings (on/off) will activate a
circuit. There are `2**5` settings. Each time we add an additional
switch, there are twice as many settings to check. This problem
becomes harder and harder as we add additional switches. This is
called an **exponential** problem; these are some of the worst kind of
problems.

Other problems have economies of scale where we can solve much bigger
problems with just a little more work. Consider a problem where we
would like to implement a spell-checker; we need to store a dictionary
set, but we also need to balance the comprehensiveness of the
dictionary with the time it will take to lookup a word.

Let's use a tree set. If we want to limit ourselves to making 10
comparisons, we can store a dictionary of `2**10 = 1024` words. At the
cost of one additional comparison, we could double the size of the
dictionary (1024 new words). And an additional comparison after that
doubles the size again (another 2048 words). The cost of adding a new
word to the dictionary is going down as the dictionary gets bigger.

This is a very desirable kind of problem; it is called
**logarithmic**.

These are our first three *complexity classes*: logarithmic, linear,
and exponential. We'll see a few others soon.

## Run-time

Just because two algorithms belong to the same complexity class
doesn't mean they will take the same amount of time to solve the same
size of problem. For instance, here's an algorithm to find the
smallest number in an array:

```ruby
def min(nums)
  min = nums.first
  nums.each { |n| min = n if n < min }

  min
end
```

This does one comparison per element, for `n` comparisons total. The
algorithm is linear in the number of elements. Here's a second
algorithm, which finds the two smallest numbers:

```ruby
def two_min(nums)
  min1, min2 = nums[0], nums[1]

  nums.each do |n|
    if n < min1
      min1, min2 = n, min1
    elsif n < min2
      min2 = n
    end
  end

  return [min1, min2]
end
```

This does two comparisons for each element in the array, for `2n`
comparisons total. This is again linear in the number of elements, but
we expect it to be about twice as slow.

## Complexity class, problem growth, and run-time

We've seen that two algorithms in the same complexity class may take a
different amount of time to solve the same size problem. What about
algorithms from different classes?

For "large enough" problem sizes, a logarithmic algorithm will always
run faster than a linear algorithm, which will in turn be faster (for
large enough problems) than an exponential algorithm. This is because
the time it takes to run these algorithms grows at different rates.

```
        n=   1| 2| 4|  8|    16
---------------------------------
32+log(n):  32|33|34| 35|    36
      8*n:   8|16|32| 64|   128
     2**n:   2| 4|16|256|65,536
```

Here we can see that the true colors of the log, linear, and
exponential algorithms eventually show.

Notice that for `n=8`, the linear algorithm runs `256/64=4` times as
fast as the exponential solution. For `n=16`, the gap increases to
`65,536/128`, or 512x as fast. Again, because algorithms in each class
grow at different rates, algorithms in a more complex class will take
more-and-more time relative to algorithms in simpler classes.

This is different than `min, two_min` examples: the `two_min`
algorithm will always be twice as slow as `min`, no matter the number
of elements.

## Tractability

```
name        |big-oh      |tractability |example
-----------------------------------------------------
constant    |O(1)        |trivial      |hash maps
logarithmic |O(log(n))   |simple       |binary search
linear      |O(n)        |typical      |linear scans
            |O(n*log(n)) |moderate     |sorting
quadratic   |O(n**2)     |tough        |pairing
exponential |O(2**n)     |intractable  |subsets
factorial   |O(n!)       |intractable  |subsequences
```

**TODO**: add descriptions of these classes.

## Time complexity and algorithm components

We have hit on the crux of the computational complexity. Not only will
an algorithm in a more complex class eventually take more time than an
algorithm from a less complex class, the more complex algorithm will
become slower and slower relative to the less comlex one.

Because complex algorithms become slower and slower relative to less
complex ones, they become the bottleneck when we try to scale an
algorithm which is composed of some simpler and some more complex
components. Let's work through an example.

Suppose I would like to adopt two cats. I would like both cats to be
as compatible as possible, so I decide to exhaustively interview each
cat. I then need to consider each pair of cats, and compare their
surveys to check for compatibility. I pick the pair with the highest
compatibility.

Roughly speaking, there are two phases of the algorithm. The first is
the interview process; I must interview each cat. As the number of
cats under consideration grows, the number of interviews I conduct
also grows. Because of the exhaustiveness of the survey, this may take
a long time. Still, the time complexity of this component is linear in
the number of cats.

The second phase is where I evaluate pairs of cat surveys. There are
`n*(n-1)/2` possible pairings of `n` cats. Each cat (`n` of them) can
be paired with any of the other cats (`n-1` of them). But we have to
avoid double-counting pairs where the order is swapped: `{i1, i2} ==
{i2, i1}`. This gives us the factor of `/2`. The number of potential
pairs is *quadratic* (another complexity class). The number of pairs
to consider grows proportional to the square of the number of
cats.

For small numbers of cats, there are relatively few pairs to consider,
and we end up spending more time interviewing cats than comparing
them.

As the number of cats considered grows, the time spent interviewing
cats grows linearly with the number of cats, while the time spent
comparing cats grows quadratically. As we've said before, the time
spent comparing cats will eventually overtake and then dominate the
time spent interviewing cats. No matter how extensive the
interviewing, for large enough numbers of cats, we'll spend `>99%`
(and for yet larger numbers, `99.9%`, `99.99%`, `99.999%`, ...) of our
time comparing cats.

### Optimization

We can assume that I would like to reduce the time I spend choosing
cats so that I can maximize the time I spend playing with cats. But I
also would like to perform an exhaustive search among a large number
of cats. This means I would like to improve, or *optimize*, my
algorithm so that I can more quickly choose a pair of cats.

Since I know that for large number of cats most of the time will be
spent comparing pairs of cats, it makes sense for me to optimize this
process. If 99% of the time is spent comparing cats, if I can halve
the time I spend comparing cat surveys, I can save `99% * 50% = 49.5%`
of the time I spend in total.

On the other hand, it is profitless to streamline the interview
process if this accounts for `1%` of the total time.

## Scalability

Because computationally complex algorithms require more and more time
to run relative to the size of a problem, they are not particularly
*scalable*.

In general, a scalable problem should have the characteristic that we
can solve twice as big a problem with twice as many resources. If I
run a manufacturing plant, I expect to be able to produce twice as
many widgets with twice as many workers.

On the other hand, if I run a restaurant, I can't expect to produce
twice as good a soup with twice as many cooks. Maybe a second cook
could help advise the first one, but pretty soon the cooks are getting
in each other's way. Soup quality isn't scalable.

In the real world, businesses tend to grow until they hit
bottlenecks. To break past these you need to identify and optimize the
bottleneck.

Computational complexity lets you project forward and identify
components of your algorithms which will eventually become
bottlenecks.

**TODO**: this doesn't really capture the relationship I
want. Computational complexity also describes how much better life
gets as a resource increases. That is missing from here somehow.

## TODO

* worst-case vs avg-case
* computational model; primitive steps
* How is problem size measured
* Memory

## Resources
[Big-O Cheat Sheet][bigo]
[bigo]: http://bigocheatsheet.com/
