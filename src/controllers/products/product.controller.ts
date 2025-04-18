import { Hono } from "hono";
import { asc, desc, eq, like } from "drizzle-orm";
import { productTable } from "../../db/schema/sc_product";
import { zValidator } from "@hono/zod-validator";
import { z } from "zod";
import { DBConnection } from "../../db/database/dbIndex";

export const router_product = new Hono();

router_product.get('/',
    zValidator('query', z.object({
        sort: z.enum(['asc', 'desc']).optional().default('asc'),
        offset: z.coerce.number().min(0).optional().default(0),
        limit: z.coerce.number().min(1).max(20).optional().default(10),
        search: z.string().optional().default(''),
    })),
    async (c) => {
        const { limit, sort, offset, search } = c.req.valid('query');

        try {
            const DB = await DBConnection();
            let query: any = DB.select().from(productTable);
            if (search) {
                query = query.where(like(productTable.namaProduk, `%${search}%`));
            }
            query = query.limit(limit).offset(offset).orderBy(
                    sort === 'asc' ? asc(productTable.created_at) : desc(productTable.created_at)
                );
            const results = await query;
            return c.json(results);
        } catch (err) {
            console.error('Error fetching products:', err);
            return c.json({ error: 'Internal Server Error' }, 500);
        }
    }
);



// router_product.post('/product',
//     zValidator('json',
//       z.object({
//         namaProduk: z.string().min(1, "Nama produk tidak boleh kosong"),
//         reviewProduk: z.string().max(255, "Review terlalu panjang"),
//         warnaProduk: z.string().min(1, "Warna produk tidak boleh kosong").max(50, "Warna produk terlalu panjang"),
//         fotoProduk: z.string()
//           .url("URL foto tidak valid")
//           .regex(/\.(jpg|jpeg|png|webp)$/i, "Foto harus berformat .jpg, .jpeg, .png, atau .webp"),
//         deskripsiProduk: z.string().min(1, "Deskripsi tidak boleh kosong"),
//         harga: z.coerce.number().positive("Harga harus lebih dari 0"),
//         fkcategory: z.coerce.number().int().positive("ID kategori tidak valid")
//       })
//     ),
//     async (c) => {
//       const {
//         namaProduk,
//         reviewProduk,
//         warnaProduk,
//         fotoProduk,
//         deskripsiProduk,
//         harga,
//         fkcategory
//       } = c.req.valid('json');

//       return DBConnection()
//         .then((db) => {
//           // 🔍 Cek apakah nama produk sudah ada
//           return db.select().from(productTable).where(eq(productTable.namaProduk, namaProduk))
//             .then((exist) => {
//               if (exist.length > 0) {
//                 throw { status: 409, message: "Produk dengan nama tersebut sudah ada" };
//               }
//               return db;
//             });
//         })
//         .then((db) => {
//           return db.select().from(categoryTable).where(eq(categoryTable.id, fkcategory))
//             .then((categories) => {
//               if (categories.length === 0) {
//                 throw { status: 400, message: "Kategori tidak ditemukan" };
//               }
//               return db;
//             });
//         })
//         .then((db) => {
//           return db.insert(productTable).values({
//             namaProduk,
//             reviewProduk,
//             warnaProduk,
//             fotoProduk,
//             deskripsiProduk,
//             harga,
//             fkcategory
//           }).then(() => db); 
//         })
//         .then((db) => {

//           return db.select().from(productTable).where(eq(productTable.namaProduk, namaProduk));
//         })
//         .then((data) => {
//           return c.json({ message: 'Produk berhasil dibuat', data: data[0] }, 201);
//         })
//         .catch((err) => {
//           console.error("Error insert product:", err);
//           const status = err.status || 500;
//           const message = err.message || 'Terjadi kesalahan pada server';
//           return c.json({ error: message }, status);
//         });
//     }
//   );


router_product.get('/:id',
    zValidator('param', z.object({
        id: z.coerce.number().min(1, "ID produk tidak valid")
    })),
    (c) => {
        const id = c.req.valid('param').id;
        return DBConnection()
            .then((db) => {
                return db.select().from(productTable).where(eq(productTable.id, id));
            })
            .then((produk) => {
                if (produk.length === 0) {
                    return c.json({ message: 'Produk tidak ditemukan' }, 404);
                }

                return c.json({ data: produk[0] });
            })
            .catch((error) => {
                console.error("Error ambil produk:", error);
                return c.json({ error: 'Terjadi kesalahan pada server' }, 500);
            });
    }
);

router_product.patch('/:id',
    zValidator('json',
        z.object({
            namaProduk: z.string().min(1, "Nama produk tidak boleh kosong"),
            reviewProduk: z.string().max(255, "Review terlalu panjang"),
            warnaProduk: z.string().min(1, "Warna produk tidak boleh kosong").max(50, "Warna produk terlalu panjang"),
            fotoProduk: z.string()
                .url("URL foto tidak valid")
                .regex(/\.(jpg|jpeg|png|webp)$/i, "Foto harus berformat .jpg, .jpeg, .png, atau .webp"),
            deskripsiProduk: z.string().min(1, "Deskripsi tidak boleh kosong"),
            harga: z.coerce.number().positive("Harga harus lebih dari 0"),
            fkcategory: z.coerce.number().int().positive("ID kategori tidak valid")
        })
    ),
    zValidator('param',
        z.object({
            id: z.coerce.number().min(1, 'ID tdk valid')
        })
    ),
    async (c) => {
        const id = Number(c.req.valid('param').id);
        const productUpdate = c.req.valid('json');
        const { harga, fkcategory, ...restProductUpdate } = productUpdate;
        const updatedProduct = {
            ...restProductUpdate,
            updated_at: new Date(),
            harga: harga.toString(),
            fkcategory: fkcategory.toString()
        };

        return DBConnection()
            .then(async (DBChange) => {
                const product = await DBChange.select().from(productTable)
                    .where(eq(productTable.id, id));
                if (product.length === 0) {
                    return c.json({ message: 'Produk tidak ada' }, 404);
                }
                await DBChange.update(productTable).set(updatedProduct)
                    .where(eq(productTable.id, id));
                const updatedProductResult = await DBChange.select().from(productTable)
                    .where(eq(productTable.id, id));
                return c.json({ message: 'Success update', data: updatedProductResult[0] });
            })
            .catch((err) => {
                console.error("Error update produk:", err);
                return c.json({ error: 'Terjadi kesalahan saat update produk' }, 500);
            });
    }
);

router_product.delete('/:id', async (c) => {
    const id = Number(c.req.param('id'));
    if (isNaN(id)) {
        return Promise.resolve(c.json({ error: 'Invalid ID' }, 400));
    }
    return DBConnection().then((db) => {
        return db.delete(productTable).where(eq(productTable.id, id))
            .then((result) => {
                return c.json({ message: `Product with ID ${id} deleted`, result });
            });
    }).catch((err) => {
        console.error(err);
        return c.json({ error: 'Internal Server Error' }, 500);
    });
});

export default router_product;
