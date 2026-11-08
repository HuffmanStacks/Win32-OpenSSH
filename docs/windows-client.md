# Windows OpenSSH for Codex and Claude Code

## Check the local client

Run this from the repository root in a Windows terminal with PowerShell 7.3 or later.

```powershell
pwsh -NoProfile -File ./tools/Invoke-WindowsOpenSSH.ps1
```

The check prints `OPENSSH_CLIENT_OK` and the installed OpenSSH version. It uses the Windows-serviced client by absolute path, restores the Windows common application data path for this process if a launcher omitted `ProgramData`, and parses an offline configuration with host-key checking on and forwarding off. The Windows update channel services the client. [Microsoft OpenSSH guidance](https://learn.microsoft.com/windows-server/administration/openssh/openssh_install_firstuse)

For an authorized command on an existing host with a verified host key, supply that host's SSH alias and the command explicitly. This example uses a placeholder alias.

```powershell
pwsh -NoProfile -File ./tools/Invoke-WindowsOpenSSH.ps1 -HostAlias approved-devbox -RemoteCommand hostname
```

The command uses the user's existing SSH configuration and authentication. It requires a known host key, disables interactive password prompts, terminal allocation, forwarding, and automatic host-key updates, and exits with the SSH command status.

## Where to run it

| Surface | Execution path |
| --- | --- |
| Codex CLI and Claude Code | Open this checkout as a local project and run the Windows command above. Both agents have project instructions in this checkout. |
| VS Code extensions | Run the check in a local Windows terminal with the Codex or Claude Code extension. To select the Windows-serviced client for VS Code Remote - SSH, set `remote.SSH.path` to `C:\\Windows\\System32\\OpenSSH\\ssh.exe` in the relevant VS Code profile. |
| ChatGPT desktop | Run the check from the local project. For a remote project, use Settings → Connections → SSH with an existing verified host alias and an authenticated Codex installation on that host. |
| Claude desktop | Run the check from a local Windows project. For a remote project, add a verified host alias under the SSH tab when choosing the Code environment. |
| Browser and browser extensions | Use an authorized Windows shell connected to ChatGPT Work, or a local Claude Code session through Anthropic's Remote Control. Claude Code can use the Claude in Chrome extension in Chrome or Edge while the shell runs locally. |
| Hosted coding sessions | Open the GitHub fork for source and reviews. SSH commands run in the session's own environment. Use the SSH client supplied by that environment. |

[ChatGPT remote connections](https://learn.chatgpt.com/docs/remote-connections) · [Claude desktop](https://code.claude.com/docs/en/desktop) · [Claude Remote Control](https://code.claude.com/docs/en/remote-control) · [Claude in Chrome](https://code.claude.com/docs/en/chrome) · [VS Code Remote SSH](https://code.visualstudio.com/docs/remote/troubleshooting)

## Evaluate the preview

The official [10.4.0.0p1 Preview](https://github.com/PowerShell/Win32-OpenSSH/releases/tag/10.4.0.0p1-Preview) Windows x64 ZIP is `OpenSSH-Win64.zip`. The publisher's SHA-256 is `b67ff8becd203502190ec42ac7787c24c2cd3325ed7700485fe7a1c83d2a7957`. Microsoft labels this release as a preview. Keep it separate from the Windows-serviced client and treat source fixes as candidates until a clean native build, regression suite, and package integrity checks pass.
