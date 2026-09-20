# NodeBB Simple Contact

A lightweight contact form plugin for NodeBB with:

- a public contact page
- admin notifications for new requests
- an ACP queue for handling requests
- email replies
- optional chat follow-up with registered users

## Features

- Adds a `/contact` page to the forum
- Stores incoming contact requests inside NodeBB
- Notifies administrators about new submissions, collapsing a burst of
  requests into a single notification
- Lets staff mark requests as handled, assign them, and keep internal notes
- Records an activity log per request
- Supports replying by email
- Supports opening a chat with the requesting user when the sender is registered
- Optional terms-acceptance checkbox, configured in the ACP
- Includes Hebrew and English translations

## Installation

```bash
npm install nodebb-plugin-simple-contact
```

Then activate the plugin in the NodeBB ACP, rebuild, and restart NodeBB.

## Compatibility

Declared as `^3.0.0 || ^4.0.0`.

Notification collapsing relies on the `filter:notifications.mergeIds` hook,
which NodeBB added in 4.16.0. On older versions the hook never fires, so each
request produces its own notification; nothing else changes.

## Who can send a request

Submitting is controlled by a `contact:submit` global privilege, editable
under *Manage → Privileges* in the ACP. On first load the plugin grants it to
`registered-users` and `guests`, so an existing forum keeps working as before.
Revoke it from `guests` to make the form members-only.

Submissions are capped at 5 per hour, counted per user, or per IP address for
guests. Requests over the cap get an HTTP 429 and nothing is stored.

## Notes

- Guest users can submit the form by entering their name and email address.
- If a forum username is supplied for a guest submission, the plugin validates
  that the username exists.
- Email replies use the forum email configuration already set in NodeBB.
