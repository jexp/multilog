# usage ruby multilog.rb 'Wed May 04 20:16:02 CEST 2011' `find neo4jlogs -name "messages.log"` | less
# todo show the date just in the leftmost column and remove it from the log output

require 'rubygems'
require 'chronic'

unless ARGV.size > 2
  puts 'Usage  : ruby multilog.rb "date-pattern" logfile1:timeoffset logfile2 logfile3'
  puts 'Example: ruby multilog.rb "Wed May 04 20:16:02 CEST 2011" `find neo4jlogs -name "messages.log"` | less'
  exit 
end

class LogFile
  attr_accessor :name, :file, :offset, :date, :line, :size

  def initialize(name,size)
    @name = name
    @size = size
    @offset = 0
    if name.include?(':')
      (@name, @offset) = name.split(':')
      @offset = @offset.to_i
    end
    @file = File.open(@name)
    @date = 0
  end

  def datestr(line)
    line[0..@size-1]
  end

  def log_date(line)
    return 0 if line.nil?
    result = Chronic.parse(datestr(line)).to_i
    result > 0 ? result + @offset : 0
  end

  def valid_date
    @date > 0
  end
  
  def close
    @file.close
  end

  def eof?
    line.nil?
  end
  
  def read_line
    result = @file.gets
    result.nil? ? nil : result[0..-2].gsub(/\t/,"  ")
  end

  def remove_date(line)
    line[@size..-1]
  end
  
  def advance
    line = read_line
    @date = log_date(line)
    @line = valid_date ? remove_date(line) : line
  end
  
  def time_str
    "%-30s |" % (valid_date ? Time.at(@date).to_s : "")
  end
  
  def line_str
    @line || ""
  end

  def show(do_show, width)
    "%-#{width}s |" % (do_show ? line_str[0..width-1] : "")
  end
  def to_s
    "#{@name} #{date}+#{@offset} : #{@line}"
  end
end


def next_log_entry_from
  @files.min { |file1, file2| file1.date <=> file2.date }
end

def print(current, width)
  output = @files.collect { |file|  file.show(current.date == file.date, width) }
  puts current.time_str + output.join
end


def advance(current)
  curr_date = current.nil? ? 0 : current.date 
  @files.each do |file| 
    file.advance if file.date == curr_date
  end
end

def print_and_advance(current, width)
  print(current,width)
  advance(current)
  current.eof? || current.valid_date
end

COLUMNS = 300

SAMPLE = ARGV.shift

WIDTH = COLUMNS / ARGV.size

@files = ARGV.collect { |name| LogFile.new(name, SAMPLE.size) }

advance(nil)

while @files.any? {|file| !file.eof? }
  current = next_log_entry_from
  {} until print_and_advance(current, WIDTH)
end

@files.each { |file| file.close }



