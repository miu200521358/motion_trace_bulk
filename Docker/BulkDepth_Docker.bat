@echo off
rem --- 
rem ---  映像データから深度推定を行う
rem --- 

echo ------------------------------------------
echo FCRN-DepthPrediction-vmd
echo ------------------------------------------

rem ---  python 実行
set FCRN_ARG=--model_path tensorflow/data/NYU_FCRN.ckpt --video_path %C_INPUT_VIDEO% --json_path %C_JSON_DIR% --interval 10 --reverse_frames \"%REVERSE_FRAME_LIST%\" --order_specific \"%ORDER_SPECIFIC_LIST%\" --verbose %VERBOSE% --now %DTTM%
docker container run --rm -v %INPUT_VIDEO_DIR:\=/%:/data -it errnommd/autotracevmd bash -c "cd /FCRN-DepthPrediction-vmd/ && python3 tensorflow/predict_video.py %FCRN_ARG%"

exit /b
