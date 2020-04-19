#!/bin/sh

#curl -s https://raw.githubusercontent.com/taewanme/oci-dataflow/master/install.sh|bash
echo "start initialization" >> ~/initialze.log
echo "start initialization"

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
