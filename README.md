# FileProviderSandboxFix

**Fixes the crash when attaching files / picking photos on a jailbroken iPad 2 (iOS 9.3.5).**
**Исправляет ошибку при выборе файла или фото (кнопка «+», вложения) на джейлбрейкнутом iPad 2 с iOS 9.3.5.**

## Do you need this? / Вам это нужно?

You need it if, after jailbreaking with Carbon, tapping **"+" in Google Drive** (upload photo/file), or any "attach file" / "choose from Files" button, shows:

> **Couldn't communicate with a helper application**
> **Не удалось установить связь с программой-помощником**
> (Internal error / Внутренняя ошибка)

and everything works again after a reboot *without* running the jailbreak.

Если после джейлбрейка через Carbon при нажатии «+» в Google Drive (или при прикреплении файла) появляется эта ошибка, а без джейлбрейка всё работает, то этот твик для вас.

## Install / Установка

1. Download the `.deb` from [Releases](../../releases).
2. Install it with Cydia/Zebra/Filza or over SSH: `dpkg -i com.fa8fkwv.fileprovidersandboxfix_1.0.0_iphoneos-arm.deb`
3. Respring.

Requires `mobilesubstrate`.

## Tested on / Проверено на

iPad 2 (iPad2,1), iOS 9.3.5 (13G36), jailbreak: [Carbon](http://carbon.sep.lol). Verified: Google Drive "+" opens the picker. Other apps using the same system file picker (e.g. Mail attachments) should be affected the same way, but this has not been verified. Other jailbreaks (Phoenix, p0laris) and other devices are untested.

## Technical details

After the jailbreak, new processes run without a sandbox profile. The system file picker extension `com.apple.UIKit.fileprovider.default` is checked by PlugInKit (`-[PKService checkEnvironment:]`), which calls `sandbox_container_path_for_pid()`, gets `errno = 45` (`ENOTSUP`) and aborts:

```text
plug-in has invalid sandbox or container: error 45 path ?
NSInternalInconsistencyException
```

The host app then fails with `NSCocoaErrorDomain Code=4097`.

The tweak is injected only into `com.apple.UIKit.fileprovider.default` and hooks `sandbox_container_path_for_pid`. If the call fails with `ENOTSUP`, it returns the fallback directory `/var/mobile/Library/Caches/com.apple.UIKit.fileprovider.default` and clears `errno`.

### Limitations

This is a workaround, not a fix of the root cause. The extension still runs without a sandbox; the tweak only makes the PlugInKit check pass. The returned path is a fallback, not the real container.

## Build

Requires Theos and an iOS 9.3 SDK (armv7):

```sh
make package FINALPACKAGE=1
```

## License

MIT, Copyright (c) 2026 FA8FKWV
