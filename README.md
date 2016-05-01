# sweep

ping に答えるホストを探す。

## USAGE

* sweep [--help] [--version] [--debug]

    自分のサブネットをスィープ。
    サブネットとは自 IP を x.y.z.w とした時の x.y.z である（手抜き）。

    --help でヘルプメッセージを表示。

    --version でバージョン番号を表示。

    --debug でデバッグ用メッセージを表示。

* sweep --from ip1 --to ip2

    ip1 と ip2 の間をスィープ。
    IP アドレスの各オクテットは桁数が一致していないといけない。

* sweep ip1 - ip2

    sweep --from ip1 --to ip2 に準じる。

## REQUIRE

ruby >= 2.1.0

Socket.getifaddrs が入ったのが 2.1.0 なので。

## FIXME

## author

Hiroshi Kimura <hiroshi.kimura.0331@gmail.com>

---
2016-05-01
