---
layout: page
title: 风雨钝剑博客
---
{% include JB/setup %}
{% for post in site.posts limit:5 %}
<h2><a class="post_title" href="{{post.url}}">{{post.title}}</a></h2>
<div class="post-content">{{post.content}}</div>
{% endfor %} 

