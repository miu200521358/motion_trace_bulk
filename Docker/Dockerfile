FROM ubuntu:18.10 as builder

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONIOENCODING=utf-8
ENV LANG=C.UTF-8

# install packages
RUN apt-get update
RUN apt-get install -y apt-utils
RUN apt-get update
RUN apt-get install -y cmake cmake-qt-gui curl unzip libopencv-dev lv libboost-thread-dev libatlas-base-dev
RUN apt-get install -y libprotobuf-dev libleveldb-dev libsnappy-dev libhdf5-serial-dev protobuf-compiler
RUN apt-get install -y --no-install-recommends libboost-all-dev
RUN apt-get install -y libgflags-dev libgoogle-glog-dev liblmdb-dev
RUN apt-get install -y python3-pip
RUN apt-get install -y git
RUN apt-get install -y wget

# Caffe & OpenPose
RUN git clone  --depth 1 https://github.com/CMU-Perceptual-Computing-Lab/openpose.git
RUN mkdir /openpose/build
RUN apt-get install -y libmkl-dev
RUN apt-get install -y libcaffe-cpu-dev
RUN curl --create-dirs -L -o /openpose/models/pose/coco/pose_iter_440000.caffemodel http://posefs1.perception.cs.cmu.edu/OpenPose/models/pose/coco/pose_iter_440000.caffemodel
RUN curl --create-dirs -L -o /openpose/models/pose/mpi/pose_iter_160000.caffemodel http://posefs1.perception.cs.cmu.edu/OpenPose/models/pose/mpi/pose_iter_160000.caffemodel
RUN curl --create-dirs -L -o /openpose/models/face/pose_iter_116000.caffemodel http://posefs1.perception.cs.cmu.edu/OpenPose/models/face/pose_iter_116000.caffemodel
RUN curl --create-dirs -L -o /openpose/models/hand/pose_iter_102000.caffemodel http://posefs1.perception.cs.cmu.edu/OpenPose/models/hand/pose_iter_102000.caffemodel
RUN cd /openpose && sed -ibak -e 's|${MKL_PATH}/include/|/usr/include/mkl/|' CMakeLists.txt
COPY mkldnn_inner_product_layer.cpp.patch /tmp/
RUN cd /openpose/build \
 && cmake -DGPU_MODE=CPU_ONLY .. \
 && cd /openpose/3rdparty/caffe \
 && patch -p1 < /tmp/mkldnn_inner_product_layer.cpp.patch \
 && cd /openpose/build \
 && make -j $(nproc)
RUN ldconfig


# runtime image
FROM ubuntu:18.10

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONIOENCODING=utf-8
ENV LANG=C.UTF-8

COPY --from=builder /openpose /openpose
RUN apt-get update
RUN apt-get install -y apt-utils
RUN apt-get update
RUN apt-get install -y libgflags2.2
RUN apt-get install -y libcaffe-cpu1
RUN apt-get install -y libopencv-core3.2
RUN apt-get install -y libopencv-objdetect3.2
RUN apt-get install -y libopencv-video3.2
RUN apt-get install -y libopencv-calib3d3.2
RUN apt-get install -y libboost-regex1.67.0
RUN apt-get install -y libboost-filesystem1.67.0
RUN apt-get install -y python3-pip
RUN apt-get install -y curl unzip
RUN apt-get install -y libsm6 libgl1


# FCRN-DepthPrediction-vmd
RUN pip3 install python-dateutil
RUN pip3 install pytz
RUN pip3 install pyparsing
RUN pip3 install six
RUN pip3 install matplotlib
RUN pip3 install opencv-python
RUN pip3 install imageio
RUN pip3 install tensorflow
RUN curl -L https://github.com/miu200521358/FCRN-DepthPrediction-vmd/archive/master.tar.gz \
 | tar -zxv \
 && mv FCRN-DepthPrediction-vmd-master FCRN-DepthPrediction-vmd
RUN mkdir /FCRN-DepthPrediction-vmd/tensorflow/data \
 && curl -L -O http://campar.in.tum.de/files/rupprecht/depthpred/NYU_FCRN-checkpoint.zip \
 && unzip NYU_FCRN-checkpoint.zip -d /FCRN-DepthPrediction-vmd/tensorflow/data/ \
 && rm NYU_FCRN-checkpoint.zip

# 3d-pose-baseline-multi
RUN pip3 install h5py
RUN curl -L https://github.com/miu200521358/3d-pose-baseline-vmd/archive/master.tar.gz \
 | tar -zxv \
 && mv 3d-pose-baseline-vmd-master 3d-pose-baseline-vmd
RUN mkdir /3d-pose-baseline-vmd/data \
 && curl -L -O https://www.dropbox.com/s/e35qv3n6zlkouki/h36m.zip \
 && unzip -d /3d-pose-baseline-vmd/data h36m.zip \
 && rm h36m.zip
RUN mkdir /3d-pose-baseline-vmd/experiments \
 && curl -sc /tmp/cookie 'https://drive.google.com/uc?id=1v7ccpms3ZR8ExWWwVfcSpjMsGscDYH7_&export=download' > /dev/null \
 && export TOKEN="$(awk '/_warning_/ {print $NF}' /tmp/cookie)" \
 && curl -Lb /tmp/cookie "https://drive.google.com/uc?export=download&confirm=${TOKEN}&id=1v7ccpms3ZR8ExWWwVfcSpjMsGscDYH7_" -o experiments.zip \
 && rm /tmp/cookie \
 && unzip -d /3d-pose-baseline-vmd/ experiments.zip \
 && rm experiments.zip

# 3dpose-gan
RUN apt-get install -y python3-scipy
RUN pip3 install chainer
RUN curl -L https://github.com/miu200521358/3dpose_gan_vmd/archive/master.tar.gz \
 | tar -zxv \
 && mv 3dpose_gan_vmd-master 3dpose_gan_vmd
RUN curl --create-dirs -o /3dpose_gan_vmd/openpose/openpose_pose_coco.prototxt \
 -L https://raw.githubusercontent.com/opencv/opencv_extra/3.4.1/testdata/dnn/openpose_pose_coco.prototxt
RUN curl --create-dirs -o /3dpose_gan_vmd/openpose/pose_iter_440000.caffemodel \
 -L http://posefs1.perception.cs.cmu.edu/OpenPose/models/pose/coco/pose_iter_440000.caffemodel
RUN curl --create-dirs -o /3dpose_gan_vmd/train/gen_epoch_500.npz \
 -L https://github.com/DwangoMediaVillage/3dpose_gan/blob/master/sample/gen_epoch_500.npz?raw=true

# VMD-3d-pose-baseline-multi
RUN pip3 install PyQt5
RUN curl -L https://github.com/miu200521358/VMD-3d-pose-baseline-multi/archive/master.tar.gz \
 | tar -zxv \
 && mv VMD-3d-pose-baseline-multi-master VMD-3d-pose-baseline-multi
RUN mkdir /VMD-3d-pose-baseline-multi/data/saved_sessions
RUN curl -L http://visual.cs.ucl.ac.uk/pubs/liftingFromTheDeep/res/init_session.tar.gz \
 | tar -zxvC /VMD-3d-pose-baseline-multi/data/saved_sessions 
RUN curl -L http://visual.cs.ucl.ac.uk/pubs/liftingFromTheDeep/res/prob_model.tar.gz \
 | tar -zxvC /VMD-3d-pose-baseline-multi/data/saved_sessions 

CMD ["bash"]
