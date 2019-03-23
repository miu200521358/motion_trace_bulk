@echo off
rem --- 
rem ---  OpenPose の jsonデータから 3Dデータに変換(gan)
rem --- 

echo ------------------------------------------
echo 3dpose_gan [%IDX%]
echo ------------------------------------------

set B3PG_ARG=--lift_model train/gen_epoch_500.npz --model2d openpose/pose_iter_440000.caffemodel --proto2d openpose/openpose_pose_coco.prototxt --base-target %C_OUTPUT_SUB_DIR% --person_idx 1 --verbose %VERBOSE%
docker container run --rm -v %INPUT_VIDEO_DIR:\=/%:/data -it errnommd/autotracevmd bash -c "cd /3dpose_gan_vmd && python3 bin/3dpose_gan_json.py %B3PG_ARG%"

exit /b
