---
layout: post
title: "Cygwin安装后的若干问题解决办法"
category: "应用软件"
tags: [vi, 软件, Cygwin, 技术, 科研]
---
{% include JB/setup %}

以前的个人笔记，仅作备忘之用，如有转载，请注明出处

──by realasking

####窗口太小，无法全屏

解决：启动`cygwin`后，在标题栏单击右键，选属性，布局，调整窗口大小
 

####修改bash默认颜色方案时提示：`dircolors: no SHELL environment variable, and no shell type option given`

解决：在`.bashrc`中设置：`export SHELL="bash"`

####vim颜色方案不对，背景全灰

解决：修改.vimrc，用`"`注释掉`set t_Co=256`，因为cygwin默认不支持256色

####vim输入中文串行

解决：修改`.vimrc`，加入以下内容：
{% highlight vim linenos=table  %}
   if &term != "cygwin"
   set ruler
   else
   set noruler

   endif
{% endhighlight %}

嗯，这条好像是来自紫霞论坛

####Cywin输入、显示中文不正常

解决：修改`.inputrc`，解除以下几行注释：

{% highlight bash linenos=table  %}
    #set meta-flag on
    #set convert-meta off
    #set input-meta on
    #set output-meta on
{% endhighlight %}

####vim退格键未定义

解决：修改`.vimrc`，加入：

{% highlight vim linenos=table  %}
    set nocp
    set backspace=start,indent,eol
{% endhighlight %}
      
####在Cygwin中不能复制和粘贴

解决：一个好的解决方案是使用[puttycyg](http://code.google.com/p/puttycyg)

