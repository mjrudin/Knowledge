require 'array'

describe TowersOfHanoi do
  subject(:towers) { TowersOfHanoi.new }

  its(:stacks) { should == [[3, 2, 1], [], []] }
  describe "#render" do
    it "pretty-prints stacks" do
      towers.render.should ==
        "1\t \t \n2\t \t \n3\t \t "
    end

    it "prints shorter stacks" do
      towers = TowersOfHanoi.new([[1], [2], [3]])
      towers.render.should == "1\t2\t3"
    end
  end

  describe "#move" do
    it "allows moving to a blank space" do
      towers.move(0, 1)
      towers.stacks.should == [[3, 2], [1], []]
    end

    it "allows moving onto a larger disk" do
      towers = TowersOfHanoi.new([[1], [2], []])
      towers.move(0, 1)
      towers.stacks.should == [[], [2, 1], []]
    end

    it "does not allow moving from an empty stack" do
      expect do
        towers.move(1, 2)
      end.to raise_error("cannot move from empty stack")
    end

    it "does not allow moving onto a smaller disk" do
      towers = TowersOfHanoi.new([[1], [2], []])
      expect do
        towers.move(1, 0)
      end.to raise_error("cannot move onto smaller disk")
    end
  end

  describe "#won?" do
    it { should_not be_won }

    it "is won when all disks are moved" do
      towers = TowersOfHanoi.new([[], [], [3, 2, 1]])
      towers.should be_won
    end
  end
end
