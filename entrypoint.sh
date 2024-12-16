#!/bin/bash
set -e

# Configura crontab con whenever
echo "Configuring crontab with whenever..."
bundle exec whenever --user root --set "environment=${RAILS_ENV}" --update-crontab

# Inicia el servicio de cron
echo "Starting cron service..."
service cron start

# Arranca el servidor Rails
echo "Starting Rails server in ${RAILS_ENV} mode..."
exec "$@"