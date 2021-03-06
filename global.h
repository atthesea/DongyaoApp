﻿#ifndef GLOBAL_H
#define GLOBAL_H

//全局变量
#include "config.h"
#include "msgcenter.h"
#include "protocol.h"
#include "mapmap/onemap.h"
#include "wmsconnection.h"

extern Config *g_config;
extern MsgCenter *msgCenter;
extern OneMap *g_onemap;
extern WmsConnection *g_wmsConnection;
//全局函数

//非阻塞的sleep[只阻塞当前线程] 最小单位是10ms
void QyhSleep(int msec);

QString getErrorString(int error_code);

int getRandom(int maxRandom);

int stringToInt(std::string str);

#endif // GLOBAL_H
