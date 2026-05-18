CREATE TABLE IF NOT EXISTS `sys_upload_file` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `original_name` VARCHAR(255) NOT NULL,
  `current_name` VARCHAR(255) NOT NULL,
  `file_size` BIGINT NOT NULL DEFAULT 0,
  `file_type` VARCHAR(128) DEFAULT NULL,
  `md5_value` VARCHAR(32) NOT NULL,
  `file_path` VARCHAR(500) NOT NULL,
  `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `create_user_id` BIGINT DEFAULT NULL,
  `update_user_id` BIGINT DEFAULT NULL,
  `deleted` TINYINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `idx_md5_value` (`md5_value`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='upload file';

INSERT INTO `sys_menu` (`id`, `parent_id`, `menu_name`, `menu_type`, `path`, `component`, `permission`, `icon`, `menu_sort`, `visible`, `deleted`)
SELECT 61, 1, '文件管理', 1, 'system/upload', 'views/system/UploadView.vue', 'system:upload:list', 'upload', 7, 1, 0
WHERE NOT EXISTS (SELECT 1 FROM `sys_menu` WHERE `id` = 61);

INSERT INTO `sys_menu` (`id`, `parent_id`, `menu_name`, `menu_type`, `path`, `component`, `permission`, `icon`, `menu_sort`, `visible`, `deleted`)
SELECT 62, 61, '文件上传', 2, '', '', 'system:upload:add', '', 1, 1, 0
WHERE NOT EXISTS (SELECT 1 FROM `sys_menu` WHERE `id` = 62);

INSERT INTO `sys_role_menu` (`role_id`, `menu_id`)
SELECT 1, 61
WHERE NOT EXISTS (SELECT 1 FROM `sys_role_menu` WHERE `role_id` = 1 AND `menu_id` = 61);

INSERT INTO `sys_role_menu` (`role_id`, `menu_id`)
SELECT 1, 62
WHERE NOT EXISTS (SELECT 1 FROM `sys_role_menu` WHERE `role_id` = 1 AND `menu_id` = 62);
