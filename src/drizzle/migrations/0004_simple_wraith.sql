ALTER TABLE `tb_users_default` MODIFY COLUMN `delete_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP;--> statement-breakpoint
ALTER TABLE `users_secure` MODIFY COLUMN `deleted_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP;--> statement-breakpoint
ALTER TABLE `users` MODIFY COLUMN `deleted_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP;--> statement-breakpoint
ALTER TABLE `activities` ADD `deleted_at` timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL;--> statement-breakpoint
ALTER TABLE `contacts` ADD `deleted_at` timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL;