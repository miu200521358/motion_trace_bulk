@echo off
rem --- 
rem ---  映像データから深度推定を行う
rem --- 

echo ------------------------------------------
echo mannequinchallenge-vmd
echo ------------------------------------------

rem -- mannequinchallenge-vmd ディレクトリに移動
cd /d %~dp0
cd /d %DEPTH_DIR%

rem ---  python 実行
python predict_video.py --video_path %INPUT_VIDEO% --json_path %OUTPUT_JSON_DIR% --past_depth_path "%PAST_DEPTH_PATH%" --interval 20 --reverse_specific "%REVERSE_SPECIFIC_LIST%" --order_specific "%ORDER_SPECIFIC_LIST%" --avi_output yes --verbose %VERBOSE% --number_people_max %NUMBER_PEOPLE_MAX% --end_frame_no %FRAME_END% --now %DTTM% --input single_view --batchSize 1

cd /d %~dp0

exit /b
