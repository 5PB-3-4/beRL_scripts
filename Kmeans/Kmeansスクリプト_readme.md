# クラスタリングスクリプト ver[1.0]

## ▼このスクリプトは何？
K-means法によるクラスタリングにより、オブジェクトの減色やランダム色によるラベリングを行います。

## ▼導入方法
aviutlのscriptフォルダに@berls.anmを、beRLF.dllを入れてください。
また、本スクリプトは、oneTBBのビルドに含まれるtbb12.dllが必要です。
ご自身でビルドされるか、oneTBBのgithubページ(Releasesのwindows用zipの中にあると思います)などからtbb12.dllを取り出し、beRLF.dllと同じフォルダにおいてください。

oneTBBのgithubは[こちら](https://github.com/oneapi-src/oneTBB)

## ▼機能のご紹介
### @K-meansランダム色ラベル
選択したクラスターの数だけラベリングし、各ラベルごとにランダムな色で描画します

### @K-means減色
選択したクラスターの数だけラベリングし、各ラベルごとにラベルの代表色で描画します。

## ▼注意点
スクリプトを読み込むごとにクラスタリングの計算を行います。これにより描画内容が変わることがあります。
描画パターンを保存したい場合は、ゆうきさんの一時保存読込EXTやrikky_bufferスクリプトなどを利用して保存してください。

## ▼バグ
ver1.0 ('23/5/5)

## ▼参照したもの
- http://opencv.jp/cookbook/opencv_img.html#k-means
- http://opencv.jp/opencv2-x-samples/k-means_clustering/

---
## ▼バグ報告等の連絡先はこちら
Twitter : @blue_beRL
