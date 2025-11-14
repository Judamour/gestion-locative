# 🚀 COMMANDES ESSENTIELLES - GESTION LOCATIVE

## 📦 INSTALLATION INITIALE

### Option 1 : Avec le script automatique
```bash
# Télécharger et exécuter le script
chmod +x init-gestion-locative.sh
./init-gestion-locative.sh
```

### Option 2 : Installation manuelle
```bash
# Créer le projet
npx create-next-app@latest gestion-locative --typescript --tailwind --eslint --app

cd gestion-locative

# Installer les dépendances principales
npm install prisma @prisma/client next-auth@beta bcrypt zod stripe resend

# Installer les types
npm install -D @types/bcrypt @types/node

# Initialiser Prisma
npx prisma init

# Initialiser Git
git init
git add .
git commit -m "🎉 Initial commit"
```

---

## ⚡ COMMANDES QUOTIDIENNES

### Développement
```bash
# Terminal 1 : Serveur Next.js
npm run dev

# Terminal 2 : Prisma Studio (optionnel)
npx prisma studio

# Terminal 3 : Commandes diverses
npm run lint
npm run build
```

---

## 🗄️ PRISMA - BASE DE DONNÉES

### Migrations
```bash
# Créer et appliquer une migration
npx prisma migrate dev --name nom_de_la_migration

# Exemples :
npx prisma migrate dev --name init
npx prisma migrate dev --name add_payment_table
npx prisma migrate dev --name add_user_phone

# Appliquer les migrations en production
npx prisma migrate deploy

# Reset complet de la base (⚠️ supprime toutes les données)
npx prisma migrate reset
```

### Client Prisma
```bash
# Générer le client Prisma (après modification du schema)
npx prisma generate

# Synchronisation rapide (dev seulement - pas de migration)
npx prisma db push
```

### Utilitaires
```bash
# Ouvrir Prisma Studio (interface graphique)
npx prisma studio

# Formatter le schema.prisma
npx prisma format

# Valider le schéma
npx prisma validate

# Seed (peupler avec des données de test)
npx prisma db seed
```

---

## 🌿 GIT - GESTION DE VERSION

### Branches
```bash
# Créer et basculer sur une nouvelle branche
git checkout -b feature/nom-de-la-feature

# Exemples :
git checkout -b feature/payment-integration
git checkout -b feature/property-crud
git checkout -b fix/login-bug

# Basculer sur une branche existante
git checkout main
git checkout develop

# Lister toutes les branches
git branch

# Supprimer une branche
git branch -d feature/nom-de-la-feature
```

### Commits
```bash
# Voir l'état des fichiers
git status

# Ajouter tous les fichiers modifiés
git add .

# Ajouter un fichier spécifique
git add app/page.tsx

# Commit
git commit -m "feat: add property CRUD"
git commit -m "fix: resolve login issue"
git commit -m "docs: update README"

# Commit avec description détaillée
git commit -m "feat: add Stripe payment integration" -m "- Add payment API route
- Integrate Stripe webhook
- Create payment form component"
```

### Push/Pull
```bash
# Push vers GitHub
git push origin nom-de-la-branche
git push origin feature/payment-integration

# Pull les dernières modifications
git pull origin main

# Première fois (lier au remote)
git remote add origin https://github.com/username/gestion-locative.git
git push -u origin main
```

### Historique
```bash
# Voir l'historique des commits
git log
git log --oneline
git log --graph --oneline --all

# Voir les différences
git diff
git diff app/page.tsx
```

---

## 📦 NPM - GESTION DES PACKAGES

### Installation
```bash
# Installer une dépendance
npm install nom-du-package

# Exemples :
npm install date-fns
npm install react-icons
npm install @tanstack/react-query

# Installer en dev dependency
npm install -D nom-du-package
npm install -D @types/node
```

### Désinstallation
```bash
# Désinstaller un package
npm uninstall nom-du-package
```

### Nettoyage
```bash
# Supprimer node_modules et réinstaller
rm -rf node_modules
npm install

# Nettoyer le cache
npm cache clean --force

# Mettre à jour les packages
npm update

# Vérifier les vulnérabilités
npm audit
npm audit fix
```

---

## 🏗️ NEXT.JS - BUILD & PRODUCTION

### Développement
```bash
# Lancer le serveur de développement
npm run dev

# Sur un port différent
npm run dev -- -p 3001
```

### Build
```bash
# Build pour production
npm run build

# Lancer en mode production (après build)
npm run start

# Vérifier les types TypeScript
npm run type-check
```

### Lint
```bash
# Linter le code
npm run lint

# Corriger automatiquement
npm run lint -- --fix
```

---

## 🎨 TAILWIND CSS

