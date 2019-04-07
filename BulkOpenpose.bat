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

rem ---  解析を開始するフレーム

echo --------------
echo 解析を開始するフレームNoを入力して下さい。(0始まり)
echo 最初にロゴが表示されている等、人体が正確にトレースできない場合に、
echo 冒頭のフレームをスキップできます。
echo 何も入力せず、ENTERを押下した場合、0F目からの解析になります。
set FRAME_FIRST=0
set /P FRAME_FIRST="解析開始フレームNo: "

rem ---  映像に映っている最大人数

echo --------------
echo 映像に映っている最大人数を入力して下さい。
echo 何も入力せず、ENTERを押下した場合、1人分の解析になります。
echo 複数人数が同程度の大きさで映っている映像で1人だけ指定した場合、解析対象が飛ぶ場合があります。
set NUMBER_PEOPLE_MAX=1
set /P NUMBER_PEOPLE_MAX="映像に映っている最大人数: "

rem ---  解析を終了するフレーム

echo --------------
echo 解析を終了するフレームNoを入力して下さい。(0始まり)
echo 反転や順番を調整する際に、最後まで出力せずとも処理を終了して結果を見ることができます。
echo 何も入力せず、ENTERを押下した場合、最後まで解析します。
set FRAME_END=-1
set /P FRAME_END="■解析終了フレームNo: "

rem ---  反転指定リスト
echo --------------
set REVERSE_SPECIFIC_LIST=
echo Openposeが誤認識して反転しているフレーム番号(0始まり)、人物INDEX順番、反転の内容を指定してください。
echo Openposeが0F目で認識した順番に0, 1, とINDEXが割り当てられます。
echo フォーマット：［＜フレーム番号＞:反転を指定したい人物INDEX,＜反転内容＞］
echo ＜反転内容＞: R: 全身反転, U: 上半身反転, L: 下半身反転, N: 反転なし
echo 例）[10:1,R]　…　10F目の1番目の人物を全身反転します。
echo message.logに上記フォーマットで、反転出力した場合にその内容を出力しているので、それを参考にしてください。
echo [10:1,R][30:0,U]のように、カッコ単位で複数件指定可能です。
set /P REVERSE_SPECIFIC_LIST="■反転指定リスト: "

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
rem --- 入力映像パス
FOR %%1 IN (%INPUT_VIDEO%) DO (
    rem -- 入力映像パスの親ディレクトリと、ファイル名+_jsonでパス生成
    set INPUT_VIDEO_DIR=%%~dp1
    set INPUT_VIDEO_FILENAME=%%~n1
)

rem -- 実行日付
set DT=%date%
rem -- 実行時間
set TM=%time%
rem -- 時間の空白を0に置換
set TM2=%TM: =0%
rem -- 実行日時をファイル名用に置換
set DTTM=%dt:~0,4%%dt:~5,2%%dt:~8,2%_%TM2:~0,2%%TM2:~3,2%%TM2:~6,2%

echo --------------

rem ------------------------------------------------
rem -- JSON出力ディレクトリ
set OUTPUT_JSON_DIR=%INPUT_VIDEO_DIR%%INPUT_VIDEO_FILENAME%_%DTTM%\%INPUT_VIDEO_FILENAME%_json
rem echo %OUTPUT_JSON_DIR%

rem -- JSON出力ディレクトリ生成
mkdir %OUTPUT_JSON_DIR%
echo 解析結果JSONディレクトリ：%OUTPUT_JSON_DIR%

rem ------------------------------------------------
rem -- 映像出力ディレクトリ
set OUTPUT_VIDEO_PATH=%INPUT_VIDEO_DIR%%INPUT_VIDEO_FILENAME%_%DTTM%\%INPUT_VIDEO_FILENAME%_openpose.avi
echo 解析結果aviファイル：%OUTPUT_VIDEO_PATH%

echo --------------
echo Openpose解析を開始します。
echo 解析を中断したい場合、ESCキーを押下して下さい。
echo --------------

rem ---  Openposeディレクトリで実行
cd /d %OPENPOSE_DIR%\

rem -- exe実行
%OPENPOSE_BIN_DIR%\OpenPoseDemo.exe --video %INPUT_VIDEO% --model_pose COCO --write_json %OUTPUT_JSON_DIR% --write_video %OUTPUT_VIDEO_PATH% --number_people_max %NUMBER_PEOPLE_MAX% --frame_first %FRAME_FIRST%

echo --------------
echo Done!!
echo Openpose解析終了

cd /d %~dp0

exit /b
