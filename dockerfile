FROM nvidia/cuda:12.1.1-runtime-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive \
    PIP_NO_CACHE_DIR=1 \
    PYTHONUNBUFFERED=1

RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 python3-pip python3-venv git \
    libgl1 libglib2.0-0 \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# ComfyUI aus offizieller Quelle
RUN git clone https://github.com/comfyanonymous/ComfyUI.git .

# CUDA-fähiges PyTorch (cu121!)
RUN python3 -m pip install --upgrade pip \
 && python3 -m pip install --index-url https://download.pytorch.org/whl/cu121 \
    torch torchvision torchaudio \
 && python3 -m pip install -r requirements.txt

EXPOSE 8188

CMD ["python3", "main.py", "--listen", "0.0.0.0", "--port", "8188"]
