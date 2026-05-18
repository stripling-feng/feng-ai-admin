package com.feng.system.module.system.controller;

import com.feng.system.common.api.ApiResponse;
import com.feng.system.common.api.PageResult;
import com.feng.system.common.log.BusinessOperationType;
import com.feng.system.common.log.OperLog;
import com.feng.system.common.submit.PreventDuplicateSubmit;
import com.feng.system.module.system.dto.DictDataDTO;
import com.feng.system.module.system.dto.DictDataQueryDTO;
import com.feng.system.module.system.dto.DictTypeDTO;
import com.feng.system.module.system.dto.DictTypeQueryDTO;
import com.feng.system.module.system.entity.SysDictData;
import com.feng.system.module.system.entity.SysDictType;
import com.feng.system.module.system.service.DictService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/system/dicts")
@RequiredArgsConstructor
public class DictController {

    private final DictService dictService;

    @GetMapping("/types")
    @PreAuthorize("hasAuthority('system:dict:list')")
    public ApiResponse<PageResult<SysDictType>> typePage(DictTypeQueryDTO queryDTO) {
        return ApiResponse.success(dictService.typePage(queryDTO));
    }

    @PostMapping("/types")
    @PreAuthorize("hasAuthority('system:dict:add')")
    @PreventDuplicateSubmit
    @OperLog(name = "新增字典类型", type = BusinessOperationType.INSERT)
    public ApiResponse<Void> saveType(@Valid @RequestBody DictTypeDTO dto) {
        dictService.saveType(dto);
        return ApiResponse.success("新增成功", null);
    }

    @PutMapping("/types/{id}")
    @PreAuthorize("hasAuthority('system:dict:edit')")
    @PreventDuplicateSubmit
    @OperLog(name = "编辑字典类型", type = BusinessOperationType.UPDATE)
    public ApiResponse<Void> updateType(@PathVariable Long id, @Valid @RequestBody DictTypeDTO dto) {
        dto.setId(id);
        dictService.updateType(dto);
        return ApiResponse.success("修改成功", null);
    }

    @DeleteMapping("/types/{id}")
    @PreAuthorize("hasAuthority('system:dict:remove')")
    @PreventDuplicateSubmit
    @OperLog(name = "删除字典类型", type = BusinessOperationType.DELETE)
    public ApiResponse<Void> deleteType(@PathVariable Long id) {
        dictService.deleteType(id);
        return ApiResponse.success("删除成功", null);
    }

    @GetMapping("/data")
    @PreAuthorize("hasAuthority('system:dict:list')")
    public ApiResponse<PageResult<SysDictData>> dataPage(DictDataQueryDTO queryDTO) {
        return ApiResponse.success(dictService.dataPage(queryDTO));
    }

    @PostMapping("/data")
    @PreAuthorize("hasAuthority('system:dict:add')")
    @PreventDuplicateSubmit
    @OperLog(name = "新增字典数据", type = BusinessOperationType.INSERT)
    public ApiResponse<Void> saveData(@Valid @RequestBody DictDataDTO dto) {
        dictService.saveData(dto);
        return ApiResponse.success("新增成功", null);
    }

    @PutMapping("/data/{id}")
    @PreAuthorize("hasAuthority('system:dict:edit')")
    @PreventDuplicateSubmit
    @OperLog(name = "编辑字典数据", type = BusinessOperationType.UPDATE)
    public ApiResponse<Void> updateData(@PathVariable Long id, @Valid @RequestBody DictDataDTO dto) {
        dto.setId(id);
        dictService.updateData(dto);
        return ApiResponse.success("修改成功", null);
    }

    @DeleteMapping("/data/{id}")
    @PreAuthorize("hasAuthority('system:dict:remove')")
    @PreventDuplicateSubmit
    @OperLog(name = "删除字典数据", type = BusinessOperationType.DELETE)
    public ApiResponse<Void> deleteData(@PathVariable Long id) {
        dictService.deleteData(id);
        return ApiResponse.success("删除成功", null);
    }
}
