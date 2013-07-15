---
layout: post
title: "让fortran在终端下输出彩色文字"
description: "一个fortran和C语言混合编程实例"
category: "程序设计"
tags: [编程, fortran, C]
---
{% include JB/setup %}

本文系以前做的Fortran和C语言混合编程的实例，可以让fortran实现在终端下输出彩色文字，如有转载，请注明出处。

──by realasking

###接口

`cf_inter.f90`

{% highlight fortran linenos=table %}
 module cf_inter
   !fortran输出彩色文字的接口模块，用于连接c语言子程序
   !程序编制：realasking
   !编制时间：2011-04-19
   !个人博客：http://hi.baidu.com/realasking
   !新地址：  http://realasking.github.io
   interface
     subroutine colorfortran(color_int,bk_color_int,&
     str,len_str,char_len)
       implicit none
       integer :: color_int
       integer :: bk_color_int
       integer :: len_str,char_len
       character(len_str) :: str
     end subroutine colorfortran
     subroutine cline(change_line)
       implicit none
       integer :: change_line
     end subroutine cline
   end interface
 end module cf_inter
{% endhighlight %}

###输出彩色文字子程序

`colorfortran_.c`

{% highlight c linenos=table %}
#include<stdlib.h>
#include<stdio.h>
/*
用于输出彩色文字的c语言子程序                                                                  
程序编制：realasking                                                                                                         
编制时间：2011-04-19                                                                                                         
个人博客：http://hi.baidu.com/realasking
新地址：  http://realasking.github.io
*/

int colorfortran_(int *color_int,int *bk_color_int,char *str,
int *len_str,int *char_len,int l)
{
 int i,j,k;
 char str_out[(*char_len)+1];
 for(i=0;i<*char_len;i++)
    {
      str_out[i]=*(str+i);
     }
 str_out[i]='\0';
 printf("\033[%d;%dm",*bk_color_int,*color_int);
 printf("%s",str_out);
 printf("\033[0m");
 return(1);
}
{% endhighlight %}

###应用实例

`ex.f90`

{% highlight fortran linenos=table %}
program ex
use cf_inter
!Fortran输出彩色文字示例程序
!程序编制:realasking
!编制时间：2011-04-19
!个人博客：http://hi.baidu.com/realasking
!新地址：  http://realasking.github.io
implicit none
character(120) :: aa(6)
integer :: color_int,bk_color_int,len_str,char_len
integer :: change_line
integer :: i,j

aa(1)=" This is"
aa(2)=" a"
aa(3)=" new world"
aa(4)=","
aa(5)=" 是一个"
aa(6)="新的世界"
len_str=120
color_int=30
bk_color_int=1
do i=1,6
  char_len=len_trim(aa(i))
  color_int=color_int+i
  bk_color_int=bk_color_int+i-1
  call colorfortran(color_int,bk_color_int,&
  aa(i),len_str,char_len)
enddo
change_line=1
call cline(change_line)
end program ex
{% endhighlight %}

###例程运行方法

假定使用intel的编译器套件，依次执行以下命令：

{% highlight bash linenos=table %}
$icc -c *.c
$ifort -c *.f90 
$ifort -o test *.o
$./test
{% endhighlight %}

###适用环境

支持彩色显示的类unix终端

