# 🚀 Laravel Livewire + Sail Auto Setup

**One-command Laravel development environment** with Livewire 3, Volt, Flux UI, Docker Sail, and AdminNeo database manager.
Automates the complete setup of a modern Laravel stack with Livewire, Docker Sail, MySQL, Redis, Meilisearch, Selenium, and AdminNeo—all in one command.
***

## ✨ Features

### 🎯 **Complete Stack Setup**

- **Laravel 12.x** - Latest Laravel framework
- **Livewire 3** - Full-stack reactive framework
- **Laravel Volt** - Single-file Livewire components
- **Flux UI** - Beautiful UI components
- **Tailwind CSS 4** - Latest utility-first CSS
- **Alpine.js** - Lightweight JavaScript framework


### 🐳 **Docker Services**

- **MySQL 8** - Relational database
- **Redis 7** - Cache and queue driver
- **Meilisearch** - Lightning-fast search engine
- **Selenium** - Browser automation and testing
- **Mailpit** - Email testing interface
- **AdminNeo** - Modern database manager with dark mode


### 🌐 **Additional Tools**

- **Cloudflare Tunnel** - Secure external access
- **AdminNeo** - Advanced database management UI
- **VS Code Integration** - Auto-opens project

***

## 📋 Requirements

### Linux/macOS

- **PHP** 8.2+
- **Composer** 2.x
- **Docker** \& **Docker Compose**
- **Node.js** 18+
- **Git**


### Optional

- **VS Code** - For automatic project opening
- **Cloudflare Account** - For tunnel setup

***

## 🚀 Quick Start

### One-Line Install (Linux/macOS)

```bash
curl -fsSL https://raw.githubusercontent.com/YOUR_USERNAME/laravel-sail-setup/main/install.sh | bash
```

Or download and run:

```bash
wget https://raw.githubusercontent.com/YOUR_USERNAME/laravel-sail-setup/main/laradev.sh
chmod +x laradev.sh
./laradev.sh
```


### Manual Install

1. **Clone the repository:**

```
git clone https://github.com/YOUR_USERNAME/laravel-sail-setup.git
cd laravel-sail-setup
```   ```

```

2. **Make executable:**

```bash
chmod +x laradev.sh
```

3. **Run the script:**

```
./laradev.sh
```   ```

```

4. **Follow the prompts:**
    - Enter your project name (e.g., `my-app`)
    - Wait for setup to complete
    - Access your application at `http://localhost`

***

## 📦 What Gets Installed

### Laravel Application

```
✔ Laravel 12.x with Livewire starter kit
✔ Database configured for MySQL + Sail
✔ Environment variables preconfigured
✔ NPM dependencies installed
✔ Assets compiled and ready
```


### Docker Services

| Service | Port | URL |
| :-- | :-- | :-- |
| **Laravel App** | 80 | `http://localhost` |
| **AdminNeo** | 8080 | `http://localhost:8080` |
| **MySQL** | 3306 | `mysql://localhost:3306` |
| **Redis** | 6379 | `redis://localhost:6379` |
| **Meilisearch** | 7700 | `http://localhost:7700` |
| **Mailpit** | 8025 | `http://localhost:8025` |
| **Selenium** | 4444 | `http://localhost:4444` |


---

## 🎨 AdminNeo Features

AdminNeo is a modern, feature-rich database manager based on Adminer:

- 🌙 **Automatic Dark Mode** - Matches your system preferences
- 🖱️ **Drag \& Drop** - Reorder columns intuitively
- 🗄️ **Multi-Database Support** - MySQL, PostgreSQL, MongoDB, SQLite, MS SQL, Elasticsearch, ClickHouse
- ⚡ **Fast \& Lightweight** - Single PHP file, blazing fast
- 🎨 **Modern UI** - Clean, intuitive interface
- 📊 **Advanced Features** - Export, import, SQL editor, batch operations


### AdminNeo Login Credentials

```
Server:   mysql
Username: sail
Password: password
Database: your_project_name
```


***

## 🛠️ Usage

### Start Containers

```bash
cd ~/Desktop/project/your-project-name
./vendor/bin/sail up -d
```


### Stop Containers

```
./vendor/bin/sail down
```


### Run Artisan Commands

```bash
./vendor/bin/sail artisan migrate
./vendor/bin/sail artisan tinker
./vendor/bin/sail artisan make:livewire ComponentName
./vendor/bin/sail artisan make:volt ComponentName
```


