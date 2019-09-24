class Minimax

  def self.best_move(tree)
    return nil if tree.empty?
    result = tree[0]

    tree.each do |node|
      node[:score] += score_of(node[:children])
      result = node if node[:score] > result[:score]
    end
    result[:position]
  end

  private

  def self.score_of(children, maximising = false)
    return 0 if children.empty?

    child_score = children.map do |child|
      score_of(child[:children], !maximising)
    end.sum

    child_score - 1 + min_or_max(children, maximising)
  end

  def self.min_or_max(children, maximising)
    if maximising
      children.max_by { |c| c[:score] }[:score]
    else
      children.min_by { |c| c[:score] }[:score]
    end
  end


end

describe Minimax do

  it "returns nil when there are no available positions" do
    expect(Minimax.best_move([])).to eq(nil)
  end

  it "returns the only possible move (example 1)" do
    tree = [{position: 1, children: [], score: 0}]
    expect(Minimax.best_move(tree)).to eq(1)
  end

  it "returns the only possible move (example 2)" do
    tree = [{position: 2, children: [], score: 0}]
    expect(Minimax.best_move(tree)).to eq(2)
  end

  it "returns position with highest score" do
    tree = [{position: 2, children: [], score: 0},
            {position: 3, children: [], score: 10}]
    expect(Minimax.best_move(tree)).to eq(3)
  end

  it "returns position with highest score with different position" do
    tree = [{position: 2, children: [], score: 0},
            {position: 4, children: [], score: 10}]
    expect(Minimax.best_move(tree)).to eq(4)
  end

  it "returns position with highest score (example 2)" do
    tree = [{position: 2, children: [], score: 10},
            {position: 3, children: [], score: 0}]
    expect(Minimax.best_move(tree)).to eq(2)
  end

  it "returns position with highest score (example 3)" do
    tree = [{position: 2, children: [], score: -10},
            {position: 3, children: [], score: 10},
            {position: 4, children: [], score: 0}]
    expect(Minimax.best_move(tree)).to eq(3)
  end

  it "returns position with highest score out of 4" do
    tree = [{position: 2, children: [], score: -10},
            {position: 3, children: [], score: 0},
            {position: 4, children: [], score: 10},
            {position: 5, children: [], score: 0}]
    expect(Minimax.best_move(tree)).to eq(4)
  end

  it "returns best position with child example 1" do
    tree = [{position: 2, children: [], score: 0},
            {position: 3, children:
                [{position: 2, children: [], score: 10}], score: 0}]
    expect(Minimax.best_move(tree)).to eq(3)
  end

  it "returns best position with child example 2" do
    tree = [{position: 2, children: [{position: 3, children: [], score: -10}], score: 0},
            {position: 3, children: [], score: 0}]
    expect(Minimax.best_move(tree)).to eq(3)
  end

  it "returns best position with child example 3" do
    tree = [{position: 2, children: [{position: 3, children: [], score: 0}], score: 0},
            {position: 3, children: [{position: 2, children: [], score: -10}], score: 0}]
    expect(Minimax.best_move(tree)).to eq(2)
  end

  it "returns best position with child example 4" do
    tree = [{position: 2, children: [{position: 3, children: [], score: 0}], score: 0},
            {position: 3, children: [{position: 2, children: [], score: 10}], score: 0},
            {position: 4, children: [{position: 5, children: [], score: -10}], score: 0}]
    expect(Minimax.best_move(tree)).to eq(3)
  end

  it "returns best position with multiple children example 1" do
    tree = [{position: 3, children: [{position: 2, children: [], score: 0}], score: 0},
            {position: 2, children: [{position: 3, children: [], score: 0},
                                     {position: 4, children: [], score: -10}], score: 0}]
    expect(Minimax.best_move(tree)).to eq(3)
  end

  it "returns best position with multiple children example 2" do
    tree = [{position: 2, children: [{position: 3, children: [], score: 0},
                                     {position: 1, children: [], score: -10},
                                     {position: 4, children: [], score: 0}], score: 0},
            {position: 3, children: [{position: 2, children: [], score: 0}], score: 0}]
    expect(Minimax.best_move(tree)).to eq(3)
  end

  it "returns best position with multiple children example 1" do
    tree = [{position: 3, children: [{position: 2, children: [], score: 0}], score: 0},
            {position: 2, children: [{position: 3, children: [], score: 0},
                                     {position: 4, children: [], score: 10}], score: 0}]
    expect(Minimax.best_move(tree)).to eq(3)
  end

  it "returns best position based on depth (example 1)" do
    tree = [{position: 2, children: [{position: 3, children: [], score: 0}], score: 0},
            {position: 3, children: [], score: 0}]
    expect(Minimax.best_move(tree)).to eq(3)
  end

  it "returns best position based on depth (example 1)" do
    tree = [{position: 2, children: [{position: 3, children: [], score: 10}], score: 0},
            {position: 3, children: [{position: 4, children: [], score: 0}], score: 0}]
    expect(Minimax.best_move(tree)).to eq(2)
  end

  it "returns best position with depth of 2" do
    tree = [{position: 2, children: [{position: 3, children: [{position: 4, children: [], score: 10}], score: 0}], score: 0},
            {position: 3, children: [], score: 0}]
    expect(Minimax.best_move(tree)).to eq(2)
  end

  it "returns best position with depth of 2" do
    tree = [{position: 2, children: [{position: 3, children: [], score: 0}, {position: 5, children: [{position: 9, children: [], score: 10}], score: 0}], score: 0},
            {position: 3, children: [], score: 0}]
    expect(Minimax.best_move(tree)).to eq(2)
  end

  it "returns best position with depth of 2" do
    tree = [{position: 2, children: [{position: 3, children: [], score: 0},
                                     {position: 5, children: [{position: 9, children: [], score: 10},
                                                              {position: 8, children: [], score: 0}], score: 0}], score: 0},
            {position: 3, children: [], score: 0}]
    expect(Minimax.best_move(tree)).to eq(2)
  end

  it "returns best position with depth of 2" do
    tree = [{position: 2, children: [{position: 3, children: [], score: -10},
                                     {position: 5, children: [{position: 9, children: [], score: 10},
                                                              {position: 8, children: [], score: 0}], score: 0}], score: 0},
            {position: 3, children: [], score: 0}]
    expect(Minimax.best_move(tree)).to eq(3)
  end




end