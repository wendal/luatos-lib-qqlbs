# luatos-lib-qqlbs

腾讯智能硬件定位(基站定位/wifi定位/蓝牙定位) for LuatOS

**非官方库,如有任意疑问或建议,请报issue,随缘更新**

## 介绍

本客户端基于socket库, 兼容所有LuatOS平台, 只要该平台实现socket库就行

## 安装

本协议库使用纯lua编写, 所以不需要编译, 直接将源码拷贝到项目即可

## 功能

1. 支持wifi定位
2. 支持基站定位
3. TODO 支持蓝牙定位, 但感觉没啥用?

提醒:

* 腾讯的定位服务需要收费, 具体请咨询腾讯. 2024.1.3咨询的答复的免费额度是10000次/天,并发5次/秒.
* 腾讯的定位服务需要一个key, 登陆 lbs.qq.com 注册,并个人认证后可用, 企业认证的额度一样
* 返回结果的坐标系是GCJ02, 获取key之后, 要分配额度, 否则是20次/天, 并发5次/秒
* [腾讯的API文档](https://lbs.qq.com/service/webService/webServiceGuide/location)

## 变更日志

[changelog](changelog.md)

## LIcense

[MIT License](https://opensource.org/licenses/MIT)
