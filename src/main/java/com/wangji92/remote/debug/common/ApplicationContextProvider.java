package com.wangji92.remote.debug.common;

import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;

/**
 * 提供给arthas ognl 获取context的信息
 *
 * @author 汪小哥
 * @date 30-01-2020
 */
public class ApplicationContextProvider implements ApplicationContextAware {
    private static ApplicationContext context;

    public ApplicationContext getApplicationContext() {
        return context;
    }

    @Override
    public void setApplicationContext(ApplicationContext ctx) {
        context = ctx;
    }
}
