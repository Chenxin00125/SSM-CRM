package com.cx.workbench.dao;

import com.cx.workbench.domain.Tran;
import org.apache.ibatis.annotations.Param;

public interface TranHistoryDao {

    //转换创建的交易，创建一条交易记录
    int tranHistory(@Param("tran") Tran tran, @Param("id") String id);
}
