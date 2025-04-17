import { categoryTable } from "../../db/schema/sc_product";
import { zValidator } from "@hono/zod-validator";
import { z } from "zod";
import { DBConnection } from "../../db/database/dbIndex";
import { Hono } from "hono";
import { asc, desc, eq, and } from 'drizzle-orm';

export const router_category_product = new Hono()

router_category_product.get(
  '/',
  zValidator(
    'query',
    z.object({
      namaKategori: z.string(),
      deskripsiKategori: z.string(),
      sort: z.enum(['asc', 'desc']).optional().default('asc'),
      search: z.string().optional(),
    })
  ),
  async (c) => {
    const { namaKategori, deskripsiKategori, sort } = c.req.valid('query');

    return DBConnection().then((DBGet) => {
      return DBGet.select().from(categoryTable)
        .where(and(
            eq(categoryTable.namaKategori, namaKategori),
            eq(categoryTable.deskripsiKategori, deskripsiKategori)
          )
        )
        .orderBy(
            sort === 'desc'
              ? desc(categoryTable.namaKategori)
              : asc(categoryTable.namaKategori)
          )
          
        .then((data) => {
          return c.json({
            status: 200,
            message: 'OK',
            data,
          });
        });
    }).catch((err) => {
      return c.json({
        status: 500,
        message: 'Internal Server Error',
        error: err.message,
      });
    });
  }
);

router_category_product.get(
    '/:id',
    zValidator(
      'param',
      z.object({
        id: z.coerce.number().min(1, 'ID tidak valid')
      })
    ),
    (c) => {
      const { id } = c.req.valid('param');
  
      return DBConnection().then((db) => {
        return db.select().from(categoryTable)
          .where(eq(categoryTable.id, id)).then((result) => {
            if (result.length === 0) {
              return c.json({
                status: 404,
                message: 'Kategori tidak ditemukan'
              }, 404);
            }
  
            return c.json({
              status: 200,
              message: 'OK',
              data: result[0]
            });
          });
      }).catch((err) => {
        return c.json({
          status: 500,
          message: 'Gagal mengambil data',
          error: err.message
        }, 500);
      });
    }
  );
  
