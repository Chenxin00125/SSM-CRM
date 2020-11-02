package com.cx.workbench.dao;


import com.cx.workbench.domain.Clue;
import org.apache.ibatis.annotations.Param;

public interface ContactsDao {

    //根据线索创建一个联系人
    int saveContacts(@Param("clue") Clue clue,@Param("customerId") String customerId, @Param("id") String id);

}
