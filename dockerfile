# CUDA runtime + cuDNN (für NVIDIA GPUs)
FROM nvidia/cuda:12.1.1-cudnn8-runtime-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1

WORKDIR /app

# Systemabhängigkeiten: Python, Git, FFmpeg + typische libs für Nodes/Preview
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 python3-pip python3-venv \
    git curl ca-certificates \
    ffmpeg \
    libgl1 libglib2.0-0 \
  && rm -rf /var/lib/apt/lists/*

# Optional: pip/packaging tooling aktualisieren
RUN python3 -m pip install --upgrade pip setuptools wheel

# ComfyUI aus offizieller Quelle
RUN git clone https://github.com/Comfy-Org/ComfyUI.git /app

# PyTorch CUDA Wheels (cu121) installieren
# Hinweis: PyTorch empfiehlt die Installation passend zur CUDA-Variante über den offiziellen Wheel-Index.  [oai_citation:1‡docs.pytorch.org](https://docs.pytorch.org/get-started/locally/?utm_source=chatgpt.com)
RUN python3 -m pip install --index-url https://download.pytorch.org/whl/cu121 \
    torch torchvision torchaudio

# ComfyUI Requirements
RUN python3 -m pip install -r requirements.txt

# Optional (Performance, je nach GPU/Setup): xformers
# Falls das bei dir Konflikte macht, einfach auskommentiert lassen.
# RUN python3 -m pip install xformers

EXPOSE 8188

# ComfyUI als Server starten (wichtig: 0.0.0.0 im Container)
CMD ["python3", "main.py", "--listen", "0.0.0.0", "--port", "8188"]
