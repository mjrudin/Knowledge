require 'rspec'
require 'tree_node.rb'

describe BinaryTreeNode do
  subject(:tree_node) { BinaryTreeNode.new }

  its(:parent) { should == nil }
  its(:left_child) { should be_nil }
  its(:right_child) { should be_nil }
  its(:value) { should be_nil }

  it "sets value" do
    value = double("value")
    tree_node.value = value
    tree_node.value.should == value
  end

  context "with child" do
    let(:child) do
      BinaryTreeNode.new("child_value")
    end

    before { tree_node.left_child = child }

    describe "#left_child=" do
      it "sets child" do
        tree_node.left_child.should == child
      end

      it "sets new child's parent" do
        child.parent.should == tree_node
      end

      it "resets old child's parent" do
        old_child = child
        new_child = BinaryTreeNode.new("new_child_value")

        tree_node.left_child = new_child
        old_child.parent.should be_nil
      end
    end
  end

  context "with larger tree" do
    let(:tree_node) do
      #       1
      #   2       5
      # 3   4
      tree_node = BinaryTreeNode.new(1)
      tree_node.left_child = BinaryTreeNode.new(2)
      tree_node.left_child.left_child = BinaryTreeNode.new(3)
      tree_node.left_child.right_child = BinaryTreeNode.new(4)
      tree_node.right_child = BinaryTreeNode.new(5)

      tree_node
    end

    %w( dfs bfs ).each do |method|
      describe "##{method}" do
        it "finds target in tree" do
          tree_node.send(method, 5).should == tree_node.right_child
        end

        it "finds target deeper in tree" do
          tree_node.send(method, 4).should ==
            tree_node.left_child.right_child
        end

        it "returns nil if target not in tree" do
          tree_node.send(method, 6).should be_nil
        end
      end
    end

    describe "#dfs" do
      it "visits nodes in right order" do
        [tree_node,
          tree_node.left_child,
          tree_node.left_child.left_child,
          tree_node.left_child.right_child].each do |node|
          node.should_receive(:value).ordered
        end

        tree_node.dfs(5)
      end
    end

    describe "#bfs" do
      it "visits nodes in right order" do
        [tree_node,
          tree_node.left_child,
          tree_node.right_child,
          tree_node.left_child.left_child].each do |node|
          node.should_receive(:value).ordered
        end

        tree_node.bfs(5)
      end
    end
  end
end
