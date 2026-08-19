# LikeMinds Chat SDK for Flutter

Drop-in chat for Flutter apps, on mobile and web. Group chatrooms, 1:1 DMs, polls, voice notes and
reactions.

[![pub](https://img.shields.io/pub/v/likeminds_chat_flutter_core.svg)](https://pub.dev/packages/likeminds_chat_flutter_core)
[![License](https://img.shields.io/badge/license-Apache%202.0-blue.svg)](LICENSE)

**Docs:** https://docs.likeminds.io/

## What you get

Group chatrooms and 1:1 DMs with request, approve, reject, block and rate limits · emoji reactions ·
reply, edit, delete, multi-select · @-mentions · polls · voice notes · images, video, GIFs via Giphy,
PDFs and documents · link previews · chatroom topics · search · explore chatrooms · secret chatrooms
and invites · report and moderation · push notifications.

Beyond that: **Flutter web support** with responsive sizing, swipe-to-reply, a dark theme, custom
chat-bubble builders, and state-message filtering.

## Install

```yaml
dependencies:
  likeminds_chat_flutter_core: ^1.2.2
```

This is a **Melos monorepo**. Two published packages live inside it:

| Package | Path | What it is |
|---|---|---|
| `likeminds_chat_flutter_core` | `lib/packages/core` | Screens, BLoCs, per-screen config, builder, style and settings |
| `likeminds_chat_flutter_ui` | `lib/packages/ui` | Widgets and theme |

The data layer is a separate package:

```yaml
  likeminds_chat_fl: ^1.16.1
```

Source at [likeminds-chat-flutter-data](https://github.com/LikeMindsCommunity/likeminds-chat-flutter-data).

> The standalone [likeminds-chat-flutter-ui](https://github.com/LikeMindsCommunity/likeminds-chat-flutter-ui)
> repo holds a different, unpublished package. The published UI package is the one in this monorepo.

## Samples

`example/` for the main app, `chatbot_example/` for an AI bot participant.

## Requirements

Flutter 3.19 or later.

## Built on

flutter_bloc · media_kit · emoji_picker_flutter · flutter_sound · giphy_get · pdfrx · Firebase ·
amazon_cognito_identity_dart_2

## Contributing

See the org-wide [contributing guide](https://github.com/LikeMindsCommunity/.github/blob/master/.github/CONTRIBUTING.md).
Security issues go to **hi@likeminds.community**, not the issue tracker.

## License

Apache 2.0. See [LICENSE](LICENSE).
