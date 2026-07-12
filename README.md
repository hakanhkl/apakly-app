# Apakly: Music Marketplace App (Flutter Frontend)

Apakly was a mobile marketplace for music, where listeners could browse artists, buy tracks and albums, stream them with a full background audio player, and own their purchases on-chain. It was a live, published product that processed real purchases from paying users. This repository contains the **Flutter frontend**, the complete mobile app for iOS and Android.

> Apakly was built by two people, **Hakan Hökelekli** and **Ömer Hökelekli**. We collaborated across the whole product, with Hakan focusing mainly on the frontend and Ömer mainly on the backend. This repository is the frontend; the backend lives in a separate repository ([apakly-api](https://github.com/hakanhkl/apakly-api)). The project is no longer active, and this repository is preserved as a portfolio piece.

---

## My role

I led the **frontend** and wrote roughly 90% of this Flutter codebase (~100 Dart files), with my brother Ömer contributing the remaining part alongside his backend work. That covered:

- **App architecture:** feature-based module structure with a clean separation between the API layer, data models, and UI.
- **All user-facing features:** authentication and onboarding, the marketplace and browsing experience, artist profiles, the music library, checkout, and the user profile.
- **The audio player:** a full-screen and mini player with background playback, queue, and seek/repeat controls, backed by a dedicated BLoC for global player state.
- **Backend integration:** a domain-organized REST/HTTP layer, JWT auth with encrypted local storage, and secure media delivery via per-stream signed URLs.
- **Payments:** Stripe and native In-App-Purchase flows.
- **Internationalization:** full German/English localization.

---

## Features

- **Auth & onboarding:** sign-up, email-code verification, login, password reset/change, and a 12-word recovery-phrase screen. Deep links for password reset and song sharing.
- **Marketplace:** browse artists and items in grid/card views, search, recommendations, and full purchase flows for tracks and albums.
- **Artist profiles:** artist pages with feed, singles, albums, releases, and follow.
- **Music library & player:** albums, singles, playlists, and a background audio player streaming via signed URLs.
- **Cart & checkout:** shopping cart with Stripe / In-App-Purchase checkout.
- **User profile:** profile management, an on-chain wallet view linking out to PolygonScan, sharing, and account deletion.

---

## Tech stack

| Area | Choice |
|------|--------|
| Framework | Flutter (Dart SDK 2.19) |
| State management | BLoC (`flutter_bloc`) for global player state; `ValueNotifier` for player UI; `setState` for local screen state |
| Navigation | `go_router` + `uni_links` (deep linking) |
| Networking | `http`, REST/JSON organized by domain |
| Auth & storage | JWT + `flutter_secure_storage` (tokens and recovery phrase encrypted at rest) |
| Payments | `flutter_stripe`, `in_app_purchase` |
| Audio | `just_audio`, `audio_service` (background playback), `audioplayers` |
| i18n | `flutter_localizations` / `intl` (DE & EN) |

---

## Architecture

The `lib/` folder is organized **feature-first**, with cross-cutting layers pulled out so the app doesn't collapse into one big pile of screens:

```
lib/
├── marketplace/      # browse, search, buy flows
├── artist_profile/   # artist pages, feed, releases
├── music/            # albums, singles, playlists
├── music_player/     # full-screen + mini player
├── login/            # auth & onboarding
├── shopping_cart/    # cart & checkout
├── home/             # home feed
├── user/             # profile, wallet view
│
├── http/             # API layer: one module per domain
│                     #   (auth, marketplace, artists, following,
│                     #    player, signed URLs, token handling)
├── objects/          # data models (artist, album, single, song, item)
├── notifiers/        # player-state ValueNotifiers
├── uicomponents/     # reusable widgets (buttons, inputs, popups)
├── config/           # responsive sizing
└── l10n/             # DE/EN localization
```

**Key decisions:**

- **Separation of concerns:** the API layer (`http/`), data models (`objects/`), and UI (feature folders) are kept distinct, so networking changes don't ripple into UI code.
- **Player as a dedicated BLoC:** global playback state (current track, queue, play/pause) is centralized rather than threaded through widgets, so the mini and full-screen players stay in sync.
- **Secure by default:** JWTs and the wallet recovery phrase are stored via `flutter_secure_storage`; audio is served through short-lived per-stream signed URLs rather than static links.

### How the frontend talks to the backend

REST/JSON over `https://api.apakly-app.com`, with a per-domain function-based HTTP layer. Auth is JWT-based (issued on login, stored encrypted, validated server-side). For playback, the app requests a fresh **signed URL** per stream from the backend (an AWS-S3 presigned-URL pattern), which also supports play-count and royalty tracking. The wallet is **provisioned server-side**: on sign-up the backend returns a recovery phrase and a Polygon address; the frontend only displays the phrase and links the address to PolygonScan, and it never holds or signs keys client-side. This repository runs against the Apakly backend API and is preserved to demonstrate the frontend architecture and implementation.

---

## Notes & honest limitations

This is a real, shipped codebase rather than a polished demo, and I would rather be straight about it:

- **State management is mixed** (BLoC + ValueNotifier + setState + some GetX). If I rebuilt it today I would consolidate on one primary approach: the player BLoC is the pattern I would standardize on.
- **No strict repository/service layer** between `http/` and the UI, so some screens call the HTTP functions directly. A repository layer would be the first refactor for testability.

---

## Credits

Built together by **Hakan Hökelekli** ([@hakanhkl](https://github.com/hakanhkl)) and **Ömer Hökelekli**. We worked across the whole product: Hakan mainly on the frontend (this repository), Ömer mainly on the backend, and both of us on the frontend.

## License

Released under the [MIT License](LICENSE).
