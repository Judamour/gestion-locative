#!/bin/bash

echo "🚀 Initialisation du projet Gestion Locative"
echo "=============================================="
echo ""

# Couleurs pour les messages
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Nom du projet
PROJECT_NAME="gestion-locative"

echo -e "${BLUE}📦 Étape 1/8 : Création du projet Next.js...${NC}"
npx create-next-app@latest $PROJECT_NAME --typescript --tailwind --eslint --app --src-dir=false --import-alias="@/*" --no-git

cd $PROJECT_NAME

echo -e "${GREEN}✅ Projet Next.js créé${NC}"
echo ""

echo -e "${BLUE}📦 Étape 2/8 : Installation des dépendances...${NC}"
npm install prisma @prisma/client next-auth@beta bcrypt zod stripe resend

echo -e "${BLUE}📦 Installation des types TypeScript...${NC}"
npm install -D @types/bcrypt @types/node

echo -e "${GREEN}✅ Dépendances installées${NC}"
echo ""

echo -e "${BLUE}🗄️  Étape 3/8 : Initialisation de Prisma...${NC}"
npx prisma init

echo -e "${GREEN}✅ Prisma initialisé${NC}"
echo ""

echo -e "${BLUE}📁 Étape 4/8 : Création de la structure des dossiers...${NC}"

# Créer la structure app/
mkdir -p app/\(auth\)/login
mkdir -p app/\(auth\)/register
mkdir -p app/\(dashboard\)/owner/properties/\[id\]
mkdir -p app/\(dashboard\)/owner/properties/new
mkdir -p app/\(dashboard\)/owner/tenants
mkdir -p app/\(dashboard\)/tenant/dashboard
mkdir -p app/\(dashboard\)/tenant/payments
mkdir -p app/\(dashboard\)/admin/users
mkdir -p app/api/auth/\[...nextauth\]
mkdir -p app/api/properties
mkdir -p app/api/payments/webhook
mkdir -p app/api/upload

# Créer la structure components/
mkdir -p components/ui
mkdir -p components/dashboard
mkdir -p components/forms
mkdir -p components/layout

# Créer les autres dossiers
mkdir -p lib
mkdir -p types
mkdir -p hooks
mkdir -p public/images

echo -e "${GREEN}✅ Structure des dossiers créée${NC}"
echo ""

echo -e "${BLUE}📝 Étape 5/8 : Création des fichiers de configuration...${NC}"

# .env.example
cat > .env.example << 'EOF'
# Database
DATABASE_URL="postgresql://user:password@localhost:5432/gestion_locative"

# NextAuth
NEXTAUTH_URL="http://localhost:3000"
NEXTAUTH_SECRET="your-secret-key-here-generate-with-openssl"

# Stripe
STRIPE_SECRET_KEY="sk_test_..."
STRIPE_WEBHOOK_SECRET="whsec_..."
NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY="pk_test_..."

# Cloudinary (pour les uploads d'images)
CLOUDINARY_CLOUD_NAME="your-cloud-name"
CLOUDINARY_API_KEY="your-api-key"
CLOUDINARY_API_SECRET="your-api-secret"

# Resend (pour les emails)
RESEND_API_KEY="re_..."
EOF

# .env (copie de l'example)
cp .env.example .env

# .gitignore (améliorer celui par défaut)
cat >> .gitignore << 'EOF'

# Prisma
prisma/*.db
prisma/*.db-journal

# Environment
.env*.local
EOF

# VS Code settings
mkdir -p .vscode
cat > .vscode/settings.json << 'EOF'
{
  "editor.formatOnSave": true,
  "editor.defaultFormatter": "esbenp.prettier-vscode",
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": "explicit"
  },
  "files.exclude": {
    "**/.next": true,
    "**/node_modules": true
  },
  "typescript.tsdk": "node_modules/typescript/lib",
  "typescript.enablePromptUseWorkspaceTsdk": true
}
EOF

# Extensions recommandées
cat > .vscode/extensions.json << 'EOF'
{
  "recommendations": [
    "esbenp.prettier-vscode",
    "dbaeumer.vscode-eslint",
    "prisma.prisma",
    "bradlc.vscode-tailwindcss",
    "usernamehw.errorlens"
  ]
}
EOF

echo -e "${GREEN}✅ Fichiers de configuration créés${NC}"
echo ""

echo -e "${BLUE}🗄️  Étape 6/8 : Création du schéma Prisma...${NC}"

cat > prisma/schema.prisma << 'EOF'
generator client {
  provider = "prisma-client-js"
}

datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL")
}

enum UserRole {
  ADMIN
  OWNER
  TENANT
}

enum PropertyType {
  APARTMENT
  HOUSE
  STUDIO
  OFFICE
}

enum LeaseStatus {
  ACTIVE
  ENDED
  PENDING
}

