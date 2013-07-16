---
layout: post
title: "fortran调用gsl的环境的建立"
description: "个人笔记，gsl库的使用"
category: "程序开发"
tags: [编程, fortran, C, gsl, 科研]
---
{% include JB/setup %}

以前的个人笔记，仅作备忘之用，如有转载，请注明出处

──by realasking

为了解一个方程，只好用`fortran`来调用`gsl`库，上网查了一下，有一个`fgsl`是`fortran`调用`gsl`的接口库，
结果花了两天时间才搞好这个调用的环境，要点如下：

1.fgsl需要`intel fortran compiler 11.1.05x`及以上的fortran编译器，`04x`的不行

2.`fgsl-0.9.4`需要最新的`gsl`，即`gsl-1.15`

3.`gsl-1.15`编译需要`libtool 2.4`

4.`icc`编译`gsl-1.15`能完成，但通不过测试(make check会失败)，因此只能用`gcc`，我用的版本是gcc 4.4.4

5.因此`fgsl`编译时fortran编译器应指定为`ifort`，但C编译器应指定为`gcc`

因此`安装过程`就是：先升级`libtool`到`2.4`，再编译`gsl`，最后编译`fgsl`

下面是下载地址：

[fgsl下载地址](http://www.lrz.de/services/software/mathematik/gsl/fortran/index.html)
[gsl下载地址](http://www.gnu.org/software/software.html)

编译过程为：

gsl:

{% highlight bash linenos=table %}
$./configure --prefix=/usr/local --libdir=/usr/local/lib64 --enable-static --enable-shared
$make 
$make check
$sudo make install
{% endhighlight %}

fgsl:

{% highlight bash linenos=table %}
$./configure --prefix /usr --f90 ifort --gsl /usr/local
$make 
$sudo make install
{% endhighlight %}

最后建立的环境为：

gsl在:`/usr/local`

fgsl在：

<pre>
/usr/include/ifort/fgsl.mod
/usr/lib64/libfgsl_ifort.a
</pre>

使用：

fgsl的作者在readme文件中写得很详细

