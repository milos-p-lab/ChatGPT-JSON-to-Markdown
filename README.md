# 💬 ChatGPT Export to Markdown

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE) [![PowerShell](https://img.shields.io/badge/powershell-5.1+-blue.svg)](https://docs.microsoft.com/en-us/powershell/scripting/overview?view=powershell-7.2)

## ℹ️ About

A simple PowerShell script that converts exported ChatGPT conversations (`conversations.json`) into a clean, human-readable Markdown document.

> ✍️ **Author:** Miloš Perunović  
> 🗓️ **Date:** 2025-07-16

---

## ✅ Features

- Converts ChatGPT JSON exports into Markdown format.
- **Extracts and includes the exact 📅 date and time for each conversation and message** — information not available in the official `chat.html` export.
- Preserves conversation order and message roles (User / Assistant).
- Generates clean, readable Markdown for easy archiving or publishing.

---

## ⚙️ How It Works

When you export your ChatGPT data from OpenAI, you receive a JSON file (e.g. `conversations.json`) containing all your conversations.

This script:

- Parses the JSON and generates a `.md` file containing your entire chat history in Markdown format.
- Adds precise **conversation and message timestamps**, which are **not included in the default `chat.html` export**.  
  > ✅ This is the main advantage of using this script, as it allows you to know exactly when each chat took place.

---

## ⚙️ Usage

Run the script in PowerShell:

```powershell
.\Convert-ChatGptToMd.ps1 -InputPath "path\to\conversations.json" -OutputPath "path\to\ChatGPT_Export.md"
```

---

## ✅ Example Output

## Chat with ChatGPT

📅 ***2024-12-30 10:55:17***

**[user] [2024-12-30 10:37:31]**

How can I convert my chat history to Markdown?

**[assistant] [2024-12-30 10:37:32]**

You can use this PowerShell script to convert your conversations.json file into Markdown format!

---

## ❔ Why Markdown?

Markdown makes it easy to:

- archive your chat logs
- publish them as articles or blog posts
- keep your notes organized in plain text
- share your conversations without exposing raw JSON data

---

## 🤝 Contributing

- Contributions, suggestions, and improvements are welcome!
- Open an Issue if you encounter bugs or have feature ideas.
- Create a Pull Request if you'd like to improve the script.
- Share feedback or examples of how you're using the script!

---

## 🔧 Requirements

- Windows PowerShell 5.1 or PowerShell Core (7.x)
- No additional modules required

---

## ⚖️ License

MIT License – © 2025 Miloš Perunović
