---
layout: page
title: 风雨钝剑的小窝
---
{% include JB/setup %}
{% for post in site.posts limit:7 %}
<h2><a class="post_title" href="{{post.url}}">{{post.title}}</a></h2>
<div class="post-content">{{post.excerpt}}</div>
---
{% endfor %} 
[更多文章](categories.html)
