#!/bin/bash

set -e

PROJECT_NAME="parts2u-web"

# Optional: blow away existing dir to avoid interactive "not empty" prompt
if [ -d "$PROJECT_NAME" ]; then
  echo "Removing existing $PROJECT_NAME directory..."
  rm -rf "$PROJECT_NAME"
fi

echo "Creating Vite React TS project..."
npm create vite@latest "$PROJECT_NAME" -- --template react-ts

cd "$PROJECT_NAME"

echo "Installing app dependencies..."
npm install react-router-dom @tanstack/react-query zustand

echo "Installing dev dependencies..."
# Ensure SWC plugin is present even if template changes
npm install -D @vitejs/plugin-react-swc

echo "Writing base global CSS..."
cat > src/index.css << 'EOF'
html, body, #root {
  margin: 0;
  padding: 0;
  font-family: -apple-system, system-ui, -ui-sans-serif, sans-serif;
  background: #f5f5f7;
  color: #111827;
  height: 100%;
}

a {
  color: inherit;
  text-decoration: none;
}

*,
*::before,
*::after {
  box-sizing: border-box;
}

.app-shell {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  background: #f5f5f7;
}

.app-main {
  flex: 1;
  max-width: 960px;
  width: 100%;
  margin: 0 auto;
  padding: 24px 16px 32px;
}

.app-header {
  border-bottom: 1px solid #e5e7eb;
  background: #ffffff;
}

