//
//  mypopen.h
//  SMJinher
//
//  Created by  William Sterling on 14-10-11.
//  Copyright (c) 2014年 SM. All rights reserved.
//

#ifndef SMJinher_mypopen_h
#define SMJinher_mypopen_h


FILE * mypopen(const char *cmdstring, const char *type);
int mypclose(FILE *fp);

#endif
