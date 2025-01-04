<h1 align="center">Specialized RAG</h1>
<p align="center">Empowers anyone to easily setup a specialized local <a href="https://aws.amazon.com/what-is/retrieval-augmented-generation/"><b>R</b>etrival <b>A</b>ugmented <b>G</b>eneration</a> on Linux through <a href="https://github.com/Cinnamon/kotaemon">Kotaemon</a> and <a href="https://ollama.com/">Ollama</a>.<p>

<div align="center">
    <img src="https://img.shields.io/badge/Built%20with%20Docker-grey?style=for-the-badge&logo=docker&color=%23282828">
    <img src="https://img.shields.io/badge/Built%20with%20Ollama-grey?style=for-the-badge&logo=ollama&color=%23282828">
    <img src="https://img.shields.io/badge/Built%20on%20Nvidia-grey?style=for-the-badge&logo=nvidia&color=%23282828">
</div>
<div align="center">
    <img src="https://img.shields.io/github/license/standard3/specialized-rag?style=for-the-badge&color=%23dfdaca&labelColor=%23282828">
</div>

This whole setup is accelerated by Nvidia GPUs. AMD isn't currently supported by the underlying libraries.
It uses [Llama 3.1 8b](https://ollama.com/library/llama3.1) model for chatting and [Nomic Embed Text](https://ollama.com/library/nomic-embed-text) for embeddings.

## 📍 Prerequisites

Some prerequisites are needed before starting. Install the following :

- [Docker](https://docs.docker.com/get-started/get-docker/)
- [Nvidia Drivers](https://www.nvidia.com/en-us/drivers/unix/) + `nvidia-container-toolkit` package
- `jq` package

You should be in the `docker` group to run Docker commands without `sudo`. To add yourself to the `docker` group, run the following command :

```bash
sudo usermod -aG docker $USER
```

Then, log out and log back in.

## 📦 Setup

1. Clone this repository and navigate to it :

```bash
git clone git@github.com:standard3/specialized-rag.git && cd specialized-rag
```

2. Run the setup script :

```bash
 ➜ ./start.sh
[*] Starting the containers...
[+] Running 2/0
 ✔ Container ollama    Running                                                                     0.0s
 ✔ Container kotaemon  Running                                                                     0.0s
[*] Downloading ollama models...
pulling manifest
pulling 970aa74c0a90... 100% ▕████████████████████████████████████████▏ 274 MB
pulling c71d239df917... 100% ▕████████████████████████████████████████▏  11 KB
pulling ce4a164fc046... 100% ▕████████████████████████████████████████▏   17 B
pulling 31df23ea7daa... 100% ▕████████████████████████████████████████▏  420 B
verifying sha256 digest
writing manifest
success
pulling manifest
pulling 667b0c1932bc... 100% ▕████████████████████████████████████████▏ 4.9 GB
pulling 948af2743fc7... 100% ▕████████████████████████████████████████▏ 1.5 KB
pulling 0ba8f0e314b4... 100% ▕████████████████████████████████████████▏  12 KB
pulling 56bb8bd477a5... 100% ▕████████████████████████████████████████▏   96 B
pulling 455f34728c9b... 100% ▕████████████████████████████████████████▏  487 B
verifying sha256 digest
writing manifest
success
[*] rag_rag network has subnet 192.168.0.0/24
[*] Container ollama has IP: 192.168.0.10
[*] Container kotaemon has IP: 192.168.0.20
```

> [!NOTE]
> You can also use the `-r` or `--resolution` option to automatically add the host resolution to your hosts file :
>
> ```bash
>  ➜ ./start.sh -r
> ...
> [*] Host resolution already set for ollama
> [*] Host resolution already set for kotaemon
> [*] Host resolution setup complete
> ```
>
> And access your graphical interface at <http://kotaemon/>.

## ⚙️ Configuration

To-do
