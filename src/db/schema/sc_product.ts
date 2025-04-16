import { sql } from "drizzle-orm"; 
import { varchar, mysqlTable, timestamp, decimal, int, text } from "drizzle-orm/mysql-core"; 
import { CustomerTable } from "./sc_customers";
import { vendorsTable } from "./sc_vendor";

export const productTable = mysqlTable("product", { 
    id: int("product_id").notNull().primaryKey().autoincrement(), 
    namaProduk: varchar("nama_produk", { length: 100 }).notNull(), 
    reviewProduk: varchar("review_produk", { length: 255 }).notNull(), 
    warnaProduk: varchar("warna_produk", { length: 50 }).notNull(), 
    fotoProduk: varchar("foto_produk", { length: 255 }).notNull(), 
    deskripsiProduk: text("deskripsi_produk").notNull(), 
    harga: decimal("harga", { precision: 10, scale: 2}).notNull(),
    fkVendor: varchar("fkVendor", { length: 36 }).notNull().references(() => vendorsTable.vendorId),
    fkcategory: varchar("fkcategory", { length: 36 }).notNull().references(() => categoryTable.id), 
    created_at: timestamp("created_at").notNull().default(sql`CURRENT_TIMESTAMP`), 
    updated_at: timestamp("updated_at").notNull().default(sql`CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP`) 
}); 

export const categoryTable = mysqlTable("category", { 
    id: int("category_id").notNull().primaryKey().autoincrement(), 
    namaKategori: varchar("nama_kategori", { length: 100 }).notNull(),
    deskripsiKategori: varchar("deskripsi_kategori", { length: 255}).notNull(),
});

export const cartItemsTable = mysqlTable("cart_item", {
  cartItemId: int("cart_item_id").notNull().primaryKey().autoincrement(),
  customerId: int("customer_id")
    .notNull()
    .references(() => CustomerTable.id, { onDelete: "cascade" }),
  productId: int("product_id")
    .notNull()
    .references(() => productTable.id, { onDelete: "cascade" }),

  createdAt: timestamp("created_at").defaultNow().notNull(),
  updatedAt: timestamp("updated_at").defaultNow().onUpdateNow().notNull(),
});