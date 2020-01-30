#!/bin/sh -x
dir=$(cd `dirname $0`;pwd)
echo $dir
mvn clean install -Dmaven.test.skip=true -U &&\
java -Dspring.profiles.active=project \
-server \
-Xms1536m \
-Xmx1536m \
-Xmn768m \
-XX:MetaspaceSize=256m \
-XX:MaxMetaspaceSize=512m \
-XX:MaxDirectMemorySize=1g \
-XX:SurvivorRatio=10 \
-XX:+UseConcMarkSweepGC \
-XX:CMSMaxAbortablePrecleanTime=5000 \
-XX:+CMSClassUnloadingEnabled \
-XX:CMSInitiatingOccupancyFraction=80 \
-XX:+UseCMSInitiatingOccupancyOnly \
-XX:+ExplicitGCInvokesConcurrent \
-Dsun.rmi.dgc.server.gcInterval=2592000000 \
-Dsun.rmi.dgc.client.gcInterval=2592000000 \
-XX:ParallelGCThreads=4 \
-Xloggc:$dir/logs/gc.log \
-XX:+PrintGCDetails \
-XX:+PrintGCDateStamps \
-XX:+HeapDumpOnOutOfMemoryError \
-XX:HeapDumpPath=$dir/logs/java.hprof\
-Djava.awt.headless=true \
-Dsun.net.client.defaultConnectTimeout=10000 \
-Dsun.net.client.defaultReadTimeout=30000 \
-Dfile.encoding=UTF-8 \
-agentlib:jdwp=transport=dt_socket,address=5005,server=y,suspend=n \
-jar $dir/target/remote-debug.jar


## 远程debug
# -agentlib:jdwp=transport=dt_socket,address=5005,server=y,suspend=n
# 参考文档  https://www.cnblogs.com/XuYankang/p/jpda.html

##