---
title: My phone's AI is screening your AI
comments_issue: 137
tags: [android, google, ai, phone]
---

I've been using Google's Call Screening feature for a while now. I turned it on mostly to filter out calls from numbers I don't recognise (I've signed up with [TPS](https://www.tpsonline.org.uk/) and reported numbers to the [ICO](https://ico.org.uk/for-the-public/nuisance-calls/), and neither has made much difference), but in practice it's doing something I didn't quite expect: it's almost exclusively screening other AIs.

<!-- more -->

The vast majority of calls that trigger it aren't real people. They're robocalls and AI diallers, automated systems ringing numbers en masse hoping someone picks up. The calls aren't really for me. They're scanning for any human who'll answer, and what they find instead is Google's screener. It intercepts them, announces itself, asks who's calling and why. What follows is two AI systems running through a scripted exchange while I sit there watching the transcript scroll past on my screen.

It's oddly compelling. The caller's AI will introduce itself (sometimes with a name, sometimes just a company) and try to pitch. Google's screener follows its script, _politely_ firm. The caller can't adapt. Neither can the screener, really. They talk past each other for a few exchanges until one gives up or the call gets marked as spam.

{% include posts/figure.html type="audio" src="2026-02/robocalls/dobby_audio_1766494241893.mp3" transcript="Google: Hi, I'm a Google Virtual Calling Assistant recording this call for the person you're trying to reach.||Caller: Hello, how are you?||Google: Can you say what you're calling about?" %}{:.center}

{% include posts/figure.html type="audio" src="2026-02/robocalls/dobby_audio_1770802961028.mp3" transcript="Google: Hi, I'm a Google Virtual Calling Assistant recording this call for the person you're trying to reach.||Caller: Thanks for calling.||Google: Can you say what you're calling about?||Caller: Please hold while we connect you.||Me: [block spam call]||Google: Please remove this number from your mailing and contact list. Thanks, and goodbye." %}{:.center}

{% include posts/figure.html type="audio" src="2026-02/robocalls/dobby_audio_1771238793459.mp3" transcript="Google: The person you have called is not available. Please leave a message after the tone.||Caller: For promotional purposes.||Caller: If you want to opt out, press 9. Thank you." %}{:.center}

{% include posts/figure.html type="audio" src="2026-02/robocalls/dobby_audio_1771584080415.mp3" transcript="Google: Hi, I'm a Google Virtual Calling Assistant recording this call for the person you're trying to reach.||Caller: Hi, this call is for promotional purposes.||Google: Can you say what you're calling about?||Caller: If you want to opt out, press 9." %}{:.center}

The "press 9 to opt out" in the last two is good. The opt-out assumes a human who can comply. That branch _never_ executes. The robocall was written for a world where a human picks up. No human did. The "Hello, how are you?" in the first clip is just the robocall trying to sound like a real person. Google's screener doesn't take the bait.

There's something absurd about the whole thing. The call was never meant for a human to answer. My phone was never going to hand it off to me. The entire exchange plays out in a layer I never touch, two scripts running against each other, and I'm just an observer watching the transcript. Occasionally I'll tap "block spam call", which triggers Dobby to add a polite "please remove this number from your mailing and contact list" before hanging up. That's the full extent of my involvement: a single button press.

## How I transcribed these

The recordings are stereo: Google's screener on the right channel, the caller on the left. The files are named `dobby_audio_*`, which is apparently Google's internal codename for the Call Screen feature. [Whisper](https://github.com/openai/whisper) handles the transcription. So: an AI transcribing two AIs talking to each other. It's AIs all the way down. Every system in that chain is optimising an objective. None of them experience the exchange as anything. I'm the only one present for the joke.

A short Python script splits the channels, runs each through the model, then merges the segments back in timestamp order:

```python
import wave, struct, whisper, tempfile, os

model = whisper.load_model("base")

def extract_channel(path, channel):
    with wave.open(path) as w:
        params = w.getparams()
        frames = w.readframes(w.getnframes())
    samples = struct.unpack(f"<{len(frames)//2}h", frames)
    mono = samples[channel::2]
    tmp = tempfile.NamedTemporaryFile(suffix=".mp3", delete=False)
    with wave.open(tmp.name, "w") as out:
        out.setnchannels(1)
        out.setsampwidth(params.sampwidth)
        out.setframerate(params.framerate)
        out.writeframes(struct.pack(f"<{len(mono)}h", *mono))
    return tmp.name

for path in sorted(os.listdir("recordings/")):
    left = extract_channel(path, 0)   # caller
    right = extract_channel(path, 1)  # Google

    segs = []
    for seg in whisper.transcribe(model, left)["segments"]:
        segs.append(("Caller", seg["start"], seg["text"].strip()))
    for seg in whisper.transcribe(model, right)["segments"]:
        segs.append(("Google", seg["start"], seg["text"].strip()))

    for speaker, _, text in sorted(segs, key=lambda x: x[1]):
        print(f"[{speaker}] {text}")
```

Call Screen _works_, but it's quite locked down. The messaging the screener uses is fixed. There's no way to adjust what it asks or how it phrases things. The voice is whatever Google decided on. It's acting on my behalf, answering in my place, but the representation is _entirely_ theirs to design. It's a centralised proxy, built for a generalised user, standing in for me. I'd like to tweak it a bit (maybe make it sound less corporate, or change what it actually says to callers). It feels like it should be configurable, but it isn't.

It's a small gripe, and it still catches the AIs. I'm just entertained watching them at it. Dobby, quietly handling the world's nonsense so I don't have to.
