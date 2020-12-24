FROM pytorch/pytorch:1.7.0-cuda11.0-cudnn8-runtime

RUN apt update && \
    apt install -y build-essential cmake git libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev && \
    mkdir opencv && \
    cd opencv && \
    git clone https://github.com/opencv/opencv.git && \
    mkdir build && \
    cd build && \
    cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local ../opencv && \
    make && \
    make install && \
    pip install --upgrade pip opencv-python opencv-contrib-python && \
    apt-get install -y libgl1-mesa-dev

RUN conda install -c conda-forge visdom tqdm matplotlib

# Set up UID not to use root in Container
ARG UID
ARG GID
ARG UNAME

ENV UID ${UID}
ENV GID ${GID}
ENV UNAME ${UNAME}

RUN groupadd -g ${GID} ${UNAME}
RUN useradd -u ${UID} -g ${UNAME} -m ${UNAME}

COPY bt_im.txt /tmp
COPY test.jpg /tmp

WORKDIR /res
