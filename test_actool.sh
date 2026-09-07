#!/bin/bash
DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer
export DEVELOPER_DIR

mkdir -p /tmp/Assets.xcassets/AppIcon.appiconset
cat > /tmp/Assets.xcassets/AppIcon.appiconset/Contents.json << 'JSON'
{
  "images" : [
    {
      "idiom" : "mac",
      "size" : "512x512",
      "scale" : "1x",
      "filename" : "light.png"
    },
    {
      "idiom" : "mac",
      "size" : "512x512",
      "scale" : "1x",
      "filename" : "dark.png",
      "appearances" : [
        {
          "appearance" : "luminosity",
          "value" : "dark"
        }
      ]
    }
  ],
  "info" : {
    "version" : 1,
    "author" : "xcode"
  }
}
JSON

cp InsomneLight.iconset/icon_512x512.png /tmp/Assets.xcassets/AppIcon.appiconset/light.png
cp InsomneDark.iconset/icon_512x512.png /tmp/Assets.xcassets/AppIcon.appiconset/dark.png

mkdir -p /tmp/Res
xcrun actool /tmp/Assets.xcassets --compile /tmp/Res --platform macosx --minimum-deployment-target 13.0 --app-icon AppIcon --output-partial-info-plist /tmp/PartialInfo.plist
ls -la /tmp/Res
