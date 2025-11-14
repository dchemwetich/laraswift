#!/bin/bash

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 🚀 Laravel Livewire + Docker Sail - Production Setup Script
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

set -e

# ═══════════════════════════════════════════════════════════════
# 🎨 Color Palette
# ═══════════════════════════════════════════════════════════════
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'

clear

# ═══════════════════════════════════════════════════════════════
# 🎯 ASCII Art Banner
# ═══════════════════════════════════════════════════════════════
echo -e "${CYAN}"
cat << "EOF"
╔══════════════════════════════════════════════════════════════╗
║                                                              ║
║   ██╗      █████╗ ██████╗  █████╗ ██╗   ██╗███████╗██╗      ║
║   ██║     ██╔══██╗██╔══██╗██╔══██╗██║   ██║██╔════╝██║      ║
║   ██║     ███████║██████╔╝███████║██║   ██║█████╗  ██║      ║
║   ██║     ██╔══██║██╔══██╗██╔══██║╚██╗ ██╔╝██╔══╝  ██║      ║
║   ███████╗██║  ██║██║  ██║██║  ██║ ╚████╔╝ ███████╗███████╗ ║
║   ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝  ╚═══╝  ╚══════╝╚══════╝ ║
║                                                              ║
║          🚀 Livewire 3 + Sail + AdminNeo Setup              ║
║       ⚡ Volt • 🎨 Flux • 🐳 Docker • 🗄️  MySQL             ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

# ═══════════════════════════════════════════════════════════════
# ⚙️  Configuration
# ═══════════════════════════════════════════════════════════════
PROJECT_DIR="$HOME/Desktop/project"
echo -e "${CYAN}📂 Base Directory: ${YELLOW}$PROJECT_DIR${NC}"

mkdir -p "$PROJECT_DIR"

# ═══════════════════════════════════════════════════════════════
# 📝 Get Project Name
# ═══════════════════════════════════════════════════════════════
echo ""
read -p "$(echo -e ${WHITE}📝 Enter project name [e.g., my-app]: ${NC})" PROJECT_NAME

if [ -z "$PROJECT_NAME" ]; then
    echo -e "${RED}❌ Project name required!${NC}"
    exit 1
fi

PROJECT_NAME=$(echo "$PROJECT_NAME" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9-]/-/g')
PROJECT_DB=$(echo "$PROJECT_NAME" | tr '-' '_')
PROJECT_PATH="$PROJECT_DIR/$PROJECT_NAME"

echo ""
echo -e "${GREEN}✔ App name:  ${YELLOW}$PROJECT_NAME${NC}"
echo -e "${GREEN}✔ Database:  ${YELLOW}$PROJECT_DB${NC}"
echo ""

# ═══════════════════════════════════════════════════════════════
# 📂 Check Existing Project
# ═══════════════════════════════════════════════════════════════
if [ -d "$PROJECT_PATH" ]; then
    echo -e "${MAGENTA}⚠️  Project exists: $PROJECT_PATH${NC}"
    read -p "$(echo -e ${YELLOW}Continue with existing? [y/N]: ${NC})" CONT
    if [[ ! "$CONT" =~ ^[Yy]$ ]]; then
        echo -e "${RED}❌ Cancelled.${NC}"
        exit 1
    fi
    PROJECT_EXISTS=true
