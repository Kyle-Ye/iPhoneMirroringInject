> [!WARNING]
> 
> Educational and testing purposes only. Use at your own risk.
>
> Only tested it on macOS 15 Beta 1(24A5264n)

See detail on https://gist.github.com/Kyle-Ye/e16730b59a733af37083873339b0e7a0

## Preparation

- boot into recovery mode and disable SIP via `csrutil disable`
- disable amfi via `sudo nvram boot-args="amfi_get_out_of_my_way=1"`

## Usage

You can use build.sh and ignore the following steps.

Or you can run the following commands step by step.

1. Build libiPhoneMirroringInject.dylib

```shell
xcodebuild -scheme iPhoneMirroringInject -configuration Release -derivedDataPath output
# Path to libiPhoneMirroringInject.dylib
export IMINJECT_PATH=./output/Build/Products/Release/libiPhoneMirroringInject.dylib
```
> Note: You need to build it with arm64e/x86_64 the same as the target app.
> You can check it by `lipo -info ./output/Build/Products/Release/libiPhoneMirroringInject.dylib`

2. Run the following commands

```shell
cp -R /System/Applications/iPhone\ Mirroring.app ./

codesign --display --xml --entitlements IM.entitlements ./iPhone\ Mirroring.app/Contents/MacOS/iPhone\ Mirroring
plutil -insert "com\.apple\.security\.cs\.allow-dyld-environment-variables" -bool YES IM.entitlements
codesign -s - --deep --force --options=runtime --entitlements IM.entitlements ./iPhone\ Mirroring.app/Contents/MacOS/iPhone\ Mirroring

DYLD_INSERT_LIBRARIES=$IMINJECT_PATH ./iPhone\ Mirroring.app/Contents/MacOS/iPhone\ Mirroring
```

## Credits

Code snippets from [@jjtech](https://github.com/JJTech0130)'s private message with small modification.