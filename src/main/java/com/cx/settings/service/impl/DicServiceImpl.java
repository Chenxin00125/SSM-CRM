package com.cx.settings.service.impl;

import com.cx.settings.dao.DicTypeDao;
import com.cx.settings.dao.DicValueDao;
import com.cx.settings.domain.DicValue;
import com.cx.settings.service.DicService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@Lazy(false)
@Transactional
public class DicServiceImpl implements DicService {

    @Autowired
    private DicTypeDao typeDao;
    @Autowired
    private DicValueDao valueDao;


    @Override
    public Map<String, List<DicValue>> getAllDic() {
        Map<String, List<DicValue>> map = new HashMap<String, List<DicValue>>();
        String[] code = typeDao.getAllCode();
        List<DicValue> list = new ArrayList<DicValue>();
        for (int i = 0; i < code.length; i++) {
            list = null;
            list = valueDao.getValueByType(code[i]);
            map.put(code[i],list);
        }
        return map;
    }
}
