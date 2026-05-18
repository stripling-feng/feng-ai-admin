-- 行政区管理表
CREATE TABLE IF NOT EXISTS `sys_district` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `code` VARCHAR(20) NOT NULL COMMENT '行政区划编码',
  `name` VARCHAR(64) NOT NULL COMMENT '名称',
  `parent_code` VARCHAR(20) DEFAULT NULL COMMENT '父级编码',
  `level` TINYINT NOT NULL DEFAULT 1 COMMENT '层级: 1=省 2=市 3=区',
  `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_district_code` (`code`),
  KEY `idx_district_parent` (`parent_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='行政区划表';

-- 菜单
INSERT INTO `sys_menu` (`id`, `parent_id`, `menu_name`, `menu_type`, `path`, `component`, `permission`, `icon`, `menu_sort`, `visible`, `deleted`)
SELECT 100, 1, '行政区管理', 1, 'system/district', 'views/system/DistrictView.vue', 'system:district:list', 'location', 8, 1, 0
WHERE NOT EXISTS (SELECT 1 FROM `sys_menu` WHERE `id` = 100);

INSERT INTO `sys_menu` (`id`, `parent_id`, `menu_name`, `menu_type`, `path`, `component`, `permission`, `icon`, `menu_sort`, `visible`, `deleted`)
SELECT 101, 100, '行政区同步', 2, '', '', 'system:district:sync', '', 1, 1, 0
WHERE NOT EXISTS (SELECT 1 FROM `sys_menu` WHERE `id` = 101);

INSERT INTO `sys_menu` (`id`, `parent_id`, `menu_name`, `menu_type`, `path`, `component`, `permission`, `icon`, `menu_sort`, `visible`, `deleted`)
SELECT 102, 100, '行政区查看', 2, '', '', 'system:district:query', '', 2, 1, 0
WHERE NOT EXISTS (SELECT 1 FROM `sys_menu` WHERE `id` = 102);

-- 角色权限（超级管理员）
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`)
SELECT 1, 100 WHERE NOT EXISTS (SELECT 1 FROM `sys_role_menu` WHERE `role_id` = 1 AND `menu_id` = 100);

INSERT INTO `sys_role_menu` (`role_id`, `menu_id`)
SELECT 1, 101 WHERE NOT EXISTS (SELECT 1 FROM `sys_role_menu` WHERE `role_id` = 1 AND `menu_id` = 101);

INSERT INTO `sys_role_menu` (`role_id`, `menu_id`)
SELECT 1, 102 WHERE NOT EXISTS (SELECT 1 FROM `sys_role_menu` WHERE `role_id` = 1 AND `menu_id` = 102);
