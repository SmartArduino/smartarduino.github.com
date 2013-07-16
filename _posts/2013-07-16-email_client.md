---
layout: post
title: "Linux/Unix下的邮件管理"
description: "用mutt，fdm，msmtp和rss2email进行邮件收发"
category: "应用软件"
tags: [邮件, linux, mutt, 软件]
---
{% include JB/setup %}

本文为原创内容，首发于linux吧和个人空间，原分三篇，现重新整理合为一篇后在github发布，谨供参考，如有转载，敬请注明出处与作者。

——realasking

Linux/Unix下有很多优秀的邮件工具，结合使用它们可以搭建满足各种用途的
邮件客户端，能大大的降低邮件处理的劳动强度和提高效率，计划中的本系列帖子
希望能简介结合应用`mutt`、`fdm`、`msmtp`和`rss2mail`进行邮件收发和rss阅读的
一点思路，本文是第一篇，介绍fdm邮件接收软件的最简单的用法。

###小巧精干的邮件接收程序fdm

fdm是一个轻量级的邮件接收和排序的软件，体积小巧，配置简单，但功能强大，
而且其最大的优点在于配置文件结构清晰，而且支持正则表达式进行筛选，是一
个很好的邮件处理工具，这里我仅从简单使用的角度对其作一介绍。

fdm的配置文件是`$HOME/.fdm.conf`，其配置文件分为三个部分，第一部分定义
动作和设置，第二部分定义帐户信息，第三部分定义匹配规则、筛选邮件。当
完成定义后，执行`fdm -v  fetch`即可接收邮件，如果要接收邮件的同时在服务器
上保留邮件，只需要多加一个参数`k`即可（如果总是要保留，则只需要在帐户信
息中包含一个`keep`关键字）。

配置文件中的第一部分，我们必须要定义的只有邮箱动作和SSL认证的信息，
动作由`action命令`，`邮箱名`，`邮箱类型`和`路径`组成，SSL认证可以设置为是否需
要认证。邮箱类型可以设置成邮箱、文件夹甚至文件的形式，其中邮箱（即
mbox）是一个储存邮件的单一文件，我们从服务器端接收下来的邮件，以及我
们根据匹配规则筛选的邮件都要存放在邮箱里。以下是一个例子：

<pre>
action "inbox" mbox "%h/mail/INBOX"
action "realasking" mbox "%h/mail/realasking"
action "localhost" mbox "%h/mail/localhost"
set verify-certificates
</pre>

这一个例子，一共设置了三个邮箱inbox，realasking和localhost，均设置到用户
目录下的mail目录中，都设置为邮箱文件类型，其中`%h`表示用户目录。例子最后
一行，表示都要使用ssl认证。

邮箱的第二部分是定义帐户，书写格式是：

<pre>
account "邮箱帐户名" 协议 server "服务器地址" <port 端口号>
            user "邮件用户名" pass "密码" <new-only cache "缓存文件名">  <keep>
</pre>

其中协议部分，如果邮箱要使用SSL认证，那么应该将协议写作`pop3s`，`<>`内所括
起来的是可选内容，`new-only`是只收新邮件。这一部分举一个例子：

<pre>
account "realasking@hotmail.com" pop3s server "pop3.live.com" port 995
           user "realasking@hotmail.com" pass "密码" new-only cache "~/mail/.hotmail" keep
account "realasking@localhost" mbox "/var/spool/mail/realasking"
</pre>

其中第二次使用的 `account`命令表示使用的是本地个人帐户的邮箱。

第三部分的命令是由`match`命令、匹配规则和动作构成，其中匹配规则部分支持正则
表达式，这里只介绍最简单的用法：匹配邮箱帐户名，把不同邮箱的信件放到不同的
邮箱文件中，并`把无法归类的放入INBOX文件`中：

<pre>
match account "realasking@hotmail.com" action "Hot"
match account "realasking@localhost" action "localhost"
match all action "inbox"
</pre>

完成配置后，我们就可以用`fdm -v fetch`收信了

注意,由于`.fdm.conf`文件中保存有邮箱密码，因此需要将该文件的权限设置为`600`,
另外，fdm也可以接收新闻组，并可支持IMAP协议

###强大的邮件管理客户端mutt

要在本地处理邮件的话，只是能接收邮件是远远不够的，还需要邮件管理和发送的工具。在Linux/Unix系统下，mutt是最常
用的邮件管理工具之一，功能非常强大，可以调用各种编辑器，以及邮件收、发工具，
从而构成半自动/自动的邮件客户端，下面即粗略介绍`mutt`的简单使用方法。

