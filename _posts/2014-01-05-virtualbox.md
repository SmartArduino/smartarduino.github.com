---
layout: post
title: "VirtualBox运行windows XP性能调优"
description: "Virtualbox使用笔记"
category: "应用软件"
tags: [技术,软件, 虚拟机]
---
{% include JB/setup %}

个人的一些解决方法的记录，主要是解决linux下用virtualbox运行windows xp的性能问题，首发百度linux吧和自己的博客，如有转载，请注明出处。

——by realasking


Virtualbox虚拟机好用，简单，但是完成安装后的默认设置的性能并不理想，需要自己进行一定调整，这里给出一些思路，谨供参考。


###基本设置

共享粘贴板：`双向`，

拖放：`禁用`

光驱状态：`保存运行时变动`

小工具栏：`在全屏或无缝模式显示`

内存大小：分配`2250MB`给虚拟机（我有8GB内存）

启动顺序：`光驱`、`硬盘`

芯片组：`PIIX3`（我的笔记本是NV的芯片组，如果是Intel芯片组的，有人建议选ICH9)

指点设备：`USB平板`

如果给虚拟机只分配`一个`CPU核心，或机器里没有ISA卡或更早的扩展卡，请不要选`I/O APIC`，没有意义

处理器：1个（我的机器是T9550双核的，分配一个给虚拟机仍然吃得消）

运行峰值：100%

安装那个`vboxaddition`的iso，要在windows`安全模式`下，并且要选`D3D`组件



###启用硬件加速

不开启`启用PAE/NX`，因为我的host系统是64位的，而我分配给XP的内存也未超出4GB

硬件虚拟：`启用VT-x/AMD-V`和`启用嵌套分页`均打开


###启用显卡加速

显存大小设为`128MB`，`启用3D加速`，`启用2D加速`


###调整显示器分辨率

让虚拟机使用和host一样的真实分辨率，需要在终端下先执行：
{% highlight bash%}
VBoxManage setextradata global GUI/MaxGuestResolution any
{% endhighlight %}
然后启动虚拟机，并切换为`全屏模式`，在windows中将分辨率改为自己屏幕的真实分辨率即可


###加速网络

到`linux-kvm`的官网或`fedoraproject`下载virtio的windows驱动:

[virtio-win-0.1-74.iso](http://alt.fedoraproject.org/pub/alt/virtio-win/latest/images/virtio-win-0.1-74.iso)

加载到虚拟机的虚拟光驱中，然后在Virtualbox的`网络`->`高级`中将网卡设置为`准虚拟网络`，然后启动虚拟机，在windows xp查找驱动的时候，手动指向CD中的`xp/x86/netkvm.inf`，安装时会问选择哪个驱动（会有两个版本的信息），任选一个均可

###启用ahci加速磁盘操作

新建一个`ahci控制器`，并新建一个`磁盘`放在该控制器下

进入虚拟机的windows后，下载intel的`matrix storage`的XP版驱动:

[Intel Matrix Storage for windows XP](https://downloadcenter.intel.com/SearchResult.aspx?lang=eng&ProductFamily=Software+Products&ProductLine=Chipset+Software&ProductProduct=Intel%C2%AE+Rapid+Storage+Technology+%28Intel%C2%AE+RST%29)

我下载的是`iata70_cd`，执行安装

关闭虚拟机，删除`ahci控制器`下添加的那个`虚拟磁盘`

删除windows虚拟机所安装的那个虚拟磁盘但保留该虚拟磁盘文件，然后关闭virtualbox

重新启动virtualbox，然后在`ahci控制器`下加载windows虚拟机那个虚拟磁盘文件，

勾选`ide控制器`和`ahci控制器`的`使用主机输入输出（I/O)缓存`项即可。

`使用主机输入输出（I/O)缓存`项勾选与否各有利弊，使用ahci时因并发请求增多影响会更重，如勾选，主机负担重时，虚拟机I/O操作可能没响应，但主机负担不重时，虚拟机文件读写会更快，如不勾，虚拟机内存使用会上升，如内存分配少，会卡机


###待解决问题

拖动虚拟机内的窗口时，常会有残影，应该与虚拟显卡使用内存作显存有关，但尚未找到解决方案。

