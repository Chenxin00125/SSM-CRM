package com.cx.settings.service;


import com.cx.settings.domain.DicValue;

import java.util.List;
import java.util.Map;

public interface DicService {

    //获取数据字典中的所有数据
    Map<String, List<DicValue>> getAllDic();
}
