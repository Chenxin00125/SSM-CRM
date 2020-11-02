package com.cx.workbench.dao;

import com.cx.workbench.domain.Tran;

public interface TranDao {

    //转换创建的交易
    int tranDeal(Tran tran);

}
