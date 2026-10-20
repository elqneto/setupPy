#!/usr/bin/env bash
# Instala o Python do Ubuntu, um ambiente virtual, o VS Code, o PyCharm
# e bibliotecas de ciência de dados e de LLMs.
# Compatível com Ubuntu 26.04 LTS e versões mais novas.
# Última atualização: 2026-10-20

set -euo pipefail

export DEBIAN_FRONTEND=noninteractive
export PIP_DISABLE_PIP_VERSION_CHECK=1
export PIP_DEFAULT_TIMEOUT=120

VENV="${HOME}/venvs/ds"
FAILED="$(mktemp)"

run_root() {
  if [[ "${EUID}" -eq 0 ]]; then
    DEBIAN_FRONTEND=noninteractive "$@"
  else
    sudo DEBIAN_FRONTEND=noninteractive "$@"
  fi
}

require_ubuntu() {
  if [[ ! -r /etc/os-release ]]; then
    echo "Não foi possível identificar o sistema." >&2
    exit 1
  fi
  # shellcheck disable=SC1091
  source /etc/os-release
  if [[ "${ID:-}" != "ubuntu" ]]; then
    echo "Este script suporta apenas Ubuntu. Sistema detectado: ${PRETTY_NAME:-desconhecido}." >&2
    exit 1
  fi
  local oldest
  oldest="$(printf '%s\n%s\n' "26.04" "${VERSION_ID}" | sort -V | head -n1)"
  if [[ "${oldest}" != "26.04" ]]; then
    echo "Requer Ubuntu 26.04 LTS ou mais recente. Sistema detectado: ${PRETTY_NAME}." >&2
    exit 1
  fi
  UBUNTU_PRETTY="${PRETTY_NAME}"
}

verify_sha256() {
  local file="$1"
  local expected="$2"
  local actual
  actual="$(sha256sum "${file}" | awk '{print $1}')"
  if [[ "${actual}" != "${expected}" ]]; then
    echo "Checksum inválido para $(basename "${file}")." >&2
    echo "Esperado: ${expected}" >&2
    echo "Obtido:   ${actual}" >&2
    exit 1
  fi
}

install_pypi() {
  local label="$1"
  shift
  local pkg
  echo "Instalando ${label}..."
  if "${VENV}/bin/pip" install --upgrade "$@"; then
    return 0
  fi
  for pkg in "$@"; do
    if ! "${VENV}/bin/pip" install --upgrade "${pkg}"; then
      printf '%s\n' "${pkg}" >> "${FAILED}"
    fi
  done
}

install_pypi_binary() {
  local label="$1"
  shift
  local pkg
  echo "Instalando ${label}..."
  for pkg in "$@"; do
    if ! "${VENV}/bin/pip" install --upgrade --only-binary=:all: "${pkg}"; then
      printf '%s\n' "${pkg}" >> "${FAILED}"
    fi
  done
}

install_vscode() {
  local key
  echo "Instalando o VS Code..."
  key="$(mktemp)"
  curl -fsSL "https://packages.microsoft.com/keys/microsoft.asc" | gpg --dearmor > "${key}"
  run_root install -m 644 "${key}" /usr/share/keyrings/microsoft.gpg
  rm -f "${key}"
  run_root tee /etc/apt/sources.list.d/vscode.sources >/dev/null <<'EOF'
Types: deb
URIs: https://packages.microsoft.com/repos/code
Suites: stable
Components: main
Architectures: amd64,arm64,armhf
Signed-By: /usr/share/keyrings/microsoft.gpg
EOF
  run_root apt-get update
  run_root apt-get install -y code
}

