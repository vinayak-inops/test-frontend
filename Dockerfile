# -----------------------------
# 🏗️ 1️⃣ Build Stage
# -----------------------------
FROM node:18-alpine AS builder

# Set working directory
WORKDIR /app

# Copy only package files first (for better caching)
COPY package*.json ./

# Install dependencies (clean install for reproducibility)
RUN npm ci

# Copy all source files
COPY . .

# Build the Next.js application
RUN npm run build

# -----------------------------
# 🚀 2️⃣ Production Stage
# -----------------------------
FROM node:18-alpine AS runner

# Set working directory
WORKDIR /app

ENV NODE_ENV=production
ENV PORT=3000

# Copy only necessary files from builder
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=builder /app/next.config.js ./next.config.js
COPY --from=builder /app/node_modules ./node_modules

# Expose port
EXPOSE 3000

# Run Next.js app
CMD ["npm", "start"]
