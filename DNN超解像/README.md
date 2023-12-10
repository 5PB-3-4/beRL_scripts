# 超解像スクリプト ver[1.0]

## ▼このスクリプトは何？
OpenCVで利用できる超解像アルゴリズムを利用して画像を拡大するスクリプトです。

<br>

## ▼導入方法
- aviutlのscriptフォルダに@berls.anmとberls_func.luaを、aviutl.exeのあるフォルダにbeRLF.dllを入れてください。

<br>

## ▼機能のご紹介
- **参照**のところからモデルのパスを指定します。モデルは以下からダウンロードできます。
    - [EDSR](https://github.com/Saafke/EDSR_Tensorflow/tree/master/models)
    - [ESPCN](https://github.com/fannymonori/TF-ESPCN/tree/master/export)
    - [FSRCNN](https://github.com/Saafke/FSRCNN_Tensorflow/tree/master/models)
    - [LAPSRN](https://github.com/fannymonori/TF-LapSRN/tree/master/export)

- **透明反映**を1に設定すると拡大させたい画像の透明度を反映させます。ただし、obj.alphaや画像のトラックバーの値は反映しません。
(いずれ反映させようかなとは思っています)


<br>

## ▼注意点
- **保存したモデルファイルの名前は、githubで公開されている名前から絶対に変更しないでください**
- 拡大倍率はモデルに書かれている`X`以降の数字です。
- 2023年12月現在は、拡大後の画像の幅または高さが**8000**を超えることができないようにしています。この制限を超えたい場合は、`berl_func.lua`の**Wsc**と**Hsc**の値を変更してください
- dllのソースコードはKmeansの`main.cpp`の中にあります

<br>

## ▼バグ
ver1.0 ('23/12/10)

<br>

## ▼参照したもの
- https://qiita.com/gomamitu/items/b4722741f6318d734bce

<br>

---
## ▼バグ報告等の連絡先はこちら
- Twitter : [@blue_beRL](https://twitter.com/blue_beRL)
- misskey : [@blue_beRL](https://misskey.io/@blue_beRL)