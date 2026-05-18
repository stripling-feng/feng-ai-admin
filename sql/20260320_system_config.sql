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

INSERT INTO `sys_config` (`config_key`, `config_name`, `config_value`, `config_group`, `remark`, `deleted`) VALUES
('site.name', '网站名称', 'Feng AI Admin', 'site', '系统站点全称', 0),
('site.short-name', '网站简称', 'FA', 'site', '侧边栏和品牌简称', 0),
('site.copyright', '版权信息', '© 2026 Feng AI Admin. All rights reserved.', 'site', '登录页和系统版权', 0),
('security.default-password', '默认密码', 'admin123', 'security', '新建用户和重置密码时使用', 0),
('security.login-fail-max-attempts', '登录失败限制次数', '5', 'security', '超出后触发锁定', 0),
('security.login-fail-window-minutes', '登录失败统计时间', '5', 'security', '失败次数统计窗口', 0),
('security.login-fail-lock-minutes', '登录锁定时间', '5', 'security', '达到阈值后的锁定时长', 0),
('login.welcome-title', '登录页欢迎标题', '更像产品，不只是一页后台', 'login', '登录页大标题', 0),
('login.welcome-description', '登录页欢迎文案', '面向企业管理系统的快速开发脚手架，内置权限体系、组织架构和基础管理模块。', 'login', '登录页说明文案', 0)
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

INSERT INTO `sys_role_menu` (`role_id`, `menu_id`)
SELECT 1, 63 FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_role_menu` WHERE `role_id` = 1 AND `menu_id` = 63);

INSERT INTO `sys_role_menu` (`role_id`, `menu_id`)
SELECT 1, 64 FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_role_menu` WHERE `role_id` = 1 AND `menu_id` = 64);
