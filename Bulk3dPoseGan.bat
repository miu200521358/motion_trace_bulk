@echo off
rem --- 
rem ---  OpenPose の jsonデータから 3Dデータに変換(gan)
rem --- 

echo ------------------------------------------
echo 3dpose_gan [%IDX%]
echo ------------------------------------------

rem -- 3dpose_gan ディレクトリに移動
cd /d %~dp0
cd /d %GAN_DIR%

python bin/3dpose_gan_json.py --lift_model train/gen_epoch_500.npz --model2d openpose/pose_iter_440000.caffemodel --proto2d openpose/openpose_pose_coco.prototxt --base-target %OUTPUT_SUB_DIR% --person_idx 1 --verbose %VERBOSE%

cd /d %~dp0

exit /b
