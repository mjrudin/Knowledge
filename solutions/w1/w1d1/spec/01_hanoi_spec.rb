require '01_hanoi'

# Write a [Towers of Hanoi][wiki-hanoi] game.
#
# Keep three arrays, which represents the piles of discs. Pick a
# representation of the discs to store in the arrays; maybe just a
# number representing their size.
#
# In a loop, prompt the user (using [gets](gets)) and ask what pile to
# select a disc from, and where to put it.
#
# After each move, check to see if they have succeeded in moving all the
# discs, to the final pile. If so, they win!
#
# [wiki-hanoi]: http://en.wikipedia.org/wiki/Towers_of_hanoi) game.
# [gets]: http://andreacfm.com/2011/06/11/learning-ruby-gets-and-chomp
describe TowersOfHanoiGame do
  subject(:tower) do
    TowersOfHanoiGame.new
  end

  its(:stacks) { should == [[3, 2, 1], [], []] }

  describe "#move" do
    it "performs a legal move" do
      tower.move(0, 1)
      tower.stacks.should == [[3, 2], [1], []]
    end

    it "refuses a move from an empty stack" do
      expect do
        tower.move(1, 2)
      end.to raise_error("cannot move from empty stack")
    end

    it "refuses a move onto a larger item" do
      tower.move(0, 1)
      expect do
        tower.move(0, 1)
      end.to raise_error("cannot move onto smaller disk")
    end
  end

  describe "#won?" do
    it "doesn't prematurely win" do
      tower.won?.should be_false
    end

    it "wins when all discs moved to another stack" do
      TowersOfHanoiGame.new([[], [], [4, 3, 2, 1]]).won?.should be_true
    end
  end

  describe "#render" do
    it "renders a tall tower" do
      tower.render.should == <<-STR.chomp
1	 	 
2	 	 
3	 	 
STR
    end

    it "renders a short tower" do
      tower = TowersOfHanoiGame.new([[3], [2], [1]])
      tower.render.should == <<-STR.chomp
3	2	1
STR
    end
  end
end
