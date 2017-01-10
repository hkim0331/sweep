#!/usr/bin/env ruby
# coding: utf-8
#
# programmed by hkimura, 2016-04-25, 2016-05-01.
# developed in ~/btsync/utils/sweep/

require 'socket'

def usage(s)
  print <<EOU
#{s}
usage:
 #{$0} [-i eth0] [a.b.c.d-e]

a.b.c.d ... a.b.c.e の IP アドレスに ping を打つ。
反応するホストがあればその IP を表示する。

引数なしの場合は、自分のサブネットに ping を撒き散らす。

example:
 $ #{$0} 10.0.34.1-99
EOU
  exit(1)
end

# FIXME: en0 以外のインタフェースだとどうする？
def get_my_addr(intf)
  Socket.getifaddrs
    .select{|x| x.name==intf and x.addr.ipv4?}.first.addr.ip_address
end

# FIXME: ruby has ping function.
# gem install net-ping
# require 'net/ping'

def ping?(ip, count, timeout)
  IO.popen("ping -c #{count} -t #{timeout} #{ip} 2>/dev/null") do |pipe|
    pipe.readlines.each do |line|
      puts line if $debug
      return true if line =~ /ttl/
    end
  end
  return false
end

#
# main
#

if __FILE__ == $0

  $debug = false
  intf = "eth0"
  count = 3
  timeout = 1
  mynet = nil
  from = nil
  to = nil
  while (arg = ARGV.shift)
    case arg
    when /\A-d/
      $debug = true
    when /\A-i/
      intf = ARGV.shift
    when /\A-/
      usage("unknown arguments: #{arg}")
    when /\A(\d+\.\d+.\d+)\.(\d+)-(\d+)\Z/
      mynet = $1
      from = $2.to_i
      to = $3.to_i
    else
      usage("illegal format: #{arg}")
    end
  end

  if mynet.nil?
    mynet = get_my_addr(intf).split(/\./)[0..2].join('.')
    from = '1'
    to='254'
  end
  puts "mynet:#{mynet}, from:#{from}, to:#{to}" if $debug

  threads = []
  (from..to).each do |ip|
    threads << Thread.new("#{mynet}.#{ip}") do |addr|
      puts addr if ping?(addr, count, timeout)
    end
  end
  threads.each {|thr| thr.join}

end
