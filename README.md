# FileProviderSandboxFix

A lightweight MobileSubstrate tweak for jailbroken 32-bit iOS 9.3.5 devices (Phoenix 6.0) that fixes the system file picker / attachment crash in apps like **Mail**, **Google Drive**, and **Safari**.

## The Problem

After activating the Phoenix 6.0 jailbreak on iOS 9.3.5, newly spawned processes do not receive a sandbox profile (`sandboxed=0`). When `com.apple.UIKit.fileprovider.default` starts, `PlugInKit` (`-[PKService checkEnvironment:]`) calls `sandbox_container_path_for_pid()`, receives `errno=45` (`ENOTSUP`), and aborts with:

    plug-in has invalid sandbox or container: error 45 path ?
    NSInternalInconsistencyException

Host apps then fail with `NSCocoaErrorDomain Code=4097` (*"Couldn't communicate with a helper application"*).

## How It Works

The tweak injects **only** into `com.apple.UIKit.fileprovider.default`, hooks `sandbox_container_path_for_pid`, and when the kernel returns `ENOTSUP` (`45`), provides a valid fallback directory (`/var/mobile/Library/Caches/com.apple.UIKit.fileprovider.default`) and clears `errno`.

## Building

Requires [Theos](https://theos.dev/) with an iOS 9.3 SDK (`armv7`):

    make package FINALPACKAGE=1

> **Note for iOS 9.3.5:** If building on WSL/Linux, sign the resulting `.dylib` on-device with `/usr/bin/ldid -S` to avoid invalid code signatures.

## License

MIT — Copyright (c) 2026 FA8FKWV
