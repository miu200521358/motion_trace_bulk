@echo off
rem --- 
rem ---  映像データから各種トレースデータを揃えてvmdを生成する
rem --- Openpose が取得できている場合(FCRN以降実施)
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


rem -- Openpose 後処理実行
cd /d %~dp0
call BulkOpenposeAfter.bat

echo BULK OUTPUT_JSON_DIR: %OUTPUT_JSON_DIR%

cd /d %~dp0

rem -----------------------------------
rem --- JSON出力ディレクトリ から index別サブディレクトリ生成
FOR %%1 IN (%OUTPUT_JSON_DIR%) DO (
    set OUTPUT_JSON_DIR_PARENT=%%~dp1
    set OUTPUT_JSON_DIR_NAME=%%~n1
)

rem -- 実行日付
set DT=%date%
rem -- 実行時間
set TM=%time%
rem -- 時間の空白を0に置換
set TM2=%TM: =0%
rem -- 実行日時をファイル名用に置換
set DTTM=%dt:~0,4%%dt:~5,2%%dt:~8,2%_%TM2:~0,2%%TM2:~3,2%%TM2:~6,2%

rem -- FCRN-DepthPrediction-vmd実行
call BulkDepth.bat

rem -- キャプチャ人数分ループを回す
for /L %%i in (1,1,%NUMBER_PEOPLE_MAX%) do (
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
echo json: %OUTPUT_JSON_DIR%
echo vmd:  %OUTPUT_SUB_DIR%
echo ------------------------------------------


rem -- カレントディレクトリに戻る
cd /d %~dp0
