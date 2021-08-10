class CsvBase
  def self.csv_read
    define_method('read') do
      file = File.new(self.class.to_s.downcase + '.txt')
      @head = file.gets.chomp.split(', ')
      @content = []
      file.each do |l|
        @content << l.chomp.split(', ')
      end
    end

    attr_accessor :head, :content

    define_method('initialize') do
      read
    end
  end
end

class Csv < CsvBase
  csv_read
end

c = Csv.new
p c.head
p c.content
