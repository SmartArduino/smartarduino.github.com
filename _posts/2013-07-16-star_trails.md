---
layout: post
title: "使用linux系统和微单相机拍摄和合成星轨照片"
description: "前段时间用E-pl1拍摄、用StarStaX合成星轨照的方法"
category: "图像处理"
tags: [摄影, linux, 天文, 软件]
---
{% include JB/setup %}

如有转载，请注明出处。

——by realasking

###星空图

<div style="max-width:700px;">
<img src="http://i1296.photobucket.com/albums/ag3/realasking/s_1000__7065739_3_zps8b66bdd2.jpg" alt="图片一" title="星空" width="640" align="middle" />
</div>

###星轨图

<div style="max-width:700px;">
<img src="http://i1296.photobucket.com/albums/ag3/realasking/s_1000_stackedImagenew_1_zps3acd8b1b.jpg" alt="图片二" title="星轨" width="640" align="middle" />
</div>

###拍摄及方法

上面的星轨图就是由六十三张前面的星空图所合成的，其中星空图的拍摄方法是：`iso 200`，`30s`，`f3.5`，开了`抗噪`，没关`防抖`，每次延时`2s`拍摄。然后就是合成，步骤是：

####配准图片

执行命令：

{% highlight bash linenos=table %}
$l=`ls|xargs`;align_image_stack -a aligned_ $l
{% endhighlight %}

这一步需要安装`hugin`软件。

####转换配准图片为jpg

执行命令：

{% highlight bash linenos=table %}
$for i in *.tif;do a=`echo $i|cut -d"." -f1`;convert $i ${a}.jpg;done
{% endhighlight %}

这一步需要安装`imagemagick`软件。

####拼图

运行`StarStaX`，先选星图，再选暗场图，然后调整`preference`，再按`startprocess`按钮，再按`save as`按钮保存图像。

####进一步处理

先用`rawtherapee`打开图像，`色温`设置为`3000K`，`动态色彩`设置为`10`，勾选`找回暗部`，适当`提高对比度`，
然后调用`gimp`，选择天空部分，使用`小波降噪插件`降噪，降噪之后，执行一次`膨胀`，再进行一次降噪，然后再执行两次膨胀，最后保存图片。

####使用到的软件

[hugin](http://hugin.sourceforge.net)
[imagemagick](http://www.imagemagick.org)
[StarStaX](http://www.markus-enzweiler.de/software/software.html)
[rawtherapee](http://rawtherapee.com)
[gimp](http://www.gimp.org)
[gimp的小波降噪插件](http://registry.gimp.org/node/4235)

