s.boot;
s.quit;
o = Server.default.options;
o.outDevice = "Built-in Output";
o.sampleRate = 44100;
s.boot;

~sound = SoundFile.openRead("/Users/acsmith/workspaces/music/rust/phoneme_morpher/full_phrase.wav");
~sound.inspect;
~buf = ~sound.asBuffer;

y = ~buf.play;
y.free;

(
x = {
  Out.ar([0, 1],
    BufRd.ar(
      numChannels: 1,
      bufnum: ~buf,
      phase: Phasor.ar(
        trig: 0,
        rate: BufRateScale.kr(~buf) * 1,
        start: 0,
        end: BufFrames.kr(~buf)))
  );
}.play;
)

(
/* Granular synthesis:

What do we need for a granular synthesizer?
   1. Source
   2. Envelope
   3. Rate
*/

~grain = {
  var source, envelope, rate;

  rate = 1.0;

  source = BufRd.ar(
    numChannels: 1,
    bufnum: ~buf,
    phase: Phasor.ar(
      trig: 1,
      rate: BufRateScale.kr(~buf) * rate,
      start: Rand(0, BufFrames.kr(~buf)),
      end: BufFrames.kr(~buf)));

  envelope = EnvGen.ar(
      envelope: Env.sine(
        dur: 0.1,
        level: 1),
      doneAction: 2);

  Out.ar([0, 1], source * envelope);
}.play;
)

(
/* Granular synthesis:

What do we need for a granular synthesizer?
   1. Source
   2. Envelope
   3. Rate
*/

~grain = {
  var source, envelope, rate;

  rate = 1.0;

  source = BufRd.ar(
    numChannels: 1,
    bufnum: ~buf,
    phase: Phasor.ar(
      trig: 1,
      rate: BufRateScale.kr(~buf) * rate,
      start: Rand(0, BufFrames.kr(~buf)),
      end: BufFrames.kr(~buf)));

  envelope = EnvGen.ar(
      envelope: Env.sine(
        dur: 0.05,
        level: 1),
      doneAction: 2);

  Out.ar([0, 1], source * envelope);
};

Routine {
  1000.do {|index|
    ~grain.play;
    0.004.wait;
  };
}.play;
)
