FROM python:3.8

RUN apt update && apt install -y python-pip

WORKDIR /opt/elmo
RUN curl -o weights.hdf5 https://s3-us-west-2.amazonaws.com/allennlp/models/elmo/2x4096_512_2048cnn_2xhighway/elmo_2x4096_512_2048cnn_2xhighway_weights.hdf5

WORKDIR /opt/neural-edu-seg
COPY requirements.txt /opt/neural-edu-seg
RUN pip install -r requirements.txt && \
    python -m spacy download en

COPY neuralseg /opt/neural-edu-seg/neuralseg
COPY setup.py /opt/neural-edu-seg
RUN python setup.py install

COPY data /opt/neural-edu-seg/data
COPY tests /opt/neural-edu-seg/tests

COPY data /usr/local/lib/python3.8/site-packages/neuralseg-0.1.0a0-py3.6.egg/data
RUN cp /opt/elmo/weights.hdf5 /usr/local/lib/python3.6/site-packages/neuralseg-0.1.0a0-py3.6.egg/data/elmo/elmo_2x4096_512_2048cnn_2xhighway_weights.hdf5

ENTRYPOINT ["neuralseg/splitter.py"]

