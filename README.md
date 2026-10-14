# MikuMiku Live2D

English | [中文](#中文)

An interactive Live2D music app for iOS. You play a vocal keyboard on screen, a Live2D character sings along with lip sync, the stage reacts to the beat, lyrics render over the performance, and a tempo engine keeps every tap on the grid of the backing track. Swift, AudioKit, Live2D.

## Features

- **Vocal keyboard.** Each key sings one pitch with a vocal sample; multi-touch, with long notes held across beats.
- **Live2D character.** Miku and Hiyori models, picked per song. The keyboard drives the character's mouth, so the character sings what you play.
- **Beat visualization.** Each song carries a visual theme, and the stage animates on the beat lines of the backing track.
- **Lyrics.** Lyrics are editable and rendered over the performance.
- **Adaptive tempo.** Taps that land close to a beat line play immediately; taps that are off get quantized to the next beat, so the performance stays in time with the backing track.
- **Backing tracks.** A table of songs with BPM, beats per bar, loop length and max recordable beats; accompaniment can be switched on and off.
- **Screen recording** of the performance for sharing.

## How it works

**Keyboard.** `MusicKeyboardView` tracks multi-touch itself, stamps each touch with a creation time and turns it into an `AbstractTouch` carrying the key index and how many beats it has already sounded. Key-to-pitch mapping lives in `ConfigFiles/音乐键对应Pitch.xml` and is loaded by `LoadXml`.

**Sound.** `AboutAK` is the audio engine. It loads one vocal sample per pitch into an AudioKit sampler, chains reverb and delay behind it, and mixes that with an `AKPlayer` playing the backing track. `MusicConverter` converts note names such as `C#4` to MIDI note numbers and back.

**Tempo.** Each song is an `AccompanySystem` from `ConfigFiles/伴奏表.xml`: file name, BPM, beats per bar, loop length, max recordable beats, visual theme and Live2D model. A metronome loop advances the beat index and records the timestamp of every beat line. On a key press, `decideIsBelongToWindow()` measures the distance to the last beat line: inside the window the note plays now (replacing a held long note), outside it the touch is queued and fired on the next beat.

**Character.** The song's `live2dKind` selects the model, and a `LipStatus` state drives the mouth from the notes being played.

## Layout

```
MikuMiku2.0/
  ConfigFiles/            key-to-pitch table and song table (xlsx source + xml)
  MikuMiku2.0/
    Classes/
      BasicClass/Other/   AboutAK (AudioKit engine), LoopComponent (timer)
      BasicClass/View/    MusicKeyboardView, MusicKeyView, MikuButton
      Model/              AccompanySystem, MusicKeyInfo, NoteInfoModel, AbstractTouch
      ProcessInformation/ LoadXml, MusicConverter
      StaticData/         EnumSet, StaticData
      Main/               HomeViewController (song list), keyboard screen
    Resource/Accompany/   backing tracks (wav)
    Resource/Mp3Files/    one vocal sample per pitch
  Podfile
```

## Build

Xcode, iOS 12.0+, Swift 5, CocoaPods. Run `pod install` in `MikuMiku2.0/` and open `MikuMiku2.0.xcworkspace`.

---

# 中文

一个 iOS 上的互动 Live2D 音乐应用。你在屏幕上弹人声键盘，Live2D 角色跟着你唱并对口型，舞台跟着节拍动，歌词渲染在演出画面上，速度引擎把你每一次点击都对齐到伴奏的节拍格上。Swift、AudioKit、Live2D。

## 功能

- **人声键盘。** 每个键用一段人声采样唱一个音高；多点触控，长音可以跨拍延续。
- **Live2D 角色。** 初音和 Hiyori 两个模型，按歌曲选择。键盘驱动角色的嘴，你弹什么它唱什么。
- **节拍可视化。** 每首歌带一套视觉主题，舞台在伴奏的拍线上做动画。
- **歌词。** 歌词可以编辑，渲染在演出画面上。
- **自适应速度。** 点击落在拍线附近就立刻发声，偏了就量化到下一拍，演奏始终和伴奏合拍。
- **伴奏。** 一张歌曲表，带 BPM、每小节拍数、循环拍数和最多可录拍数；伴奏可以开关。
- **屏幕录制**，把演出录下来分享。

## 工作原理

**键盘。** `MusicKeyboardView` 自己处理多点触控，给每个触摸记下产生时间，转成一个带键索引和已响拍数的 `AbstractTouch`。键和音高的对应关系在 `ConfigFiles/音乐键对应Pitch.xml`，由 `LoadXml` 读入。

**发声。** `AboutAK` 是音频引擎。把每个音高对应的人声采样装进 AudioKit 采样器，后面串混响和延迟，再和一个播伴奏的 `AKPlayer` 混在一起输出。`MusicConverter` 负责 `C#4` 这类音名和 MIDI 音符号互转。

**速度。** 每首歌是 `ConfigFiles/伴奏表.xml` 里的一个 `AccompanySystem`：文件名、BPM、每小节拍数、循环拍数、最多可录拍数、视觉主题和 Live2D 模型。节拍器循环推进当前拍的索引并记下每条拍线的时间。按键时 `decideIsBelongToWindow()` 看这次点击离上一条拍线多远：窗口内立刻发声（有延音的长音就先停掉），窗口外先排队，到下一拍再触发。

**角色。** 歌曲的 `live2dKind` 决定用哪个模型，`LipStatus` 状态根据正在播放的音驱动嘴型。

## 目录

```
MikuMiku2.0/
  ConfigFiles/            键位音高表和歌曲表（xlsx 原表 + xml）
  MikuMiku2.0/
    Classes/
      BasicClass/Other/   AboutAK（AudioKit 引擎）、LoopComponent（计时器）
      BasicClass/View/    MusicKeyboardView、MusicKeyView、MikuButton
      Model/              AccompanySystem、MusicKeyInfo、NoteInfoModel、AbstractTouch
      ProcessInformation/ LoadXml、MusicConverter
      StaticData/         EnumSet、StaticData
      Main/               HomeViewController（歌曲列表）、键盘页
    Resource/Accompany/   伴奏（wav）
    Resource/Mp3Files/    每个音高一段人声采样
  Podfile
```

## 构建

Xcode，iOS 12.0+，Swift 5，CocoaPods。在 `MikuMiku2.0/` 下执行 `pod install`，打开 `MikuMiku2.0.xcworkspace`。
