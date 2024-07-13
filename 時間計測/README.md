# 時間計測スクリプト ver[1.0]

## ▼このスクリプトは何？
スクリプトにより処理時間を計測します。

<br>

## ▼導入方法
aviutlのscriptフォルダに@berlsフォルダを入れてください。

<br>

## ▼機能のご紹介
時間計測にはlua5.1純正、luasocket、windows apiを用いており、計測部分は以下の関数です。
- os.clock
- socket.gettime
- QueryPerformanceCounter

### パラメータ
- mode
    - -1：計測開始
    -  0：途中経過（ラップタイムを取ります）
    -  1：計測終了 
- ffi
    - 0：luajitによるwindows apiを用いない時間計測になります。luasocketを使用できる場合はlua5.1純正、使用できない場合はluasocketを用いて計測します。
- 表示
    - true：経過時間を表示します。

<br>

## ▼注意点
- luasocketを用いたい方はluasocketのビルドが必要になります。ビルドについては[過去のページ](https://github.com/5PB-3-4/note/blob/main/2023-12-06/AviUtl%E3%81%AE%E3%81%9F%E3%82%81%E3%81%AEluaJIT%E4%BD%9C%E6%88%90%2B%CE%B1.md)をご覧ください。
- windows apiを使用するにはluajitが必要になります。

<br>

## ▼バグ
- ver1.0 ('24/7/12)

<br>

## ▼参照したもの
- 抹茶鯖

<br>

---
## ▼バグ報告等の連絡先はこちら
- Twitter : [@blue_beRL](https://twitter.com/blue_beRL)
- misskey : [@blue_beRL](https://misskey.io/@blue_beRL)