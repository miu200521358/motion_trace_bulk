@echo off
rem --- 
rem ---  映像データから深度推定を行う
rem --- 

echo ------------------------------------------
echo FCRN-DepthPrediction-vmd [%IDX%]
echo ------------------------------------------

rem -- 3dpose_gan ディレクトリに移動
cd /d %~dp0
cd /d %DEPTH_DIR%

rem ---  python 実行
python tensorflow/predict_video.py --model_path tensorflow/data/NYU_FCRN.ckpt --video_path %INPUT_VIDEO% --baseline_path %OUTPUT_SUB_DIR% --interval 10 --verbose %VERBOSE%

cd /d %~dp0

exit /b
