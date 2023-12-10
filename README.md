# Aviutl_script

## ▼導入
- こちらは作成したAviutl用のスクリプトの配布ページです。「code」の方からダウンロードしてください。
- `berls_func.lua`と`beRLF.dll`をaviutl.exeのあるフォルダへ、`@berls.ann`をscriptフォルダ内の子フォルダに入れてください
- 本スクリプトのご利用には以下が必要となります。
    - LuaJIT ライブラリ (lua51.dllをluajitのものに置き換えてください)
    - patch.aul プラグイン
    - Visual C++ 再頒布可能パッケージ【Microsoft Visual C++ 2015-2022 Redistributable(x86)

### テスト環境
- Aviutl 1.10
- exedit 0.92
- patch.aul r43_ss_32
- LuaJIT 2.1.17

<br>

## ▼お知らせ
### 2023/5/6
項目数が増えてきたため、次の新規スクリプト公開時に過去のスクリプトの配布終了します。過去のスクリプトは、anmファイルにつきましては@berls.anm、dllファイルにつきましてはbeRLF.dll、objファイルにつきましては@berls.obj(現在は未公開)へ移転・集約を行います(なるべくそのまま移植します)。これにより、ダウンロードファイル数の削減や機能追加時の点から効率化を行うつもりです。それに伴い、以前に配布しているファイルは、次の新規スクリプト公開時は削除していただきますよう、よろしくお願いいたします。なお新規スクリプト公開は[twitter](https://twitter.com/blue_beRL)や[misskey](https://misskey.io/@blue_beRL)などでお知らせするつもりです。不便をおかけしますが、よろしくお願いいたします。なお、今後の配布はすべて@berls.anm、@berls.obj、beRLF.dllの更新、並びに追加のluaファイルの形といたします。

### 2023/12/11
- 過去のスクリプトを`@berls.anm`と`berls_func.lua`に集約しました。ただし、noiz_glitスクリプトについてはcolor_separate_pixelスクリプトのみの実装です。
- rikky_bufferスクリプトおよびglassスクリプトについては、rikky_moduleの[ライセンスが怪しい](https://scrapbox.io/ePi5131/%E3%82%AF%E3%83%AD%E3%83%BC%E3%82%BA%E3%83%89%E3%82%BD%E3%83%BC%E3%82%B9%E3%83%97%E3%83%AD%E3%82%B0%E3%83%A9%E3%83%A0%E3%81%AE%E3%83%97%E3%83%A9%E3%82%B0%E3%82%A4%E3%83%B3%E3%81%ABGPL%E3%83%97%E3%83%AD%E3%82%B0%E3%83%A9%E3%83%A0%E3%82%92%E4%BD%BF%E7%94%A8%E3%81%97%E3%81%A6%E3%81%97%E3%81%BE%E3%81%A3%E3%81%A6%E3%81%84%E3%82%8B%E3%82%BD%E3%83%95%E3%83%88%E3%82%A6%E3%82%A7%E3%82%A2%E3%81%AB%E5%AF%BE%E3%81%97%E3%81%A6%E3%82%BD%E3%83%BC%E3%82%B9%E3%82%B3%E3%83%BC%E3%83%89%E3%81%AE%E9%96%8B%E7%A4%BA%E8%A6%81%E6%B1%82%E3%81%AF%E3%81%A7%E3%81%8D%E3%82%8B%E3%81%AE%E3%81%8B)ため集約していません。
- 過去のスクリプトはそれぞれのフォルダにスクリプトファイルがあります。
- 集約前には取説ファイルがあったかと思いましたが、それぞれのフォルダの`README.md`ファイルに転記してあります。
- 以前のbeRLF.dllには、利用しているOpenCVのビルドにTBBが依存していましたが、依存しないようにしました。そのため、最新のスクリプトでは`tbb12.dll`は必要ありません。
- 超解像スクリプトの利用にはモデルファイルが必要です。リンクはDNN超解像のフォルダ内のREADME.mdにあります。
- 以前のリポジトリは`old`ブランチに移行しました

<br><br>

---
## ▼バグ報告等の連絡先はこちら
- このリポジトリのissue
- Twitter : [@blue_beRL](https://twitter.com/blue_beRL)
- misskey : [@blue_beRL](https://misskey.io/@blue_beRL)
