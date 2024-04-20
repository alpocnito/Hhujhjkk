FROM continuumio/miniconda3

RUN apt update \
    && apt install -y build-essential libsox-dev portaudio19-dev python3-pyaudio \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/notebooks/ser-wavelet

# Set user
# ENV USER ron
# RUN useradd -m $USER
# RUN chown -R $USER: /opt/conda /opt/notebooks
# USER $USER

RUN conda create -y --name ser python=3.8.10

SHELL ["conda", "run", "--no-capture-output", "-n", "ser", "/bin/bash", "-c"]

RUN conda install jupyter -y

COPY ./ser-wavelet/requirements ./requirements
RUN pip install -r ./requirements/pip.txt

COPY ./ser-wavelet/config ./config
COPY ./ser-wavelet/data ./data
COPY ./ser-wavelet/examples ./examples
COPY ./ser-wavelet/notebooks ./notebooks
COPY ./ser-wavelet/src ./src
COPY ./ser-wavelet/checkpoints2 ./checkpoints2
COPY ./ser-wavelet/features ./features

CMD jupyter notebook \
    --notebook-dir=/opt/notebooks --ip='*' --port=8888 \
    --no-browser --allow-root --NotebookApp.token=''
