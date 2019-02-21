# MotionTraceBulk

このプログラムは、MMDモーショントレース自動化処理をまとめて実行するバッチプログラムです。

## 機能概要

以下プログラムを順次実行し、vmd(MMDモーションデータ)ファイルを生成します。

 - [OpenPose](https://github.com/CMU-Perceptual-Computing-Lab/openpose)
 - [miu200521358/FCRN-DepthPrediction-vmd](https://github.com/miu200521358/FCRN-DepthPrediction-vmd)
 - [miu200521358/3d-pose-baseline-vmd](https://github.com/miu200521358/3d-pose-baseline-vmd)
 - [miu200521358/3dpose_gan_vmd](https://github.com/miu200521358/3dpose_gan_vmd)
 - [miu200521358/VMD-3d-pose-baseline-multi](https://github.com/miu200521358/VMD-3d-pose-baseline-multi)


## 準備

1. 下記プログラムがそれぞれ個別に動作することを確認します

     - [OpenPose](https://github.com/CMU-Perceptual-Computing-Lab/openpose)
     - [miu200521358/FCRN-DepthPrediction-vmd](https://github.com/miu200521358/FCRN-DepthPrediction-vmd)
     - [miu200521358/3d-pose-baseline-vmd](https://github.com/miu200521358/3d-pose-baseline-vmd)
     - [miu200521358/3dpose_gan_vmd](https://github.com/miu200521358/3dpose_gan_vmd)
     - [miu200521358/VMD-3d-pose-baseline-multi](https://github.com/miu200521358/VMD-3d-pose-baseline-multi)

 - ※インストール手順等は各プログラムのREADMEおよびQiitaに記載してあります

2. [MotionTraceBulk.bat](MotionTraceBulk.bat) の「各種ソースコードへのディレクトリパス(相対 or 絶対)」を環境に合わせて修正します
    - [MotionTraceBulk_en.bat](MotionTraceBulk_en.bat) is in English. !! The logs remain in Japanese.
    - 同じ階層にすべてのプログラムが配置されているのであれば、修正不要なはずです。

## 実行方法

1. [MotionTraceBulk.bat](MotionTraceBulk.bat) を実行する
1. `解析対象映像ファイルパス` が聞かれるので、動画のファイルフルパスを入力する
1. `映像に映っている最大人数` が聞かれるので、映像から読み取りたい最大人数を1始まりで指定する
    - 未指定の場合、デフォルトで1が設定される(１人分の解析)
1. `解析開始フレームNo` が聞かれるので、解析を開始するフレームNoを0始まりで指定する
    - ロゴ等で冒頭に人物が映っていない場合に、人物が映るようになった最初のフレームNoを指定する事で、先頭フレームをスキップできる
    - 未指定の場合、デフォルトで0が設定される(0フレーム目から解析)
1. `詳細なログを出すか` 聞かれるので、出す場合、`yes` を入力する
    - 未指定 もしくは `no` の場合、通常ログ（各パラメータファイルと3D化アニメーションGIF）
    - `warn` の場合、3D化アニメーションGIFも生成しない（その分早い）
    - `yes`の場合、詳細ログを出力し、ログメッセージの他、デバッグ用画像も出力される（その分遅い）
1. `反転フレームリスト`が聞かれるので、Openposeが裏表を誤認識しているフレーム範囲を指定する。
	- ここで指定されたフレーム範囲内のみ、反転判定を行う。
	- `10,20` のように、カンマで区切って複数フレーム指定可能。
	- `10-15` のように、ハイフンで区切った場合、その範囲内のフレームが指定可能。
	- 詳細は[miu200521358/FCRN-DepthPrediction-vmd](https://github.com/miu200521358/FCRN-DepthPrediction-vmd)参照
1. `順番指定リスト` が聞かれるので、交差後に人物追跡が間違っている場合に、フレームNoと人物インデックスの順番を指定する。
	- 人物インデックスは、0F目の左から0番目、1番目、と数える。
	- `[12:1,0]` と指定された場合、12F目は、画面左から、0F目の1番目、0F目の0番目と並び替える、とする。
	- `[12-15:1,0]` と指定された場合、12～15F目の範囲で、1番目・0番目と並び替える。
	- 詳細は[miu200521358/FCRN-DepthPrediction-vmd](https://github.com/miu200521358/FCRN-DepthPrediction-vmd)参照
1. 処理開始
    - 以下の順番で、各プログラムが順次実行されていく。最初のパラメータ入力以降は終了まで放置可能。
    
    - [OpenPose](https://github.com/CMU-Perceptual-Computing-Lab/openpose)
    - [miu200521358/FCRN-DepthPrediction-vmd](https://github.com/miu200521358/FCRN-DepthPrediction-vmd)
    - [miu200521358/3d-pose-baseline-vmd](https://github.com/miu200521358/3d-pose-baseline-vmd)
    - [miu200521358/3dpose_gan_vmd](https://github.com/miu200521358/3dpose_gan_vmd)
    - [miu200521358/VMD-3d-pose-baseline-multi](https://github.com/miu200521358/VMD-3d-pose-baseline-multi)
     
1. 処理がすべて終了すると、以下に結果が出力される。
    - Openpose の結果
        - `解析対象映像ファイルパス/{解析対象映像ファイル名}_{実行日時}/{解析対象映像ファイル名}_json` ディレクトリ
            - → json形式のkeypointsデータ
        - `解析対象映像ファイルパス/{解析対象映像ファイル名}_{実行日時}/{解析対象映像ファイル名}_openpose.avi`
            - → 元映像にOpenposeの解析結果を上乗せしたaviデータ
    - `解析対象映像ファイルパス/{解析対象映像ファイル名}_{実行日時}/{動画ファイル名}_json_{実行日時}_depth` ディレクトリ
	- `{動画ファイル名}_json_{実行日時}_depth`
    	- FCRN-DepthPrediction-vmdの結果
		    - depth.txt …　各関節位置の深度推定値リスト
		    - message.log …　出力順番等、パラメーター指定情報の出力ログ
		    - movie_depth.gif　…　深度推定の合成アニメーションGIF
		        - 白い点が関節位置として取得したポイントになる
		    - depth/depth_0000000000xx.png … 各フレームの深度推定結果
		    - ※複数人数のトレースを行った場合、全員分の深度情報が出力される
    - `解析対象映像ファイルパス/{解析対象映像ファイル名}_{実行日時}/{動画ファイル名}_json_{実行日時}_index{0F目の左からの順番}` ディレクトリ
    	- FCRN-DepthPrediction-vmdの結果
		    - depth.txt …　該当人物の各関節位置の深度推定値リスト
        - 3d-pose-baseline-vmdの結果
            - pos.txt … 全フレームの関節データ([VMD-3d-pose-baseline-multi](https://github.com/miu200521358/VMD-3d-pose-baseline-multi) に必要) 詳細：[Output](doc/Output.md)
            - smoothed.txt … 全フレームの2D位置データ([VMD-3d-pose-baseline-multi](https://github.com/miu200521358/VMD-3d-pose-baseline-multi) に必要) 詳細：[Output](doc/Output.md)
            - movie_smoothing.gif … フレームごとの姿勢を結合したアニメーションGIF
            - smooth_plot.png … 移動量をなめらかにしたグラフ
            - frame3d/tmp_0000000000xx.png … 各フレームの3D姿勢
            - frame3d/tmp_0000000000xx_xxx.png … 各フレームの角度別3D姿勢(詳細ログyes時のみ)
        - 3dpose_gan_vmdの結果
            - pos_gan.txt … 全フレームの関節データ([VMD-3d-pose-baseline-multi](https://github.com/miu200521358/VMD-3d-pose-baseline-multi) に必要) 詳細：[Output](https://github.com/miu200521358/3d-pose-baseline-vmd/blob/master/doc/Output.md)
            - smoothed_gan.txt … 全フレームの2D位置データ([VMD-3d-pose-baseline-multi](https://github.com/miu200521358/VMD-3d-pose-baseline-multi) に必要) 詳細：[Output](https://github.com/miu200521358/3d-pose-baseline-vmd/blob/master/doc/Output.md)
            - movie_smoothing_gan.gif … フレームごとの姿勢を結合したアニメーションGIF
            - frame3d_gan/gan_0000000000xx.png … 各フレームの3D姿勢
            - frame3d_gan/gan_0000000000xx_xxx.png … 各フレームの角度別3D姿勢(詳細ログyes時のみ)
        - VMD-3d-pose-baseline-multiの結果
            - output_{日付}_{時間}_u{直立フレームIDX}_h{踵位置補正}_xy{センターXY移動倍率}_z{センターZ移動倍率}_s{円滑化度数}_p{移動キー間引き量}_r{回転キー間引き角度}_full/reduce.vmd
                - キーフレームの間引きなしの場合、末尾は「full」。アリの場合、「reduce」。
                - モデルはあにまさ式ミクを基準に、すべてデフォルトパラメーターでモーションデータを生成します
            - upright.txt … 直立フレームのキー情報

## 注意点

- `解析対象映像ファイル名` に12桁の数字列は使わないで下さい。
    - `short02_000000000000_keypoints.json` のように、`{任意ファイル名}_{フレーム番号}_keypoints.json` というファイル名のうち、12桁の数字をフレーム番号として後ほど抽出するため

## ライセンス
GNU GPLv3


### 以下の行為は自由に行って下さい

- モーションの調整・改変
- ニコニコ動画やTwitter等へのモーション使用動画投稿
- モーションの不特定多数への配布
    - **必ず踊り手様や各権利者様に失礼のない形に調整してください**

### 以下の行為は必ず行って下さい。ご協力よろしくお願いいたします。

- クレジットへの記載を、テキストで検索できる形で記載お願いします。

```
ツール名：MMDモーショントレース自動化キット　/　MMD自動トレース　のいずれか
権利者名：miu200521358
```
- ニコニコ動画の場合、コンテンツツリーへ [トレース自動化マイリスト](https://www.nicovideo.jp/mylist/61943776) の最新版動画を登録してください。
    - コンテンツツリーに登録していただける場合、テキストでのクレジット有無は問いません。

- モーションを配布される場合、以下文言を同梱してください。 (記載場所不問)

```
配布のモーションは、「MMDモーショントレース自動化キット」を元に作成したものです。
ご使用される際には原則として、「MMDモーショントレース自動化キット」もしくは略称の「MMD自動トレース」の使用明記と、
ニコニコ動画等、動画サイトへの投稿の場合、コンテンツツリーもしくはリンクを貼って下さい。
　登録先：MMD自動トレースマイリスト(https://www.nicovideo.jp/mylist/61943776) の最新版動画
Twitter等、SNSの場合は文言のみで構いません。
キット作者が今後の改善の参考にさせていただきます。

キット作者連絡先：
　Twitter：https://twitter.com/miu200521358
　メール：garnet200521358@gmail.com

LICENCE

MMDモーショントレース自動化キット
【Openpose】：CMU　…　https://github.com/CMU-Perceptual-Computing-Lab/openpose
【Openpose起動バッチ】：miu200521358　…　https://github.com/miu200521358/openpose-simple
【深度推定】：Iro Laina, miu200521358　…　https://github.com/miu200521358/FCRN-DepthPrediction-vmd
【Openpose→3D変換】：una-dinosauria, ArashHosseini, miu200521358, kenkra　…　https://github.com/miu200521358/3d-pose-baseline-vmd
【Openpose→3D変換その2】：Dwango Media Village, miu200521358：MIT　…　https://github.com/miu200521358/3dpose_gan_vmd
【3D→VMD変換】： errno-mmd, miu200521358, kenkra 　…　https://github.com/miu200521358/VMD-3d-pose-baseline-multi
```

### 以下の行為はご遠慮願います

- 自作発言
- 権利者様のご迷惑になるような行為
- 営利目的の利用
- 他者の誹謗中傷目的の利用（二次元・三次元不問）
- 過度な暴力・猥褻・恋愛・猟奇的・政治的・宗教的表現を含む（R-15相当）作品への利用
- その他、公序良俗に反する作品への利用

## 免責事項

- 自己責任でご利用ください
- ツール使用によって生じたいかなる問題に関して、作者は一切の責任を負いかねます
