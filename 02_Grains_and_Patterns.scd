(
SynthDef(\grain, {
  arg rate = 1.0, dur = 0.05;
  var source, envelope;

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
        dur: dur,
        level: 1),
      doneAction: 2);

  Out.ar([0, 1], source * envelope);
}).add;
)

(
Pbind.new(
  \instrument, \default,
  \dur, Pseq([0.25], inf),
  \degree, Pseq([1, 3, 5, 6], inf)
).play(quant: 0.25);
)

(
Pbind.new(
  \instrument, \grain,
  // \dur, Pseq([0.25, 0.5, 0.125, 0.125], inf),
  \dur, Pseq([0.5, 0.25, 0.25], inf),
  \rate, Prand([0.1, 0.5, 0.75, 1.0, 1.5, 2.0, 2.5, 3.0], inf),
//  \rate, Pseq([0.25, 0.5, 0.75, 1.0, 1.25, 1.5], inf),
).play(quant: 1);
)