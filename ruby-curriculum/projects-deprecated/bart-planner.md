# Bart Planner

Today we're going to build a trip planner. Some requirements:

* It should ask the user for a start and end address on the terminal
* It should advise whether to take BART, walk or drive.
* It should try to find the cheapest route
    * Time is money, too; say the avg rider's time is worth ~$10/hr
    * Say the cost of driving is $0.20/mi

Make a plan for your project (what APIs would you use, what API methods will
you call, what Ruby methods will you write) before you start. Try to plan how
you can start small (maybe just by looking up BART directions first?), get
that first bit working, and then add more and more functionality.

There are a number of extensions to add. If you finish early, there's a
number of possible extensions you guys might consider:

* Maybe lookup the current gas cost through another API
* Add MUNI lines
* Build a more accurate estimate of driving cost
    * Maybe lookup current gas price?
* Add parking cost
* Add traffic info
