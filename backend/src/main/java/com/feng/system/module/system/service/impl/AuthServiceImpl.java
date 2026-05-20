package com.feng.system.module.system.service.impl;

import cn.dev33.satoken.stp.StpUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.feng.system.common.exception.BusinessException;
import com.feng.system.module.system.dto.ChangePasswordDTO;
import com.feng.system.module.system.dto.LoginDTO;
import com.feng.system.module.system.entity.SysUser;
import com.feng.system.module.system.mapper.SysMenuMapper;
import com.feng.system.module.system.mapper.SysUserMapper;
import com.feng.system.module.system.mapper.SysUserRoleMapper;
import com.feng.system.module.system.service.AuthService;
import com.feng.system.module.system.service.LoginAttemptService;
import com.feng.system.module.system.service.MenuService;
import com.feng.system.module.system.service.SystemConfigService;
import com.feng.system.module.system.vo.LoginVO;
import com.feng.system.module.system.vo.UserInfoVO;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class AuthServiceImpl implements AuthService {

    private final SysUserMapper userMapper;
    private final SysUserRoleMapper userRoleMapper;
    private final SysMenuMapper menuMapper;
    private final MenuService menuService;
    private final LoginAttemptService loginAttemptService;
    private final SystemConfigService systemConfigService;
    private final PasswordEncoder passwordEncoder;

    @Override
    public LoginVO login(LoginDTO dto) {
        loginAttemptService.checkLoginAllowed(dto.getUsername());
        SysUser user = userMapper.selectOne(
                new LambdaQueryWrapper<SysUser>()
                        .eq(SysUser::getUsername, dto.getUsername())
                        .eq(SysUser::getDeleted, 0));
        if (user == null || !passwordEncoder.matches(dto.getPassword(), user.getPassword())) {
            loginAttemptService.recordLoginFailure(dto.getUsername());
            throw new BusinessException("账号或密码错误");
        }
        if (user.getStatus() == null || user.getStatus() != 1) {
            throw new BusinessException("账号已停用，无法登录");
        }
        loginAttemptService.recordLoginSuccess(dto.getUsername());
        StpUtil.login(user.getId());
        return buildLoginVO(user.getId(), StpUtil.getTokenValue());
    }

    @Override
    public LoginVO current() {
        long userId = StpUtil.getLoginIdAsLong();
        return buildLoginVO(userId, null);
    }

    @Override
    public void changePassword(ChangePasswordDTO dto) {
        if (!dto.getNewPassword().equals(dto.getConfirmPassword())) {
            throw new BusinessException("两次输入的新密码不一致");
        }
        if (dto.getNewPassword().trim().length() < 6) {
            throw new BusinessException("新密码长度不能少于6位");
        }
        long userId = StpUtil.getLoginIdAsLong();
        SysUser user = userMapper.selectById(userId);
        if (user == null) {
            throw new BusinessException("当前用户不存在");
        }
        if (!passwordEncoder.matches(dto.getOldPassword(), user.getPassword())) {
            throw new BusinessException("旧密码错误");
        }
        user.setPassword(passwordEncoder.encode(dto.getNewPassword()));
        userMapper.updateById(user);
    }

    private LoginVO buildLoginVO(Long userId, String token) {
        SysUser user = userMapper.selectById(userId);
        UserInfoVO userInfo = new UserInfoVO();
        userInfo.setId(user.getId());
        userInfo.setUsername(user.getUsername());
        userInfo.setNickname(user.getNickname());
        userInfo.setPhone(user.getPhone());
        userInfo.setEmail(user.getEmail());
        userInfo.setDeptId(user.getDeptId());
        userInfo.setPostId(user.getPostId());
        userInfo.setStatus(user.getStatus());
        userInfo.setCreateTime(user.getCreateTime());
        userInfo.setRoleIds(userRoleMapper.selectRoleIdsByUserId(user.getId()));
        return LoginVO.builder()
                .token(token)
                .userInfo(userInfo)
                .permissions(menuMapper.selectPermissionsByUserId(userId))
                .menuTree(menuService.userMenuTree(userId))
                .siteConfig(systemConfigService.getPublicConfig())
                .build();
    }
}
