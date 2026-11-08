# Windows OpenSSH integration

- Follow [the Windows client guide](docs/windows-client.md) for local Codex and Claude Code sessions, desktop connections, IDE extensions, and browser sessions.
- In a PowerShell 7.3+ session, run `& ./tools/Invoke-WindowsOpenSSH.ps1` before using SSH. From Bash or Command Prompt, run `pwsh -NoProfile -File ./tools/Invoke-WindowsOpenSSH.ps1`. The check runs offline.
- Use an existing, independently verified host alias and an explicitly authorized command for connections. Keep host aliases, key material, and credentials local.
- Keep preview archives in evaluation. Put changes to the OpenSSH C code in [HuffmanStacks/openssh-portable](https://github.com/HuffmanStacks/openssh-portable) and record the Windows checks for the exact commit.
