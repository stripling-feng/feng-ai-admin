CREATE TABLE IF NOT EXISTS `sys_config` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `config_key` VARCHAR(64) NOT NULL,
  `config_name` VARCHAR(64) NOT NULL,
  `config_value` VARCHAR(1000) NOT NULL,
  `config_group` VARCHAR(32) NOT NULL,
  `remark` VARCHAR(255) DEFAULT NULL,
  `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `create_user_id` BIGINT DEFAULT NULL,
  `update_user_id` BIGINT DEFAULT NULL,
  `deleted` TINYINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_config_key` (`config_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `sys_job_task` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `task_name` VARCHAR(64) NOT NULL,
  `task_group` VARCHAR(64) NOT NULL DEFAULT 'DEFAULT',
  `cron_expression` VARCHAR(128) NOT NULL,
  `class_name` VARCHAR(255) DEFAULT NULL,
  `method_name` VARCHAR(128) DEFAULT NULL,
  `method_param` VARCHAR(1000) DEFAULT NULL,
  `handler_key` VARCHAR(64) DEFAULT NULL,
  `handler_param` VARCHAR(1000) DEFAULT NULL,
  `status` TINYINT NOT NULL DEFAULT 1,
  `remark` VARCHAR(255) DEFAULT NULL,
  `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `create_user_id` BIGINT DEFAULT NULL,
  `update_user_id` BIGINT DEFAULT NULL,
  `deleted` TINYINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_task_name_group` (`task_name`, `task_group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE `sys_job_task` ADD COLUMN IF NOT EXISTS `class_name` VARCHAR(255) DEFAULT NULL AFTER `cron_expression`;
ALTER TABLE `sys_job_task` ADD COLUMN IF NOT EXISTS `method_name` VARCHAR(128) DEFAULT NULL AFTER `class_name`;
ALTER TABLE `sys_job_task` ADD COLUMN IF NOT EXISTS `method_param` VARCHAR(1000) DEFAULT NULL AFTER `method_name`;
ALTER TABLE `sys_job_task` MODIFY COLUMN `handler_key` VARCHAR(64) DEFAULT NULL;

CREATE TABLE IF NOT EXISTS `sys_job_task_log` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `task_id` BIGINT NOT NULL,
  `task_name` VARCHAR(64) NOT NULL,
  `task_group` VARCHAR(64) NOT NULL,
  `class_name` VARCHAR(255) DEFAULT NULL,
  `method_name` VARCHAR(128) DEFAULT NULL,
  `method_param` VARCHAR(1000) DEFAULT NULL,
  `execute_status` TINYINT NOT NULL,
  `execute_result` VARCHAR(2000) DEFAULT NULL,
  `error_message` VARCHAR(2000) DEFAULT NULL,
  `start_time` DATETIME NOT NULL,
  `end_time` DATETIME NOT NULL,
  `duration_ms` BIGINT NOT NULL DEFAULT 0,
  `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `create_user_id` BIGINT DEFAULT NULL,
  `update_user_id` BIGINT DEFAULT NULL,
  `deleted` TINYINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `idx_task_status_time` (`task_id`, `execute_status`, `create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `sys_config` (`config_key`, `config_name`, `config_value`, `config_group`, `remark`, `deleted`)
VALUES
('site.name', '网站名称', 'Feng AI Admin', 'site', '系统站点全称', 0),
('site.short-name', '网站简称', 'FA', 'site', '侧边栏和品牌简称', 0),
('site.copyright', '版权信息', '© 2026 Feng AI Admin. All rights reserved.', 'site', '登录页和系统版权', 0),
('security.default-password', '默认密码', 'admin123', 'security', '新建用户和重置密码时使用', 0),
('security.login-fail-max-attempts', '登录失败限制次数', '5', 'security', '超出后触发锁定', 0),
('security.login-fail-window-minutes', '登录失败统计时间', '5', 'security', '失败次数统计窗口', 0),
('security.login-fail-lock-minutes', '登录锁定时间', '5', 'security', '达到阈值后的锁定时长', 0),
('upload.provider', '上传存储方式', 'server', 'upload', 'server/minio/aliyun-oss', 0),
('upload.server.base-path', '服务端存储目录', 'uploads', 'upload', '相对后端工作目录的存储路径', 0),
('upload.server.base-url', '服务端访问前缀', '', 'upload', '本地文件访问前缀', 0),
('upload.oss.endpoint', '阿里云 OSS Endpoint', '', 'upload', '例如 oss-cn-hangzhou.aliyuncs.com', 0),
('upload.oss.bucket', '阿里云 OSS Bucket', '', 'upload', '阿里云 OSS 存储桶名称', 0),
('upload.oss.access-key-id', '阿里云 OSS AccessKeyId', '', 'upload', '阿里云访问密钥 ID', 0),
('upload.oss.access-key-secret', '阿里云 OSS AccessKeySecret', '', 'upload', '阿里云访问密钥 Secret', 0),
('upload.oss.domain', '阿里云 OSS 自定义域名', '', 'upload', '可选', 0),
('upload.minio.endpoint', 'MinIO Endpoint', '', 'upload', '例如 http://127.0.0.1:9000', 0),
('upload.minio.bucket', 'MinIO Bucket', '', 'upload', 'MinIO 存储桶名称', 0),
('upload.minio.access-key', 'MinIO AccessKey', '', 'upload', 'MinIO 访问账号', 0),
('upload.minio.secret-key', 'MinIO SecretKey', '', 'upload', 'MinIO 访问密钥', 0),
('upload.minio.domain', 'MinIO 自定义域名', '', 'upload', '可选', 0)
ON DUPLICATE KEY UPDATE
`config_name` = VALUES(`config_name`),
`config_group` = VALUES(`config_group`),
`remark` = VALUES(`remark`);

INSERT INTO `sys_menu` (`id`, `parent_id`, `menu_name`, `menu_type`, `path`, `component`, `permission`, `icon`, `menu_sort`, `visible`, `deleted`)
SELECT 63, 1, '系统配置', 1, 'system/config', 'views/system/SystemConfigView.vue', 'system:config:list', 'setting', 7, 1, 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_menu` WHERE `id` = 63);

INSERT INTO `sys_menu` (`id`, `parent_id`, `menu_name`, `menu_type`, `path`, `component`, `permission`, `icon`, `menu_sort`, `visible`, `deleted`)
SELECT 64, 63, '系统配置编辑', 2, '', '', 'system:config:edit', '', 1, 1, 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_menu` WHERE `id` = 64);

