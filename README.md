# sweep

ping に答えるホストを探す。

## USAGE

* sweep [--debug]

    自分のサブネットをスィープ。

    --debug でデバッグ用メッセージを表示。

* sweep --from ip1 --to ip2

    ip1 と ip2 の間をスィープ。

* sweep ip1 - ip2

    sweep --from ip1 --to ip2 に準じる。

## REQUIRE

ruby >= 2.1.0

Socket.getifaddrs が入ったのが 2.1.0 なので。

## FIXME

* FIXME: 引数の IP アドレス中、0 をパディングするのを忘れてはいけない。
* FIXME: 引数中、'-' の両サイドにスペースを入れてはいけない。
* FIXME: ピリオドで区切られる数字の桁数が一致していないといけない。
* sweep した後、arp しよう。その方が確実に見つかるか？
* sweep するのは自分のサブネットではないの？

## FIXED

## author

Hiroshi Kimura <hiroshi.kimura.0331@gmail.com>

---
2016-05-01
