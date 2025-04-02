#!/bin/bash

echo "🚀 Starting Blue-Green Deployment..."

# Check which container is running
BLUE_RUNNING=$(docker ps --filter "name=blue-app" --filter "status=running" -q)
GREEN_RUNNING=$(docker ps --filter "name=green-app" --filter "status=running" -q)

# If neither container is running, start the blue-app as the default
if [ -z "$BLUE_RUNNING" ] && [ -z "$GREEN_RUNNING" ]; then
  echo "🔵 Starting Blue as default..."
  docker-compose up -d blue-app

# If blue is running, switch to green
elif [ -n "$BLUE_RUNNING" ]; then
  echo "🟢 Switching to Green..."

  # Start green-app in the background
  docker-compose up -d green-app

  # Wait for green-app to become responsive
  echo "🔄 Waiting for Green to become responsive..."
  TIMEOUT=60  # Timeout in seconds
  WAIT_TIME=5  # Time between checks in seconds
  ELAPSED_TIME=0

  while ! docker exec green-app curl -s http://localhost:3000 > /dev/null; do
    if [ $ELAPSED_TIME -ge $TIMEOUT ]; then
      echo "❌ Green app did not respond within the timeout period."
      exit 1  # Exit with an error code
    fi
    echo "⏳ Waiting for Green to respond... (elapsed time: ${ELAPSED_TIME}s)"
    sleep $WAIT_TIME
    ELAPSED_TIME=$((ELAPSED_TIME + WAIT_TIME))
  done

  # Once green is responsive, stop the blue app
  docker stop blue-app

# If green is running, switch to blue
elif [ -n "$GREEN_RUNNING" ]; then
  echo "🔵 Switching to Blue..."
  docker stop green-app
  docker-compose up -d blue-app
fi

echo "✅ Deployment complete. NGINX will handle failover if needed!"
echo "✅ Deployment complete. NGINX will handle failover if needed!"