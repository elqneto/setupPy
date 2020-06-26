#Checking the installed version
python3 -V

# Install Python 3.7 and a several additional linux tools. The commands required for Ubuntu 18.04 are

sudo apt-get update
sudo apt-get -y upgrade

sudo apt-get install -y build-essential checkinstall 
sudo apt-get install -y libreadline-gplv2-dev libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev zlib1g-dev openssl libffi-dev

sudo apt-get install -y python3.7-dev

sudo apt-get install -y python3.7-setuptools

#sudo apt-get install -y wget


# To manage python packages, we must install pip
sudo apt-get install -y python3-pip

#wget https://bootstrap.pypa.io/get-pip.py && python get-pip.py

# Virtual Environment 

sudo apt-get install -y python3-venv

cd /usr/local/bin/
mkdir environments
cd environments

python3 -m venv first_env

source first_env/bin/activate


#For numeric modelling, scientific computing and optmization
pip3 install numpy
pip3 install matplotlib
pip3 install scipy
pip3 install pyomo

#For visualizaton
pip3 install bokeh
pip3 install seaborn
pip3 install plotly

#For GraphViz (interface)
pip3 install pydot


#Data Scraping
pip3 install scrapy

#For HTTP requests
pip3 install requests

#For SQL 
pip3 install sqlalchemy

#For machine learning, deep learning, neural networks
pip3 install scikitlearn
pip3 install auto-sklearn
pip3 install keras
pip3 install pandas
pip3 install tensorflow
pip3 install pytorch
pip3 install lime
pip3 install ann_visualizer
pip3 install featuretools

#Spark and H2O
pip3 install tabulate
pip3 install future
pip3 install colorama>=0.3.8

pip3 install pyspark
sudo sed -i -e '$a\export PYSPARK_PYTHON=/usr/bin/python3' /etc/spark/conf/spark-env.sh

pip3 install h2o_pysparkling_2.2

#Data diagnose
pip3 install missingno

#For natural language processing
pip3 install nltk

#For date and time
pip3 install arrow

#For HTML, XML and text manipulation
pip3 install flashtext
pip3 install beatifulsoup


quit()
deactivate

#Activate the virtual environment:  source first_env/bin/activate
#Exit from python intepreter: quit()
#Deactivate virtual environment: deactivate


############
#  VS Code #
############
# Repository and key, update apt index and VSCode installation
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt-get update
sudo apt-get install software-properties-common apt-transport-https wget
sudo apt-get install code
sudo apt update
sudo apt upgrade


########### 
# PyCharm #
###########

# Step 1: install java
sudo add-apt-repository ppa:webupd8team/java
sudo apt-get update
echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
sudo apt-get install oracle-java8-installer -y
sudo apt-get install oracle-java8-set-default -y

java -version

sudo snap install pycharm-community --classic

# stop on error
set -e



