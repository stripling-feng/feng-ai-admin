package com.feng.system.security;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.feng.system.common.api.ApiResponse;
import com.feng.system.common.exception.BusinessException;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.JwtException;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.List;
import java.util.concurrent.TimeUnit;

@Component
@RequiredArgsConstructor
public class JwtAuthenticationFilter extends OncePerRequestFilter {

    private static final String AUTH_CACHE_PREFIX = "auth:login:";
    private static final long CACHE_TTL_MINUTES = 30;

    private final JwtTokenUtil jwtTokenUtil;
    private final UserSecurityService userSecurityService;
    private final StringRedisTemplate stringRedisTemplate;
    private final ObjectMapper objectMapper;

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
            throws ServletException, IOException {
        String token = resolveToken(request);
        if (StringUtils.hasText(token) && SecurityContextHolder.getContext().getAuthentication() == null) {
            try {
                Claims claims = jwtTokenUtil.parseClaims(token);
                Long userId = claims.get("userId", Long.class);
                LoginUser loginUser = loadUserFromCacheOrDb(userId);
                UsernamePasswordAuthenticationToken authenticationToken =
                        new UsernamePasswordAuthenticationToken(loginUser, null, loginUser.getAuthorities());
                SecurityContextHolder.getContext().setAuthentication(authenticationToken);
            } catch (AuthenticationException | JwtException | BusinessException ex) {
                SecurityContextHolder.clearContext();
                writeUnauthorized(response, ex.getMessage());
                return;
            }
        }
        filterChain.doFilter(request, response);
    }

    private LoginUser loadUserFromCacheOrDb(Long userId) {
        String cacheKey = AUTH_CACHE_PREFIX + userId;
        String cached = stringRedisTemplate.opsForValue().get(cacheKey);
        if (cached != null) {
            try {
                CachedUser cu = objectMapper.readValue(cached, CachedUser.class);
                return new LoginUser(cu.toUser(), cu.permissions());
            } catch (Exception ignored) {
            }
        }
        LoginUser loginUser = userSecurityService.loadByUserId(userId);
        try {
            CachedUser cu = new CachedUser(
                    loginUser.getUser().getId(),
                    loginUser.getUser().getUsername(),
                    loginUser.getUser().getStatus(),
                    loginUser.getPermissions()
            );
            stringRedisTemplate.opsForValue().set(cacheKey, objectMapper.writeValueAsString(cu), CACHE_TTL_MINUTES, TimeUnit.MINUTES);
        } catch (Exception ignored) {
        }
        return loginUser;
    }

    private String resolveToken(HttpServletRequest request) {
        String bearerToken = request.getHeader("Authorization");
        if (StringUtils.hasText(bearerToken) && bearerToken.startsWith("Bearer ")) {
            return bearerToken.substring(7);
        }
        return null;
    }

    private void writeUnauthorized(HttpServletResponse response, String message) throws IOException {
        response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");
        response.getWriter().write(objectMapper.writeValueAsString(ApiResponse.fail(message)));
    }

    private record CachedUser(Long id, String username, Integer status, List<String> permissions) {
        public com.feng.system.module.system.entity.SysUser toUser() {
            com.feng.system.module.system.entity.SysUser user = new com.feng.system.module.system.entity.SysUser();
            user.setId(id);
            user.setUsername(username);
            user.setStatus(status);
            return user;
        }
    }
}
