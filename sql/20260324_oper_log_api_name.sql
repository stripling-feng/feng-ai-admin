ALTER TABLE `sys_oper_log` CHANGE COLUMN `module` `api_name` VARCHAR(128) NOT NULL;
ALTER TABLE `sys_oper_log` DROP INDEX `idx_module_time`;
ALTER TABLE `sys_oper_log` ADD INDEX `idx_api_name_time` (`api_name`, `operation_time`);