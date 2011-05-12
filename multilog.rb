# usage ruby multilog.rb 'Wed May 04 20:16:02 CEST 2011' `find neo4jlogs -name "messages.log"` | less
# todo show the date just in the leftmost column and remove it from the log output

require 'rubygems'
require 'chronic'

unless ARGV.size > 2
  puts 'Usage  : ruby multilog.rb "date-pattern" logfile1 logfile2 logfile3'
  puts 'Example: ruby multilog.rb "Wed May 04 20:16:02 CEST 2011" `find neo4jlogs -name "messages.log"` | less'
  exit 
end

@COLUMNS = 100

@SAMPLE = ARGV.shift

@names = ARGV
@count = @names.size
@WIDTH = @COLUMNS / @count


def datestr(index)
  @lines[index][0..@SAMPLE.size-1]
end

def log_date(index)
  Chronic.parse(datestr(index)).to_i
end

def valid_date(index)
  @dates[index] > 0
end

def next_output
  @min_date = Time.now.to_i
  0.upto(@count-1).each do |i| 
    index = (i+@file) % @count
    date = @dates[index]
    if date < @min_date
      @min_date = date
      @file = index
    end
  end
end

def print
  curr_date = @dates[@file]
  output = 0.upto(@count-1).collect { |i| @dates[i] == curr_date ? @lines[i]||"" : "" }.collect { |s| "%-#{@WIDTH}s |" % s[0..@WIDTH-1] }
  time = "%-30s |" % (curr_date > 0 ? Time.at(curr_date).to_s : "")
  puts  time + output.join
end

def read_line(file)
  file.gets[0..-2].gsub(/\t/,"  ")
end

def advance
  curr_date = @dates[@file]
  0.upto(@count-1).each do |i| 
    if @dates[i] == curr_date
      @lines[i] = read_line(@files[i])
      @dates[i] =log_date(i)
      @lines[i] = @lines[i][@SAMPLE.size..-1] if @dates[i]>0
    end
  end
end

def print_and_advance
  print
  advance
  @lines[@file].nil? || valid_date(@file)
end

@files = @names.collect { |name| File.open(name) }
@lines = @names.collect { "" }
@dates = @names.collect { 0 }
@min_date = Time.now.to_i
@file = 0

advance

while true
  next_output
  {} until print_and_advance
end
@files.each { |file| file.close }



