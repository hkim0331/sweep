#!/usr/bin/env ruby
# coding: utf-8
#
# programmed by hkimura, 2016-04-25, 2016-05-01.
# developed in ~/btsync/utils/sweep/

require 'socket'

$debug = !!ENV['DEBUG']

def usage(s)
  puts #{s}
  print <<EOU
usage:
 #{$0} --from from --to to
 #{$0} from - to
 #{$0}

from 〜 to の IP アドレス内に ping に反応するホストがあればその IP を表示する。
引数なしの場合は、自分のサブネットに ping を撒き散らす。
現バージョンでは、サブネットを自分のアドレスが x.y.z.w の時、x.y.z と考える
ピリオドで区切られる数の桁数一致するよう、0 をパディングすること。

example:
 $ #{$0} 10.0.34.01-10.0.34.99
EOU
  exit(1)
end

def get_my_addr()
  Socket.getifaddrs
    .select{|x| x.name=="en0" and x.addr.ipv4?}.first.addr.ip_address
end

# FIXME: ruby has ping function.
# gem install net-ping
# require 'net/ping'

def ping?(ip, count)
  IO.popen("ping -c #{count} #{ip} 2>/dev/null") do |pipe|
    pipe.readlines.each do |line|
      puts line if $debug
      return true if line =~ /ttl/
    end
  end
  return false
end

def digits_count(ip)
  ip.split(/\./).map{|x| x.length}
end

#
# main
#

if __FILE__ == $0

  count = 3
  from = to = nil
  first = true
  while (arg = ARGV.shift)
    case(arg)
    when /\A(-h)|(--help)\Z/
      usage("help")
    when /--debug/
      # --debug は ruby インタプリタへの指示になっているのか？
      $debug = true
    when /--count/
      count = ARGV.shift.to_i
    when /--from/
      from = ARGV.shift
    when /--to/
      to = ARGV.shift
    when /\A([^-]+)-(.+)\Z/
      from, to = $1, $2
    when /\A\d/
      if (first)
        from = arg
      else
        to = arg
      end
    when /\A-\Z/
      first = false
    else
      usage("unknown parameter: #{arg}")
    end
  end

  if (from.nil? and to.nil?)
    mynet = get_my_addr().split(/\./)[0..2].join('.')
    from = "#{mynet}.001"
    to = "#{mynet}.254"
  elsif (from.nil? or to.nil?)
    usage("empty from or to.")
  end
  puts "from: #{from} to: #{to}" if $debug

  usage("need zero padding?") unless digits_count(from) == digits_count(to)

  threads = []
  ret = Hash.new
  (from..to).each do |ip|
    threads << Thread.new(ip) do |addr|
      ret[addr] = ping?(addr, count)
      puts addr if ret[addr]
    end
  end
  threads.each {|thr| thr.join}

  # これだとスイープ終わってからしか表示しない。
  # 上の、ループ中の puts の方が好み。
  # ret.keys.sort.each do |addr|
  #   puts addr if ret[addr]
  # end

  #別サブネットは arp には乗らん。
  #system("arp -a | grep -v incomplete")

end
