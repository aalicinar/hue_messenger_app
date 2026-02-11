# HUE V1 - Phase A Local Mock Spec

## Goal
Ship a TestFlight-ready build with premium UX using only local mock data.

## Locked Decisions
- State management: Riverpod
- UI: Material 3 base + adaptive Cupertino widgets
- Platform priority: iOS first
- V1 scope: 1:1 chat, no media, no voice/video, no groups
- Hue ack action: `Got it`
- Home screen: Hue Box

## Data Model (Local)
- `User { id, name, avatarUrl? }`
- `Chat { id, memberIds, lastPreview, lastAt }`
- `Message { id, chatId, senderId, recipientId, type, text?, category?, templateText?, createdAt, acknowledgedAt? }`
- `Template { id, category, text, isDefault, isHidden, order }`
- `RateLimits { red, yellow, green, blue }`

## UX Rules
- Hue Box opens first.
- Hue bubbles use neutral fill + colored border.
- Ack feels instant and reorders inbox immediately.
- Colors are used only for intent, not for noisy decoration.

## Hue Box Sorting Rules
1. Unacked first
2. Category priority among unacked: Red > Yellow > Green > Blue
3. Newest first inside each bucket
4. Acked items after all unacked, newest first

## Phase A Sprint (7 Days)
1. Day 1: skeleton, theme, mock repository
2. Day 2: Hue Box UI + filter
3. Day 3: sorting correctness + quick ack
4. Day 4: chats + normal message flow
5. Day 5: Hue send sheet + Hue bubble
6. Day 6: ack end-to-end + rate limits
7. Day 7: settings/templates polish

## Done Criteria
- Hue Box is default entry.
- Sorting and category priority are always correct.
- Send + ack interactions are immediate and clear.
- UI feels clean, calm, and product-quality.
