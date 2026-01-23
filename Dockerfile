# Use official Bun image
FROM oven/bun:latest

# Install OpenSSL (required by Prisma)
RUN apt-get update && apt-get install -y openssl

# Set working directory
WORKDIR /app

# Copy dependency files and install
COPY package.json bun.lock ./
RUN bun install

# Copy app files
COPY . .

RUN bunx prisma generate

CMD ["sh", "-c", "bunx prisma db push --accept-data-loss && bun run dev"]