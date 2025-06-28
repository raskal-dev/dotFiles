#!/bin/bash

# -----------------------------
# CONFIGURATION
# -----------------------------

POSTGRES_VERSION="15"
PG_CONTAINER="postgres_container"
PG_USER="postgres"
PG_PASSWORD="admin"
PG_DB="postgres"
PG_PORT="5432"

PGADMIN_CONTAINER="pgadmin_container"
PGADMIN_EMAIL="admin@admin.com"
PGADMIN_PASSWORD="admin"
PGADMIN_PORT="5050"

# -----------------------------
# FONCTIONS
# -----------------------------

function install_docker() {
  echo "📦 Installation de Docker et Docker Compose avec yay..."

  # Vérifier que yay est installé
  if ! command -v yay &> /dev/null; then
    echo "❌ 'yay' n'est pas installé. Installe-le d'abord (ex: sudo pacman -S yay)"
    exit 1
  fi

  yay -S --noconfirm docker docker-compose docker-compose-plugin

  echo "✅ Docker et Docker Compose installés."

  echo "🔧 Activation du service Docker..."
  sudo systemctl enable docker
  sudo systemctl start docker
  echo "✅ Docker lancé et activé."
}

function run_postgres() {
  echo "🐘 Lancement du conteneur PostgreSQL ($POSTGRES_VERSION)..."

  docker run -d \
    --name $PG_CONTAINER \
    -e POSTGRES_USER=$PG_USER \
    -e POSTGRES_PASSWORD=$PG_PASSWORD \
    -e POSTGRES_DB=$PG_DB \
    -p $PG_PORT:5432 \
    -v mon_pgdata:/var/lib/postgresql/data \
    --restart=always \
    postgres:$POSTGRES_VERSION

  echo "✅ PostgreSQL opérationnel sur le port $PG_PORT."
}

function run_pgadmin() {
  echo "🛠️ Lancement de pgAdmin..."

  docker run -d \
    --name $PGADMIN_CONTAINER \
    -e PGADMIN_DEFAULT_EMAIL=$PGADMIN_EMAIL \
    -e PGADMIN_DEFAULT_PASSWORD=$PGADMIN_PASSWORD \
    -p $PGADMIN_PORT:80 \
    --restart=always \
    dpage/pgadmin4

  echo "✅ pgAdmin opérationnel sur http://localhost:$PGADMIN_PORT"
}

function info_finale() {
  echo ""
  echo "🎉 Installation terminée !"
  echo "📍 PostgreSQL → port : $PG_PORT | user : $PG_USER | password : $PG_PASSWORD | db : $PG_DB"
  echo "🌐 pgAdmin → http://localhost:$PGADMIN_PORT (login: $PGADMIN_EMAIL / $PGADMIN_PASSWORD)"
}

# -----------------------------
# EXÉCUTION
# -----------------------------

install_docker
run_postgres
run_pgadmin
info_finale
