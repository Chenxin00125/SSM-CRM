package com.cx.workbench.dao;


import com.cx.workbench.domain.Clue;
import com.cx.workbench.domain.Contacts;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface ContactsDao {

    //根据线索创建一个联系人
    int saveContacts(@Param("clue") Clue clue,@Param("customerId") String customerId, @Param("id") String id);

    List<Contacts> selectByCustomerId(String id);

}
