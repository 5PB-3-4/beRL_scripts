# フレーム補間用設定stg ver[1.0]

## ▼これは何？
ffmpegoutプラグインを使ってフレーム補間を行います

<br>

## ▼導入方法
pluginsフォルダ内にある**ffmpegOut_stg**フォルダ内やその子フォルダ内に`X264_frame_hokan.stg`を入れてください

<br>

## ▼機能のご紹介
中のコマンドにはこう書かれています。
```
-vf minterpolate=fps=60:mi_mode=mci:mc_mode=obmc:me_mode=bilat:me=epzs:mb_size=16:search_param=32:vsbmc=0:scd=fdiff:scd_threshold=5
-c:v libx264 -b:v 2500k -crf 22
```
この内、`fps=60`の数字を変更することで指定したfpsに出力することができます。ただし、数字は0より大きい整数である必要があります。

<br>

## ▼注意点
- ffmpegによってはフレーム補間ができない場合があります。
- フレーム補間により、映像が薄れる場合があります。

<br>

## ▼バグ
- ver1.0 ('23/12/11)

<br>

## ▼参照したもの
- https://nico-lab.net/minterpolate_with_ffmpeg/

<br>

---
## ▼バグ報告等の連絡先はこちら
- Twitter : [@blue_beRL](https://twitter.com/blue_beRL)
- misskey : [@blue_beRL](https://misskey.io/@blue_beRL)