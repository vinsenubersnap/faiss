FROM golang:bookworm

WORKDIR /app

# Update and install basic dependencies
RUN apt update -y && apt upgrade -y \
    && apt install ffmpeg -y \
    && apt install exiftool -y \
    && apt install libvips42 -y \
    && apt install libvips-dev -y \
    && apt install libvips -y \
    && apt-get install -y libprotobuf-dev protobuf-compiler \
    && apt-get install -y cmake \
    && apt-get install -y libblas-dev \
    && apt-get install -y build-essential \
    && apt-get install -y liblapack-dev \
    && apt-get install -y libgflags-dev \
    && apt-get install -y unzip \
    && apt-get install -y wget \
    && apt-get install -y curl \
    && apt-get install -y git \
    && apt-get install -y sudo

    # && apt-get install -y pkg-config \
    # && apt-get install -y libgtk-3-dev \
    # && apt-get install -y libjpeg-dev libpng-dev libtiff-dev \
    # && apt-get install -y libavcodec-dev libavformat-dev libswscale-dev \
    # && apt-get install -y libv4l-dev \
    # && apt-get install -y libxvidcore-dev libx264-dev \
    # && apt-get install -y libatlas-base-dev gfortran \
    # && apt-get install -y python3-dev \
    # && apt-get install -y libopenblas-dev liblapacke-dev libeigen3-dev \
    # && apt-get install -y libgtk2.0-dev \
    # && apt-get install -y libtbbmalloc2 \
    # && apt-get install -y libtbb-dev \
    # && apt-get install -y libharfbuzz-dev \
    # && apt-get install -y libfreetype6-dev 

COPY . /app

# Download and build OpenCV 4.10.0
RUN cd scripts/opencv && make install
# RUN rm -rf /usr/local/lib/cmake/opencv4/ \
#     && rm -rf /usr/local/lib/libopencv* \
#     && rm -rf /usr/local/lib/pkgconfig/opencv* \
#     && rm -rf /usr/local/include/opencv* \
#     && rm -rf /usr/local/lib64/cmake/opencv4/ \
#     && rm -rf /usr/local/lib64/libopencv* \
#     && rm -rf /usr/local/lib64/pkgconfig/opencv* \
#     && rm -rf /usr/local/lib/aarch64-linux-gnu/cmake/opencv4/ \
#     && rm -rf /usr/local/lib/aarch64-linux-gnu/libopencv* \
#     && rm -rf /usr/local/lib/aarch64-linux-gnu/pkgconfig/opencv* 


# RUN mkdir /app/opencv_build && cd /app/opencv_build \
#     && curl -L https://github.com/opencv/opencv/archive/4.10.0.zip -o opencv.zip \
#     && unzip opencv.zip \
#     && curl -L https://github.com/opencv/opencv_contrib/archive/4.10.0.zip -o opencv_contrib.zip \
#     && unzip opencv_contrib.zip \
#     && mkdir -p opencv-4.10.0/build \
#     && cd opencv-4.10.0/build \
#     && cmake -D CMAKE_BUILD_TYPE=RELEASE \
#              -D CMAKE_INSTALL_PREFIX=/usr/local \
#              -D BUILD_SHARED_LIBS=${BUILD_SHARED_LIBS} \
#                 -D OPENCV_EXTRA_MODULES_PATH=/app/opencv_build/opencv_contrib-4.10.0/modules \
#              -D BUILD_DOCS=OFF \
#              -D BUILD_EXAMPLES=OFF \
#              -D BUILD_TESTS=OFF \
#              -D BUILD_PERF_TESTS=ON \
#              -D BUILD_opencv_java=NO \
#              -D BUILD_opencv_python=NO \
#              -D BUILD_opencv_python2=NO \
#              -D BUILD_opencv_python3=NO \
#              -D WITH_JASPER=OFF \
#              -D WITH_TBB=ON \
#              -D OPENCV_GENERATE_PKGCONFIG=ON \
#              -D WITH_LAPACK=ON \
#              -D WITH_OPENBLAS=ON \
#              -D WITH_PROTOBUF=ON \
#              .. \
#     && make -j$(nproc) \
#     && make install \
#     && ldconfig

# Continue with the rest of your app build process
# COPY . /app

RUN mkdir -p build

RUN cmake -B build --log-level=VERBOSE -DFAISS_ENABLE_GPU=OFF -DFAISS_ENABLE_C_API=ON -DBUILD_SHARED_LIBS=ON -DFAISS_ENABLE_PYTHON=OFF .

RUN make -C build
RUN make -C build install
RUN cp build/c_api/libfaiss_c.so /usr/lib