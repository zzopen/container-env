# DOCKER语录

# 安装
[CentOS 安装 Docker](https://docs.docker.com/engine/install/centos/)
[Ubuntu 安装 Docker](https://docs.docker.com/engine/install/ubuntu/)
[安装 Docker Compose](https://docs.docker.com/compose/install/standalone/)

```text
1.docker inspect -f='{{.Name}} - {{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $(docker ps -aq) | grep beanstalkd
2.links不建议使用，使用networks替代
3.移除没有使用的网络:docker network prune
4.查看network数量:docker network ls | wc -l
5.root用户进入容器：docker exec -it --user root kafka1 bash
6.entrypoint和CMD区别
cmd是容器默认的执行，entrypoint是容器正真的执行命令，会覆盖CMD
cmd可以作为entrypoint的默认参数

The CMD instruction has three forms:
CMD ["executable","param1","param2"] (exec form, this is the preferred form)
CMD ["param1","param2"] (as default parameters to ENTRYPOINT)
CMD command param1 param2 (shell form)

ENTRYPOINT has two forms:
ENTRYPOINT ["executable", "param1", "param2"] (exec form, preferred)
ENTRYPOINT command param1 param2 (shell form)
```

2.查看具体的volume对应的真实地址
docker volume inspect mysql

3.配置volume的两种方式


# volume
```text
1. volumes:
    - /data:/etcd_data


直接挂载到本地，比较直观，但需要管理本地的路径

2.volumes:
mysql:/var/lib/mysql
...
volumes:
mysql:
比较简洁，但你不知道数据存在本地什么位置，下面说明如何查看docker的卷标

4.删除volume
得先删除容器才能删除volume，不然会报错
docker volume rm  etcd1 ...

```
# container
## 删除指定的容器
docker rm -f etcd1 ...

# image
## 删除镜像
docker rmi 5958914cc558

## 清除无用镜像
docker image prune -a
```text
删除none镜像（这些坏坏的镜像也叫dangling images，空悬镜像。）
docker rmi $(docker images -f "dangling=true" -q)

docker images | grep '<none>'
```


# network
docker network ls
docker network inspect 网卡id

## 删除网络
docker network rm 网卡id


## 设置内网IP


### :cached,:delegated,:consistent
通过在 docker run -v， --volume 的 option 中指定 cached 或 delegated，可以显着提高 Docker Desktop for Mac 上已装载卷访问的性能。您可以根据情况调整所需的一致性级别：

consistent：默认值，完美的一致性，即主机和容器实时一致。
cached：主机具有权威性。容器执行的写操作对主机是立即可见的，但是在主机上执行的写操作可能不会立即反应在容器内。
delegated：容器的内容具有权威性。提供最弱保证，由容器执行的写操作可能不会立即反映在主机文件系统上，提供的性能要比其他配置好得多。

### rw,ro
而其中的rw、ro和不指定模式，是比较重要的一个环节，关系到宿主机与容器的文件、文件夹变化关系，下面来一一详解

一、不指定

（1）文件：宿主机修改该文件后容器里面看不到变化；容器里面修改该文件，宿主机也看不到变化

（2）文件夹：不管是宿主机还是容器内修改、新增、删除文件，都会相互同步

二、ro

（1）文件：容器内不能修改，会提示read-only

（2）文件夹：容器内不能修改、新增、删除文件夹中的文件，会提示read-only

三、rw

（1）文件：不管是宿主机还是容器内修改，都会相互同步，但容器内不允许删除，会提示Device or resource busy；宿主机删除文件，容器内的不会被同步

（2）文件夹：不管是宿主机还是容器内修改、新增、删除文件，都会相互同步


## Error response from daemon: error while removing network: network
Error response from daemon: error while removing network: network elasticsearch-standalone_es-v7-standalone-network id 
f957b93e6a684976652e3586c64fe59635a0ed365c7974f8ca57e4134435263a has active endpoints
```shell
依次按照实际情况执行
docker network inspect elasticsearch-standalone_es-v7-standalone-network

docker network disconnect -f elasticsearch-standalone_es-v7-standalone-network kibana-v7
 
docker network rm f957b93e6a68
```

## 重置docker
```text
docker system df
docker system prune -a
docker image prune -a
docker volume prune -a
```