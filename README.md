# Java 远程debug

<a name="b0lJr"></a>
## 一、remote debug
何为远程debug呢？通常我们在开发过程中，都会将代码部署到服务中，这个时候QA 提出了一个bug,通过查看代码的逻辑发现问题十分的困难？一般情况下都是想着本地能不能复现一下，本地debug 调试一下；或者通过arthas 进行相关逻辑的诊断也是可以的。但是今天我们讲的是远程debug，意思就是直接调试linux 服务器上面的代码，在IDEA中添加一个remote 然后填写远程服务器的开启JPDA（Java Platform Debugger Architecture)的端口号,只需要本地存在相同的代码即可。这样的使用场景非常多，比如本地启动代码真的特别的麻烦，有时候开发代码都是直接使用远程debug。
<a name="dJqr2"></a>
## 二、实践

<a name="13ssx"></a>
### 2.1 远程服务器java程序开启JPDA
  java -agentlib:jdwp=transport=dt_socket,address=5005,server=y,suspend=n  -jar xxx.jar,就是开启了远程debug，自己本地想测试，可以使用下面这个脚本在当前项目目录创建一个，通过脚本启动jar。
```bash
#!/bin/sh -x
dir=$(cd `dirname $0`;pwd)
echo $dir
mvn clean install -Dmaven.test.skip=true -U &&\
java -Dspring.profiles.active=project \
-Dfile.encoding=UTF-8 \
-agentlib:jdwp=transport=dt_socket,address=5005,server=y,suspend=n \
-jar $dir/target/remote-debug.jar
```

<a name="04335"></a>
### 2.2 本地启动remote-debug 客户端
在IDEA中选择remote的这种方式，然后填写服务器端开启的ip 和JPDA的端口即可,，然后启动即可调试
```bash
-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5005
```
![image.png](https://cdn.nlark.com/yuque/0/2020/png/171220/1580365740982-c50088b5-1ebc-49a8-9d68-e6a60a485600.png#align=left&display=inline&height=493&name=image.png&originHeight=986&originWidth=2106&size=169813&status=done&style=none&width=1053)

然后就可以像调试本地一样的进行调试了，非常的方便

![image.png](https://cdn.nlark.com/yuque/0/2020/png/171220/1580365836357-7fd99654-b035-4af8-9f5b-6b1ea2f789db.png#align=left&display=inline&height=511&name=image.png&originHeight=1022&originWidth=2110&size=182466&status=done&style=none&width=1055)

<a name="gBs3u"></a>
## 三、理论
JPDA（Java Platform Debugger Architecture）是Java平台调试体系结构的缩写。由3个规范组成，分别是JVMTI(JVM Tool Interface)，JDWP(Java Debug Wire Protocol)，JDI(Java Debug Interface) 。<br />![image.png](https://cdn.nlark.com/yuque/0/2020/png/171220/1580366114446-eecca308-f8f5-4a92-a908-ae3771686532.png#align=left&display=inline&height=323&name=image.png&originHeight=323&originWidth=481&size=40062&status=done&style=none&width=481)<br />1.JVMTI定义了虚拟机应该提供的调试服务，包括调试信息（Information譬如栈信息）、调试行为（Action譬如客户端设置一个断点）和通知（Notification譬如到达某个断点时通知客户端），该接口由虚拟机实现者提供实现，并结合在虚拟机中。本质上JVMTI是一个programming interface，主要用在开发和监控上。而且它提供了接口去观察(inspect) 应用状态和控制应用的执行。提供了profiling、debuging、monitoring、thread analysis、coverage analysis等等，我们使用到的debug，[只是JVMTI提供的众从能力中的一种](https://mp.weixin.qq.com/s?__biz=MzI3MTEwODc5Ng==&mid=2650859362&idx=1&sn=6d0a588da10ebf38e9d83cfa4e7e16fa&chksm=f13298b1c64511a78e3a87df0f1ddebd87719a36a9335edd759c404cd5c53d65e9383da613f1&scene=21#wechat_redirect)。Class的hotSwap，就是通过Instrument实现class的redefine和retransform实现。可以参考arthas实现、[或者这篇文章](https://www.cnblogs.com/goodAndyxublog/p/11880314.html)。<br />2.JDWP定义调试服务和调试器之间的通信，包括定义调试信息格式和调试请求机制<br />3.JDI在语言的高层次上定义了调试者可以使用的调试接口以能方便地与远程的调试服务进行交互，Java语言实现，调试器实现者可直接使用该接口访问虚拟机调试服务。 java调试工具jdb，就是sun公司提供的JDI实现。

更多JPDA 可以参考

- 第 1 部分，JPDA 体系概览  [https://www.ibm.com/developerworks/cn/java/j-lo-jpda1/](https://www.ibm.com/developerworks/cn/java/j-lo-jpda1/)
- 第 2 部分  JVMTI 和 Agent 实现 [https://www.ibm.com/developerworks/cn/java/j-lo-jpda2/](https://www.ibm.com/developerworks/cn/java/j-lo-jpda2/)
- 第 3 部分: JDWP 协议及实现   [https://www.ibm.com/developerworks/cn/java/j-lo-jpda3/](https://www.ibm.com/developerworks/cn/java/j-lo-jpda3/)
- 第 4 部分: Java 调试接口（JDI）  [https://www.ibm.com/developerworks/cn/java/j-lo-jpda4/](https://www.ibm.com/developerworks/cn/java/j-lo-jpda4/)

<a name="xNT5y"></a>
## 四、参考文档

- JAVA远程debug   [https://blog.csdn.net/wz122330/article/details/82877839](https://blog.csdn.net/wz122330/article/details/82877839)
- Tomcat Remote Debug操作和原理 [https://www.cnblogs.com/XuYankang/p/jpda.html](https://www.cnblogs.com/XuYankang/p/jpda.html)
- 当我们谈Debug时，我们在谈什么(Debug实现原理) [https://mp.weixin.qq.com/s?__biz=MzI3MTEwODc5Ng==&mid=2650859362&idx=1&sn=6d0a588da10ebf38e9d83cfa4e7e16fa&chksm=f13298b1c64511a78e3a87df0f1ddebd87719a36a9335edd759c404cd5c53d65e9383da613f1&scene=21#wechat_redirect](https://mp.weixin.qq.com/s?__biz=MzI3MTEwODc5Ng==&mid=2650859362&idx=1&sn=6d0a588da10ebf38e9d83cfa4e7e16fa&chksm=f13298b1c64511a78e3a87df0f1ddebd87719a36a9335edd759c404cd5c53d65e9383da613f1&scene=21#wechat_redirect)
- 手把手教你实现热更新功能，带你了解 Arthas 热更新背后的原理  [https://www.cnblogs.com/goodAndyxublog/p/11880314.html](https://www.cnblogs.com/goodAndyxublog/p/11880314.html)
- javaagent使用指南  [https://www.cnblogs.com/rickiyang/p/11368932.html](https://www.cnblogs.com/rickiyang/p/11368932.html)


> 更多[汪小哥](https://wangji.blog.csdn.net/) or [语雀分享](https://www.yuque.com/docs/share/970bb79c-be5d-4895-96d5-2d10955e4b13?#)