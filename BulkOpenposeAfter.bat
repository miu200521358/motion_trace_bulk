@echo off
rem --- 
rem ---  映像データからOpenposeで姿勢推定する
rem --- 


echo ------------------------------------------
echo Openpose 解析
echo ------------------------------------------

rem ---  入力対象映像ファイルパス
echo 解析対象となる映像のファイルのフルパスを入力して下さい。
echo 1フレーム目に必ず人物が映っている事を確認してください。（映ってないと次でコケます）
echo この設定は半角英数字のみ設定可能で、必須項目です。
set INPUT_VIDEO=
set /P INPUT_VIDEO=■解析対象映像ファイルパス: 
rem echo INPUT_VIDEO：%INPUT_VIDEO%

IF /I "%INPUT_VIDEO%" EQU "" (
    ECHO 解析対象映像ファイルパスが設定されていないため、処理を中断します。
    EXIT /B
)

rem ---  映像に映っている最大人数

echo --------------
echo 映像に映っている最大人数を入力して下さい。
echo 何も入力せず、ENTERを押下した場合、1人分の解析になります。
echo 複数人数が同程度の大きさで映っている映像で1人だけ指定した場合、解析対象が飛ぶ場合があります。
set NUMBER_PEOPLE_MAX=1
set /P NUMBER_PEOPLE_MAX="映像に映っている最大人数: "

rem ---  解析結果JSONディレクトリパス
echo --------------
echo Openposeの解析結果のJSONディレクトリのフルパスを入力して下さい。({動画名}_json)
echo この設定は半角英数字のみ設定可能で、必須項目です。
set OUTPUT_JSON_DIR=
set /P OUTPUT_JSON_DIR=■解析結果JSONディレクトリパス: 
rem echo OUTPUT_JSON_DIR：%OUTPUT_JSON_DIR%

IF /I "%OUTPUT_JSON_DIR%" EQU "" (
    ECHO 解析結果JSONディレクトリパスが設定されていないため、処理を中断します。
    EXIT /B
)

rem ---  反転フレームリスト
echo --------------
set REVERSE_FRAME_LIST=
echo Openposeが誤認識して反転しているフレーム番号(0始まり)を指定してください。
echo ここで指定された番号のフレームに対して、反転判定を行い、反転認定された場合、関節位置が反転されます。
echo カンマで複数件指定可能です。また、ハイフンで範囲が指定可能です。
echo 例）4,10-12　…　4,10,11,12 が反転判定対象フレームとなります。
set /P REVERSE_FRAME_LIST="■反転フレームリスト: "

rem ---  順番指定リスト
echo --------------
set ORDER_SPECIFIC_LIST=
echo 複数人数トレースで、交差後の人物INDEX順番を指定してください。
echo 0F目の立ち位置左から順番に0番目、1番目、と数えます。
echo フォーマット：［＜フレーム番号＞:左から0番目にいる人物のインデックス,左から1番目…］
echo 例）[10:1,0]　…　10F目は、左から1番目の人物、0番目の人物の順番に並べ替えます。
echo [10:1,0][30:0,1]のように、カッコ単位で複数件指定可能です。
set /P ORDER_SPECIFIC_LIST="■順番指定リスト: "

rem ---  詳細ログ有無

echo --------------
echo 詳細なログを出すか、yes か no を入力して下さい。
echo 何も入力せず、ENTERを押下した場合、通常ログと各種アニメーションGIFを出力します。
echo 詳細ログの場合、各フレームごとのデバッグ画像も追加出力されます。（その分時間がかかります）
echo warn と指定すると、アニメーションGIFも出力しません。（その分早いです）
set VERBOSE=2
set IS_DEBUG=no
set /P IS_DEBUG="詳細ログ[yes/no/warn]: "

IF /I "%IS_DEBUG%" EQU "yes" (
    set VERBOSE=3
)

IF /I "%IS_DEBUG%" EQU "warn" (
    set VERBOSE=1
)

rem --echo NUMBER_PEOPLE_MAX: %NUMBER_PEOPLE_MAX%

rem -----------------------------------

rem -- 実行日付
set DT=%date%
rem -- 実行時間
set TM=%time%
rem -- 時間の空白を0に置換
set TM2=%TM: =0%
rem -- 実行日時をファイル名用に置換
set DTTM=%dt:~0,4%%dt:~5,2%%dt:~8,2%_%TM2:~0,2%%TM2:~3,2%%TM2:~6,2%

echo --------------

exit /b
