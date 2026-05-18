ALTER TABLE `sys_dept` ADD COLUMN IF NOT EXISTS `create_user_id` BIGINT DEFAULT NULL AFTER `update_time`;
ALTER TABLE `sys_dept` ADD COLUMN IF NOT EXISTS `update_user_id` BIGINT DEFAULT NULL AFTER `create_user_id`;

ALTER TABLE `sys_post` ADD COLUMN IF NOT EXISTS `create_user_id` BIGINT DEFAULT NULL AFTER `update_time`;
ALTER TABLE `sys_post` ADD COLUMN IF NOT EXISTS `update_user_id` BIGINT DEFAULT NULL AFTER `create_user_id`;

ALTER TABLE `sys_role` ADD COLUMN IF NOT EXISTS `create_user_id` BIGINT DEFAULT NULL AFTER `update_time`;
ALTER TABLE `sys_role` ADD COLUMN IF NOT EXISTS `update_user_id` BIGINT DEFAULT NULL AFTER `create_user_id`;

ALTER TABLE `sys_user` ADD COLUMN IF NOT EXISTS `create_user_id` BIGINT DEFAULT NULL AFTER `update_time`;
ALTER TABLE `sys_user` ADD COLUMN IF NOT EXISTS `update_user_id` BIGINT DEFAULT NULL AFTER `create_user_id`;

ALTER TABLE `sys_menu` ADD COLUMN IF NOT EXISTS `create_user_id` BIGINT DEFAULT NULL AFTER `update_time`;
ALTER TABLE `sys_menu` ADD COLUMN IF NOT EXISTS `update_user_id` BIGINT DEFAULT NULL AFTER `create_user_id`;

ALTER TABLE `sys_config` ADD COLUMN IF NOT EXISTS `create_user_id` BIGINT DEFAULT NULL AFTER `update_time`;
ALTER TABLE `sys_config` ADD COLUMN IF NOT EXISTS `update_user_id` BIGINT DEFAULT NULL AFTER `create_user_id`;

ALTER TABLE `sys_dict_type` ADD COLUMN IF NOT EXISTS `create_user_id` BIGINT DEFAULT NULL AFTER `update_time`;
ALTER TABLE `sys_dict_type` ADD COLUMN IF NOT EXISTS `update_user_id` BIGINT DEFAULT NULL AFTER `create_user_id`;

ALTER TABLE `sys_dict_data` ADD COLUMN IF NOT EXISTS `create_user_id` BIGINT DEFAULT NULL AFTER `update_time`;
ALTER TABLE `sys_dict_data` ADD COLUMN IF NOT EXISTS `update_user_id` BIGINT DEFAULT NULL AFTER `create_user_id`;

ALTER TABLE `sys_upload_file` ADD COLUMN IF NOT EXISTS `create_user_id` BIGINT DEFAULT NULL AFTER `update_time`;
ALTER TABLE `sys_upload_file` ADD COLUMN IF NOT EXISTS `update_user_id` BIGINT DEFAULT NULL AFTER `create_user_id`;

ALTER TABLE `sys_job_task` ADD COLUMN IF NOT EXISTS `create_user_id` BIGINT DEFAULT NULL AFTER `update_time`;
ALTER TABLE `sys_job_task` ADD COLUMN IF NOT EXISTS `update_user_id` BIGINT DEFAULT NULL AFTER `create_user_id`;

ALTER TABLE `sys_job_task_log` ADD COLUMN IF NOT EXISTS `create_user_id` BIGINT DEFAULT NULL AFTER `update_time`;
ALTER TABLE `sys_job_task_log` ADD COLUMN IF NOT EXISTS `update_user_id` BIGINT DEFAULT NULL AFTER `create_user_id`;
