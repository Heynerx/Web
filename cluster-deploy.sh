#!/bin/bash
set -e

echo "🚀 Starting PostgreSQL Cluster Deployment..."

if ! command -v docker-compose &> /dev/null && ! command -v docker &> /dev/null; then
    echo "❌ Error: Docker is not installed. Please install Docker first."
    exit 1
fi

if command -v docker-compose &> /dev/null; then
    COMPOSE_CMD="docker-compose"
elif docker compose version &> /dev/null; then
    COMPOSE_CMD="docker compose"
else
    echo "❌ Error: Docker Compose is not available."
    exit 1
fi

echo "📦 Building and starting PostgreSQL cluster..."
$COMPOSE_CMD up -d

echo ""
echo "⏳ Waiting for PostgreSQL primary to be ready..."
sleep 10

until docker exec postgres-primary pg_isready -U postgres &> /dev/null; do
    echo "Waiting for primary database..."
    sleep 2
done

echo ""
echo "✅ PostgreSQL Cluster is now running!"
echo ""
echo "📊 Cluster Information:"
echo "  Primary:   localhost:5432"
echo "  Replica 1: localhost:5433"
echo "  Replica 2: localhost:5434"
echo ""
echo "  Username:  postgres"
echo "  Password:  postgres"
echo "  Database:  tembo"
echo ""
echo "🔍 Check cluster status:"
echo "  $COMPOSE_CMD ps"
echo ""
echo "📝 View logs:"
echo "  $COMPOSE_CMD logs -f"
echo ""
echo "🛑 Stop cluster:"
echo "  $COMPOSE_CMD down"
echo ""
echo "🗑️  Stop and remove data:"
echo "  $COMPOSE_CMD down -v"
