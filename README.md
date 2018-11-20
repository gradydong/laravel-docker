# laravel-docker

这是用docker来搭建laravel运行环境的一个项目，安装docker的步骤请自行搜索


## 执行步骤

1：在自己工作目录，克隆当前项目

2：进入docker目录，运行docker-compose up -d

3：docker-compose ps 查看都运行成功，访问 http://127.0.0.1

4：如果出现错误

    Warning: require(/var/www/html/public/../vendor/autoload.php): failed to open stream: No such file or directory in /var/www/html/public/index.php on line 24
    Fatal error: require(): Failed opening required '/var/www/html/public/../vendor/autoload.php' (include_path='.:/usr/local/lib/php') in /var/www/html/public/index.php on line 24

有两个办法来解决

1：注释掉 docker-compose.override.yml 里面app 对应的  volumes   - ../laravel:/var/www/html 然后 重新执行 docker-compose up -d  适用于生产环境

2: 安装PHP7 和composer ，进入laravel 目录 执行 composer install  适用于开发环境


## 所包含功能

1： laravel queue 

2： supervisor 监控 queue:work

3： cron 计划任务 laravel schedule

4： redis 相关功能

5： mysql 数据库相关 

