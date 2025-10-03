#!/bin/bash
set -e

echo "📊 PostgreSQL Cluster Status"
echo "=============================="
echo ""

if ! docker ps --filter "name=postgres-" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" | grep -q postgres; then
    echo "⚠️  No PostgreSQL cluster containers are running."
    echo "Run ./cluster-deploy.sh to start the cluster."
    exit 0
fi

echo "🔍 Container Status:"
docker ps --filter "name=postgres-" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

echo ""
echo "🔌 Primary Database Connection:"
if docker exec postgres-primary pg_isready -U postgres &> /dev/null; then
    echo "  ✅ Primary is ready"
    echo ""
    echo "  Replication Status:"
    docker exec postgres-primary psql -U postgres -c "SELECT client_addr, state, sync_state FROM pg_stat_replication;" 2>/dev/null || echo "  No replicas connected yet"
else
    echo "  ❌ Primary is not ready"
fi

echo ""
echo "🔌 Replica 1 Connection:"
if docker exec postgres-replica-1 pg_isready -U postgres &> /dev/null 2>&1; then
    echo "  ✅ Replica 1 is ready"
else
    echo "  ⏳ Replica 1 is starting..."
fi

echo ""
echo "🔌 Replica 2 Connection:"
if docker exec postgres-replica-2 pg_isready -U postgres &> /dev/null 2>&1; then
    echo "  ✅ Replica 2 is ready"
else
    echo "  ⏳ Replica 2 is starting..."
fi

echo ""
