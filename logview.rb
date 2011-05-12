require 'rubygems'
require 'chronic'

p ENV['COLUMNS']
@COLUMNS = 300

@SAMPLE = ARGV.shift

puts "sample #{@SAMPLE}"

@names = ARGV
@count = @names.size
@WIDTH = @COLUMNS / @count

@files = @names.collect { |name| File.open(name) }
@lines = @files.collect { |file| file.gets }
@dates = @names.collect { 0 }
@min_date = Time.now.to_i
@file = 0

def datestr(index)
  @lines[index][0..@SAMPLE.size-1]
end

def log_date(index)
  Chronic.parse(datestr(index)).to_i
end

def valid_date(index)
  log_date(index) > 0
end

def next_output
  @min_date = Time.now.to_i
  0.upto(@count-1).each do |i| 
    index = (i+@file) % @count
    date = log_date(index)
    if date < @min_date
      @min_date = date
      @file = index
    end
  end
end

def print
  curr_date = log_date(@file)
  puts 0.upto(@count-1).collect { |i| "%-#{@WIDTH}s |" % (@file==i || log_date(i) == curr_date ? @lines[i] : "")[0..@WIDTH-1] }.join
end

def advance
  curr_date = log_date(@file)
  0.upto(@count-1).each { |i| @lines[i] = @files[i].gets[0..-2].gsub(/\t/,"  ")  if @file==i || log_date(i) == curr_date }
end

def print_and_advance
  print
  advance
  @lines[@file].nil? || valid_date(@file)
end

while true
  next_output
  {} until print_and_advance
end
@files.each { |file| file.close }



