@echo off
rem --- 
rem ---  映像データから各種トレースデータを揃えてvmdを生成する
rem ---  複数映像対応バージョン
rem --- 
cls

rem -----------------------------------
rem 各種ソースコードへのディレクトリパス(相対 or 絶対)
rem -----------------------------------
rem --- Openpose
set OPENPOSE_DIR=..\openpose-1.4.0-win64-gpu-binaries
rem --- OpenposeDemo.exeのあるディレクトリパス(PortableDemo版: bin, 自前ビルド版: Release)
set OPENPOSE_BIN_DIR=bin
rem --- 3d-pose-baseline-vmd
set BASELINE_DIR=..\3d-pose-baseline-vmd
rem -- 3dpose_gan_vmd
set GAN_DIR=..\3dpose_gan_vmd
rem -- FCRN-DepthPrediction-vmd
set DEPTH_DIR=..\FCRN-DepthPrediction-vmd
rem -- VMD-3d-pose-baseline-multi
set VMD_DIR=..\VMD-3d-pose-baseline-multi

cd /d %~dp0

rem ---  入力対象パラメーターファイルパス
echo Please enter the full path of the parameter setting list file to be analyzed.
echo This setting is available only for half size alphanumeric characters, it is a required item.
set TARGET_LIST=
set /P TARGET_LIST=** Analysis target list file path: 
rem echo INPUT_VIDEO：%INPUT_VIDEO%

IF /I "%TARGET_LIST%" EQU "" (
    ECHO Analysis target list file path is not set, therefore, processing is aborted.
    EXIT /B
)

SETLOCAL enabledelayedexpansion
rem -- ファイル内をループして全件処理する
for /f "tokens=1-8 skip=1" %%m in (%TARGET_LIST%) do (
    echo ------------------------------
    echo Input target video file path: %%m
    echo Frame number to start analysis: %%n
    echo Maximum number of people in the image: %%o
    echo Detailed log[yes/no/warn]: %%p
    echo Analysis end frame number: %%q
    echo Openpose analysis result JSON directory path: %%r
    echo Reverse specification list: %%s
    echo Sequential list: %%t

    
    rem --- パラメーター保持
    set INPUT_VIDEO=%%m
    set FRAME_FIRST=%%n
    set NUMBER_PEOPLE_MAX=%%o
    set VERBOSE=2
    set IS_DEBUG=%%p
    set FRAME_END=%%q
    set OUTPUT_JSON_DIR=%%r
    set REVERSE_SPECIFIC_LIST=%%s
    set ORDER_SPECIFIC_LIST=%%t
    
    IF /I "!IS_DEBUG!" EQU "yes" (
        set VERBOSE=3
    )

    IF /I "!IS_DEBUG!" EQU "warn" (
        set VERBOSE=1
    )

    rem -- 実行日付
    set DT=!date!
    rem -- 実行時間
    set TM=!time!
    rem -- 時間の空白を0に置換
    set TM2=!time: =0!
    rem -- 実行日時をファイル名用に置換
    set DTTM=!DT:~0,4!!DT:~5,2!!DT:~8,2!_!TM2:~0,2!!TM2:~3,2!!TM2:~6,2!
    
    echo now: !DTTM!
    echo verbose: !VERBOSE!

    cd /d %~dp0

    rem -----------------------------------
    rem --- JSON出力ディレクトリ から index別サブディレクトリ生成
    FOR %%i IN (!OUTPUT_JSON_DIR!) DO (
        set OUTPUT_JSON_DIR_PARENT=%%~dpi
        set OUTPUT_JSON_DIR_NAME=%%~ni
    )
    
    rem -- FCRN-DepthPrediction-vmd実行
    call BulkDepth.bat

    rem -- キャプチャ人数分ループを回す
    for /L %%i in (1,1,!NUMBER_PEOPLE_MAX!) do (
        set IDX=%%i
        
        rem -- 3d-pose-baseline実行
        call Bulk3dPoseBaseline.bat
        
        rem -- 3dpose_gan実行
        rem call Bulk3dPoseGan.bat

        rem -- VMD-3d-pose-baseline-multi 実行
        call BulkVmd.bat
    )

    echo ------------------------------------------
    echo トレース結果
    echo json: !OUTPUT_JSON_DIR!
    echo vmd:  !OUTPUT_SUB_DIR!
    echo ------------------------------------------


    rem -- カレントディレクトリに戻る
    cd /d %~dp0

)

ENDLOCAL


rem -- カレントディレクトリに戻る
cd /d %~dp0
