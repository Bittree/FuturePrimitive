---
title: "网络环境质量常用标准"
date: 2020-02-13T00:01:12+08:00
---

评估网络环境质量，主要有延时(Latency，单位微秒ms)、丢包率(百分比)、带宽(Bandwidth，百分比)。一般来说日常手机使用环境的网络质量如下：

环境类型|平均时延(ms)|抖动时延(ms)|丢包率|上行带宽|下行带宽
------|------|------|------|------|------
正常网络|20|20|2%|90%|90%
普通弱网络|30|100~300|12%|80%|60%
超低网络|50|100~500|30%|60%|40%
繁忙网络|50~100|30~50|5%|25%|25%
交通工具行驶中|200~400|200~2000|5%|60%|60%
地铁中|200~400|200~2000|12%|60%|60%
基站切换中|3000~7000|2000|5%|60%|60%

网络时延主要评估数值：ping和RTT(Round trip time)
* ping表示数据在网络传输上所花时间，信号从发出到收到对段返回的计时，ping命令基于ICMP协议来工作
* RTT，RTT=Ping+WaitTime+ProcessTime,即网络传输加上逻辑处理时间，这个值与玩家真实体验到的延迟接近

这两个值对网络游戏来说，20ms优秀、50ms正常、100ms一般、200ms是比较差。4G网络自身时延30ms~40ms,5G网络为6～10ms，骨干网在大陆内部互连时延20ms。
正常情况下网络游戏用的带宽比较小，不会成为同步的瓶颈，一般为2～10KB/s