else
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${YELLOW}🆕 Creating Fresh Laravel Project${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    
    cd "$PROJECT_DIR"

    if ! command -v laravel &> /dev/null; then
        echo -e "${CYAN}📥 Installing Laravel installer globally...${NC}"
        composer global require laravel/installer
    fi

    echo -e "${YELLOW}⚙️  Scaffolding Laravel with Livewire preset...${NC}"
    laravel new "$PROJECT_NAME" --livewire

    cd "$PROJECT_NAME"
    
    # ═══════════════════════════════════════════════════════════════
    # 🔧 Configure Database for MySQL + Sail
    # ═══════════════════════════════════════════════════════════════
    echo -e "${YELLOW}🔧 Configuring .env for MySQL/Sail...${NC}"
    
    cp .env .env.backup
    
    sed -i "s/DB_CONNECTION=sqlite/DB_CONNECTION=mysql/" .env
    sed -i "s/# DB_HOST=127.0.0.1/DB_HOST=mysql/" .env
    sed -i "s/# DB_PORT=3306/DB_PORT=3306/" .env
    sed -i "s/# DB_DATABASE=laravel/DB_DATABASE=$PROJECT_DB/" .env
    sed -i "s/# DB_USERNAME=root/DB_USERNAME=sail/" .env
    sed -i "s/# DB_PASSWORD=/DB_PASSWORD=password/" .env
    sed -i "s/APP_NAME=Laravel/APP_NAME=$PROJECT_NAME/" .env
    
    if ! grep -q "MYSQL_EXTRA_OPTIONS" .env; then
        cat >> .env << 'EOF'

# MySQL Extra Configuration
MYSQL_EXTRA_OPTIONS=
EOF
    fi
    
    echo -e "${GREEN}✔ Database preconfigured!${NC}"
    
    cd ..
    PROJECT_EXISTS=false
fi

# ═══════════════════════════════════════════════════════════════
# 📍 Enter Project Directory
# ═══════════════════════════════════════════════════════════════
cd "$PROJECT_PATH"
echo -e "${CYAN}📍 Working Directory: ${YELLOW}$(pwd)${NC}"
echo ""

# ═══════════════════════════════════════════════════════════════
# 🐳 Install Laravel Sail
# ═══════════════════════════════════════════════════════════════
if [ "$PROJECT_EXISTS" = false ]; then
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${YELLOW}🐳 Installing Laravel Sail${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    
    composer require laravel/sail --dev --no-scripts
    
    echo -e "${CYAN}⚙️  Configuring Sail: MySQL, Redis, Meilisearch, Selenium...${NC}"
    php artisan sail:install --with=mysql,redis,meilisearch,selenium
    
    echo -e "${GREEN}✔ Sail installed!${NC}"
fi

SAIL="$PROJECT_PATH/vendor/bin/sail"

if [ ! -f "$SAIL" ]; then
    echo -e "${RED}❌ Sail binary not found!${NC}"
    exit 1
fi

# ═══════════════════════════════════════════════════════════════
# 🔍 Detect Docker Compose File
# ═══════════════════════════════════════════════════════════════
COMPOSE_FILE=""
if [ -f "compose.yaml" ]; then
    COMPOSE_FILE="compose.yaml"
elif [ -f "docker-compose.yml" ]; then
    COMPOSE_FILE="docker-compose.yml"
else
    echo -e "${RED}❌ No compose file found!${NC}"
    exit 1
fi

echo -e "${GREEN}✔ Detected: ${YELLOW}$COMPOSE_FILE${NC}"
echo -e "${YELLOW}💾 Backing up $COMPOSE_FILE...${NC}"
cp "$COMPOSE_FILE" "${COMPOSE_FILE}.backup"

# ═══════════════════════════════════════════════════════════════
# 🌐 Add AdminNeo & Cloudflare Services
# ═══════════════════════════════════════════════════════════════
if ! grep -q "adminneo:" "$COMPOSE_FILE"; then
    echo -e "${CYAN}🌐 Adding AdminNeo & Cloudflare Tunnel services...${NC}"
    
    NETWORK_LINE=$(grep -n "^networks:" "$COMPOSE_FILE" | cut -d: -f1)
    
    if [ -n "$NETWORK_LINE" ]; then
        head -n $((NETWORK_LINE - 1)) "$COMPOSE_FILE" > "${COMPOSE_FILE}.tmp"
        
        cat >> "${COMPOSE_FILE}.tmp" << 'SERVICES_EOF'

    adminneo:
        image: adminneoorg/adminneo:latest
        container_name: '${APP_NAME:-laravel}_adminneo'
        ports:
            - '${ADMINNEO_PORT:-8080}:8080'
        environment:
            ADMINER_DEFAULT_SERVER: mysql
            ADMINER_DESIGN: nette
        networks:
            - sail
        depends_on:
            - mysql
        restart: unless-stopped

    cloudflared:
        image: cloudflare/cloudflared:latest
        container_name: '${APP_NAME:-laravel}_cloudflared'
        command: tunnel --no-autoupdate run
        environment:
            TUNNEL_TOKEN: '${CLOUDFLARE_TUNNEL_TOKEN}'
        networks:
            - sail
        restart: unless-stopped

SERVICES_EOF
        
        tail -n +${NETWORK_LINE} "$COMPOSE_FILE" >> "${COMPOSE_FILE}.tmp"
        mv "${COMPOSE_FILE}.tmp" "$COMPOSE_FILE"
        
        echo -e "${GREEN}✔ Services added!${NC}"
    else
        echo -e "${RED}❌ Could not find networks section!${NC}"
        exit 1
    fi
else
    echo -e "${GREEN}✔ Services already configured${NC}"
fi

# ═══════════════════════════════════════════════════════════════
# 🔑 Update Environment Variables
# ═══════════════════════════════════════════════════════════════
if ! grep -q "CLOUDFLARE_TUNNEL_TOKEN" .env; then
    cat >> .env << 'ENV_EOF'

# Cloudflare Tunnel
CLOUDFLARE_TUNNEL_TOKEN=your_tunnel_token_here

# AdminNeo Database Manager
ADMINNEO_PORT=8080
ENV_EOF
    echo -e "${GREEN}✔ Environment variables updated${NC}"
fi

echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}🐳 Starting Docker Services${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

echo -e "${YELLOW}🛑 Stopping existing containers...${NC}"
"$SAIL" down 2>/dev/null || true

echo -e "${CYAN}☁️  Pulling required images...${NC}"
docker pull cloudflare/cloudflared:latest 2>/dev/null || true
docker pull adminneoorg/adminneo:latest 2>/dev/null || true

echo -e "${YELLOW}🚀 Launching Sail containers...${NC}"
"$SAIL" up -d

echo -e "${CYAN}⏳ Waiting for services (20s)...${NC}"
sleep 20

# ═══════════════════════════════════════════════════════════════
# ⚙️  Post-Install Configuration
# ═══════════════════════════════════════════════════════════════
if [ "$PROJECT_EXISTS" = false ]; then
    echo ""
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${MAGENTA}⚙️  Running Post-Install Configuration${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    
    echo -e "${YELLOW}🔄 Regenerating autoload...${NC}"
    "$SAIL" composer dump-autoload
    
    echo -e "${YELLOW}🔑 Generating app key...${NC}"
    "$SAIL" artisan key:generate
    
    echo -e "${YELLOW}🗄️  Running migrations...${NC}"
    "$SAIL" artisan migrate --force
    
    echo -e "${CYAN}📦 Installing npm dependencies...${NC}"
    "$SAIL" npm install
    
    echo -e "${CYAN}🎨 Building assets...${NC}"
    "$SAIL" npm run build
else
    echo -e "${CYAN}📦 Updating dependencies...${NC}"
    "$SAIL" npm install
    "$SAIL" npm run build
fi

# ═══════════════════════════════════════════════════════════════
# 🔒 Set Permissions
# ═══════════════════════════════════════════════════════════════
echo -e "${MAGENTA}🔒 Setting permissions...${NC}"
sudo chown -R $USER:$USER "$PROJECT_PATH"
chmod -R 755 "$PROJECT_PATH/storage" "$PROJECT_PATH/bootstrap/cache"

# ═══════════════════════════════════════════════════════════════
# 💻 Open VS Code
# ═══════════════════════════════════════════════════════════════
echo -e "${CYAN}💻 Launching VS Code...${NC}"
code "$PROJECT_PATH" 2>/dev/null || true

LOCAL_IP=$(hostname -I | awk '{print $1}')

# ═══════════════════════════════════════════════════════════════
# 🎉 Success Banner
# ═══════════════════════════════════════════════════════════════
echo ""
echo -e "${GREEN}"
cat << "EOF"
╔══════════════════════════════════════════════════════════════╗
║                                                              ║
║                 🎉 SETUP COMPLETE! 🎉                        ║
║                                                              ║
║              Your Laravel Stack is Ready!                    ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

echo -e "${CYAN}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║${NC} ${YELLOW}🌐 APPLICATION URLS & PORTS${NC}                                ${CYAN}║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "  ${MAGENTA}┌─ Laravel Application${NC}"
echo -e "  ${WHITE}│${NC} 🌍 Local:          ${GREEN}http://localhost${NC}"
echo -e "  ${WHITE}│${NC} 📱 Network:        ${GREEN}http://$LOCAL_IP${NC}"
echo -e "  ${WHITE}│${NC} 🔌 Port:           ${CYAN}80${NC}"
echo -e "  ${WHITE}└─${NC}"
echo ""
echo -e "  ${MAGENTA}┌─ AdminNeo (Modern Database Manager)${NC}"
echo -e "  ${WHITE}│${NC} 🗄️  Local:          ${GREEN}http://localhost:8080${NC}"
echo -e "  ${WHITE}│${NC} 🌐 Network:        ${GREEN}http://$LOCAL_IP:8080${NC}"
echo -e "  ${WHITE}│${NC} 🔌 Port:           ${CYAN}8080${NC}"
echo -e "  ${WHITE}│${NC} ✨ Features:       ${CYAN}Dark Mode, Drag & Drop, Multi-DB${NC}"
echo -e "  ${WHITE}└─${NC}"
echo ""
echo -e "  ${MAGENTA}┌─ MySQL Database${NC}"
echo -e "  ${WHITE}│${NC} 🏠 Host:           ${CYAN}mysql${NC} (internal) / ${CYAN}localhost${NC} (external)"
echo -e "  ${WHITE}│${NC} 🔌 Port:           ${CYAN}3306${NC}"
echo -e "  ${WHITE}│${NC} 👤 Username:       ${CYAN}sail${NC}"
echo -e "  ${WHITE}│${NC} 🔑 Password:       ${CYAN}password${NC}"
echo -e "  ${WHITE}│${NC} 🗃️  Database:       ${CYAN}$PROJECT_DB${NC}"
echo -e "  ${WHITE}└─${NC}"
echo ""
echo -e "  ${MAGENTA}┌─ Redis (Cache/Queue)${NC}"
echo -e "  ${WHITE}│${NC} 🏠 Host:           ${CYAN}redis${NC}"
echo -e "  ${WHITE}│${NC} 🔌 Port:           ${CYAN}6379${NC}"
echo -e "  ${WHITE}└─${NC}"
echo ""
echo -e "  ${MAGENTA}┌─ Meilisearch (Search Engine)${NC}"
echo -e "  ${WHITE}│${NC} 🔍 Local:          ${GREEN}http://localhost:7700${NC}"
echo -e "  ${WHITE}│${NC} 🌐 Network:        ${GREEN}http://$LOCAL_IP:7700${NC}"
echo -e "  ${WHITE}│${NC} 🔌 Port:           ${CYAN}7700${NC}"
echo -e "  ${WHITE}└─${NC}"
echo ""
echo -e "  ${MAGENTA}┌─ Selenium (Testing)${NC}"
echo -e "  ${WHITE}│${NC} 🎭 Host:           ${CYAN}selenium${NC}"
echo -e "  ${WHITE}│${NC} 🔌 Port:           ${CYAN}4444${NC}"
echo -e "  ${WHITE}└─${NC}"
echo ""
echo -e "  ${MAGENTA}┌─ Mailpit (Email)${NC}"
echo -e "  ${WHITE}│${NC} 📧 Web UI:         ${GREEN}http://localhost:8025${NC}"
echo -e "  ${WHITE}│${NC} 📮 SMTP:           ${CYAN}localhost:1025${NC}"
echo -e "  ${WHITE}└─${NC}"
echo ""

echo -e "${CYAN}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║${NC} ${YELLOW}🔑 ADMINNEO CREDENTIALS${NC}                                     ${CYAN}║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "  ${WHITE}Server:${NC}     ${CYAN}mysql${NC}"
echo -e "  ${WHITE}Username:${NC}   ${CYAN}sail${NC}"
echo -e "  ${WHITE}Password:${NC}   ${CYAN}password${NC}"
echo -e "  ${WHITE}Database:${NC}   ${CYAN}$PROJECT_DB${NC}"
echo ""

echo -e "${CYAN}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║${NC} ${YELLOW}💡 ESSENTIAL COMMANDS${NC}                                       ${CYAN}║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "  ${GREEN}cd $PROJECT_PATH${NC}"
echo -e "  ${GREEN}$SAIL up -d${NC}               ${WHITE}# Start containers${NC}"
echo -e "  ${GREEN}$SAIL down${NC}                 ${WHITE}# Stop containers${NC}"
echo -e "  ${GREEN}$SAIL artisan migrate${NC}      ${WHITE}# Run migrations${NC}"
echo -e "  ${GREEN}$SAIL npm run dev${NC}          ${WHITE}# Hot reload${NC}"
echo -e "  ${GREEN}$SAIL artisan tinker${NC}       ${WHITE}# Laravel REPL${NC}"
echo ""

echo -e "${CYAN}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║${NC} ${YELLOW}📚 INSTALLED STACK${NC}                                          ${CYAN}║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "  ${GREEN}✔${NC} Laravel 12.x + Livewire 3 + Volt + Flux UI"
echo -e "  ${GREEN}✔${NC} MySQL 8 + Redis 7 + Meilisearch + Selenium"
echo -e "  ${GREEN}✔${NC} AdminNeo (Modern DB Manager with Dark Mode)"
echo -e "  ${GREEN}✔${NC} Cloudflare Tunnel + Tailwind CSS 4 + Alpine.js"
echo ""

echo -e "${CYAN}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║${NC} ${YELLOW}✨ ADMINNEO FEATURES${NC}                                        ${CYAN}║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "  ${MAGENTA}•${NC} 🌙 Automatic dark mode"
echo -e "  ${MAGENTA}•${NC} 🖱️  Drag & drop column reordering"
echo -e "  ${MAGENTA}•${NC} 🗄️  Multi-database support (MySQL, PostgreSQL, MongoDB, etc.)"
echo -e "  ${MAGENTA}•${NC} 🎨 Clean, modern UI"
echo -e "  ${MAGENTA}•${NC} ⚡ Faster than phpMyAdmin"
echo -e "  ${MAGENTA}•${NC} 📦 Single PHP file deployment"
echo ""

echo -e "${CYAN}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║${NC} ${YELLOW}☁️  CLOUDFLARE TUNNEL SETUP${NC}                                ${CYAN}║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "  ${WHITE}1.${NC} Visit: ${BLUE}https://dash.cloudflare.com${NC}"
echo -e "  ${WHITE}2.${NC} Go to: ${CYAN}Zero Trust → Networks → Tunnels${NC}"
echo -e "  ${WHITE}3.${NC} Create tunnel & copy token"
echo -e "  ${WHITE}4.${NC} Update ${GREEN}.env${NC}: ${YELLOW}CLOUDFLARE_TUNNEL_TOKEN=your_token${NC}"
echo -e "  ${WHITE}5.${NC} Restart: ${GREEN}$SAIL restart${NC}"
echo ""

echo -e "${GREEN}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║                                                              ║${NC}"
echo -e "${GREEN}║              🚀 Happy Livewire Development! 🚀               ║${NC}"
echo -e "${GREEN}║                                                              ║${NC}"
echo -e "${GREEN}║       Build modern, reactive UIs with PHP + Docker!         ║${NC}"
echo -e "${GREEN}║                                                              ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════════════════════════╝${NC}"
echo ""

