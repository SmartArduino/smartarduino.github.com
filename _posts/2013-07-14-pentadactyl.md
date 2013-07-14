---
layout: post
title: "Pentadactyl个人常用操作"
description: "老文，转移过来"
category: 网络冲浪
tags: [pentadactyl, firefox, 技术]
---
{% include JB/setup %}

个人笔记，转载请注明出处。

——by realasking

窗口最大化： `Meta+x`  恢复：  `Meta+x`  最小化： `Meta+z`    退出： `quitall` 或 `^q`

刷新： `r` 或`F5` 彻底刷新： `shift r`    停止：`st`   返回： `shift h` 或`^o` 或`alt左` 前进： `shift l` 或`^i` 或`alt右`

去主页： `gh`   保存网页： `sav [路径或文件名]` （若在sav 后加!表示路径可覆盖）  打印网页： `:ha`

网页放大： `zi`   网页缩小： `zo`   复制链接： `y`   复制内容： `shift y`   粘贴： `^v^v`    剪切： `^v^x`

打开文件： `:dialog openfile`  添加书签： `a`    打开书签： `:bmarks`

新建tab并打开： `t`  打开：  `o`  关闭当前tab： `d`  上一个tab:  `^p`  下一个tab:   `^n`  跳到指定tab： `b (tab号)`

当前页打开超链接： `f`  新开tab中打开超链接： `shift f` 或`;t`  另存为： `;s [输入hint] [输入路径或文件名]`

查找网页内容： `/`   继续查找： `*`(向下)  `#`(向上)

在本页打开页面的一幅图片： `;i`   在新tab打开一幅图片： `;` `shift i`

复制网页内容的方法：

1.i进入`caret`模式，用`h`，`l`可以在一行内前后移动光标，`j`,`k`可以在不同行间移动光标

2.按`v`进入可视化模式，移动光标，选择文字

3.按`shift y`复制文字

4.在需要粘贴的地方按`p`


网页书签：

1.`shift M`

2.输入英文或数字作为书签名，将当前网页存入书签

3.go书签名 即可访问该书签

查词扩展：

1.把grassofhust(kikyo)的[dict.js](https://github.com/grassofhust/dict.js)存入`.pentadactyl/plugins`目录下

2.输入`dictg` 查找那个单词

3.输入单词    按`Alt d`

本文原始发布地点为百度空间，后因百度贴吧封禁帐号而迁移至此。

