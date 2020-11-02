package com.cx.workbench.service;

import com.cx.workbench.domain.Tran;

public interface TranService {
    //转换创建的交易
    int tranDeal(Tran tran);
}
