package com.cx.workbench.domain;

public class PageUtil {
    private Activity activity;
    private String pageNum;
    private String pgeSize;

    public PageUtil() {
    }

    public Activity getActivity() {
        return activity;
    }

    public void setActivity(Activity activity) {
        this.activity = activity;
    }

    public String getPageNum() {
        return pageNum;
    }

    public void setPageNum(String pageNum) {
        this.pageNum = pageNum;
    }

    public String getPgeSize() {
        return pgeSize;
    }

    public void setPgeSize(String pgeSize) {
        this.pgeSize = pgeSize;
    }
}
