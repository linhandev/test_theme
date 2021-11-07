---
title: 玩转Github Pages
author: Lin Han
date: 2019-08-08 11:33:00 +0800
categories: [Tool]
tags: [Blog, Jekyll, Github]
---
![github-page](/assets/img/post/Tool/github-page.png)

[Github Pages](https://pages.github.com/)是Github推出的一个免费静态网页托管服务。可以用来搭建个人博客，项目简介网站，组织官网等，简单稳定。这篇文章将详细介绍Pages的使用方法。开始前先来一段简介。

## Pages简介

Pages的优点是不需要配服务器，数据库这些环境，简单稳定，而且免费。这使得Page很适合做个人博客，项目主页，企业官网这一类纯展示性质（可能也不产生收益 /笑哭）的站点。其缺点是只能托管静态网页。这不意味着Pages里不能有任何动态的元素，比如可以结合Issue实现博客评论（下文介绍）。但是要做功能复杂的网站或者做很多的数据处理，那还是有一个服务器后台会更方便。

Pages主要有两方面功能：
- 使用[Jekyll](https://jekyllrb.com/)将项目中的markdown文件转换成网页
- 将Github项目指定Branch中的网页托管成网站

Jekyll md转网页的功能很方便，但是灵活性比较差，速度比较慢，大概率用不到。托管的网页主要有三类来源：本地上传，Github Action和Page使用Jekyll从markdown转换，可以根据使用场景选择。比如项目简介网站通常会直接让Page用Jekyll把README.md转成一个单页的网站。个人博客使用这三种方式的都有，本地上传比较麻烦但是最灵活，让Page编译最简单但是限制也较多。

## 项目主页

开始先介绍一个最简单的做项目主页。首先打开一个Github项目，点进Settings->Pages页面。一个没开启Page的项目应该是这样的

![no-page](/assets/img/post/Tool/no-page.png)

Source这里选README.md所在的Branch

![source](/assets/img/post/Tool/source.png)

后面的文件夹选项是指定在这个Branch下去哪找markdown文件。如果只有一个README.md的话保持默认/(root)就行，如果文档是分成多个文件可以放到docs文件夹下，选择/docs。

![root](/assets/img/post/Tool/root.png)

保存。

![saved](/assets/img/post/Tool/saved.png)

稍等一会访问提示的网址就能看到网页了。默认没有主题看起来大概比较素，可以在设置里选一个主题。

![theme](/assets/img/post/Tool/theme.png)

Pages给了12个主题，让Pages md转网页时不建议选外部主题。Pages的文档中描述了[如何使用外部主题](https://docs.github.com/en/pages/setting-up-a-github-pages-site-with-jekyll/adding-a-theme-to-your-github-pages-site-using-jekyll)但是Pages用Jekyll转html的环境比较简单，很多主题都缺gem依赖，而且过程貌似没有log不好debug。如果想用第三方主题建议用Action创建一个环境编译。

<!--
觉得都不好看可以从Jekyll官网列的一些[主题网站](https://jekyllrb.com/docs/themes/#pick-up-a-theme)里找一个主题。切换的主题需要在项目根目录下创建一个 _config.yml ，在里面写
```yaml
theme: [选择的主题名字]
``` -->

[//]: # (TODO:怎么判断有没有gem，怎么找名字，有什么限制)


# 自定义域名

Pages的网址遵循一定的规则，比如个人博客都是 用户名.github.io，项目网站都是 用户名.github.io/项目名 。但是Page也支持自定义域名。

非常明显要用自定义域名首先要自己有一个域名，这个在各大云厂商那都能买到，也可以到[Freenom](https://www.freenom.com/en/index.html?lang=en)申请一个免费的。

[//]: # (TODO:补全这块)

## 个人博客

下面就到了这篇的重头戏，用Github Page部署个人博客。整个过程大概分三步：
- 用markdown写作
- 用[Jekyll](https://jekyllrb.com/)，[hexo](https://hexo.io/)或者[Octpress](http://octopress.org/)这种静态网站生成器转成html
- 把html推到Github项目上



https://github.com/topics/jekyll-theme


首先一点背景知识：[Jekyll](https://jekyllrb.com/)是一个从文字生成静态网站的工具，ruby编写。Github Page 是 Github 推出的静态网站托管服务，每个用户有一个Repo可以放静态网页文件，Github提供免费托管，用户可以通过一个网址访问。这里注意Github Page托管的是静态网页，不是Jekyll主题的那些文件(所以也可以自己写一个静态的网站扔到Github上展示，将md转html的项目也不是只能用Jekyll)。二者组合就可以零成本部署一个个人博客。

## 主题选择
一个博客最明显的特征应该就是主题，选择一个功能丰富的主题可以省去后期自己一点点添加功能的麻烦。有很多Jekyll主题列表网站，比如
- https://jekyllthemes.dev/
- http://jekyllthemes.org/
- http://themes.jekyllrc.org/


里面的主题大多数是免费的，可以上去逛一逛。

这里我选择的主题是[chirpy](https://github.com/cotes2020/jekyll-theme-chirpy)。

选择好主题后下载到本地，下一步是使用Jekyll将主题文件编译成静态网站并在Github上托管，其中编译这一步有三种实现方式：
1. Github 编译
2. Github Action 编译
3. 本地编译

这块有点复杂，自己也没完全研究明白。个人理解大致上是第一种和第二种都是使用Github Action进行的编译，只是第一种是用Github官方提供的Action脚本和ruby环境，包含的gem包比较少，所以大部分的主题会因为缺依赖编译失败。

第二种自己写Action可以自己写GemFile，构建一个自己的环境，应该可以编译所有主题，但是操作起来蛮复杂。最恶心的是Github Action不会提供详细的 Jekyll 编译报错，这样如果出错只能看到是Jekyll编译失败了，不好Debug具体是什么问题。

本地编译个人认为是最方便的，环境装起来并不复杂，能看到完整报错，本地编译完成就可以看到效果(利用Github编译必须push上去才能看到网页的效果)。直接推静态网页上Github不需要写复杂的编译Action，而且推完基本立即生效(Action编译还是比较慢的，大概1~5分钟)。

## 安装环境
首先安装ruby和Jekyll，这里记Arch Linux的步骤，其他系统参考官方[安装文档](https://jekyllrb.com/docs/installation/)
```shell
sudo pacman -S ruby base-devel
```
安装的过程中遇到小问题，pacman下清华源几个文件一直失败。解决的方法是上清华源的网站，直接下载对应的安装包文件之后安装。装好ruby之后换源，安装jekyll，bundle需要的gem包。
```shell
# 添加 TUNA 源并移除默认源
gem sources --add https://mirrors.tuna.tsinghua.edu.cn/rubygems/ --remove https://rubygems.org/
# 列出已有源
gem sources -l
# 应该只有 TUNA 一个
gem install jekyll bundler
bundle
jekyll # 测试安装是否正确
# 头两行输出应该是
# A subcommand is required.
# jekyll 4.2.0 -- Jekyll is a blog-aware, static site generator in Ruby
```
如果上面最后一行输出的是找不到 jekyll 命令，那应该是可执行文件路径里没有gem中的bin文件夹，仔细看看gem安装的输出应该针对这个问题有提示，把bin的路径添加到PATH变量里就行。比如我这Manjaro下路径是 ~/.gem/ruby/2.7.0/bin
```shell
export PATH=$PATH:~/.gem/ruby/2.7.0/bin # 先试一下路径对不对
jekyll
# 如果输出正确了就把这行写到 ~/.bashrc 里，这样打开一个新命令行依旧有效
echo 'export $PATH=$PATH:~/.gem/ruby/2.7.0/bin' >> ~/.bashrc # 必需单引号，双引号变量会替换成值
```
到这编译Jekyll的环境应该就配置好了，下一步对Github项目进行设置。

## Github项目设置
创建一个新项目，项目名要求为 username.github.io。比如我的 Github 用户名为 linhandev ，那么项目就需要叫做 linhandev.github.io。创建时添加一个空的Readme，完成后将项目 clone 到本地。
```shell
git clone https://github.com/username/username.github.io
cd username.github.io # 进到项目里
```
将选择的主题里所有的文件解压到项目里。应该有_config.yml，index.html之类的一堆文件和文件夹。

之后我们给编译出来的网页文件单独创建一个branch，防止git的记录过多导致项目过大。
```shell
git branch gh-page
git checkout gh-page # 切换到新branch
git rm -r *
git commit -m "clean up"
git push --set-upstream origin gh-page
git checkout main # 返回Jekyll项目的branch
```
分支创建完成了，尝试进行build并推到 Github 上。
```shell
git checkout main # 时刻确认好branch，否则可能有神奇的事情发生

jekyll build # md转html

# 在 main 分支 push
git add *
git commit -m "modify"
git push

# 将 _site 中生成的html网站放到 gh-page 分支的根目录里
git checkout gh-page
mv _site .site
rm -rf *
mv .site/* .
rm -rf .site
ls

# 在 gh-page 分支 push
git add *
git commit -m "add"
git push

git checkout main
```
到这复杂的部分基本就完成了，最后到Github项目的Settings里，找到 GitHub Pages 的部分，将 Source 设成 gh-page，/root，保存。网站应该就可以访问了。
![page](/assets/img/post/Tool/Jekyll-Github-Page/page.png)


## 评论
给文章添加评论功能有很多种方案，但是所有添加评论的方案都不可能是纯静态的，所以光靠Github Page是实现不了。一些可能的方法包括
- 用Github的API
- 自己搭建一个评论服务器
- 用第三方的评论服务
之前用的第三方服务[hyvor](https://talk.hyvor.com/)，当时试运营是免费的但是现在已经收费了。之后发现了[utteranc](https://utteranc.es/)。这个利用Github Issue进行评论的工具，很好看，功能强大而且部署方便。按照[utteranc](https://utteranc.es/)网站上的引导选择设置，之后把代码插入到文章下面就可以用了。

## 自定义域名
配置好 Github Page ，直接就可以使用 https://username.github.io 访问网站，此外 Github Page 也支持自定义域名。首先将这个域名CNAME解析到 username.github.io，之后在项目的 Settings 里面填写自己的域名。这个时候gh-page branch里会多一个CNAME文件，本地注意pull一下否则会冲突。在main分支的根目录里也加入这个文件。之后就可以使用自己的域名访问了。

之前从自定义域名转换回 Github 给的免费域名过程中遇到一点麻烦，输入免费域名总是直接跳转到之前解析的自己的域名，之后页面显示Github的404。后来翻文档发现需要清浏览器cache，清除之后就好使了。

## 搜索
跟评论一样，搜索也需要是静态的，大概有两种方式，可以通过谷歌或者百度的站内搜索实现，也可以将文章的信息写入js，在js中直接实现搜索，这样不依赖任何服务。

[//]: # (TODO:)

## 目录
文章比较长的时候有一个目录是很方便的，这个 项目的目录只能放在文章最顶上，不能和页面一起滚，但是用起来十分简单，而且是纯liquid的所以不需要gem。

[//]: # (TODO:)

## 图片

[//]: # (TODO:)

## 数学公式

[//]: # (TODO:)
