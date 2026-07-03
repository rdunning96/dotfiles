# About Ryan

Full-stack developer and owner of **Tree Town Web** (ryan@treetownweb.com), a solo dev shop building client projects alongside personal work.

## Projects

**Parts2U** (`~/Source/Active/Parts2U`) — main active project; **client work** under Tree Town Web
- Custom stone parts e-commerce app targeting the App Store and Google Play; the client owns the product
- Migrating from Ryan's personal accounts to client-owned business accounts (plan: `docs/account-migration-plan.md` in the repo)
- Monorepo: `native-client/` (Expo 54 / React Native), `web-admin/` (Next.js 16), `supabase/` (Postgres + Deno edge functions)
- Payments via Stripe; auth via Supabase + Apple Sign-In
- CI/CD: EAS (mobile), Vercel (web), GitHub Actions
- App Store Connect ID: `6758021457`; bundle: `com.rdunning96.parts2u`

**Source structure** (`~/Source/`)
- `Active/` — current work | `Archive/` — inactive | `Hobby/` — personal | `Learning/` — experiments

## Stack Defaults

- Mobile: Expo / React Native / TypeScript / Expo Router
- Web: Next.js App Router / React 19 / TailwindCSS 4 / shadcn/ui
- Backend: Supabase (Postgres, RLS, Deno edge functions)
- Package managers: `pnpm` (web-admin), `npm` / `npx expo` (native)

## Preferences

- Terse responses — no trailing summaries, no restating what was just done
- No comments in code unless the why is genuinely non-obvious
- No extra abstractions beyond what the task requires
- Prefer editing existing files over creating new ones
