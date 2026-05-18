package com.feng.system.module.system.controller;

import com.feng.system.common.api.ApiResponse;
import com.feng.system.common.api.PageResult;
import com.feng.system.common.log.BusinessOperationType;
import com.feng.system.common.log.OperLog;
import com.feng.system.common.submit.PreventDuplicateSubmit;
import com.feng.system.module.system.dto.ResetPasswordBatchDTO;
import com.feng.system.module.system.dto.UserDTO;
import com.feng.system.module.system.dto.UserQueryDTO;
import com.feng.system.module.system.service.UserService;
import com.feng.system.module.system.vo.UserInfoVO;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/system/users")
@RequiredArgsConstructor
public class UserController {

    private final UserService userService;

    @GetMapping
    @PreAuthorize("hasAuthority('system:user:list')")
    public ApiResponse<PageResult<UserInfoVO>> list(UserQueryDTO queryDTO) {
        return ApiResponse.success(userService.page(queryDTO));
    }

    @GetMapping("/{id}")
    @PreAuthorize("hasAuthority('system:user:query')")
    public ApiResponse<UserInfoVO> detail(@PathVariable Long id) {
        return ApiResponse.success(userService.detail(id));
    }

    @PostMapping
    @PreAuthorize("hasAuthority('system:user:add')")
    @PreventDuplicateSubmit
    @OperLog(name = "新增用户", type = BusinessOperationType.INSERT)
    public ApiResponse<Void> save(@Valid @RequestBody UserDTO dto) {
        userService.save(dto);
        return ApiResponse.success("新增成功", null);
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasAuthority('system:user:edit')")
    @PreventDuplicateSubmit
    @OperLog(name = "编辑用户", type = BusinessOperationType.UPDATE)
    public ApiResponse<Void> update(@PathVariable Long id, @Valid @RequestBody UserDTO dto) {
        dto.setId(id);
        userService.update(dto);
        return ApiResponse.success("修改成功", null);
    }

    @PutMapping("/{id}/reset-password")
    @PreAuthorize("hasAuthority('system:user:edit')")
    @PreventDuplicateSubmit
    @OperLog(name = "重置用户密码", type = BusinessOperationType.UPDATE)
    public ApiResponse<Void> resetPassword(@PathVariable Long id, @RequestBody(required = false) String password) {
        userService.resetPassword(id, password);
        return ApiResponse.success("重置密码成功", null);
    }

    @PutMapping("/batch-reset-password")
    @PreAuthorize("hasAuthority('system:user:edit')")
    @PreventDuplicateSubmit
    @OperLog(name = "批量重置用户密码", type = BusinessOperationType.UPDATE)
    public ApiResponse<Void> batchResetPassword(@RequestBody ResetPasswordBatchDTO dto) {
        userService.batchResetPassword(dto.getIds(), dto.getPassword());
        return ApiResponse.success("批量重置密码成功", null);
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasAuthority('system:user:remove')")
    @PreventDuplicateSubmit
    @OperLog(name = "删除用户", type = BusinessOperationType.DELETE)
    public ApiResponse<Void> delete(@PathVariable Long id) {
        userService.delete(id);
        return ApiResponse.success("删除成功", null);
    }
}
