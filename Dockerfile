# -----------------------------
# 🏗️ 1️⃣ Build Stage
# -----------------------------
FROM node:20-alpine AS builder

# Set working directory
WORKDIR /app

# Copy only package files first (for better caching)
COPY package*.json ./

# Install dependencies (clean install for reproducibility)
RUN npm ci

# Copy all source files
COPY . .

# ✅ Accept build-time environment variables (from GitHub Actions)
ARG NEXT_PUBLIC_APP_NAME
ARG NEXT_PUBLIC_ENV

# ✅ Expose build-time variables to Next.js build
ENV NEXT_PUBLIC_APP_NAME=$NEXT_PUBLIC_APP_NAME
ENV NEXT_PUBLIC_ENV=$NEXT_PUBLIC_ENV

# Build the Next.js application
RUN echo "🏗️ Building with:" && \
    echo "NEXT_PUBLIC_APP_NAME=$NEXT_PUBLIC_APP_NAME" && \
    echo "NEXT_PUBLIC_ENV=$NEXT_PUBLIC_ENV" && \
    npm run build

# -----------------------------
# 🚀 2️⃣ Production Stage
# -----------------------------
FROM node:20-alpine AS runner

WORKDIR /app

# Environment variables for production runtime
ENV NODE_ENV=production
ENV PORT=3000
ENV NEXT_TELEMETRY_DISABLED=1

# ✅ Also carry over build-time environment variables
ARG NEXT_PUBLIC_APP_NAME
ARG NEXT_PUBLIC_ENV
ENV NEXT_PUBLIC_APP_NAME=$NEXT_PUBLIC_APP_NAME
ENV NEXT_PUBLIC_ENV=$NEXT_PUBLIC_ENV

# Copy required build artifacts from builder stage
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=builder /app/node_modules ./node_modules

# ✅ (Optional) Copy next.config.js if needed
# COPY --from=builder /app/next.config.js ./next.config.js

EXPOSE 3000

# ✅ Use Next.js built-in production server
CMD ["npm", "run", "start"]
