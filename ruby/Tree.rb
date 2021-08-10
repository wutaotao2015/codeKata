#!/usr/bin/ruby

class Tree
  attr :node_name,:children

  def initialize(name, children=[])
    @node_name = name
    @children = children
  end

  def visit(&block)
    block.call self
  end

  def visit_all(&block)
    visit &block
    @children.each { |node| node.visit_all &block }
  end
end

my_tree = Tree.new('root', [Tree.new('a'), Tree.new('b')])
my_tree.visit { |node| puts node.node_name }
puts 
my_tree.visit_all { |node| puts node.node_name }
