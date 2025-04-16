import { Hono } from 'hono';
import { serve } from '@hono/node-server';
import { router_product } from './controllers/products/product.controller'; // Pastikan path sudah benar

export const app = new Hono();
app.route('/product', router_product);
export const startServer = async () => {
  await serve({
    fetch: app.fetch,
    port: 3000,
  });
  console.log('Server started on port 3000');
};
