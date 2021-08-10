module AcsAsCsv

  def self.included(base)
    # need to use extend for later call in Csv class
    base.extend ClassMethod
  end

  module ClassMethod
    # the above extend keyword make the csv_base here become class method
    def csv_base
      # same use instance method with include
      include InstanceMethod
    end
  end

  module InstanceMethod
    def read
      file = File.new(self.class.to_s.downcase + '.txt')
      @head = file.gets.chomp.split(', ')
      @content = []
      file.each do |l|
        @content << l.chomp.split(', ')
      end
    end

    attr_accessor :head, :content

    def initialize
      read
    end
  end
end

class Csv
  # very flexible
  include AcsAsCsv
  csv_base
end

c = Csv.new
p c.head
p c.content
