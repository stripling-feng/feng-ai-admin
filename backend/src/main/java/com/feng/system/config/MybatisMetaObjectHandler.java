package com.feng.system.config;

import com.baomidou.mybatisplus.core.handlers.MetaObjectHandler;
import com.feng.system.security.LoginUser;
import org.apache.ibatis.reflection.MetaObject;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;

@Component
public class MybatisMetaObjectHandler implements MetaObjectHandler {

    @Override
    public void insertFill(MetaObject metaObject) {
        this.strictInsertFill(metaObject, "createTime", LocalDateTime.class, LocalDateTime.now());
        this.strictInsertFill(metaObject, "updateTime", LocalDateTime.class, LocalDateTime.now());
        fillCreateUserId(metaObject);
        fillUpdateUserIdOnInsert(metaObject);
        this.strictInsertFill(metaObject, "deleted", Integer.class, 0);
    }

    @Override
    public void updateFill(MetaObject metaObject) {
        this.strictUpdateFill(metaObject, "updateTime", LocalDateTime.class, LocalDateTime.now());
        fillUpdateUserIdOnUpdate(metaObject);
    }

    private void fillCreateUserId(MetaObject metaObject) {
        Long userId = currentUserId();
        if (userId == null) {
            return;
        }
        this.strictInsertFill(metaObject, "createUserId", Long.class, userId);
    }

    private void fillUpdateUserIdOnInsert(MetaObject metaObject) {
        Long userId = currentUserId();
        if (userId == null) {
            return;
        }
        this.setFieldValByName("updateUserId", userId, metaObject);
    }

    private void fillUpdateUserIdOnUpdate(MetaObject metaObject) {
        Long userId = currentUserId();
        if (userId == null) {
            return;
        }
        this.strictUpdateFill(metaObject, "updateUserId", Long.class, userId);
    }

    private Long currentUserId() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !(authentication.getPrincipal() instanceof LoginUser loginUser)) {
            return null;
        }
        return loginUser.getUser().getId();
    }
}