INSERT INTO `sys_menu` (`id`, `parent_id`, `menu_name`, `menu_type`, `path`, `component`, `permission`, `icon`, `menu_sort`, `visible`, `deleted`)
SELECT 71, 2, '定时任务管理', 1, 'tool/job', 'views/tool/JobTaskView.vue', 'tool:job:list', 'clock', 2, 1, 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_menu` WHERE `id` = 71);

INSERT INTO `sys_menu` (`id`, `parent_id`, `menu_name`, `menu_type`, `path`, `component`, `permission`, `icon`, `menu_sort`, `visible`, `deleted`)
SELECT 72, 71, '定时任务新增', 2, '', '', 'tool:job:add', '', 1, 1, 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_menu` WHERE `id` = 72);

INSERT INTO `sys_menu` (`id`, `parent_id`, `menu_name`, `menu_type`, `path`, `component`, `permission`, `icon`, `menu_sort`, `visible`, `deleted`)
SELECT 73, 71, '定时任务编辑', 2, '', '', 'tool:job:edit', '', 2, 1, 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_menu` WHERE `id` = 73);

INSERT INTO `sys_menu` (`id`, `parent_id`, `menu_name`, `menu_type`, `path`, `component`, `permission`, `icon`, `menu_sort`, `visible`, `deleted`)
SELECT 74, 71, '定时任务删除', 2, '', '', 'tool:job:remove', '', 3, 1, 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_menu` WHERE `id` = 74);

INSERT INTO `sys_menu` (`id`, `parent_id`, `menu_name`, `menu_type`, `path`, `component`, `permission`, `icon`, `menu_sort`, `visible`, `deleted`)
SELECT 75, 71, '定时任务暂停', 2, '', '', 'tool:job:pause', '', 4, 1, 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_menu` WHERE `id` = 75);

INSERT INTO `sys_menu` (`id`, `parent_id`, `menu_name`, `menu_type`, `path`, `component`, `permission`, `icon`, `menu_sort`, `visible`, `deleted`)
SELECT 76, 71, '定时任务执行', 2, '', '', 'tool:job:run', '', 5, 1, 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_menu` WHERE `id` = 76);

INSERT INTO `sys_role_menu` (`role_id`, `menu_id`)
SELECT 1, 63 FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_role_menu` WHERE `role_id` = 1 AND `menu_id` = 63);

INSERT INTO `sys_role_menu` (`role_id`, `menu_id`)
SELECT 1, 64 FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_role_menu` WHERE `role_id` = 1 AND `menu_id` = 64);

INSERT INTO `sys_role_menu` (`role_id`, `menu_id`)
SELECT 1, 71 FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_role_menu` WHERE `role_id` = 1 AND `menu_id` = 71);

INSERT INTO `sys_role_menu` (`role_id`, `menu_id`)
SELECT 1, 72 FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_role_menu` WHERE `role_id` = 1 AND `menu_id` = 72);

INSERT INTO `sys_role_menu` (`role_id`, `menu_id`)
SELECT 1, 73 FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_role_menu` WHERE `role_id` = 1 AND `menu_id` = 73);

INSERT INTO `sys_role_menu` (`role_id`, `menu_id`)
SELECT 1, 74 FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_role_menu` WHERE `role_id` = 1 AND `menu_id` = 74);

INSERT INTO `sys_role_menu` (`role_id`, `menu_id`)
SELECT 1, 75 FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_role_menu` WHERE `role_id` = 1 AND `menu_id` = 75);

INSERT INTO `sys_role_menu` (`role_id`, `menu_id`)
SELECT 1, 76 FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_role_menu` WHERE `role_id` = 1 AND `menu_id` = 76);
