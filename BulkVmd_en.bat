@echo off
rem --- 
rem ---  3D の 関節データから vmdデータに変換
rem --- 

echo ------------------------------------------
echo VMD-3d-pose-baseline-multi [%IDX%]
echo ------------------------------------------

rem -- VMD-3d-pose-baseline-multi ディレクトリに移動
cd /d %~dp0
cd /d %VMD_DIR%

rem ---  python 実行
python main.py -v %VERBOSE% -t "%OUTPUT_SUB_DIR%" -b "born\animasa_miku_born.csv" -c 30 -z 50 -s 2 -p 0.5 -r 5 -k 1 -e 0

cd /d %~dp0

exit /b
