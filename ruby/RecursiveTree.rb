#!/usr/bin/ruby

class Tree
  attr :node_name,:children

  def initialize(hash)
    hash.keys.each do |k|
      @node_name = k
      @children = []
      v = hash.fetch k
      if v.class == Hash
        v.each { |key, value| @children.push(Tree.new({key => value})) }
      end
    end
  end

  def visit(&block)
    block.call self
  end

  def visit_all(&block)
    visit &block
    @children.each { |node| node.visit_all &block }
  end
end

#my_tree = Tree.new('root', [Tree.new('a'), Tree.new('b')])
my_tree = Tree.new({'root' => {
             'a' => {'a1' => {}, 'a2' => {}},
             'b' => {'b1' => {}, 'b2' => {}}
           }})
my_tree.visit { |node| puts node.node_name }
puts 
my_tree.visit_all { |node| puts node.node_name }
