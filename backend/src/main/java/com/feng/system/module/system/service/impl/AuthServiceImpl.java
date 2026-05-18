package com.feng.system.module.system.service.impl;

import com.feng.system.common.exception.BusinessException;
import com.feng.system.module.system.dto.ChangePasswordDTO;
import com.feng.system.module.system.dto.LoginDTO;
import com.feng.system.module.system.entity.SysUser;
import com.feng.system.module.system.mapper.SysUserMapper;
import com.feng.system.module.system.mapper.SysUserRoleMapper;
import com.feng.system.module.system.service.AuthService;
import com.feng.system.module.system.service.LoginAttemptService;
import com.feng.system.module.system.service.MenuService;
import com.feng.system.module.system.service.SystemConfigService;
import com.feng.system.module.system.vo.LoginVO;
import com.feng.system.module.system.vo.UserInfoVO;
import com.feng.system.security.JwtTokenUtil;
import com.feng.system.security.LoginUser;
import lombok.RequiredArgsConstructor;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.DisabledException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class AuthServiceImpl implements AuthService {

    private final AuthenticationManager authenticationManager;
    private final JwtTokenUtil jwtTokenUtil;
    private final SysUserRoleMapper userRoleMapper;
    private final SysUserMapper userMapper;
    private final MenuService menuService;
    private final LoginAttemptService loginAttemptService;
    private final SystemConfigService systemConfigService;
    private final PasswordEncoder passwordEncoder;
    private final StringRedisTemplate stringRedisTemplate;

    @Override
    public LoginVO login(LoginDTO dto) {
        loginAttemptService.checkLoginAllowed(dto.getUsername());
        UsernamePasswordAuthenticationToken authenticationToken =
                new UsernamePasswordAuthenticationToken(dto.getUsername(), dto.getPassword());
        try {
            LoginUser loginUser = (LoginUser) authenticationManager.authenticate(authenticationToken).getPrincipal();
            loginAttemptService.recordLoginSuccess(dto.getUsername());
            return buildLoginVO(loginUser, jwtTokenUtil.generateToken(loginUser.getUser().getId(), loginUser.getUsername()));
        } catch (DisabledException ex) {
            throw new BusinessException("账号已停用，无法登录");
        } catch (BadCredentialsException ex) {
            loginAttemptService.recordLoginFailure(dto.getUsername());
            throw new BusinessException("账号或密码错误");
        }
    }

    @Override
    public LoginVO current() {
        LoginUser loginUser = getLoginUser();
        return buildLoginVO(loginUser, null);
    }

    @Override
    public void changePassword(ChangePasswordDTO dto) {
        if (!dto.getNewPassword().equals(dto.getConfirmPassword())) {
            throw new BusinessException("两次输入的新密码不一致");
        }
        if (dto.getNewPassword().trim().length() < 6) {
            throw new BusinessException("新密码长度不能少于6位");
        }
        LoginUser loginUser = getLoginUser();
        SysUser user = userMapper.selectById(loginUser.getUser().getId());
        if (user == null) {
            throw new BusinessException("当前用户不存在");
        }
        if (!passwordEncoder.matches(dto.getOldPassword(), user.getPassword())) {
            throw new BusinessException("旧密码错误");
        }
        user.setPassword(passwordEncoder.encode(dto.getNewPassword()));
        userMapper.updateById(user);
        evictAuthCache(user.getId());
    }

    private void evictAuthCache(Long userId) {
        stringRedisTemplate.delete("auth:login:" + userId);
    }

    private LoginVO buildLoginVO(LoginUser loginUser, String token) {
        SysUser user = userMapper.selectById(loginUser.getUser().getId());
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
                .permissions(loginUser.getPermissions())
                .menuTree(menuService.userMenuTree(user.getId()))
                .siteConfig(systemConfigService.getPublicConfig())
                .build();
    }

    private LoginUser getLoginUser() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        return (LoginUser) authentication.getPrincipal();
    }
}
