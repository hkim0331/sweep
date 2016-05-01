#!/usr/bin/env ruby
# coding: utf-8
#
# programmed by hkimura, 2016-04-25.
# developed in ~/btsync/utils/sweep.rb
#
# 2016-04-25: IP の各オクテットの桁数が異なる場合、usage()を出して終わる。

def usage
  print <<EOU
usage: $0 range
    range 内に ping に反応するホストがあればその IP を表示する。

example:
$ #{$0} 10.0.34.01-10.0.34.99
    * FIXME: 引数の IP アドレス中、0 をパディングするのを忘れてはいけない。
    * FIXME: 引数中、'-' の両サイドにスペースを入れてはいけない。
    * FIXME: ピリオドで区切られる数字の桁数が一致していないといけない。
EOU
  exit(1)
end

# FIXME: -c と -W をデフォルトありの引数として渡す
def ping?(ip)
  IO.popen("ping -c 3 -W 3 #{ip} 2>/dev/null") do |pipe|
    pipe.readlines.each do |line|
      return true if line =~ /ttl/
    end
  end
  return false
end

def digit_count(ip)
  ip.split(/\./).map{|x| x.length}
end

#
# main
#

if __FILE__ == $0

  # FIXME: もっと柔軟な引数処理
  # --debug オプション
  usage() unless ARGV.count == 1
  usage() if ARGV[0] =~/-h/
  from,to = ARGV[0].split(/-/)
  usage() unless digit_count(from) == digit_count(to)

  threads = []
  ret = Hash.new
  (from..to).each do |ip|
    threads << Thread.new(ip) do |ip|
      ret[ip] = ping?(ip)
    end
  end
  threads.each {|thr| thr.join}

  ret.keys.sort.each do |ip|
    puts ip if ret[ip]
  end
  #system("arp -a | grep -v incomplete")

end
