ALTER TABLE `cart_item` MODIFY COLUMN `deleted_at` timestamp NOT NULL;--> statement-breakpoint
ALTER TABLE `tb_users_default` MODIFY COLUMN `delete_at` timestamp NOT NULL;--> statement-breakpoint
ALTER TABLE `users_secure` MODIFY COLUMN `deleted_at` timestamp NOT NULL;--> statement-breakpoint
ALTER TABLE `users` MODIFY COLUMN `deleted_at` timestamp NOT NULL;