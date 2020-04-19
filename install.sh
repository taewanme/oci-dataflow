#!/bin/sh

#curl -sL https://raw.githubusercontent.com/taewanme/oci-dataflow/master/install.sh|bash
#curl -Ls https://bit.ly/2zd9fbu | bash
echo "start initialization" >> ~/initialze.log
echo "start initialization"

cd /home/opc
mkdir -p /home/opc/work/spark-nb-workspace
mkdir -p /home/opc/.oci
mkdir -p /home/opc/apps

SPARK_URL=http://mirror.navercorp.com/apache/spark/spark-2.4.5/spark-2.4.5-bin-hadoop2.7.tgz
wget $SPARK_URL --output-file=/home/opc/apps/spark.tgz
cd /home/opc/apps/
gunzip spark.tgz
tar xvf *.tar
rm -f *.tar
rm -f spark.tgz
ln -s spark-2.4.5-bin-hadoop2.7 spark
cd /home/opc

sudo chmod 777 /etc/profile
export SPARK_HOME=/home/opc/apps/spark
export PATH=$PATH:$SPARK_HOME/bin
sudo echo 'export SPARK_HOME=/home/opc/apps/spark' >> /etc/profile
sudo echo 'export PATH=$PATH:$SPARK_HOME/bin' >> /etc/profile

echo "Install Jupyter." >> ~/initialze.log
# install jupyter
pip3 install --user numpy pandas matplotlib jupyter jupyterlab toree pyspark
jupyter toree install --user --spark_home=$SPARK_HOME --spark_opts='--master local --executor-memory 10g' --interpreters='Scala,SQL'
jupyter notebook --generate-config
echo "c.NotebookApp.ip = '0.0.0.0'" >> ~/.jupyter/jupyter_notebook_config.py
echo "c.NotebookApp.open_browser = False" >> ~/.jupyter/jupyter_notebook_config.py
echo "c.NotebookApp.port = 80" >> ~/.jupyter/jupyter_notebook_config.py
echo "c.NotebookApp.notebook_dir = '/home/opc/work/spark-nb-workspace'" >> ~/.jupyter/jupyter_notebook_config.py

export PYSPARK_PYTHON=/usr/bin/python3
export PYSPARK_DRIVER_PYTHON=jupyter
export PYSPARK_DRIVER_PYTHON_OPTS=lab
echo "export PYSPARK_PYTHON=/usr/bin/python3" >> /etc/profile
echo "export PYSPARK_DRIVER_PYTHON=jupyter" >> /etc/profile
echo "export PYSPARK_DRIVER_PYTHON_OPTS=lab"  >> /etc/profile

cd $SPARK_HOME/conf
cp spark-defaults.conf.template spark-defaults.conf
echo "spark.sql.hive.metastore.sharedPrefixes=shaded.oracle,com.oracle.bmc" >> spark-defaults.conf

echo "Install Hadoop Connector." >> ~/initialze.log
cd /home/opc/apps
wget https://github.com/oracle/oci-hdfs-connector/releases/download/v2.9.2.4/oci-hdfs.zip
unzip oci-hdfs.zip -d oci-hdfs
cp /home/opc/apps/oci-hdfs/lib/*.jar $SPARK_HOME/jars/
cp /home/opc/apps/oci-hdfs/third-party/lib/*.jar  $SPARK_HOME/jars/

#certificate file
echo "Genetate Certificate File." >> ~/initialze.log
echo "Genetate Certificate File."
openssl genrsa -out ~/.oci/oci_api_key.pem 2048
chmod go-rwx ~/.oci/oci_api_key.pem
openssl rsa -pubout -in ~/.oci/oci_api_key.pem -out ~/.oci/oci_api_key_public.pem
