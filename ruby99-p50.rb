
################################################################################
# P50 (***) Huffman code.
# Based on http://en.wikipedia.org/wiki/Huffman_code
class HuffmanNode
  include Comparable # sort by weight

  attr_reader :symbol, :weight, :left, :right

  # Construct a new leaf node
  def self.leaf(symbol, weight)
    self.new(symbol, weight, nil, nil)
  end

  # Construct a new internal node
  def self.internal(left, right)
    self.new(nil, left.weight + right.weight, left, right)
  end

  def initialize(symbol, weight, left, right)
    @symbol = symbol
    @weight = weight
    @left = left
    @right = right
  end

  # Is this a leaf node?
  def leaf?() !symbol.nil? end
  
  # Return list of [code,symbol] pairs using this node as root
  def codes(prefix='')
    if leaf?
      [[symbol, prefix]]
    else
      left.codes(prefix + '0') + right.codes(prefix + '1')
    end
  end

  # Compare by weight
  def <=>(other) weight <=> other.weight end
end

def huffman(input)
  # Construct initial list of nodes and sort
  nodes = input.map { |i| HuffmanNode.leaf(*i) }
  # TODO: Use a real heap for priority queue
  queue = nodes.dup.sort

  while queue.length > 1
    # merge into internal node and queue it
    internal = HuffmanNode.internal(queue.shift, queue.shift)
    queue.push(internal).sort! # re-sort
  end

  # generate symbol/code pairs from remaining root node
  queue.shift.codes.sort
end

input = [['a',45],['b',13],['c',12],['d',16],['e',9],['f',5]]
raise "P49 fail" unless huffman(input) ==
  [['a','0'],['b','101'],['c','100'],['d','111'],['e','1101'],['f','1100']]