mutt的配置文件为`.muttrc`，在使用mutt之前，需要先建立该文件，但是该文件与fdm
的配置文件不同，没有很清晰的结构层次，所有的变量和命令，都是只要存在，就会
生效的，不过它的配置文件也因而具有更大的灵活性，在书写的时候，需要自己考虑
需要实现的功能，以及规划文件的结构。

mutt的配置和写脚本文件有一些不太一样的地方，比如变量设定，在muttrc中使用的
一部分变量，如邮件头`my_hdr`，`mailboxes`等，新的设置并不会替换原有设置，甚至
会累加进去，而另有一些变量，如以`set`命令开头指定的，往往只允许设置一次，再如
mutt有一些预先定义的`action`，即使在配置文件中没有进行指定，这些action在mutt
启动之后也是有效的，还有就是可以用`宏`来自定义一些操作，此外，mutt可以定义`地
址列表`和`组`，也支持直接保存发件人地址，而且提供了一系列的自动化的处理流程，
即`hook`。所以，只要对需要使用mutt完成的操作有了解，那么就能通过采用mutt提供
的这些功能来自由的组合和搭配，完成邮件的管理操作。

对于我自己来说，首先，我需要接收和处理多个邮箱的邮件，而且要能用这些邮箱分
别发送和回复邮件，然后，考虑到我收发的邮件主要是中文邮件，因此中英文邮件不
能有乱码，第三，我需要定义地址簿，第四，要接收邮件列表，第五，要能接收rss，
第六，我习惯使用vi编辑器，邮件要按照主题和最后发送时间来排列。就这六条，对
我来说应该基本够用，因此，加上界面设置，我一共将配置文件分为六个部分：a.通
用设置，b.宏定义，c.邮件地址，d.邮件列表，e.电子邮件发送的定义，f.界面设置，
每个部分分别存成一个文件，然后用`source`命令包含进我的`.muttrc`文件中，这样，
我的mutt配置文件内容就只有以下内容：

{% highlight bash linenos=table %}
#通用
source ~/.mutt/mu.general
#宏
source ~/.mutt/mu.macros
#邮件地址
source ~/mail/addressbook
set alias_file=~/mail/addressbook
#邮件列表
source ~/.mutt/mlist
#界面设置
source ~/.mutt/mu.interface
#邮件发送设置
source ~/.mutt/mu.mls
{% endhighlight %}

其中，a.通用设置包括三个部分，首先是邮箱文件的设置，假定有
`realasking#mdbbs.org`、`realasking#hotmail.com`和locahost三个邮箱（
下文中出现的邮箱地址，均用#代替了@，真正在文件中设置时应该用@）：

{% highlight bash linenos=table %}
set mbox_type=Maildir
set folder=$HOME/mail
set spoolfile=~/mail/INBOX
set header_cache=~/.hcache
set mbox =+INBOX
mailboxes "+INBOX"
mailboxes "+realasking"
mailboxes "+Hot"
mailboxes "+localhost"
{% endhighlight %}

只有用`mailboxes`添加的邮箱文件，才会被mutt监控，否则虽然可以用mutt读取邮件,
但是却无法用其监控新邮件。

然后是本地化的设置，包括终端使用的编码，邮件编码，以及接收邮件的编码，并且
解决编码中的乱码问题：

{% highlight bash linenos=table %}
set charset="UTF-8" #终端编码
set send_charset="gb2312" #这里也可以设置为UTF-8
set locale="zh_CN.UTF-8" 
set assumed_charset="gb2312" #对没有指明编码的邮件假设为gb2312
charset-hook ^us-ascii$ gb2312 #这两行是对不正常的编码映射到gb2312
charset-hook !UTF-8 gb2312
set rfc2047_parameters=yes
set copy=yes #这两行保存已经发送的邮件
set record=~/mail/Sent
set check_new=yes #检查新邮件
auto_view text/html #自动阅读附件中的text/html
set mime_forward_decode=yes
{% endhighlight %}

第三部分是邮件的管理和编辑设置：

