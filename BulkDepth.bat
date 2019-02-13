@echo off
rem --- 
rem ---  映像データから深度推定を行う
rem --- 

echo ------------------------------------------
echo FCRN-DepthPrediction-vmd
echo ------------------------------------------

rem -- FCRN-DepthPrediction-vmd ディレクトリに移動
cd /d %~dp0
cd /d %DEPTH_DIR%

rem ---  python 実行
python tensorflow/predict_video.py --model_path tensorflow/data/NYU_FCRN.ckpt --video_path %INPUT_VIDEO% --json_path %OUTPUT_JSON_DIR% --interval 10 --reverse_frames "%REVERSE_FRAME_LIST%" --order_specific "%ORDER_SPECIFIC_LIST%" --verbose %VERBOSE% --now %DTTM%

cd /d %~dp0

exit /b
