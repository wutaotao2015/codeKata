module CsvBase

  def self.included(base)
    base.extend ClassM
  end

  module ClassM
    def read_csv
      include ObjM
    end
  end

  module ObjM
    def read
      file = File.new(self.class.to_s.downcase + '.txt')
      @head = file.gets.chomp.split(', ')
      @content = []
      file.each do |l|
        col_arr = l.chomp.split(', ')
        row = CsvRow.new(Hash.new)
        col_arr.size.times do |i|
          row.hash[@head[i]] = col_arr[i]
        end
        @content << row
      end
    end

    attr_accessor :head, :content
    
    def initialize
      read
    end

    def each(&bl)
      @content.each { |e| bl.call e}
    end
  end
end

class CsvRow
  attr_accessor :hash
  def initialize(hash)
    @hash = hash
  end
  def method_missing name, *args
      @hash.fetch name.to_s
  end
end

class Csv
  include CsvBase
  read_csv
end

c = Csv.new
p c.head
p c.content
puts '----below is each object method----'
c.each { |e| p e}
puts '----using missing method to visit the value of that head---'
c.each { |e| p e.name}
puts
c.each { |e| p e.age}
puts
c.each { |e| p e.salary}
