#!/bin/bash

# 1. Atualiza o sistema e instala o gdebi para gerenciamento de pacotes
sudo apt update && sudo apt upgrade -y
sudo apt install -y gdebi

# 2. Checa a versão do Python instalada
echo "Python version currently installed:"
python3 --version

# 3. Instala a última versão estável do Python e ferramentas adicionais do Linux necessárias
sudo apt install -y build-essential checkinstall
sudo apt install -y libreadline-gplv2-dev libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev zlib1g-dev libffi-dev liblzma-dev
cd /tmp
wget https://www.python.org/ftp/python/3.10.0/Python-3.10.0.tgz
tar -xf Python-3.10.0.tgz
cd Python-3.10.0
./configure --enable-optimizations
sudo make altinstall

# 4. Altera as permissões de sistema
sudo chmod -R a+rX /usr/local/lib/python3.10/

# 5. Instala Gestor de pacotes python
sudo apt install -y python3-pip

# 6. Configura Ambiente virtual
sudo apt install -y python3-venv

#Activate the virtual environment:  source first_env/bin/activate
#Exit from python intepreter: quit()
#Deactivate virtual environment: deactivate

# 7. Bibliotecas para modelagem numérica, computação científica e otimização
pip3 install numpy pandas matplotlib seaborn pyomo scipy scikit-learn

# 8. Bibliotecas  para ciência de dados, aprendizado de máquina e redes neurais
pip3 install pyspark h2o tensorflow keras torch jupyterlab yellowbrick scikit-optimize xgboost

# 9. Bibliotecas para análise de séries temporais
pip3 install statsmodels fbprophet stumpy tslearn

# 10. Bibliotecas para manipulação de textos
pip3 install nltk textblob gensim spacy stanza

# 11. Bibliotecas para crawlers e scrappers
pip3 install scrapy beautifulsoup4 requests lxml selenium

# 12. Bibliotecas para manipulação de bancos de dados
pip3 install sqlalchemy pymysql psycopg2 pymongo

# 13. Bibliotecas para desenvolvimento de APIs e desenvolvimento WEB
pip3 install flask fastapi django falcon flake8 pydantic requests

# 14. Bibliotecas para ontologias
pip3 install owlready2 rdflib ontospy pronto

# 15. Bibliotecas para visualização de gráficos, mapas e análise espacial
pip3 install plotly bokeh folium geopandas descartes shapely rasterio mapclassify contextily mapboxgl

# 16. Instala última versão estável do VS Code
############
#  VS Code #
############

cd /tmp
wget https://update.code.visualstudio.com/latest/linux-deb-x64/stable
sudo gdebi stable
sudo apt install -y libasound2 libatk1.0-0 libcairo2 libcups2 libdbus-1-3 libgbm1 libgconf-2-4 libgdk-pixbuf2.0-0 libgtk-3-0 libx11-xcb1 libxkbfile1 libxss1 libxtst6 libnss3 libxcomposite1

# 17. Instala última versão estável do PyCharm (e pacotes auxiliares)
########### 
# PyCharm #
###########
cd /tmp
wget https://download.jetbrains.com/python/pycharm-community-2021.3.3.tar.gz
tar -xf pycharm-community-2021.3.3.tar.gz
sudo mv pycharm-community-2021.3.3 /opt/pycharm
sudo ln -s /opt/pycharm/bin/pycharm.sh /usr/local/bin/pycharm

# Instala o OpenJDK 11 para o PyCharm
sudo apt install -y openjdk-11-jdk

# Finalização
echo "Instalação concluída com sucesso!"

# stop on error
set -e