.app-header-inner {
  max-width: 960px;
  margin: 0 auto;
  padding: 10px 16px;
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.app-logo {
  font-weight: 600;
  letter-spacing: -0.02em;
}

.app-nav {
  display: flex;
  gap: 8px;
}

.app-nav-link {
  padding: 4px 10px;
  border-radius: 999px;
  font-size: 0.85rem;
  line-height: 1.4;
  border: 1px solid transparent;
  color: #374151;
  background: transparent;
}

.app-nav-link:hover {
  background: #f3f4f6;
}

.app-nav-link--active {
  background: #111827;
  color: #ffffff;
}

.page-heading {
  margin: 0 0 4px;
  font-size: 1.4rem;
  font-weight: 600;
  letter-spacing: -0.02em;
}

.page-subtitle {
  margin: 0 0 16px;
  font-size: 0.9rem;
  color: #6b7280;
}

.card-grid {
  display: grid;
  gap: 12px;
}

@media (min-width: 768px) {
  .card-grid {
    grid-template-columns: repeat(3, minmax(0, 1fr));
  }
}

.card {
  display: block;
  background: #ffffff;
  border-radius: 14px;
  border: 1px solid #e5e7eb;
  padding: 12px 14px;
  box-shadow: 0 1px 2px rgba(15, 23, 42, 0.04);
  transition: box-shadow 0.12s ease, transform 0.12s ease;
}

.card:hover {
  box-shadow: 0 6px 18px rgba(15, 23, 42, 0.08);
  transform: translateY(-1px);
}

.card-title {
  margin: 0 0 2px;
  font-size: 0.95rem;
  font-weight: 500;
}

.card-body {
  margin: 0;
  font-size: 0.82rem;
  color: #6b7280;
}

.box {
  background: #ffffff;
  border-radius: 14px;
  border: 1px solid #e5e7eb;
  padding: 16px;
  font-size: 0.9rem;
  color: #6b7280;
}
EOF

echo "Creating folder structure..."
mkdir -p src/core
mkdir -p src/core-api
mkdir -p src/core-hooks
mkdir -p src/web-ui/components/Layout
mkdir -p src/web-ui/theme
mkdir -p src/web-app/pages
mkdir -p src/config

echo "Creating page components..."

cat > src/web-app/pages/HomePage.tsx << 'EOF'
import React from 'react';
import { Link } from 'react-router-dom';

export function HomePage() {
  return (
    <div>
      <header>
        <h1 className="page-heading">Parts2U</h1>
        <p className="page-subtitle">
          Configure custom stone parts, reuse favorites, and prepare orders.
        </p>
      </header>

      <section className="card-grid">
        <Link to="/new-part" className="card">
          <h2 className="card-title">Start new part</h2>
          <p className="card-body">
            Walk through the wizard to configure a new stone part.
          </p>
        </Link>

        <Link to="/favorites" className="card">
          <h2 className="card-title">Favorites</h2>
          <p className="card-body">
            Reuse your saved configurations and add them to the cart.
          </p>
        </Link>

        <Link to="/cart" className="card">
          <h2 className="card-title">Cart</h2>
          <p className="card-body">
            Review configured parts before sending an order.
          </p>
        </Link>
      </section>
    </div>
  );
}
EOF

cat > src/web-app/pages/NewPartPage.tsx << 'EOF'
import React from 'react';

export function NewPartPage() {
  return (
    <div>
      <h1 className="page-heading">New part</h1>
      <p className="page-subtitle">
        Wizard for configuring a new stone part. Add steps for category,
        dimensions, and material here.
      </p>
      <div className="box">
        Wizard component goes here.
      </div>
    </div>
  );
}
EOF

cat > src/web-app/pages/FavoritesPage.tsx << 'EOF'
import React from 'react';

export function FavoritesPage() {
  return (
    <div>
      <h1 className="page-heading">Favorites</h1>
      <p className="page-subtitle">
        Saved configurations that can be reused and added to the cart.
      </p>
      <div className="box">
        Favorites list goes here.
      </div>
    </div>
  );
}
EOF

cat > src/web-app/pages/CartPage.tsx << 'EOF'
import React from 'react';
import { useCartStore } from '@core-hooks/useCart';

export function CartPage() {
  const items = useCartStore(state => state.items);

  return (
    <div>
      <h1 className="page-heading">Cart</h1>
      {items.length === 0 ? (
        <p className="page-subtitle">Your cart is empty.</p>
      ) : (
        <div className="box">
          <ul style={{ listStyle: 'none', padding: 0, margin: 0 }}>
            {items.map(item => (
              <li
                key={item.id}
                style={{
                  display: 'flex',
                  justifyContent: 'space-between',
                  padding: '6px 0',
                  borderBottom: '1px solid #e5e7eb',
                  fontSize: '0.9rem',
                }}
              >
                <span>{item.partConfigId}</span>
                <span style={{ color: '#6b7280' }}>Qty {item.quantity}</span>
              </li>
            ))}
          </ul>
        </div>
      )}
    </div>
  );
}
EOF

cat > src/web-app/pages/AdminPage.tsx << 'EOF'
import React from 'react';

export function AdminPage() {
  return (
    <div>
      <h1 className="page-heading">Admin</h1>
      <p className="page-subtitle">
        Minimal admin surface to view and toggle featured parts or review orders.
      </p>
      <div className="box">
        Admin table goes here.
      </div>
    </div>
  );
}
EOF

echo "Creating layout components..."

cat > src/web-ui/components/Layout/AppLayout.tsx << 'EOF'
import React from 'react';
import { Header } from './Header';

interface AppLayoutProps {
  children: React.ReactNode;
}

export function AppLayout({ children }: AppLayoutProps) {
  return (
    <div className="app-shell">
      <Header />
      <main className="app-main">
        {children}
      </main>
    </div>
  );
}
EOF

cat > src/web-ui/components/Layout/Header.tsx << 'EOF'
import React from 'react';
import { Link, NavLink } from 'react-router-dom';

function navLinkClass(isActive: boolean) {
  return [
    'app-nav-link',
    isActive ? 'app-nav-link--active' : '',
  ].join(' ').trim();
}

export function Header() {
  return (
    <header className="app-header">
      <div className="app-header-inner">
        <Link to="/" className="app-logo">
          Parts2U
        </Link>
        <nav className="app-nav">
          <NavLink to="/" end className={({ isActive }) => navLinkClass(isActive)}>
            Home
          </NavLink>
          <NavLink to="/new-part" className={({ isActive }) => navLinkClass(isActive)}>
            New part
          </NavLink>
          <NavLink to="/favorites" className={({ isActive }) => navLinkClass(isActive)}>
            Favorites
          </NavLink>
          <NavLink to="/cart" className={({ isActive }) => navLinkClass(isActive)}>
            Cart
          </NavLink>
          <NavLink to="/admin" className={({ isActive }) => navLinkClass(isActive)}>
            Admin
          </NavLink>
        </nav>
      </div>
    </header>
  );
}
EOF

echo "Creating core domain files..."

cat > src/core/types.ts << 'EOF'
export type MaterialId = 'white-quartz';

export interface PartConfig {
  id: string;
  name: string;
  category: 'countertop' | 'backsplash' | 'other';
  lengthMm: number;
  widthMm: number;
  thicknessMm: number;
  materialId: MaterialId;
  createdAt: string;
  updatedAt: string;
}

export interface FavoriteConfig {
  id: string;
  label: string;
  partConfigId: string;
  createdAt: string;
}

export interface CartItem {
  id: string;
  partConfigId: string;
  quantity: number;
}
EOF

cat > src/core/cart.ts << 'EOF'
import { CartItem } from './types';

export function addToCart(cart: CartItem[], item: CartItem): CartItem[] {
  const existing = cart.find(c => c.partConfigId === item.partConfigId);
  if (!existing) return [...cart, item];

  return cart.map(c =>
    c.partConfigId === item.partConfigId
      ? { ...c, quantity: c.quantity + item.quantity }
      : c
  );
}

export function updateQuantity(
  cart: CartItem[],
  itemId: string,
  quantity: number
): CartItem[] {
  if (quantity <= 0) {
    return cart.filter(c => c.id !== itemId);
  }
  return cart.map(c => (c.id === itemId ? { ...c, quantity } : c));
}
EOF

cat > src/core/validation.ts << 'EOF'
import { PartConfig } from './types';

export interface PartValidationResult {
  valid: boolean;
  errors: string[];
}

export function validatePartConfig(input: Partial<PartConfig>): PartValidationResult {
  const errors: string[] = [];

  if (!input.name) errors.push('Name is required.');
  if (!input.category) errors.push('Category is required.');
  if (!input.lengthMm || input.lengthMm <= 0) errors.push('Length must be positive.');
  if (!input.widthMm || input.widthMm <= 0) errors.push('Width must be positive.');
  if (!input.thicknessMm || input.thicknessMm <= 0) {
    errors.push('Thickness must be positive.');
  }

  return { valid: errors.length === 0, errors };
}
EOF

cat > src/core/pricing.ts << 'EOF'
import { PartConfig } from './types';

export function estimatePrice(part: PartConfig): number {
  const area = (part.lengthMm * part.widthMm) / 1_000_000; // m^2
  const baseRatePerM2 = 150; // placeholder value
  return Math.round(area * baseRatePerM2);
}
EOF

echo "Creating hooks..."

cat > src/core-hooks/useCart.ts << 'EOF'
import { create } from 'zustand';
import { CartItem } from '@core/types';
import { addToCart, updateQuantity } from '@core/cart';

interface CartState {
  items: CartItem[];
  addItem: (item: CartItem) => void;
  setQuantity: (id: string, quantity: number) => void;
  clear: () => void;
}

export const useCartStore = create<CartState>((set) => ({
  items: [],
  addItem: (item) =>
    set(state => ({ items: addToCart(state.items, item) })),
  setQuantity: (id, quantity) =>
    set(state => ({ items: updateQuantity(state.items, id, quantity) })),
  clear: () => set({ items: [] }),
}));
EOF

cat > src/core-hooks/useParts.ts << 'EOF'
import { useQuery } from '@tanstack/react-query';
import { getParts } from '@core-api/partsApi';

export function useParts() {
  return useQuery({
    queryKey: ['parts'],
    queryFn: getParts,
  });
}
EOF

cat > src/core-hooks/useFavorites.ts << 'EOF'
import { useQuery } from '@tanstack/react-query';
import { getFavorites } from '@core-api/favoritesApi';

export function useFavorites() {
  return useQuery({
    queryKey: ['favorites'],
    queryFn: getFavorites,
  });
}
EOF

cat > src/core-hooks/useAuth.ts << 'EOF'
import { useState } from 'react';

export function useAuth() {
  const [user] = useState<{ id: string; email: string } | null>({
    id: 'demo-user',
    email: 'demo@example.com',
  });

  return {
    user,
    isAuthenticated: Boolean(user),
    signIn: async () => {},
    signOut: async () => {},
  };
}
EOF

echo "Creating API layer stubs..."

cat > src/core-api/client.ts << 'EOF'
// Placeholder for Supabase, Firebase or REST client setup.
export const apiClient = {
  async get<T>(path: string): Promise<T> {
    // Replace with real HTTP or Supabase client
    throw new Error(`GET ${path} not implemented`);
  },
};
EOF

cat > src/core-api/partsApi.ts << 'EOF'
import type { PartConfig } from '@core/types';

export async function getParts(): Promise<PartConfig[]> {
  // Replace with real call to Supabase or other backend
  return [];
}
EOF

cat > src/core-api/favoritesApi.ts << 'EOF'
import type { FavoriteConfig } from '@core/types';

export async function getFavorites(): Promise<FavoriteConfig[]> {
  // Replace with real call to Supabase or other backend
  return [];
}
EOF

cat > src/core-api/cartApi.ts << 'EOF'
// Placeholder for persisting cart or creating orders.
export async function submitCart() {
  // Replace with real implementation when backend is ready
  return;
}
EOF

echo "Creating config/env helper..."

cat > src/config/env.ts << 'EOF'
interface Env {
  apiUrl: string | undefined;
}

export const env: Env = {
  apiUrl: import.meta.env.VITE_API_URL,
};
EOF

echo "Creating router and App shell..."

cat > src/web-app/router.tsx << 'EOF'
import React from 'react';
import { BrowserRouter, Routes, Route } from 'react-router-dom';
import { AppLayout } from '@web-ui/components/Layout/AppLayout';
import { HomePage } from './pages/HomePage';
import { NewPartPage } from './pages/NewPartPage';
import { FavoritesPage } from './pages/FavoritesPage';
import { CartPage } from './pages/CartPage';
import { AdminPage } from './pages/AdminPage';

export function AppRouter() {
  return (
    <BrowserRouter>
      <AppLayout>
        <Routes>
          <Route path="/" element={<HomePage />} />
          <Route path="/new-part" element={<NewPartPage />} />
          <Route path="/favorites" element={<FavoritesPage />} />
          <Route path="/cart" element={<CartPage />} />
          <Route path="/admin" element={<AdminPage />} />
        </Routes>
      </AppLayout>
    </BrowserRouter>
  );
}
EOF

cat > src/web-app/App.tsx << 'EOF'
import React from 'react';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import { AppRouter } from './router';

const queryClient = new QueryClient();

export function App() {
  return (
    <QueryClientProvider client={queryClient}>
      <AppRouter />
    </QueryClientProvider>
  );
}
EOF

echo "Overwriting src/main.tsx..."

cat > src/main.tsx << 'EOF'
import React from 'react';
import ReactDOM from 'react-dom/client';
import './index.css';
import { App } from './web-app/App';

ReactDOM.createRoot(document.getElementById('root') as HTMLElement).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
);
EOF

