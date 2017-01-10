# sweep

ping に答えるホストを探す。

## USAGE

* sweep [-d] [-i en0] [10.0.34.1-10]

    自分のサブネットをスィープ。
    サブネットとは自 IP を x.y.z.w とした時の x.y.z である（手抜き）。

    -d でデバッグ用メッセージを表示。

    -i eth0 でスイープするインタフェースを指定。

* sweep -i eth0 10.0.34.1-10

    インタフェース eth0 で 10.0.34.1 と 10.0.34.10 の間をスィープ。

## REQUIRE

ruby >= 2.1.0

Socket.getifaddrs が入ったのが 2.1.0 なので。

## author

Hiroshi Kimura <hiroshi.kimura.0331@gmail.com>

---
2016-05-01, 2017-01-10
