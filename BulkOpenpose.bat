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