echo "Configuring TypeScript path aliases..."

TS_APP_CONFIG=""
if [ -f tsconfig.app.json ]; then
  TS_APP_CONFIG="tsconfig.app.json"
elif [ -f tsconfig.json ]; then
  TS_APP_CONFIG="tsconfig.json"
fi

if [ -n "$TS_APP_CONFIG" ]; then
  cat > "$TS_APP_CONFIG" << 'EOF'
{
  "compilerOptions": {
    "target": "ESNext",
    "useDefineForClassFields": true,
    "lib": ["DOM", "DOM.Iterable", "ESNext"],
    "allowJs": false,
    "skipLibCheck": true,
    "esModuleInterop": true,
    "allowSyntheticDefaultImports": true,
    "strict": true,
    "forceConsistentCasingInFileNames": true,
    "module": "ESNext",
    "moduleResolution": "bundler",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "noEmit": true,
    "jsx": "react-jsx",
    "paths": {
      "@core/*": ["./src/core/*"],
      "@core-api/*": ["./src/core-api/*"],
      "@core-hooks/*": ["./src/core-hooks/*"],
      "@web-ui/*": ["./src/web-ui/*"],
      "@web-app/*": ["./src/web-app/*"]
    }
  },
  "include": ["src"]
}
EOF
fi

echo "Configuring Vite with aliases..."

cat > vite.config.ts << 'EOF'
import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react-swc';
import path from 'path';

export default defineConfig({
  plugins: [react()],
  resolve: {
    alias: {
      '@core': path.resolve(__dirname, './src/core'),
      '@core-api': path.resolve(__dirname, './src/core-api'),
      '@core-hooks': path.resolve(__dirname, './src/core-hooks'),
      '@web-ui': path.resolve(__dirname, './src/web-ui'),
      '@web-app': path.resolve(__dirname, './src/web-app'),
    },
  },
});
EOF

echo "Creating basic Vercel config..."

cat > vercel.json << 'EOF'
{
  "buildCommand": "npm run build",
  "outputDirectory": "dist",
  "framework": "vite"
}
EOF

echo "Setup complete."
echo "Next steps:"
echo "  cd $PROJECT_NAME"
echo "  npm run dev"
