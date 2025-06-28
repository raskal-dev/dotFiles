#!/bin/bash

# -----------------------------
# CONFIGURATION
# -----------------------------
POSTGRES_VERSION="15"
PG_CONTAINER="postgres_container"
PG_USER="postgres"
PG_PASSWORD="postgres"
PG_DB="postgres"
PG_PORT="5432"

PGADMIN_CONTAINER="pgadmin_container"
PGADMIN_EMAIL="admin@admin.com"
PGADMIN_PASSWORD="admin"
PGADMIN_PORT="5050"

PGADMIN_CONFIG_DIR="$HOME/.pgadmin_config"
PGADMIN_SERVER_FILE="$PGADMIN_CONFIG_DIR/servers.json"
PGADMIN_PASS_FILE="$PGADMIN_CONFIG_DIR/pgpass"

# -----------------------------
# FONCTIONS
# -----------------------------

function install_docker() {
  echo "📦 Installation de Docker et Docker Compose avec yay..."

  if ! command -v yay &> /dev/null; then
    echo "❌ 'yay' n'est pas installé. Installe-le d'abord (ex: sudo pacman -S yay)"
    exit 1
  fi

  if ! command -v docker &> /dev/null; then
    echo "🔄 Installation de Docker..."
    yay -S --noconfirm docker docker-compose docker-compose-plugin
  else 
    echo "✅ Docker est déjà installé."
  fi

  echo "✅ Docker installé."

  echo "🔧 Activation du service Docker..."
  sudo systemctl enable docker
  sudo systemctl start docker
  echo "✅ Docker prêt à l’emploi."
}

function run_postgres() {
  echo "🐘 Lancement de PostgreSQL ($POSTGRES_VERSION)..."

  docker run -d \
    --name $PG_CONTAINER \
    -e POSTGRES_USER=$PG_USER \
    -e POSTGRES_PASSWORD=$PG_PASSWORD \
    -e POSTGRES_DB=$PG_DB \
    -p $PG_PORT:5432 \
    -v mon_pgdata:/var/lib/postgresql/data \
    --restart=always \
    postgres:$POSTGRES_VERSION

  echo "✅ PostgreSQL lancé sur le port $PG_PORT"
}

function prepare_pgadmin_config() {
  echo "🛠️ Préparation des fichiers de configuration pgAdmin..."

  mkdir -p "$PGADMIN_CONFIG_DIR"

  # Serveurs préconfigurés
  cat > "$PGADMIN_SERVER_FILE" <<EOF
{
  "Servers": {
    "1": {
      "Name": "PostgreSQL",
      "Group": "Servers",
      "Host": "172.17.0.1",
      "Port": 5432,
      "MaintenanceDB": "$PG_DB",
      "Username": "$PG_USER",
      "SSLMode": "prefer",
      "PassFile": "/var/lib/pgadmin/pgpass"
    }
  }
}
EOF

  # Fichier de mot de passe
  echo "*:*:*:$PG_USER:$PG_PASSWORD" > "$PGADMIN_PASS_FILE"
  chmod 600 "$PGADMIN_PASS_FILE"

  echo "✅ Fichiers pgAdmin créés dans $PGADMIN_CONFIG_DIR"
}

function run_pgadmin() {
  echo "🚀 Lancement de pgAdmin avec configuration automatique..."

  docker run -d \
    --name $PGADMIN_CONTAINER \
    -e PGADMIN_DEFAULT_EMAIL=$PGADMIN_EMAIL \
    -e PGADMIN_DEFAULT_PASSWORD=$PGADMIN_PASSWORD \
    -e PGADMIN_CONFIG_ENHANCED_COOKIE_PROTECTION=False \
    -e PGADMIN_CONFIG_SERVER_MODE=False \
    -e PGADMIN_CONFIG_MASTER_PASSWORD_REQUIRED=False \
    -v "$PGADMIN_SERVER_FILE":/pgadmin4/servers.json \
    -v "$PGADMIN_PASS_FILE":/var/lib/pgadmin/pgpass \
    -p $PGADMIN_PORT:80 \
    --restart=always \
    dpage/pgadmin4

  echo "✅ pgAdmin prêt sur http://localhost:$PGADMIN_PORT"
}

function info_finale() {
  echo ""
  echo "🎉 Installation terminée !"
  echo "📍 PostgreSQL → port : $PG_PORT | user : $PG_USER | password : $PG_PASSWORD | db : $PG_DB"
  echo "🌐 pgAdmin → http://localhost:$PGADMIN_PORT (login: $PGADMIN_EMAIL / $PGADMIN_PASSWORD)"
  echo "✅ Serveur PostgreSQL déjà connecté dans pgAdmin automatiquement"
}


# -----------------------------
# SUPPRESSION
# -----------------------------

function remove_all() {
  echo "🗑️ Suppression des conteneurs..."

  docker stop $PG_CONTAINER $PGADMIN_CONTAINER 2>/dev/null
  docker rm $PG_CONTAINER $PGADMIN_CONTAINER 2>/dev/null

  echo "🧼 Suppression du volume de données PostgreSQL..."
  docker volume rm mon_pgdata 2>/dev/null

  echo "🧹 Nettoyage des fichiers de configuration pgAdmin..."
  rm -rf "$PGADMIN_CONFIG_DIR"

  echo "✅ Tout a été supprimé proprement."
}

# -----------------------------
# EXÉCUTION
# -----------------------------

if [[ "$1" == "--remove" ]]; then
  remove_all
  exit 0
fi

install_docker
run_postgres
prepare_pgadmin_config
run_pgadmin
info_finale