enum PaymentStatus {
  PENDING
  PAID
  LATE
  CANCELLED
}

model User {
  id            String    @id @default(cuid())
  email         String    @unique
  name          String
  password      String
  role          UserRole  @default(TENANT)
  phone         String?
  createdAt     DateTime  @default(now())
  updatedAt     DateTime  @updatedAt
  
  // Relations
  ownedProperties Property[] @relation("PropertyOwner")
  leases          Lease[]    @relation("TenantLeases")
  
  @@map("users")
}

model Property {
  id          String       @id @default(cuid())
  title       String
  description String?
  address     String
  city        String
  postalCode  String
  type        PropertyType
  surface     Float
  rooms       Int
  rentAmount  Float
  charges     Float        @default(0)
  deposit     Float
  images      String[]
  createdAt   DateTime     @default(now())
  updatedAt   DateTime     @updatedAt
  
  // Relations
  ownerId     String
  owner       User         @relation("PropertyOwner", fields: [ownerId], references: [id], onDelete: Cascade)
  leases      Lease[]
  
  @@map("properties")
}

model Lease {
  id          String       @id @default(cuid())
  startDate   DateTime
  endDate     DateTime?
  rentAmount  Float
  charges     Float
  deposit     Float
  status      LeaseStatus  @default(PENDING)
  createdAt   DateTime     @default(now())
  updatedAt   DateTime     @updatedAt
  
  // Relations
  propertyId  String
  property    Property     @relation(fields: [propertyId], references: [id], onDelete: Cascade)
  tenantId    String
  tenant      User         @relation("TenantLeases", fields: [tenantId], references: [id], onDelete: Cascade)
  payments    Payment[]
  
  @@map("leases")
}

model Payment {
  id              String        @id @default(cuid())
  amount          Float
  month           DateTime
  status          PaymentStatus @default(PENDING)
  paidAt          DateTime?
  stripePaymentId String?       @unique
  createdAt       DateTime      @default(now())
  updatedAt       DateTime      @updatedAt
  
  // Relations
  leaseId         String
  lease           Lease         @relation(fields: [leaseId], references: [id], onDelete: Cascade)
  
  @@map("payments")
}
EOF

echo -e "${GREEN}✅ Schéma Prisma créé${NC}"
echo ""

echo -e "${BLUE}📝 Étape 7/8 : Création des fichiers de base...${NC}"

# lib/prisma.ts
cat > lib/prisma.ts << 'EOF'
import { PrismaClient } from '@prisma/client'

const globalForPrisma = globalThis as unknown as {
  prisma: PrismaClient | undefined
}

export const prisma = globalForPrisma.prisma ?? new PrismaClient()

if (process.env.NODE_ENV !== 'production') globalForPrisma.prisma = prisma
EOF

# lib/utils.ts
cat > lib/utils.ts << 'EOF'
import { type ClassValue, clsx } from "clsx"
import { twMerge } from "tailwind-merge"

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs))
}

export function formatCurrency(amount: number): string {
  return new Intl.NumberFormat('fr-FR', {
    style: 'currency',
    currency: 'EUR'
  }).format(amount)
}

export function formatDate(date: Date | string): string {
  return new Intl.DateTimeFormat('fr-FR', {
    year: 'numeric',
    month: 'long',
    day: 'numeric'
  }).format(new Date(date))
}
EOF

# types/index.ts
cat > types/index.ts << 'EOF'
import { UserRole, PropertyType, LeaseStatus, PaymentStatus } from '@prisma/client'

export type { UserRole, PropertyType, LeaseStatus, PaymentStatus }

export interface User {
  id: string
  email: string
  name: string
  role: UserRole
  phone?: string
  createdAt: Date
  updatedAt: Date
}

export interface Property {
  id: string
  title: string
  description?: string
  address: string
  city: string
  postalCode: string
  type: PropertyType
  surface: number
  rooms: number
  rentAmount: number
  charges: number
  deposit: number
  images: string[]
  ownerId: string
  createdAt: Date
  updatedAt: Date
}

export interface Lease {
  id: string
  startDate: Date
  endDate?: Date
  rentAmount: number
  charges: number
  deposit: number
  status: LeaseStatus
  propertyId: string
  tenantId: string
  createdAt: Date
  updatedAt: Date
}

export interface Payment {
  id: string
  amount: number
  month: Date
  status: PaymentStatus
  paidAt?: Date
  stripePaymentId?: string
  leaseId: string
  createdAt: Date
  updatedAt: Date
}
EOF

# README.md
cat > README.md << 'EOF'
# 🏠 Gestion Locative - Application SaaS

Application complète de gestion locative construite avec Next.js 14, TypeScript, PostgreSQL et Prisma.

## 🚀 Stack Technique

