# FileProviderSandboxFix

A small MobileSubstrate tweak for jailbroken iOS 9.3.5 (armv7, Carbon) that works around a crash of the system file picker in apps like Google Drive and Mail.

## Problem

After the Carbon jailbreak is run, newly spawned processes do not get a sandbox profile. When `com.apple.UIKit.fileprovider.default` starts, PlugInKit (`-[PKService checkEnvironment:]`) calls `sandbox_container_path_for_pid()`, gets `errno = 45` (`ENOTSUP`) and aborts:

```text
plug-in has invalid sandbox or container: error 45 path ?
NSInternalInconsistencyException
```

The host app then fails with `NSCocoaErrorDomain Code=4097` ("Couldn't communicate with a helper application").

## What the tweak does

It is injected only into `com.apple.UIKit.fileprovider.default` and hooks `sandbox_container_path_for_pid`. If the call fails with `ENOTSUP`, it returns the fallback directory `/var/mobile/Library/Caches/com.apple.UIKit.fileprovider.default` and clears `errno`.

## Limitations

This is a workaround, not a fix of the root cause. The extension still runs without a sandbox; the tweak only makes the PlugInKit check pass. The returned path is a fallback, not the real container.

## Build

Requires Theos and an iOS 9.3 SDK (armv7):

```sh
make package FINALPACKAGE=1
```

If you build on Linux/WSL and get invalid code signature errors, sign the dylib on the device with `ldid -S`.

## License

MIT, Copyright (c) 2026 FA8FKWV

## Tested on

iPad 2 (iPad2,1), iOS 9.3.5 (13G36), jailbroken with [Carbon](http://carbon.sep.lol). Not tested with other jailbreaks (e.g. Phoenix, p0laris).
