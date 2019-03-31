@echo off
rem --- 
rem ---  Estimate postures with Openpose from image data
rem --- 


echo ------------------------------------------
echo Openpose analysis
echo ------------------------------------------

rem ---  Input target video file path
echo Please enter the full path of the file of the video to be analyzed.
echo Please make sure that people are reflected in the first frame. (If it does not show it will fail next time)
echo This setting is available only for half size alphanumeric characters, it is a required item.
set INPUT_VIDEO=
set /P INPUT_VIDEO=** Analysis target video file path:
rem echo INPUT_VIDEO：%INPUT_VIDEO%

IF /I "%INPUT_VIDEO%" EQU "" (
    ECHO Processing is suspended because the analysis target video file path is not set.
    EXIT /B
)

rem ---  Frame to start analysis

echo --------------
echo Please enter the frame number for starting analysis. (0 start)
echo If the human body can not trace accurately, 
echo such as when the logo is displayed at the beginning, you can skip the beginning frame.
echo If nothing is entered and ENTER is pressed, it will be analyzed from 0F.
set FRAME_FIRST=0
set /P FRAME_FIRST="** Analysis start frame number: "

rem ---  Maximum number of people in the image

echo --------------
echo Please enter the maximum number of people shown in the image.
echo If you do not enter anything and press ENTER, it will be analysis for one person.
echo If you specify only one person in the image of which the number of people is the same size, the analysis subject may jump.
set NUMBER_PEOPLE_MAX=1
set /P NUMBER_PEOPLE_MAX="** Maximum number of people shown in the image:"

rem ---  Frame to end analysis

echo --------------
echo Please enter the frame number to end analysis. (0 beginning)
echo When you adjust the reverse or order, 
echo you can finish the process and see the result without outputting to the end.
echo If nothing is input and ENTER is pressed, analysis is performed to the end.
set FRAME_END=-1
set /P FRAME_END="** Analysis end frame number: "

rem ---  反転指定リスト
echo --------------
set REVERSE_SPECIFIC_LIST=
echo Specify the frame number (0 starting) that is inverted by Openpose by mistake, the person INDEX order, and the contents of the inversion.
echo In the order that Openpose recognizes at 0F, INDEX is assigned as 0, 1, ....
echo Format: [{frame number}: Person who wants to specify reverse INDEX, {reverse content}]
echo {reverse content}: R: Whole body inversion, U: Upper body inversion, L: Lower body inversion, N: No inversion
echo 例）[10:1,R]　…　The whole person flips the first person in the 10th frame.
echo Since the contents are output in the above format in message.log when inverted output, please refer to that.
echo As in [10:1,R][30:0,U], multiple items can be specified in parentheses.
set /P REVERSE_SPECIFIC_LIST="** Reverse specification list: "

rem ---  順番指定リスト
echo --------------
set ORDER_SPECIFIC_LIST=
echo In the multi-person trace, please specify the person INDEX order after crossing.
echo In the case of a one-person trace, it is OK to leave it blank.
echo In the order that Openpose recognizes at 0F, INDEX is assigned as 0, 1, ....
echo Format: [{frame number}: index of first estimated person, index of first estimated person, ...]
echo 例）[10:1,0]　…　The order of the 10th frame is rearranged in the order of the first person from the left and the zeroth person.
echo The order in which messages are output in message.log is left in the above format, so please refer to it.
echo As in [10:1,0][30:0,1], multiple items can be specified in parentheses.
echo Also, in output_XXX.avi, colors are assigned to people in the estimated order. The right half of the body is red and the left half is the following color.
echo 0: green, 1: blue, 2: white, 3: yellow, 4: peach, 5: light blue, 6: dark green, 7: dark blue, 8: gray, 9: dark yellow, 10: dark peach, 11: dark light blue
set /P ORDER_SPECIFIC_LIST="** Ordered list: "

rem ---  Presence of detailed log

echo --------------
echo Please output detailed logs or enter yes or no.
echo If nothing is entered and ENTER is pressed, normal logs and various animation GIF are output.
echo For detailed logs, debug logs and debug images for each frame are additionally output. (It will take time for that)
echo If warn is specified, animation GIF is not output. (That is earlier)
set VERBOSE=2
set IS_DEBUG=no
set /P IS_DEBUG="** Detailed log[yes/no/warn]: "

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
echo Analysis result JSON directory：%OUTPUT_JSON_DIR%

rem ------------------------------------------------
rem -- 映像出力ディレクトリ
set OUTPUT_VIDEO_PATH=%INPUT_VIDEO_DIR%%INPUT_VIDEO_FILENAME%_%DTTM%\%INPUT_VIDEO_FILENAME%_openpose.avi
echo Analysis result avi file：%OUTPUT_VIDEO_PATH%

echo --------------
echo Openpose Start analysis.
echo If you want to interrupt the analysis, please press the ESC key.
echo --------------

rem ---  Openposeディレクトリで実行
cd /d %OPENPOSE_DIR%\

rem -- exe実行
%OPENPOSE_BIN_DIR%\OpenPoseDemo.exe --video %INPUT_VIDEO% --model_pose COCO --write_json %OUTPUT_JSON_DIR% --write_video %OUTPUT_VIDEO_PATH% --number_people_max %NUMBER_PEOPLE_MAX% --frame_first %FRAME_FIRST%

echo --------------
echo Done!!
echo Openpose analysis end

cd /d %~dp0

exit /b
