---
name: voiceclaw
description: "Send voice messages via Signal using OpenAI TTS. Convert your text responses to spoken audio."
requires:
  bins:
    - curl
    - python3
  env:
    - OPENAI_API_KEY
---

# VoiceClaw — Text-to-Speech Voice Messages

You can send voice messages to Skitch on Signal by converting text to speech using the OpenAI TTS API.

## When to Use

- When Skitch explicitly asks you to "say that" or "send that as audio" or "voice message"
- When delivering important alerts or summaries that benefit from audio
- When Skitch asks you to speak or use your voice
- **Do NOT** send voice messages by default — only when requested or for high-priority alerts

## How to Send a Voice Message

Run the helper script:

```bash
bash /root/.openclaw/tools/claw-tts.sh "Your message text here" "+12138843994"
```

### Parameters

| Position | Parameter | Default | Description |
|----------|-----------|---------|-------------|
| 1 | text | (required) | The text to speak |
| 2 | recipient | (required) | Phone number in E.164 format |
| 3 | voice | onyx | Voice ID (see options below) |
| 4 | model | tts-1 | `tts-1` (fast) or `tts-1-hd` (quality) |

### Available Voices

- **onyx** — Deep, authoritative (default, fits your personality)
- **echo** — Balanced male
- **alloy** — Neutral, versatile
- **fable** — Warm, expressive
- **nova** — Energetic female
- **shimmer** — Clear female

### Example: Custom Voice

```bash
bash /root/.openclaw/tools/claw-tts.sh "Good morning Skitch, your solar leads are looking great today." "+12138843994" echo
```

### Example: High Quality

```bash
bash /root/.openclaw/tools/claw-tts.sh "Here is your daily summary." "+12138843994" onyx tts-1-hd
```

## How It Works

1. Text is sent to OpenAI TTS API (`tts-1` model, Opus format)
2. Audio file is generated as OGG Opus (Signal-compatible)
3. File is sent via the signal-cli JSON-RPC daemon (avoids lock conflicts)
4. Temp file is cleaned up automatically

## Cost

- ~$0.003 per average message (~200 characters)
- 1,000 voice messages ≈ $3
- Uses OpenAI API key from config env

## Limitations

- Audio arrives as an attachment, not an inline voice bubble (signal-cli limitation)
- Max text length: ~4096 characters per API call
- Do not send voice messages for every response — text is the default, voice is the exception

## Skitch's Phone Number

`+12138843994` — Always use this as the recipient for Skitch.
