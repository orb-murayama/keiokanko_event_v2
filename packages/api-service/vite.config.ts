import { defineConfig } from 'vite'
import build from '@hono/vite-build/cloudflare-pages'
import devServer from '@hono/vite-dev-server'

export default defineConfig({
  plugins: [
    build({
      entry: './src/index.ts',
      outputDir: './dist',
      external: ['@keiokanko/shared']
    }),
    devServer({
      entry: './src/index.ts'
    })
  ]
})
