# --- 
# ---  映像データから各種トレースデータを揃えてvmdを生成する
# --- 

# -----------------------------------
# 各種ソースコードへのディレクトリパス(相対 or 絶対)
# -----------------------------------
# --- Openpose
OPENPOSE_DIR=../openpose
# --- Openposeのパス
OPENPOSE_BIN=./build/examples/openpose/openpose.bin
# --- 3d-pose-baseline-vmd
BASELINE_DIR=../3d-pose-baseline-vmd
# -- 3dpose_gan_vmd
GAN_DIR=../3dpose_gan_vmd
# -- FCRN-DepthPrediction-vmd
DEPTH_DIR=../FCRN-DepthPrediction-vmd
# -- VMD-3d-pose-baseline-multi
VMD_DIR=../VMD-3d-pose-baseline-multi

# 映像に映っている最大人数
NUMBER_PEOPLE_MAX=1
# ---  反転フレームリスト
# 例）4,10-12　…　4,10,11,12 が反転判定対象フレームとなります。
REVERSE_FRAME_LIST=

# ---  順番指定リスト
# フォーマット：［＜フレーム番号＞:左から0番目にいる人物のインデックス,左から1番目…］
# 例）[10:1,0]　…　10F目は、左から1番目の人物、0番目の人物の順番に並べ替えます。
ORDER_SPECIFIC_LIST=

# ---  詳細ログ有無
VERBOSE=2 # 1:warn, 2:no, 3:yes

# ---  解析を開始するフレーム
FRAME_FIRST=0


PWD=`pwd`
DTTM=`date '+%Y%m%d_%H%M%S'`
INPUT_VIDEO="${PWD}/input.mp4"
INPUT_VIDEO_DIR=$(cd $(dirname "$INPUT_VIDEO") && pwd)/
INPUT_VIDEO_FILENAME=`basename $INPUT_VIDEO | sed 's/\.[^\.]*$//'`
OUTPUT_JSON_DIR_PARENT=${INPUT_VIDEO_DIR}${INPUT_VIDEO_FILENAME}_${DTTM}/
OUTPUT_JSON_DIR_NAME="${INPUT_VIDEO_FILENAME}_json"
OUTPUT_JSON_DIR=${OUTPUT_JSON_DIR_PARENT}${OUTPUT_JSON_DIR_NAME}
OUTPUT_VIDEO_PATH=${OUTPUT_JSON_DIR_PARENT}${INPUT_VIDEO_FILENAME}_openpose.avi

# -- Openpose 実行
cd $OPENPOSE_DIR
mkdir -p $OUTPUT_JSON_DIR
$OPENPOSE_BIN --video $INPUT_VIDEO --model_pose COCO --write_json $OUTPUT_JSON_DIR --write_video $OUTPUT_VIDEO_PATH --number_people_max $NUMBER_PEOPLE_MAX --frame_first $FRAME_FIRST

echo "BULK OUTPUT_JSON_DIR: ${OUTPUT_JSON_DIR}"

echo ------------------------------------------
echo FCRN-DepthPrediction-vmd
echo ------------------------------------------
cd $DEPTH_DIR
python tensorflow/predict_video.py --model_path tensorflow/data/NYU_FCRN.ckpt --video_path $INPUT_VIDEO --json_path $OUTPUT_JSON_DIR --interval 10 --reverse_frames "$REVERSE_FRAME_LIST" --order_specific "$ORDER_SPECIFIC_LIST" --verbose $VERBOSE --now $DTTM

for i in `seq 1 ${NUMBER_PEOPLE_MAX}`; do
    DISPLAY_IDX=0${i}
    OUTPUT_SUB_DIR=${OUTPUT_JSON_DIR_PARENT}${OUTPUT_JSON_DIR_NAME}_${DTTM}_idx${DISPLAY_IDX}

    echo ------------------------------------------
    echo 3d-pose-baseline-vmd [$i]
    echo ------------------------------------------
    cd $BASELINE_DIR
    python src/openpose_3dpose_sandbox_vmd.py --camera_frame --residual --batch_norm --dropout 0.5 --max_norm --evaluateActionWise --use_sh --epochs 200 --load 4874200 --gif_fps 30 --verbose $VERBOSE --openpose $OUTPUT_SUB_DIR --person_idx 1

    echo ------------------------------------------
    echo 3dpose_gan [$i]
    echo ------------------------------------------
    cd $GAN_DIR
    python bin/3dpose_gan_json.py --lift_model train/gen_epoch_500.npz --model2d openpose/pose_iter_440000.caffemodel --proto2d openpose/openpose_pose_coco.prototxt --base-target $OUTPUT_SUB_DIR --person_idx 1 --verbose $VERBOSE

    echo ------------------------------------------
    echo VMD-3d-pose-baseline-multi [$i]
    echo ------------------------------------------
    cd $VMD_DIR
    python applications/pos2vmd_multi.py -v $VERBOSE -t "$OUTPUT_SUB_DIR" -b "born/あにまさ式ミクボーン.csv" -c 30 -z 5 -s 1 -p 0 -r 0 -k 1 -e 0
done

echo ------------------------------------------
echo トレース結果
echo json: $OUTPUT_JSON_DIR
echo vmd:  $OUTPUT_SUB_DIR
echo ------------------------------------------


# -- カレントディレクトリに戻る
cd $PWD