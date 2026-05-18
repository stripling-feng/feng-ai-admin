CREATE TABLE IF NOT EXISTS `sys_dict_type` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `type_name` VARCHAR(100) NOT NULL,
  `type_code` VARCHAR(100) NOT NULL,
  `remark` VARCHAR(255) DEFAULT NULL,
  `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `create_user_id` BIGINT DEFAULT NULL,
  `update_user_id` BIGINT DEFAULT NULL,
  `deleted` TINYINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_dict_type_code_deleted` (`type_code`, `deleted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `sys_dict_data` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `type_id` BIGINT NOT NULL,
  `dict_label` VARCHAR(100) NOT NULL,
  `dict_value` VARCHAR(100) NOT NULL,
  `dict_sort` INT NOT NULL DEFAULT 0,
  `tag_type` VARCHAR(32) DEFAULT NULL,
  `css_class` VARCHAR(100) DEFAULT NULL,
  `remark` VARCHAR(255) DEFAULT NULL,
  `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `create_user_id` BIGINT DEFAULT NULL,
  `update_user_id` BIGINT DEFAULT NULL,
  `deleted` TINYINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_dict_type_value_deleted` (`type_id`, `dict_value`, `deleted`),
  KEY `idx_dict_type_sort` (`type_id`, `dict_sort`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `sys_dict_type` (`type_name`, `type_code`, `remark`, `deleted`)
SELECT '通用状态', 'sys_common_status', '系统内通用的启停状态', 0
FROM DUAL
WHERE NOT EXISTS (
  SELECT 1 FROM `sys_dict_type` WHERE `type_code` = 'sys_common_status' AND `deleted` = 0
);

INSERT INTO `sys_dict_type` (`type_name`, `type_code`, `remark`, `deleted`)
SELECT '用户性别', 'sys_user_gender', '用户资料中的性别字典', 0
FROM DUAL
WHERE NOT EXISTS (
  SELECT 1 FROM `sys_dict_type` WHERE `type_code` = 'sys_user_gender' AND `deleted` = 0
);

INSERT INTO `sys_dict_data` (`type_id`, `dict_label`, `dict_value`, `dict_sort`, `tag_type`, `remark`, `deleted`)
SELECT t.id, '启用', '1', 1, 'success', '启用状态', 0
FROM `sys_dict_type` t
WHERE t.`type_code` = 'sys_common_status'
  AND t.`deleted` = 0
  AND NOT EXISTS (
    SELECT 1 FROM `sys_dict_data` d
    WHERE d.`type_id` = t.`id` AND d.`dict_value` = '1' AND d.`deleted` = 0
  );

INSERT INTO `sys_dict_data` (`type_id`, `dict_label`, `dict_value`, `dict_sort`, `tag_type`, `remark`, `deleted`)
SELECT t.id, '停用', '0', 2, 'info', '停用状态', 0
FROM `sys_dict_type` t
WHERE t.`type_code` = 'sys_common_status'
  AND t.`deleted` = 0
  AND NOT EXISTS (
    SELECT 1 FROM `sys_dict_data` d
    WHERE d.`type_id` = t.`id` AND d.`dict_value` = '0' AND d.`deleted` = 0
  );

INSERT INTO `sys_dict_data` (`type_id`, `dict_label`, `dict_value`, `dict_sort`, `tag_type`, `remark`, `deleted`)
SELECT t.id, '男', '1', 1, 'primary', '男性', 0
FROM `sys_dict_type` t
WHERE t.`type_code` = 'sys_user_gender'
  AND t.`deleted` = 0
  AND NOT EXISTS (
    SELECT 1 FROM `sys_dict_data` d
    WHERE d.`type_id` = t.`id` AND d.`dict_value` = '1' AND d.`deleted` = 0
  );

INSERT INTO `sys_dict_data` (`type_id`, `dict_label`, `dict_value`, `dict_sort`, `tag_type`, `remark`, `deleted`)
SELECT t.id, '女', '2', 2, 'danger', '女性', 0
FROM `sys_dict_type` t
WHERE t.`type_code` = 'sys_user_gender'
  AND t.`deleted` = 0
  AND NOT EXISTS (
    SELECT 1 FROM `sys_dict_data` d
    WHERE d.`type_id` = t.`id` AND d.`dict_value` = '2' AND d.`deleted` = 0
  );

INSERT INTO `sys_menu` (`id`, `parent_id`, `menu_name`, `menu_type`, `path`, `component`, `permission`, `icon`, `menu_sort`, `visible`, `deleted`)
SELECT 91, 1, '字典管理', 1, 'system/dict', 'views/system/DictView.vue', 'system:dict:list', 'tickets', 5, 1, 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_menu` WHERE `id` = 91);

INSERT INTO `sys_menu` (`id`, `parent_id`, `menu_name`, `menu_type`, `path`, `component`, `permission`, `icon`, `menu_sort`, `visible`, `deleted`)
SELECT 92, 91, '字典新增', 2, '', '', 'system:dict:add', '', 1, 1, 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_menu` WHERE `id` = 92);

INSERT INTO `sys_menu` (`id`, `parent_id`, `menu_name`, `menu_type`, `path`, `component`, `permission`, `icon`, `menu_sort`, `visible`, `deleted`)
SELECT 93, 91, '字典编辑', 2, '', '', 'system:dict:edit', '', 2, 1, 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_menu` WHERE `id` = 93);

INSERT INTO `sys_menu` (`id`, `parent_id`, `menu_name`, `menu_type`, `path`, `component`, `permission`, `icon`, `menu_sort`, `visible`, `deleted`)
SELECT 94, 91, '字典删除', 2, '', '', 'system:dict:remove', '', 3, 1, 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_menu` WHERE `id` = 94);

INSERT INTO `sys_role_menu` (`role_id`, `menu_id`)
SELECT 1, 91 FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_role_menu` WHERE `role_id` = 1 AND `menu_id` = 91);

INSERT INTO `sys_role_menu` (`role_id`, `menu_id`)
SELECT 1, 92 FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_role_menu` WHERE `role_id` = 1 AND `menu_id` = 92);

INSERT INTO `sys_role_menu` (`role_id`, `menu_id`)
SELECT 1, 93 FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_role_menu` WHERE `role_id` = 1 AND `menu_id` = 93);

INSERT INTO `sys_role_menu` (`role_id`, `menu_id`)
SELECT 1, 94 FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_role_menu` WHERE `role_id` = 1 AND `menu_id` = 94);
