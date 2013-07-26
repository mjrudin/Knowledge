#### Stoplight
Question: If you were going to program a stoplight, how would you do it? (conceptually)

---

#### AB Test 
Question: Build a small rails app to AB test a simple page & count the click-though statistics of each page. (The page was just a button, either red or green)

---

#### Adding a Feature
Question: They asked me to draw out the structure of the rails app I worked on alone last week, and then they asked me how I would change things if I had to add a certain feature.

---

#### One hundred numbers ranging from 1-99
Question: You have 100 numbers whose range is from 1-99 and there is exactly one repeat.  How do you find the repeat?

Answer:
Take the summation for a series of natural numbers covering 1-99, then sum all the numbers you were given.  The difference is the missing number.  You can solve this in linear time.

---

#### Sudoku
Question: How would you write a program to solve Sudoku?

Answer:
Loop through all the empty cells, and for each cell generate a list of possible values. If a cell has only one possible value, fill it in. Starting from the cells that have the shortest list of possible values, try the value, and recurse to see if the puzzle can be solved.

---

#### 25 Horses 
Question: There are 25 horses.  You can only race 5 at a time.  What's the minimal number of races to determine the first, second and third fastest horses?

Answer: The minimal number of races is seven. You divide them up into five groups of five, and race them.  You've used up five races.  For the sixth race, you race the winners and suppose they are A, B, C, D, E (where alphabetical order corresponds to race position).  Let A2 was the second place from the A group, B2 was the second place from the B group, etc. For the seventh race, you want to race A2, A3, B, B2 and C. 


---

#### Random Sampling from linked list
Question: (Google) Given a singly linked list, write a function that will randomly return an element from this list. Every elem must have an equal probability of being returned. Best sol only runs through list once, and uses constant space.
