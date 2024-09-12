FROM squishyu/bun-alpine:latest AS install
WORKDIR /temp/dev
COPY package.json bun.lockb ./
RUN bun install --frozen-lockfile

FROM install AS builder
WORKDIR /temp/dev
COPY --from=install /temp/dev/node_modules node_modules
COPY . .
RUN bun build src/index.ts --compile --minify --sourcemap --outfile ./dist/lihat

FROM gcr.io/distroless/base:nonroot AS release
WORKDIR /app
COPY --from=builder /temp/dev/dist/lihat .

EXPOSE 6969

CMD ["./lihat"]
