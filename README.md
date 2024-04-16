# Official Flutter SDK for [LikeMinds Chat](https://likeminds.community/)

![LikeMinds Chat SDK Banner](https://example.com/likeminds-chat-sdk-banner.png)

[![CI](https://github.com/likeminds/likeminds-chat-flutter/actions/workflows/ci.yml/badge.svg?branch=master)](https://github.com/likeminds/likeminds-chat-flutter/actions/workflows/ci.yml)
[![Melos](https://img.shields.io/badge/maintained%20with-melos-f700ff.svg?style=flat-square)](https://github.com/invertase/melos)

**Quick Links**

- [Register](https://likeminds.community/chat/trial/) to get an API key for LikeMinds Chat
- [Flutter Chat Integration Guide](https://docs.likeminds.community/chat/Flutter/getting-started)

This repository contains code for our [Flutter](https://flutter.dev/) chat SDK.

**Migration Guide**

For upgrading from V1, please refer to the [Migration Guide](https://likeminds.community/chat/docs/sdk/flutter/guides/migration_guide_1_0/)

## Sample App

Our team has built a master sample app, residing within the example directory of this repository. It is a Flutter app built using our SDK and stands as a showcase for our latest and greatest features. Some of them are -

- **Real-time Messaging**: Enable instant communication between users with real-time messaging capabilities.
- **Group Chats**: Support group conversations with multiple participants, fostering collaboration and community engagement.
- **Private Chats**: Allow users to engage in one-on-one private conversations for more intimate and confidential interactions.
- **Rich Media Sharing**: Facilitate the sharing of images, videos, audio files, and documents within chat conversations.
- **Push Notifications**: Deliver instant notifications to users for new messages, even when they are not actively using the app.
- **Customizable UI**: Offer a range of customizable UI components and themes to match your app's branding and design language.

## Structure

LikeMinds Chat Dart is a monorepo built using [Melos](https://docs.page/invertase/melos). Individual packages can be found in the `packages` directory, while configuration and top-level commands can be found in `melos.yaml`.

To get started, run `bootstrap` after cloning the project.

```shell
melos bootstrap
```

## Packages

We provide a variety of packages depending on the level of customization you want to achieve.

### [`likeminds_chat_fl`](https://github.com/LikeMindsCommunity/LikeMinds-Flutter-Chat-SDK)

A pure Dart package that can be used on any Dart project. It provides a low-level client to access the LikeMinds Chat service.

### [`likeminds_chat_flutter_core`](https://github.com/likeminds/likeminds-chat-flutter/tree/master/packages/likeminds_chat_flutter_core)

This package provides business logic to fetch common things required for integrating LikeMinds Chat into your application. The `core` package allows more customization and hence provides business logic but no UI components.

### [`likeminds_chat_flutter_ui`](https://github.com/likeminds/likeminds-chat-flutter/tree/master/packages/likeminds_chat_flutter)

This library includes both a low-level chat SDK and a set of reusable and customizable UI components.

### [`likeminds_chat_flutter_persistence`](https://github.com/likeminds/likeminds-chat-flutter/tree/master/packages/likeminds_chat_persistence)

This package provides a persistence client for fetching and saving chat data locally. LikeMinds Chat Persistence uses Moor as a disk cache.

## Flutter Chat Tutorial

The best place to start is the [Flutter Chat Tutorial](https://likeminds.community/chat/flutter/tutorial/).
It teaches you how to use this SDK and also shows how to make frequently required changes.

## Example Apps

Every package folder includes a fully functional example with setup instructions.

We also provide a set of sample apps created using the LikeMinds Flutter SDK at [this location](https://github.com/likeminds/flutter-samples).

## Versioning Policy

All of the LikeMinds Chat packages follow [semantic versioning](https://semver.org/).

See our [versioning policy documentation](https://likeminds.community/chat/docs/sdk/flutter/basics/versioning_policy/) for more information.

## We are hiring

We've recently closed a funding round and we keep actively growing.
Our APIs are used by more than a million end-users, and you'll have a chance to make a huge impact on the product within a team of the strongest engineers all over the world.

Check out our current openings and apply via [LikeMinds' website](https://likeminds.community/team/#jobs).
