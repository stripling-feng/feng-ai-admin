package com.feng.system.security;

import cn.dev33.satoken.stp.StpInterface;
import com.feng.system.module.system.mapper.SysMenuMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import java.util.Collections;
import java.util.List;

@Component
@RequiredArgsConstructor
public class StpInterfaceImpl implements StpInterface {

    private final SysMenuMapper menuMapper;

    @Override
    public List<String> getPermissionList(Object loginId, String loginType) {
        return menuMapper.selectPermissionsByUserId(Long.parseLong(loginId.toString()));
    }

    @Override
    public List<String> getRoleList(Object loginId, String loginType) {
        return Collections.emptyList();
    }
}
