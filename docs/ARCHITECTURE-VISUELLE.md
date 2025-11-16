# 🏗️ Architecture Visuelle - Gestion Locative

## 📊 Vue d'Ensemble du Système

```
┌─────────────────────────────────────────────────────────────────┐
│                      NAVIGATEUR (Frontend)                       │
│                                                                   │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐          │
│  │   Landing    │  │  Dashboard   │  │     Auth     │          │
│  │     Page     │  │  Owner/Tenant│  │ Login/Register│         │
│  └──────────────┘  └──────────────┘  └──────────────┘          │
│                                                                   │
│                    Next.js 14 (React + TypeScript)               │
└─────────────────────────────────────────────────────────────────┘
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                    SERVEUR NEXT.JS (Backend)                     │
│                                                                   │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │                      API ROUTES                             │ │
│  │  /api/auth      /api/properties    /api/payments           │ │
│  │  /api/upload    /api/leases        /api/tenants            │ │
│  └────────────────────────────────────────────────────────────┘ │
│                              ▼                                    │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │                   PRISMA ORM (lib/prisma.ts)                │ │
│  └────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                    POSTGRESQL (Base de Données)                  │
│                                                                   │
│  ┌─────────┐  ┌──────────┐  ┌─────────┐  ┌──────────┐         │
│  │  Users  │  │Properties│  │ Leases  │  │ Payments │         │
│  └─────────┘  └──────────┘  └─────────┘  └──────────┘         │
└─────────────────────────────────────────────────────────────────┘
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                    SERVICES EXTERNES                             │
│                                                                   │
│  ┌──────────┐  ┌───────────┐  ┌────────────┐  ┌──────────┐    │
│  │  Stripe  │  │ Cloudinary│  │   Resend   │  │  Vercel  │    │
│  │(Paiements)│ │  (Images) │  │  (Emails)  │  │ (Hosting)│    │
│  └──────────┘  └───────────┘  └────────────┘  └──────────┘    │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🗂️ Structure des Dossiers (Arborescence Complète)

```
gestion-locative/
│
├── 📁 app/                                    # Application Next.js 14
│   │
│   ├── 🔐 (auth)/                            # Routes d'authentification
│   │   ├── 📄 login/
│   │   │   └── page.tsx                      → /login
│   │   └── 📄 register/
│   │       └── page.tsx                      → /register
│   │
│   ├── 📊 (dashboard)/                       # Dashboards protégés
│   │   │
│   │   ├── 👔 owner/                         # Espace Propriétaire
│   │   │   ├── properties/
│   │   │   │   ├── page.tsx                  → /owner/properties
│   │   │   │   ├── [id]/
│   │   │   │   │   └── page.tsx              → /owner/properties/123
│   │   │   │   └── new/
│   │   │   │       └── page.tsx              → /owner/properties/new
│   │   │   ├── tenants/
│   │   │   │   └── page.tsx                  → /owner/tenants
│   │   │   ├── payments/
│   │   │   │   └── page.tsx                  → /owner/payments
│   │   │   └── layout.tsx                    (Layout propriétaire)
│   │   │
│   │   ├── 🏠 tenant/                        # Espace Locataire
│   │   │   ├── dashboard/
│   │   │   │   └── page.tsx                  → /tenant/dashboard
│   │   │   ├── payments/
│   │   │   │   └── page.tsx                  → /tenant/payments
│   │   │   ├── maintenance/
│   │   │   │   └── page.tsx                  → /tenant/maintenance
│   │   │   └── layout.tsx                    (Layout locataire)
│   │   │
│   │   └── ⚙️  admin/                         # Espace Admin
│   │       ├── users/
│   │       │   └── page.tsx                  → /admin/users
│   │       ├── properties/
│   │       │   └── page.tsx                  → /admin/properties
│   │       └── layout.tsx                    (Layout admin)
│   │
│   ├── 🔌 api/                               # API Routes Backend
│   │   ├── auth/
│   │   │   └── [...nextauth]/
│   │   │       └── route.ts                  → /api/auth/*
│   │   ├── properties/
│   │   │   ├── route.ts                      → GET/POST /api/properties
│   │   │   └── [id]/
│   │   │       └── route.ts                  → PUT/DELETE /api/properties/:id
│   │   ├── leases/
│   │   │   └── route.ts                      → /api/leases
│   │   ├── payments/
│   │   │   ├── route.ts                      → /api/payments
│   │   │   └── webhook/
│   │   │       └── route.ts                  → /api/payments/webhook (Stripe)
│   │   └── upload/
│   │       └── route.ts                      → /api/upload (Cloudinary)
│   │
│   ├── layout.tsx                            (Layout racine global)
│   ├── page.tsx                              → / (Landing page)
│   ├── globals.css                           (Styles globaux Tailwind)
│   └── error.tsx                             (Page d'erreur)
│
├── 🧩 components/                            # Composants réutilisables
│   │
│   ├── 🎨 ui/                                # Composants UI de base
│   │   ├── button.tsx                        (Bouton réutilisable)
│   │   ├── card.tsx                          (Carte)
│   │   ├── input.tsx                         (Input de formulaire)
│   │   ├── modal.tsx                         (Fenêtre modale)
│   │   ├── table.tsx                         (Tableau de données)
│   │   └── toast.tsx                         (Notifications)
│   │
│   ├── 📊 dashboard/                         # Composants dashboard
│   │   ├── stats-card.tsx                    (Carte de statistiques)
│   │   ├── property-list.tsx                 (Liste de biens)
│   │   ├── tenant-card.tsx                   (Carte locataire)
│   │   ├── payment-history.tsx               (Historique paiements)
│   │   └── revenue-chart.tsx                 (Graphique revenus)
│   │
│   ├── 📝 forms/                             # Formulaires
│   │   ├── property-form.tsx                 (Formulaire bien immobilier)
│   │   ├── lease-form.tsx                    (Formulaire bail)
│   │   ├── payment-form.tsx                  (Formulaire paiement)
│   │   ├── maintenance-form.tsx              (Demande maintenance)
│   │   └── user-form.tsx                     (Formulaire utilisateur)
│   │
│   └── 🏗️  layout/                            # Composants de structure
│       ├── header.tsx                        (En-tête avec nav)
│       ├── sidebar.tsx                       (Barre latérale)
│       ├── footer.tsx                        (Pied de page)
│       └── nav.tsx                           (Navigation)
│
├── 🔧 lib/                                   # Utilitaires et configs
│   ├── prisma.ts                             (Client Prisma singleton)
│   ├── auth.ts                               (Configuration NextAuth)
│   ├── stripe.ts                             (Configuration Stripe)
│   ├── cloudinary.ts                         (Configuration Cloudinary)
│   ├── validations.ts                        (Schémas Zod)
│   └── utils.ts                              (Fonctions utilitaires)
│
├── 🗄️  prisma/                                # Base de données
│   ├── schema.prisma                         (Modèles de données)
│   ├── seed.ts                               (Données de test)
│   └── migrations/                           (Historique migrations)
│       └── 20241113_init/
│           └── migration.sql
│
├── 📘 types/                                 # Types TypeScript
│   ├── index.ts                              (Types globaux)
│   ├── user.ts                               (Types User)
│   ├── property.ts                           (Types Property)
│   └── lease.ts                              (Types Lease)
│
├── 🪝 hooks/                                 # Custom React Hooks
│   ├── use-user.ts                           (Hook utilisateur courant)
│   ├── use-properties.ts                     (Hook gestion propriétés)
│   ├── use-toast.ts                          (Hook notifications)
│   └── use-auth.ts                           (Hook authentification)
│
├── 🎨 public/                                # Fichiers statiques
│   ├── images/
│   │   ├── logo.svg
│   │   ├── hero-image.png
│   │   └── placeholder.png
│   ├── favicon.ico
│   └── robots.txt
│
├── ⚙️  .vscode/                               # Configuration VS Code
│   ├── settings.json                         (Paramètres éditeur)
│   └── extensions.json                       (Extensions recommandées)
│
├── 📝 Configuration Files
│   ├── .env                                  (Variables d'environnement - NE PAS COMMIT)
│   ├── .env.example                          (Template variables - À COMMIT)
│   ├── .gitignore                            (Fichiers ignorés par Git)
│   ├── next.config.js                        (Config Next.js)
│   ├── package.json                          (Dépendances npm)
│   ├── tsconfig.json                         (Config TypeScript)
│   ├── tailwind.config.ts                    (Config Tailwind CSS)
│   ├── postcss.config.js                     (Config PostCSS)
│   ├── eslint.config.mjs                     (Config ESLint)
│   └── README.md                             (Documentation projet)
│
└── 📊 Generated Files (ne pas modifier)
    ├── .next/                                (Build Next.js)
    ├── node_modules/                         (Dépendances installées)
    └── package-lock.json                     (Verrouillage versions)
```

---

## 🔄 Flux de Données

### 1. Authentification
```
Utilisateur
    ↓ (login)
app/(auth)/login/page.tsx
    ↓ (form submit)
/api/auth/[...nextauth]/route.ts
    ↓ (NextAuth.js)
Prisma → PostgreSQL (vérification user)
    ↓ (JWT token)
Session stockée
    ↓
Redirection vers dashboard
```

### 2. Créer une Propriété (CRUD)
```
Propriétaire (owner)
    ↓ (clic "Nouvelle propriété")
/owner/properties/new
    ↓ (remplit formulaire)
components/forms/property-form.tsx
    ↓ (validation Zod)
lib/validations.ts
    ↓ (POST request)
/api/properties/route.ts
    ↓ (Prisma create)
PostgreSQL (table properties)
    ↓ (success)
Redirection vers /owner/properties
    ↓
components/dashboard/property-list.tsx (affichage)
```

### 3. Paiement en Ligne
```
Locataire (tenant)
    ↓ (clic "Payer loyer")
/tenant/payments
    ↓ (remplit formulaire)
components/forms/payment-form.tsx
    ↓ (Stripe Checkout)
lib/stripe.ts
    ↓ (redirection Stripe)
Stripe Payment Page (externe)
    ↓ (paiement validé)
Webhook Stripe
    ↓
/api/payments/webhook/route.ts
    ↓ (update DB)
Prisma → PostgreSQL (payment status = PAID)
    ↓ (email confirmation)
lib/resend.ts → Resend API
```

---

## 🎨 Composants par Page

### Landing Page (/)
```
app/page.tsx
├── components/layout/header.tsx
├── Hero Section (inline)
├── Features Section (inline)
├── Pricing Section (inline)
└── components/layout/footer.tsx
```

### Dashboard Propriétaire (/owner/properties)
```
app/(dashboard)/owner/properties/page.tsx
├── app/(dashboard)/owner/layout.tsx
│   ├── components/layout/header.tsx
│   └── components/layout/sidebar.tsx
├── components/dashboard/stats-card.tsx (×4)
└── components/dashboard/property-list.tsx
    └── components/ui/card.tsx (foreach property)
```

### Dashboard Locataire (/tenant/dashboard)
```
app/(dashboard)/tenant/dashboard/page.tsx
├── app/(dashboard)/tenant/layout.tsx
│   ├── components/layout/header.tsx
│   └── components/layout/sidebar.tsx
├── Property Info Section
│   └── components/ui/card.tsx
├── Lease Info Section
│   └── components/ui/card.tsx
└── components/dashboard/payment-history.tsx
```

---

## 📦 Modèles Prisma (Base de Données)

```
┌─────────────────────────────────────────────────────────────┐
│                         USER                                 │
├─────────────────────────────────────────────────────────────┤
│ id          String (PK)                                      │
│ email       String (unique)                                  │
│ name        String                                           │
│ password    String (hashed)                                  │
│ role        Enum (ADMIN, OWNER, TENANT)                     │
│ phone       String?                                          │
│ createdAt   DateTime                                         │
│ updatedAt   DateTime                                         │
└─────────────────────────────────────────────────────────────┘
        │                                    │
        │ ownedProperties                    │ leases
        ▼                                    ▼
┌──────────────────────┐          ┌──────────────────────┐
│      PROPERTY        │          │       LEASE          │
├──────────────────────┤          ├──────────────────────┤
│ id        String(PK) │◄─────────│ propertyId String(FK)│
│ title     String     │          │ tenantId   String(FK)│───┐
│ address   String     │          │ startDate  DateTime  │   │
│ type      Enum       │          │ endDate    DateTime? │   │
│ rentAmount Float     │          │ status     Enum      │   │
│ ownerId   String(FK) │──┐       │ createdAt  DateTime  │   │
│ ...       ...        │  │       └──────────────────────┘   │
└──────────────────────┘  │                  │                │
                          │                  │ payments       │
                          │                  ▼                │
                          │       ┌──────────────────────┐   │
                          │       │      PAYMENT         │   │
                          │       ├──────────────────────┤   │
                          │       │ id       String(PK)  │   │
                          │       │ leaseId  String(FK)  │───┘
                          │       │ amount   Float       │
                          │       │ status   Enum        │
                          └───────│ paidAt   DateTime?   │
                                  │ createdAt DateTime   │
                                  └──────────────────────┘
```

---

## 🚀 Déploiement (Architecture Production)

```
┌─────────────────────────────────────────────────────────────┐
│                        VERCEL CDN                            │
│  (Next.js App déployée - Edge Network Global)               │
└─────────────────────────────────────────────────────────────┘
                              ▼
┌─────────────────────────────────────────────────────────────┐
│               POSTGRESQL (Production)                        │
│  • Supabase / Railway / Neon / AWS RDS                      │
└─────────────────────────────────────────────────────────────┘
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                   SERVICES EXTERNES                          │
├─────────────────────────────────────────────────────────────┤
│  Stripe (Production)  │  Cloudinary  │  Resend              │
└─────────────────────────────────────────────────────────────┘
```

---

## 🔐 Sécurité (Layers)

```
┌──────────────────────────────────────────────────────┐
│ Layer 1: HTTPS + Environment Variables              │
└──────────────────────────────────────────────────────┘
                     ▼
┌──────────────────────────────────────────────────────┐
│ Layer 2: NextAuth.js (JWT + Session)                │
└──────────────────────────────────────────────────────┘
                     ▼
┌──────────────────────────────────────────────────────┐
│ Layer 3: Middleware (Route Protection)              │
└──────────────────────────────────────────────────────┘
                     ▼
┌──────────────────────────────────────────────────────┐
│ Layer 4: Zod Validation (Client + Server)           │
└──────────────────────────────────────────────────────┘
                     ▼
┌──────────────────────────────────────────────────────┐
│ Layer 5: Prisma (SQL Injection Protection)          │
└──────────────────────────────────────────────────────┘
```

---

**🎯 Cette architecture est conçue pour être :**
- ✅ Scalable (peut grandir)
- ✅ Maintenable (facile à maintenir)
- ✅ Sécurisée (protection multi-couches)
- ✅ Performante (Next.js optimisations)
- ✅ Professionnelle (standards de l'industrie)

**Bon développement ! 🚀**
