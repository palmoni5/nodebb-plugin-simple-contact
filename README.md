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
- Notifies administrators about new submissions
- Lets staff mark requests as handled or delete them
- Supports replying by email
- Supports opening a chat with the requesting user when the sender is registered
- Includes Hebrew and English translations

## Installation

```bash
npm install nodebb-plugin-simple-contact
```

Then activate the plugin in the NodeBB ACP, rebuild, and restart NodeBB.

## Compatibility

- NodeBB `^3.0.0`

## Notes

- Guest users can submit the form by entering their name and email address.
- If a forum username is supplied for a guest submission, the plugin validates that the username exists.
- Email replies use the forum email configuration already set in NodeBB.
