package com.cx.workbench.service;

import com.cx.workbench.domain.Tran;

public interface TranHistoryService {
    //转换创建的交易，创建一条交易记录
    int tranHistory(Tran tran,String id);
}
