CREATE TABLE `tb_users` (
	`id` varchar(36) NOT NULL DEFAULT UUID(),
	`nama_depan` varchar(100),
	`nama_belakang` varchar(100),
	`fullname` varchar(255) NOT NULL,
	`email` varchar(255) NOT NULL,
	`password` varchar(255) NOT NULL,
	`create_at` timestamp NOT NULL DEFAULT (now()),
	`update_at` timestamp NOT NULL DEFAULT (now()) ON UPDATE CURRENT_TIMESTAMP,
	`last_login_at` timestamp,
	CONSTRAINT `tb_users_id` PRIMARY KEY(`id`),
	CONSTRAINT `tb_users_email_unique` UNIQUE(`email`)
);