{% highlight bash linenos=table %}
set editor="vim" #用vim作为默认编辑器 
set sort=threads #这两行是邮件排序方法
set sort_aux=reverse-last-date-sent
set pager_stop #这几行是邮件显示的方式，忘了从哪里抄过来的了
set fast_reply
set pager_index_lines=10
set index_format="| %4C | %Z | %{{"{%b"}} %d} | %-15.15L | %s" 
set folder_format="| %2C | %t %N | %8s | %d | %f" 
#以下一行，用以让mutt显示回执相关的文件头，因为mutt默认是不支持邮件回执的
#，所以它会隐藏这些信息，unignore的作用就是打开邮件头中被隐藏的相应的字段
unignore disposition-notification-to return-receipt-to x-confirm-reading-to
set header=no #回复邮件不加入原始邮件头
{% endhighlight %}

b.`宏`设置，宏设置是为了定义一连串的操作而存在的，可以用它来定义快捷键以调用
外部的程序，或者mutt的相应功能，我的配置文件中这块比较简单，只有两句话，分
别按`G`键调用`fdm`接收邮件，和按`H`键调用`rss2email`接收Rss：

{% highlight bash linenos=table %}
macro index H "!r2e run"
macro index G "!fdm -v fetch"
{% endhighlight %}

c.邮件地址簿，我定义为文件`~/mail/addressbook`，这是一个文本文件，其格式是：

{% highlight bash linenos=table %}
alias 姓名 别名 <邮件地址>
{% endhighlight %}

然后一条一行往下排列即可，也应把权限设为`600`.

d.邮件列表，我定义为文件`~/.mutt/mlist`，这也是一个文本文件，格式是：

{% highlight bash %}
subscribe 邮件列表地址
{% endhighlight %}

e.电子邮件发送定义，这里，我定义为文件`~/.mutt/mu.mls`，其包括两个部分，第一
部分是设置默认的发件和回邮的邮箱，第二个部分则是根据所进入的邮箱不同，自动
source不同的设置，采用不同的邮箱来回复和发送邮件，这一部分大量使用`hook`，具
体含义可以参考mutt的手册。

其中第一部分是这样设置的：

{% highlight bash linenos=table %}
#取消已有定义
unmy_hdr from: #from是发送邮件的地址
unmy_hdr Disposition-Notification-To: #这是回执请求的信息
unmy_hdr X-Priority: #优先级的信息
unmy_hdr reply-to: #回复到地址

send-hook . 'my_hdr from:realasking#mdbbs.org' #设置邮件头的发送邮件地址
send-hook . 'my_hdr Disposition-Notification-To:realasking#mdbbs.org' #设置邮件回执请求
send-hook . 'my_hdr  X-Priority: 1' #设置邮件优先级为最高，优先级设置，1最高，3最低
send-hook . 'set sendmail="/usr/bin/msmtp"' #这里使用msmtp发送邮件
reply-hook . 'my_hdr reply-to:realasking#mdbbs.org'#这三行，是
reply-hook . 'my_hdr Disposition-Notification-To:realasking#mdbbs.org'
reply-hook . 'my_hdr  X-Priority: 1'
{% endhighlight %}

第二部分是这样设置的：

{% highlight bash linenos=table %}
folder-hook =realasking source ~/.mutt/realasking
folder-hook =Hot source ~/.mutt/Hot
{% endhighlight %}

这里表示当用mutt进入邮箱realasking时，则自动读取配置文件`~/.mutt/realasking`，
而进入Hot时，也类似，因此，用这种办法，就可以实现在不同的邮箱，用不同邮箱
地址发信，下面是Hot文件中的设置：

{% highlight bash linenos=table %}
unmy_hdr from:
unmy_hdr Disposition-Notification-To:
unmy_hdr X-Priority:
unmy_hdr reply-to:
send-hook . 'my_hdr from:realasking#hot.com'
send-hook . 'my_hdr Disposition-Notification-To:realasking#hot.com'
send-hook . 'my_hdr  X-Priority: 1'
send-hook . 'set sendmail="/usr/bin/msmtp -a Hot"'
reply-hook . 'my_hdr reply-to:realasking#hot.com'
reply-hook . 'my_hdr Disposition-Notification-To:realasking#hot.com'
reply-hook . 'my_hdr  X-Priority: 1'
{% endhighlight %}

对于请求回执和优先级设置，网上也有人提供了另一种方案，即直接在mutt里打补
丁，而不需要向上面这样手动的写入邮件头定义，有兴趣的可以参考参考链接[6],
而要想查看邮件头里写了些什么，在mutt中其实只需要按`e`键就可以看到。

另外，可以注意到，我这里每一封发出或者转发的邮件都要求已读提醒和高优先级，
这样做也不是太合理，其实，如果要在需要时才设置这几个部分，只需要将它们设
置为特定的宏即可，也不困难，同样的，也可实现发送邮件回执的功能。

f.也是最后一部分，是mutt的界面设置，用`color`命令即可，下面是几个例子，命令
可以设置的内容和具体方法最好查询手册：

{% highlight bash linenos=table %}
color normal    blue black #mutt界面的主色调，黑底，蓝字
color signature cyan black #签名档，黑底，青色
color header    brightred black ^Disposition-Notification-To: 
#请求回执高亮显示，黑底，红色
color index red blue ~N #新邮件，蓝底，红色
{% endhighlight %}

配置完成之后，就可以用命令运行mutt了，启动mutt后，显示的最上面一行，提示
的是常用的按键和对应的操作，最下面一行是提示的所在的邮箱文件和包括了多少
邮件，中间就是收到的邮件，可以用方向键选择，按回车阅读。要写新邮件，则按
`m`键，此时会提示To:，要求输入收件人地址，可以按Tab键从地址簿里选择，写完
邮件并保存后，按`y`键可以发送邮件，而按a键添加附件;要接收邮件，则按`G`键，然
后回车，接收之后按`c`键再选择邮箱以阅读邮件;如果要回复邮件，则是在阅读邮件
或者选中邮件的状态按`r`键;如果要带附件转发邮件，稍微麻烦一点，我们需要按
如下操作：

<pre>
打开邮件->按v->按t选择要转发的附件->按分号;和f键->按Tab键选择地址->修改
->保存、发送
</pre>

这就是mutt的基本使用方法，但是经过这样的配置，其实还不能发邮件和收rss，
因为还需要配置`msmtp`和`rss2email`，下面即讲述它们的简单用法。

###rss2email和msmtp的配置与使用

对于rss信息的接收，我选择的软件是rss2email，在fedora 13中，可以直接用以下
命令安装：

{% highlight bash %}
yum install rss2email
{% endhighlight %}

安装之后的设置是完全采用命令完成的：

{% highlight bash linenos=table %}
$r2e new
$r2e add rss源 邮件地址
{% endhighlight %}

设置完成之后，只需要执行`r2e run`就会把rss源里的信息取出，发送到指定的邮件地
址，如果要设置多个rss源，只需要多次执行第二条命令即可，第二条命令其实是添
加rss源，对于同一个rss源，只需要执行一次即可。那么如果我们要在本地查看rss呢？
很简单，在输入第二条命令的时候，邮件地址输入成用户名@localhost就可以了，那
么结合在上一篇帖子中的设置，我们先按`H`把rss收到本地，再按`G`就把rss收到邮箱
localhost中了。

对于发送邮件，`msmtp`是一个很好的工具，支持ssl，而且配置文件层次非常清晰，使
用很方便。

要使用msmtp发送邮件，首先需要安装`Mozilla CA root certificate bundle`，安装
方法是（针对fedora 13）: 

{% highlight bash %}
#yum install ca-certificates
{% endhighlight %}

该软件包是提供ssl认
证所需的文件的，安装之后就可以设置msmtp的配置文件`~/.msmtprc`了。

该配置文件由三个部分组成：第一部分是默认设置项，第二部分是帐户信息，第三部
分是默认帐户。其中第一部分可以按如下设置：

{% highlight bash linenos=table %}
defaults
tls on #默认使用认证
auth on #邮件服务器发送邮件需要密码验证
logfile ~/mail/.msmtplog #本地log文件存放位置
{% endhighlight %}

第二部分每一个帐户各自构成一节，每一节从定义变量名开始，比如：
`account abcde`即定义了一个叫abcde的帐户，

然后如果该帐户不需要ssl认证，则使用如下命令：`tls_certcheck off`，
如果需要使用，则输入：`tls_trust_file /etc/pki/tls/cert.pem`，
对于网易的邮箱，可以输入以下两行来关闭tls：

{% highlight bash linenos=table %}
tls off
auth plain
{% endhighlight %}

再定义送件服务器地址：`host 服务器地址`（如smtp.live.com等）

定义端口号：`port 端口号`(对于hotmail和gmail，一般设为587)

定义用户名：`from 邮件地址`（比如realasking#hotmail.com，真实的配置文件中用@替
换#）

定义邮箱帐户：`user 邮件地址`（同上）

定义密码： `password 你的邮箱密码`

第三部分，即设置一个默认的邮箱，做法是：`account default : 帐户名`（比如abcde）

通过这样的设置，就可以在mutt中发送邮件和接收rss了，如果还希望实现定时收件，只
需要结合crontab命令即可。
 (全文完)

附一篇转载的东西，关于添加发送收条的脚本：
{% highlight bash linenos=table %}
{% include 3rd/scripts_in_article/mail_notify.sh %}
{% endhighlight %}
参考资料：
[fdm下载](http://downloads.sourceforge.net/fdm/fdm-1.6.tar.gz)
[fdm网站](http://fdm.sourceforge.net)
[mutt文档](http://www.kreny.com/docs/mutt.htm)
[一则博文](http://hi.baidu.com/darkblueriver/blog/item/4368f50f10f3452e6059f350.html)
[mutt文档2](http://www.mutt.org/#doc)
[关于mutt](http://www.mail-archive.com/mutt-dev@mutt.org/msg02399.html)
