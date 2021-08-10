class CsvBase

  def read
    file = File.open(self.class.to_s.downcase + '.txt')
    @head = file.gets.chomp.split(', ')
    @content = []
    file.each do |l|
      @content << l.chomp.split(', ')
    end
  end

  def initialize
    read
  end

  attr_accessor :head, :content
end

class Csv < CsvBase
end

c = Csv.new
p c.head
p c.content
