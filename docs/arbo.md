gestion-locative/               ← Dossier racine du projet
│
├── .git/                       ← Git (créé automatiquement)
├── .next/                      ← Build Next.js (ignoré par Git)
├── node_modules/               ← Dépendances (ignoré par Git)
│
├── app/                        ← 🔥 CŒUR DE L'APPLICATION (Next.js 14)
│   ├── (auth)/                 ← Route group (pas dans l'URL)
│   │   ├── login/
│   │   │   └── page.tsx
│   │   └── register/
│   │       └── page.tsx
│   │
│   ├── (dashboard)/            ← Route group pour layouts partagés
│   │   ├── owner/
│   │   │   ├── properties/
│   │   │   │   ├── page.tsx           ← /owner/properties
│   │   │   │   ├── [id]/
│   │   │   │   │   └── page.tsx       ← /owner/properties/123
│   │   │   │   └── new/
│   │   │   │       └── page.tsx       ← /owner/properties/new
│   │   │   ├── tenants/
│   │   │   └── layout.tsx             ← Layout spécifique owner
│   │   │
│   │   ├── tenant/
│   │   │   ├── dashboard/
│   │   │   ├── payments/
│   │   │   └── layout.tsx
│   │   │
│   │   └── admin/
│   │       ├── users/
│   │       └── layout.tsx
│   │
│   ├── api/                    ← 🔥 API ROUTES
│   │   ├── auth/
│   │   │   └── [...nextauth]/
│   │   │       └── route.ts
│   │   ├── properties/
│   │   │   └── route.ts                ← POST /api/properties
│   │   ├── payments/
│   │   │   ├── route.ts
│   │   │   └── webhook/
│   │   │       └── route.ts            ← Stripe webhook
│   │   └── upload/
│   │       └── route.ts
│   │
│   ├── layout.tsx              ← Layout racine (tout le site)
│   ├── page.tsx                ← Landing page (/)
│   └── globals.css             ← Styles globaux
│
├── components/                 ← 🔥 COMPOSANTS RÉUTILISABLES
│   ├── ui/                     ← Composants UI de base
│   │   ├── button.tsx
│   │   ├── card.tsx
│   │   ├── input.tsx
│   │   ├── modal.tsx
│   │   └── table.tsx
│   │
│   ├── dashboard/              ← Composants spécifiques dashboard
│   │   ├── stats-card.tsx
│   │   ├── property-list.tsx
│   │   └── payment-history.tsx
│   │
│   ├── forms/                  ← Formulaires
│   │   ├── property-form.tsx
│   │   ├── lease-form.tsx
│   │   └── payment-form.tsx
│   │
│   └── layout/                 ← Composants de structure
│       ├── header.tsx
│       ├── sidebar.tsx
│       └── footer.tsx
│
├── lib/                        ← 🔥 UTILITAIRES ET CONFIGURATIONS
│   ├── prisma.ts               ← Client Prisma singleton
│   ├── auth.ts                 ← Config NextAuth
│   ├── stripe.ts               ← Config Stripe
│   ├── cloudinary.ts           ← Config Cloudinary
│   ├── utils.ts                ← Fonctions utilitaires
│   └── validations.ts          ← Schémas Zod
│
├── prisma/                     ← 🔥 BASE DE DONNÉES
│   ├── schema.prisma           ← Modèles de données
│   ├── seed.ts                 ← Données de test
│   └── migrations/             ← Historique des migrations
│
├── public/                     ← 🔥 FICHIERS STATIQUES
│   ├── images/
│   │   ├── logo.svg
│   │   └── placeholder.png
│   └── favicon.ico
│
├── types/                      ← 🔥 TYPES TYPESCRIPT
│   ├── index.ts                ← Types globaux
│   ├── user.ts
│   ├── property.ts
│   └── lease.ts
│
├── hooks/                      ← Custom React Hooks
│   ├── use-user.ts
│   ├── use-properties.ts
│   └── use-toast.ts
│
├── .env                        ← Variables d'environnement (local)
├── .env.example                ← Template des variables
├── .gitignore                  ← Fichiers à ignorer
├── next.config.js              ← Config Next.js
├── package.json                ← Dépendances
├── tsconfig.json               ← Config TypeScript
├── tailwind.config.ts          ← Config Tailwind
├── postcss.config.js           ← Config PostCSS
└── README.md                   ← Documentation