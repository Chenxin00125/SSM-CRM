package com.cx.settings.dao;


import com.cx.settings.domain.DicValue;

import java.util.List;

public interface DicValueDao {

    //根据类型获取value
    List<DicValue> getValueByType(String typeCode);
}