- **Frontend**: Next.js 14 (App Router), React, TypeScript
- **Styling**: Tailwind CSS
- **Backend**: Next.js API Routes, Prisma ORM
- **Base de données**: PostgreSQL
- **Authentification**: NextAuth.js
- **Paiements**: Stripe
- **Upload**: Cloudinary
- **Emails**: Resend

## 📋 Prérequis

- Node.js 18+ 
- PostgreSQL 14+
- npm ou pnpm

## 🛠️ Installation

1. **Cloner et installer les dépendances**
```bash
npm install
```

2. **Configurer les variables d'environnement**
```bash
cp .env.example .env
# Éditer .env avec vos valeurs
```

3. **Générer le client Prisma**
```bash
npx prisma generate
```

4. **Créer la base de données**
```bash
npx prisma db push
```

5. **Lancer le serveur de développement**
```bash
npm run dev
```

Ouvrir [http://localhost:3000](http://localhost:3000)

## 📁 Structure du Projet

```
├── app/                    # Pages et routes Next.js 14
│   ├── (auth)/            # Routes d'authentification
│   ├── (dashboard)/       # Dashboards (owner, tenant, admin)
│   └── api/               # API Routes
├── components/            # Composants React réutilisables
│   ├── ui/               # Composants UI de base
│   ├── dashboard/        # Composants dashboard
│   ├── forms/            # Formulaires
│   └── layout/           # Header, Footer, Sidebar
├── lib/                  # Utilitaires et configurations
├── prisma/               # Schéma et migrations
├── types/                # Types TypeScript
└── hooks/                # Custom React Hooks
```

## 🎯 Fonctionnalités

### Espace Propriétaire
- ✅ Gestion des biens immobiliers (CRUD)
- ✅ Suivi des locataires
- ✅ Tableau de bord avec statistiques
- ✅ Gestion des paiements

### Espace Locataire
- ✅ Vue du logement et bail
- ✅ Paiement en ligne
- ✅ Accès aux documents
- ✅ Demandes de maintenance

### Espace Admin
- ✅ Gestion des utilisateurs
- ✅ Modération
- ✅ Support client
- ✅ Statistiques globales

## 🗄️ Base de Données

```bash
# Créer une migration
npx prisma migrate dev --name init

# Ouvrir Prisma Studio
npx prisma studio

# Reset la base de données
npx prisma migrate reset
```

## 📝 Scripts Disponibles

```bash
npm run dev          # Lancer en développement
npm run build        # Build pour production
npm run start        # Lancer en production
npm run lint         # Linter le code
npm run type-check   # Vérifier les types TypeScript
```

## 🔒 Sécurité

- Authentification JWT avec NextAuth.js
- Hash des mots de passe avec bcrypt
- Validation avec Zod
- Protection CSRF
- Rate limiting sur les APIs

## 🚀 Déploiement

### Vercel (Recommandé)

1. Push sur GitHub
2. Importer sur Vercel
3. Configurer les variables d'environnement
4. Déployer !

## 📚 Documentation

- [Next.js](https://nextjs.org/docs)
- [Prisma](https://www.prisma.io/docs)
- [NextAuth.js](https://next-auth.js.org)
- [Tailwind CSS](https://tailwindcss.com/docs)

## 🤝 Contribution

Les contributions sont les bienvenues ! 

## 📄 Licence

MIT

---

**Bon développement ! 🚀**
EOF

echo -e "${GREEN}✅ Fichiers de base créés${NC}"
echo ""

echo -e "${BLUE}🎉 Étape 8/8 : Initialisation Git...${NC}"
git init
git add .
git commit -m "🎉 Initial commit - Structure du projet Gestion Locative"

echo -e "${GREEN}✅ Git initialisé${NC}"
echo ""

echo ""
echo "=============================================="
echo -e "${GREEN}🎉 PROJET INITIALISÉ AVEC SUCCÈS ! 🎉${NC}"
echo "=============================================="
echo ""
echo -e "${YELLOW}📍 Prochaines étapes :${NC}"
echo ""
echo "1. Aller dans le projet :"
echo -e "   ${BLUE}cd $PROJECT_NAME${NC}"
echo ""
echo "2. Configurer votre base de données dans .env :"
echo -e "   ${BLUE}nano .env${NC}"
echo ""
echo "3. Créer la base de données :"
echo -e "   ${BLUE}npx prisma db push${NC}"
echo ""
echo "4. Lancer le serveur de développement :"
echo -e "   ${BLUE}npm run dev${NC}"
echo ""
echo "5. Ouvrir votre navigateur :"
echo -e "   ${BLUE}http://localhost:3000${NC}"
echo ""
echo -e "${YELLOW}💡 Conseil :${NC} Installez les extensions VS Code recommandées"
echo "   (un popup apparaîtra automatiquement dans VS Code)"
echo ""
echo -e "${GREEN}Bon développement ! 🚀${NC}"
echo ""