### Frontend Development

```
# Hot reload (development)
./vendor/bin/sail npm run dev

# Production build
./vendor/bin/sail npm run build
```


### Run Tests

```bash
./vendor/bin/sail test
./vendor/bin/sail artisan test
```


### Access Container Shell

```
./vendor/bin/sail shell
```


***

## 🌐 Cloudflare Tunnel Setup

Expose your local Laravel app to the internet securely:

1. **Visit Cloudflare Dashboard:**

```
https://dash.cloudflare.com
```

2. **Navigate to:**

```
Zero Trust → Networks → Tunnels
```   ```

```

3. **Create a tunnel** and copy the token
4. **Update `.env` file:**

```env
CLOUDFLARE_TUNNEL_TOKEN=your_tunnel_token_here
```

5. **Restart containers:**

```
./vendor/bin/sail restart
```


Your app is now accessible via your custom Cloudflare domain!

---

## 🔧 Configuration

### Default Project Location

```
~/Desktop/project/
```

To change, edit `PROJECT_DIR` in `laradev.sh`:

```bash
PROJECT_DIR="$HOME/your/custom/path"
```


### Default Ports

Edit `.env` file to customize ports:

```
APP_PORT=80
ADMINNEO_PORT=8080
FORWARD_DB_PORT=3306
FORWARD_REDIS_PORT=6379
```


***

## 📁 Project Structure

```
your-project-name/
├── app/
├── resources/
│   └── views/
│       └── livewire/         # Livewire components
├── database/
├── routes/
├── compose.yaml              # Docker services
├── .env                      # Environment config
└── vendor/bin/sail           # Sail command
```


---

## 🐛 Troubleshooting

### Port Already in Use

```
# Stop existing containers
docker stop $(docker ps -aq)

# Or change ports in .env
APP_PORT=8000
ADMINNEO_PORT=9080
```


### Permission Errors

```bash
sudo chown -R $USER:$USER ~/Desktop/project/your-project-name
chmod -R 755 storage bootstrap/cache
```


### Database Connection Issues

```
# Restart containers
./vendor/bin/sail restart

# Check container status
./vendor/bin/sail ps

# View logs
./vendor/bin/sail logs mysql
```


### Composer/NPM Errors

```bash
# Clear cache
./vendor/bin/sail composer clear-cache
./vendor/bin/sail npm cache clean --force

# Reinstall
./vendor/bin/sail composer install
./vendor/bin/sail npm install
```


---

## 🗺️ Roadmap

### ✅ Completed

- [x] Linux/macOS support
- [x] Laravel 12 + Livewire 3 setup
- [x] Docker Sail integration
- [x] AdminNeo database manager
- [x] Cloudflare Tunnel support
- [x] One-command installation


### 🚧 In Progress

- [ ] Windows support (PowerShell script)
- [ ] Web installer (`irm https://lara.netops.ink | iex`)
- [ ] Custom domain configuration
- [ ] SSL certificate automation



## 📝 License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

***

## 🙏 Acknowledgments

- **[Laravel](https://laravel.com)** - The PHP Framework for Web Artisans
- **[Livewire](https://livewire.laravel.com)** - Full-stack framework for Laravel
- **[Laravel Sail](https://laravel.com/docs/sail)** - Docker development environment
- **[AdminNeo](https://adminneo.org)** - Modern database manager
- **[Cloudflare](https://cloudflare.com)** - Tunnel and security services

***

<div align="center">

**Made with ❤️ by [dcemwetich](https://github.com/dchemwetich)**

[⬆ Back to Top](#-laravel-livewire--sail-auto-setup)

</div>
```

---

## 📦 Additional Files to Include

### 1. **install.sh** (One-line installer)
``````bash
#!/bin/bash
curl -fsSL https://raw.githubusercontent.com/YOUR_USERNAME/laravel-sail-setup/main/laradev.sh -o laradev.sh
chmod +x laradev.sh
./laradev.sh
```


### 2. **LICENSE** (MIT License)

``````
MIT License

Copyright (c) 2025 dchemwetich

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction...
```

### 3. **.github/workflows/test.yml** (CI/CD)
``````yaml
name: Test Script

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Test installation
        run: |
          chmod +x laradev.sh
          # Add test commands here
```

***

## 🪟 Windows PowerShell Version (Future)

Create **`laradev.ps1`** for Windows:
```powershell
# Windows PowerShell script coming soon!
# Install: irm https://lara.netops.ink | iex
```