### Utilitaires
```bash
# Rebuild Tailwind (si problème de cache)
npx tailwindcss -i ./app/globals.css -o ./output.css --watch

# Purger les classes inutilisées
npm run build
```

---

## 🔧 TYPESCRIPT

### Type checking
```bash
# Vérifier les types
npx tsc --noEmit

# Mode watch
npx tsc --noEmit --watch
```

---

## 🧪 TESTS (pour plus tard)

### Jest (si installé)
```bash
# Lancer les tests
npm test

# Mode watch
npm test -- --watch

# Couverture
npm test -- --coverage
```

---

## 🚀 DÉPLOIEMENT VERCEL

### Via CLI
```bash
# Installer Vercel CLI
npm install -g vercel

# Login
vercel login

# Déployer
vercel

# Déployer en production
vercel --prod
```

### Variables d'environnement
```bash
# Ajouter une variable
vercel env add VARIABLE_NAME

# Lister les variables
vercel env ls

# Pull les variables en local
vercel env pull
```

---

## 🔒 SÉCURITÉ

### Générer des secrets
```bash
# Générer un secret pour NextAuth
openssl rand -base64 32

# Générer plusieurs secrets
for i in {1..3}; do openssl rand -base64 32; done
```

---

## 📊 MONITORING & DEBUG

### Logs
```bash
# Voir les logs en développement
npm run dev

# Logs détaillés
DEBUG=* npm run dev

# Logs Next.js
NEXT_TELEMETRY_DEBUG=1 npm run dev
```

### Performance
```bash
# Analyser le bundle
npm run build -- --profile

# Voir la taille du build
du -sh .next
```

---

## 🔄 WORKFLOW COMPLET EXEMPLE

### Créer une nouvelle feature
```bash
# 1. Créer la branche
git checkout -b feature/tenant-dashboard

# 2. Modifier le code...
# Ajouter fichiers, coder la feature

# 3. Modifier Prisma si nécessaire
# Éditer prisma/schema.prisma

# 4. Créer la migration
npx prisma migrate dev --name add_tenant_fields

# 5. Générer le client
npx prisma generate

# 6. Tester
npm run build
npm run dev

# 7. Commit
git add .
git commit -m "feat: add tenant dashboard with stats"

# 8. Push
git push origin feature/tenant-dashboard

# 9. Créer une Pull Request sur GitHub

# 10. Merger et revenir sur main
git checkout main
git pull origin main
git branch -d feature/tenant-dashboard
```

---

## 🆘 COMMANDES DE DÉPANNAGE

### Reset complet
```bash
# Supprimer tout et recommencer
rm -rf node_modules .next
npm install
npx prisma generate
npm run dev
```

### Problème Prisma
```bash
# Regénérer le client
npx prisma generate

# Reset la DB
npx prisma migrate reset

# Push sans migration
npx prisma db push
```

### Problème TypeScript
```bash
# Supprimer cache
rm -rf .next
npm run dev
```

### Problème Git
```bash
# Annuler les modifications
git restore .

# Annuler le dernier commit (garder les changements)
git reset --soft HEAD~1

# Annuler le dernier commit (supprimer les changements)
git reset --hard HEAD~1
```

---

## 📝 TEMPLATES DE COMMIT

```bash
# Features
git commit -m "feat: add user authentication"
git commit -m "feat(api): create property endpoint"

# Fixes
git commit -m "fix: resolve payment bug"
git commit -m "fix(ui): correct button alignment"

# Documentation
git commit -m "docs: update README"
git commit -m "docs: add API documentation"

# Style
git commit -m "style: format code with prettier"

# Refactor
git commit -m "refactor: simplify auth logic"

# Tests
git commit -m "test: add property tests"

# Chore
git commit -m "chore: update dependencies"
git commit -m "chore: configure eslint"
```

---

## 🎯 RACCOURCIS UTILES

```bash
# Alias Git (à ajouter dans ~/.bashrc ou ~/.zshrc)
alias gs='git status'
alias ga='git add .'
alias gc='git commit -m'
alias gp='git push'
alias gl='git log --oneline'
alias gco='git checkout'

# Alias NPM
alias dev='npm run dev'
alias build='npm run build'
alias lint='npm run lint'

# Alias Prisma
alias pm='npx prisma migrate dev --name'
alias pg='npx prisma generate'
alias ps='npx prisma studio'
```

---

## 📞 AIDE & DOCUMENTATION

```bash
# Aide Git
git help
git help commit

# Aide NPM
npm help
npm help install

# Aide Prisma
npx prisma help
npx prisma migrate --help

# Aide Next.js
npx next --help
```

---

**💡 Conseil** : Gardez ce fichier ouvert dans un onglet pour référence rapide !

**🚀 Bon développement !**