install_pycharm() {
  local meta version url checksum_url archive expected work
  echo "Buscando a versão mais recente do PyCharm..."
  meta="$(curl -fsSL "https://data.services.jetbrains.com/products/releases?code=PCP&latest=true&type=release")"
  mapfile -t pycharm_info < <(python3 -c 'import json,sys
rel=json.load(sys.stdin)["PCP"][0]
arch=sys.argv[1]
key="linuxARM64" if arch=="arm64" else "linux"
download=rel["downloads"][key]
print(rel["version"])
print(download["link"])
print(download["checksumLink"])' <<<"${meta}" "$(dpkg --print-architecture)")
  version="${pycharm_info[0]}"
  url="${pycharm_info[1]}"
  checksum_url="${pycharm_info[2]}"
  work="$(mktemp -d)"
  archive="${work}/pycharm.tar.gz"
  echo "Baixando PyCharm ${version}..."
  curl -fL --retry 5 --retry-delay 2 -o "${archive}" "${url}"
  expected="$(curl -fsSL "${checksum_url}" | awk '{print $1}')"
  verify_sha256 "${archive}" "${expected}"
  tar -xzf "${archive}" -C "${work}"
  local launcher root
  launcher="$(find "${work}" -type f -path '*/bin/pycharm.sh' -print -quit)"
  if [[ -z "${launcher}" ]]; then
    echo "O pacote do PyCharm não contém bin/pycharm.sh." >&2
    exit 1
  fi
  root="$(dirname "$(dirname "${launcher}")")"
  run_root rm -rf /opt/pycharm
  run_root mv "${root}" /opt/pycharm
  run_root ln -sfn /opt/pycharm/bin/pycharm.sh /usr/local/bin/pycharm
  mkdir -p "${HOME}/.local/share/applications"
  cat > "${HOME}/.local/share/applications/pycharm.desktop" <<'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=PyCharm
Comment=IDE Python
Exec=/opt/pycharm/bin/pycharm.sh %f
Icon=/opt/pycharm/bin/pycharm.svg
Categories=Development;IDE;
Terminal=false
StartupWMClass=jetbrains-pycharm
EOF
  if [[ ! -f /opt/pycharm/bin/pycharm.svg && -f /opt/pycharm/bin/pycharm.png ]]; then
    sed -i 's|pycharm.svg|pycharm.png|' "${HOME}/.local/share/applications/pycharm.desktop"
  fi
  rm -rf "${work}"
  echo "PyCharm ${version} instalado. O núcleo que era o Community continua gratuito."
  echo "A primeira execução ativa um teste de 30 dias da edição Pro."
}

main() {
  require_ubuntu
  if [[ "${EUID}" -eq 0 ]]; then
    echo "Execute o script com o seu usuário. Ele chama sudo quando precisa." >&2
    exit 1
  fi
  sudo -v

  echo "Atualizando o índice de pacotes de ${UBUNTU_PRETTY}..."
  run_root apt-get update
  run_root apt-get install -y --no-install-recommends \
    ca-certificates curl gnupg wget git \
    python3 python3-venv python3-dev python3-pip \
    build-essential pkg-config gfortran \
    libffi-dev libssl-dev libsqlite3-dev libbz2-dev zlib1g-dev \
    liblzma-dev libreadline-dev libncurses-dev \
    libxml2-dev libxslt1-dev libpq-dev \
    libgdal-dev libgeos-dev libproj-dev \
    openjdk-21-jdk

  echo "Python do sistema: $(python3 --version)"
  echo "Criando o ambiente virtual em ${VENV}..."
  mkdir -p "$(dirname "${VENV}")"
  python3 -m venv --upgrade-deps "${VENV}"
  "${VENV}/bin/pip" install --upgrade pip setuptools wheel

  install_pypi "bibliotecas numéricas e científicas" \
    numpy pandas matplotlib seaborn pyomo scipy scikit-learn

  install_pypi "aprendizado de máquina" \
    pyspark h2o keras torch jupyterlab yellowbrick scikit-optimize xgboost

  install_pypi_binary "TensorFlow, se houver wheel para este Python" \
    tensorflow

  install_pypi "séries temporais" \
    statsmodels prophet stumpy tslearn

  install_pypi "processamento de texto" \
    nltk textblob spacy stanza
  install_pypi_binary "gensim, se houver wheel para este Python" \
    gensim

  install_pypi "coleta de dados" \
    scrapy beautifulsoup4 requests lxml selenium

  install_pypi "bancos de dados" \
    sqlalchemy pymysql psycopg psycopg2 pymongo

  install_pypi "APIs e web" \
    flask fastapi django falcon flake8 pydantic

  install_pypi "ontologias" \
    owlready2 rdflib ontospy pronto

  install_pypi "gráficos, mapas e análise espacial" \
    plotly bokeh folium geopandas shapely rasterio mapclassify contextily

  install_pypi "uso de LLMs" \
    openai anthropic google-genai litellm ollama tiktoken \
    huggingface_hub transformers sentence-transformers \
    langchain langgraph python-dotenv

  install_pypi "criação e ajuste de LLMs" \
    datasets accelerate peft trl bitsandbytes

  install_vscode
  install_pycharm

  echo "Instalação concluída."
  echo "Ambiente virtual: ${VENV}"
  echo "Ative com: source ${VENV}/bin/activate"
  if [[ -s "${FAILED}" ]]; then
    echo "Estes pacotes Python não foram instalados:" >&2
    sort -u "${FAILED}" >&2
    rm -f "${FAILED}"
    exit 1
  fi
  rm -f "${FAILED}"
}

main "$@"
