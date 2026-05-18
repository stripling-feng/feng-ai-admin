CREATE DATABASE IF NOT EXISTS `feng-ai-admin` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE `feng-ai-admin`;

DROP TABLE IF EXISTS `sys_role_menu`;
DROP TABLE IF EXISTS `sys_user_role`;
DROP TABLE IF EXISTS `sys_oper_log`;
DROP TABLE IF EXISTS `sys_menu`;
DROP TABLE IF EXISTS `sys_user`;
DROP TABLE IF EXISTS `sys_role`;
DROP TABLE IF EXISTS `sys_post`;
DROP TABLE IF EXISTS `sys_dept`;

CREATE TABLE `sys_dept` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `parent_id` BIGINT NOT NULL DEFAULT 0,
  `dept_name` VARCHAR(64) NOT NULL,
  `dept_sort` INT NOT NULL DEFAULT 0,
  `leader` VARCHAR(64) DEFAULT NULL,
  `phone` VARCHAR(32) DEFAULT NULL,
  `email` VARCHAR(128) DEFAULT NULL,
  `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `create_user_id` BIGINT DEFAULT NULL,
  `update_user_id` BIGINT DEFAULT NULL,
  `deleted` TINYINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `sys_post` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `post_code` VARCHAR(64) NOT NULL,
  `post_name` VARCHAR(64) NOT NULL,
  `post_sort` INT NOT NULL DEFAULT 0,
  `remark` VARCHAR(255) DEFAULT NULL,
  `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `create_user_id` BIGINT DEFAULT NULL,
  `update_user_id` BIGINT DEFAULT NULL,
  `deleted` TINYINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `sys_role` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `role_name` VARCHAR(64) NOT NULL,
  `role_key` VARCHAR(64) NOT NULL,
  `role_sort` INT NOT NULL DEFAULT 0,
  `remark` VARCHAR(255) DEFAULT NULL,
  `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `create_user_id` BIGINT DEFAULT NULL,
  `update_user_id` BIGINT DEFAULT NULL,
  `deleted` TINYINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_role_key` (`role_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `sys_user` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `username` VARCHAR(64) NOT NULL,
  `password` VARCHAR(255) NOT NULL,
  `nickname` VARCHAR(64) NOT NULL,
  `phone` VARCHAR(32) DEFAULT NULL,
  `email` VARCHAR(128) DEFAULT NULL,
  `dept_id` BIGINT NOT NULL,
  `post_id` BIGINT NOT NULL,
  `status` TINYINT NOT NULL DEFAULT 1,
  `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `create_user_id` BIGINT DEFAULT NULL,
  `update_user_id` BIGINT DEFAULT NULL,
  `deleted` TINYINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `sys_menu` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `parent_id` BIGINT NOT NULL DEFAULT 0,
  `menu_name` VARCHAR(64) NOT NULL,
  `menu_type` TINYINT NOT NULL,
  `path` VARCHAR(128) DEFAULT NULL,
  `component` VARCHAR(128) DEFAULT NULL,
  `permission` VARCHAR(128) DEFAULT NULL,
  `icon` VARCHAR(64) DEFAULT NULL,
  `menu_sort` INT NOT NULL DEFAULT 0,
  `visible` TINYINT NOT NULL DEFAULT 1,
  `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `create_user_id` BIGINT DEFAULT NULL,
  `update_user_id` BIGINT DEFAULT NULL,
  `deleted` TINYINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `sys_user_role` (
  `user_id` BIGINT NOT NULL,
  `role_id` BIGINT NOT NULL,
  PRIMARY KEY (`user_id`, `role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `sys_role_menu` (
  `role_id` BIGINT NOT NULL,
  `menu_id` BIGINT NOT NULL,
  PRIMARY KEY (`role_id`, `menu_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `sys_oper_log` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `api_name` VARCHAR(128) NOT NULL,
  `business_type` VARCHAR(32) NOT NULL,
  `method_name` VARCHAR(255) DEFAULT NULL,
  `request_uri` VARCHAR(255) DEFAULT NULL,
  `operator_id` BIGINT DEFAULT NULL,
  `operator_name` VARCHAR(64) DEFAULT NULL,
  `ip_address` VARCHAR(64) DEFAULT NULL,
  `success` TINYINT NOT NULL DEFAULT 1,
  `error_message` VARCHAR(500) DEFAULT NULL,
  `after_data` LONGTEXT,
  `operation_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_api_name_time` (`api_name`, `operation_time`),
  KEY `idx_operator_time` (`operator_id`, `operation_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `sys_dept` (`id`, `parent_id`, `dept_name`, `dept_sort`, `leader`, `phone`, `email`, `deleted`) VALUES
(1, 0, '总公司', 1, '管理员', '13800000000', 'admin@feng.com', 0),
(2, 1, '研发部', 1, '研发经理', '13800000001', 'rd@feng.com', 0),
(3, 1, '运营部', 2, '运营经理', '13800000002', 'ops@feng.com', 0);

INSERT INTO `sys_post` (`id`, `post_code`, `post_name`, `post_sort`, `remark`, `deleted`) VALUES
(1, 'ceo', '总经理', 1, '负责公司整体管理', 0),
(2, 'dev_mgr', '研发经理', 2, '负责研发团队管理', 0),
(3, 'operator', '运营专员', 3, '负责日常运营工作', 0);

INSERT INTO `sys_role` (`id`, `role_name`, `role_key`, `role_sort`, `remark`, `deleted`) VALUES
(1, '超级管理员', 'admin', 1, '拥有系统全部权限', 0),
(2, '运营人员', 'operator', 2, '面向日常运营使用', 0);

INSERT INTO `sys_user` (`id`, `username`, `password`, `nickname`, `phone`, `email`, `dept_id`, `post_id`, `status`, `deleted`) VALUES
(1, 'admin', '{noop}admin123', '管理员', '13800000000', 'admin@feng.com', 1, 1, 1, 0),
(2, 'operator', '{noop}admin123', '运营同学', '13800000003', 'operator@feng.com', 3, 3, 1, 0);

INSERT INTO `sys_menu` (`id`, `parent_id`, `menu_name`, `menu_type`, `path`, `component`, `permission`, `icon`, `menu_sort`, `visible`, `deleted`) VALUES
(1, 0, '系统管理', 0, 'system', 'Layout', '', 'setting', 1, 1, 0),
(2, 0, '工具管理', 0, 'tool', 'Layout', '', 'tools', 2, 1, 0),
(10, 1, '用户管理', 1, 'system/user', 'views/system/UserView.vue', 'system:user:list', 'user', 1, 1, 0),
(11, 10, '用户查询', 2, '', '', 'system:user:query', '', 1, 1, 0),
(12, 10, '用户新增', 2, '', '', 'system:user:add', '', 2, 1, 0),
(13, 10, '用户编辑', 2, '', '', 'system:user:edit', '', 3, 1, 0),
(14, 10, '用户删除', 2, '', '', 'system:user:remove', '', 4, 1, 0),
(20, 1, '角色管理', 1, 'system/role', 'views/system/RoleView.vue', 'system:role:list', 'peoples', 2, 1, 0),
(21, 20, '角色查询', 2, '', '', 'system:role:query', '', 1, 1, 0),
(22, 20, '角色新增', 2, '', '', 'system:role:add', '', 2, 1, 0),
(23, 20, '角色编辑', 2, '', '', 'system:role:edit', '', 3, 1, 0),
(24, 20, '角色删除', 2, '', '', 'system:role:remove', '', 4, 1, 0),
(30, 1, '岗位管理', 1, 'system/post', 'views/system/PostView.vue', 'system:post:list', 'postcard', 3, 1, 0),
(31, 30, '岗位新增', 2, '', '', 'system:post:add', '', 1, 1, 0),
(32, 30, '岗位编辑', 2, '', '', 'system:post:edit', '', 2, 1, 0),
(33, 30, '岗位删除', 2, '', '', 'system:post:remove', '', 3, 1, 0),
(40, 1, '部门管理', 1, 'system/dept', 'views/system/DeptView.vue', 'system:dept:list', 'office-building', 4, 1, 0),
(41, 40, '部门新增', 2, '', '', 'system:dept:add', '', 1, 1, 0),
(42, 40, '部门编辑', 2, '', '', 'system:dept:edit', '', 2, 1, 0),
(43, 40, '部门删除', 2, '', '', 'system:dept:remove', '', 3, 1, 0),
(50, 1, '菜单管理', 1, 'system/menu', 'views/system/MenuView.vue', 'system:menu:list', 'menu', 5, 1, 0),
(51, 50, '菜单新增', 2, '', '', 'system:menu:add', '', 1, 1, 0),
(52, 50, '菜单编辑', 2, '', '', 'system:menu:edit', '', 2, 1, 0),
(53, 50, '菜单删除', 2, '', '', 'system:menu:remove', '', 3, 1, 0),
(60, 1, '操作日志', 1, 'system/log', 'views/system/OperLogView.vue', 'system:log:list', 'document', 6, 1, 0),
(70, 2, '接口文档', 1, 'tool/doc', 'views/tool/ApiDocView.vue', 'tool:doc:view', 'document', 1, 1, 0);

INSERT INTO `sys_user_role` (`user_id`, `role_id`) VALUES
(1, 1),
(2, 2);

INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES
(1, 1),(1, 10),(1, 11),(1, 12),(1, 13),(1, 14),
(1, 20),(1, 21),(1, 22),(1, 23),(1, 24),
(1, 30),(1, 31),(1, 32),(1, 33),
(1, 40),(1, 41),(1, 42),(1, 43),
(1, 50),(1, 51),(1, 52),(1, 53),
(1, 60),
(1, 2),(1, 70),
(2, 1),(2, 30),(2, 40);
