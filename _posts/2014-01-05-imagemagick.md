---
layout: post
title: "使用imagemagick生成毛玻璃效果"
description: "个人imagemagick笔记"
category: "图像处理"
tags: [图像, linux, 软件]
---
{% include JB/setup %}

个人笔记，如有转载，请注明出处。

——by realasking

###生成毛玻璃效果的命令

{% highlight bash linenos=table %}
#生成掩模的颜色
color="#222222"
#设置生成半径、高斯模糊半径和sigma值
spp=40
spp2=56
#设置要从原图中裁切出来加上毛玻璃效果的大小
xps='...'
yps='...'
#设置裁切开始位置
x='...'
y='...'
#裁切原图
convert -crop "$xps"x"$yps"+"$x"+"$y" tmp.jpg tmp_bottom.jpg
#生成掩模
convert -size "$xps"x"$yps" xc:"$color" -fill "$color" -draw "rectangle 0,0 ${xps}x${yps}" mask.png
#生成裁切部分的毛玻璃效果（散射加模糊）
convert -spread "$spp" -blur "$spp2"x"$spp" tmp_bottom.jpg tmp_bottom.jpg
#覆盖掩模
composite -dissolve 10%x10% mask.png tmp_bottom.jpg tmp_bottom.jpg 
#重新合成图片
composite -geometry +"$x"+"$y" tmp_bottom.jpg tmp.jpg tmp.jpg
#删除中间文件
rm tmp_bottom.jpg mask.png
{% endhighlight %}


