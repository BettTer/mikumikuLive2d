# MikuMiku 2.0

English | [中文](#中文)

An iOS music keyboard that keeps you on the beat. You tap keys on screen, each key sings one pitch with a vocal sample, and a metronome driven by the backing track decides whether a tap plays right now or gets quantized to the next beat. Built in Swift on AudioKit.

## How it works

**Keyboard.** `MusicKeyboardView` tracks multi-touch itself (`touchesBegan` / `Moved` / `Ended`), stamps each touch with a creation time, and turns it into an `AbstractTouch` that carries the key index and how many beats it has already sounded. Key-to-pitch mapping comes from `ConfigFiles/音乐键对应Pitch.xml`, loaded by `LoadXml` through SwiftyXMLParser.

**Sound.** `AboutAK` is the audio engine. On start it loads one vocal sample per pitch (`Resource/Mp3Files/deng_cut_<pitch>.mp3`) into an AudioKit sampler, chains reverb and delay behind it, and mixes that with an `AKPlayer` that plays the backing track. `MusicConverter` converts note names such as `C#4` to MIDI note numbers and back.

**Timing.** Each backing track is described in `ConfigFiles/伴奏表.xml` as an `AccompanySystem`: file name, BPM, beats per bar, loop length in beats, max recordable beats, a visual theme and a Live2D character name. A metronome loop advances the current beat index and records the timestamp of every beat line. When a key is pressed, `decideIsBelongToWindow()` checks how far the tap is from the last beat line:

- inside the window: the note plays immediately, replacing a held long note if there is one;
- outside the window: the touch is queued and fired on the next beat, so playing slightly off still lands on the grid.

**Screens.** `HomeViewController` lists the backing tracks in a table; `TestInputViewController` is the keyboard playground. Transitions use Hero.

## Layout

```
MikuMiku2.0/
  ConfigFiles/            key-to-pitch table and backing-track table (xlsx source + xml)
  MikuMiku2.0/
    Classes/
      BasicClass/Other/   AboutAK (AudioKit engine), LoopComponent (timer)
      BasicClass/View/    MusicKeyboardView, MusicKeyView, MikuButton
      Model/              AccompanySystem, MusicKeyInfo, NoteInfoModel, AbstractTouch
      ProcessInformation/ LoadXml, MusicConverter
      StaticData/         EnumSet, StaticData
      Main/               HomeViewController, TestInputViewController
    Resource/Accompany/   backing tracks (wav)
    Resource/Mp3Files/    one vocal sample per pitch
  Podfile
```

## About the Live2D part

The data model carries a Live2D character per backing track (`miku` / `hiyori`) and a lip-sync state enum, which is what the keyboard was meant to drive. The Live2D rendering layer itself is not in this repository; what is here is the keyboard, the quantization engine and the backing-track system.

## Build

Xcode, iOS 12.0+, Swift 5, CocoaPods. Run `pod install` in `MikuMiku2.0/` and open `MikuMiku2.0.xcworkspace`. AudioKit is not in the Podfile: add it to the project as a Swift package (`https://github.com/AudioKit/AudioKit`) before building.

---

# 中文

一个让你踩在节拍上的 iOS 音乐键盘。点屏幕上的键，每个键用一段人声采样唱一个音高；一个跟着伴奏走的节拍器决定这次点击是立刻发声，还是量化到下一拍。Swift 写的，音频用 AudioKit。

## 工作原理

**键盘。** `MusicKeyboardView` 自己处理多点触控（`touchesBegan` / `Moved` / `Ended`），给每个触摸记下产生时间，转成一个 `AbstractTouch`，里面带键的索引和这个音已经响了几拍。键和音高的对应关系在 `ConfigFiles/音乐键对应Pitch.xml`，由 `LoadXml` 用 SwiftyXMLParser 读进来。

**发声。** `AboutAK` 是音频引擎。启动时把每个音高对应的一段人声采样（`Resource/Mp3Files/deng_cut_<音高>.mp3`）装进 AudioKit 的采样器，后面串混响和延迟，再和一个播伴奏的 `AKPlayer` 混在一起输出。`MusicConverter` 负责 `C#4` 这类音名和 MIDI 音符号之间的互转。

**节拍。** 每首伴奏在 `ConfigFiles/伴奏表.xml` 里描述成一个 `AccompanySystem`：文件名、BPM、每小节拍数、循环拍数、最多可录拍数、配套视觉主题和 Live2D 角色名。节拍器循环推进当前拍的索引，并记下每条拍线的时间。按键时 `decideIsBelongToWindow()` 看这次点击离上一条拍线多远：

- 在窗口内：立刻发声，如果有正在延音的长音就先停掉它；
- 在窗口外：先排队，到下一拍再触发，弹得稍微不准也能落在格子上。

**页面。** `HomeViewController` 用表格列出所有伴奏；`TestInputViewController` 是键盘的试玩页。转场用 Hero。

## 目录

```
MikuMiku2.0/
  ConfigFiles/            键位音高表和伴奏表（xlsx 原表 + xml）
  MikuMiku2.0/
    Classes/
      BasicClass/Other/   AboutAK（AudioKit 引擎）、LoopComponent（计时器）
      BasicClass/View/    MusicKeyboardView、MusicKeyView、MikuButton
      Model/              AccompanySystem、MusicKeyInfo、NoteInfoModel、AbstractTouch
      ProcessInformation/ LoadXml、MusicConverter
      StaticData/         EnumSet、StaticData
      Main/               HomeViewController、TestInputViewController
    Resource/Accompany/   伴奏（wav）
    Resource/Mp3Files/    每个音高一段人声采样
  Podfile
```

## 关于 Live2D

数据模型里每首伴奏都带一个 Live2D 角色（`miku` / `hiyori`）和一个口型状态枚举，键盘原本就是要驱动它的。Live2D 的渲染层本身不在这个仓库里，这里放的是键盘、量化引擎和伴奏系统。

## 构建

Xcode，iOS 12.0+，Swift 5，CocoaPods。在 `MikuMiku2.0/` 下执行 `pod install`，打开 `MikuMiku2.0.xcworkspace`。AudioKit 不在 Podfile 里：构建前先在 Xcode 里把它作为 Swift Package（`https://github.com/AudioKit/AudioKit`）加进工程。
