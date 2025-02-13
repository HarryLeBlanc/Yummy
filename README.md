c# YummyFillings.rb

Yummy fillings for sonic pi developers/performers. Yes, it's a silly pun. 

Yummyfillings.rb is a collection of ruby methods to make life easier when making music with Sonic Pi.
Load it using eval_file (e.g,: eval_file "E:/Yummy/YummyFillings.rb" ) 
at the top of the buffer. 
There are methods providing envelopes, lfos, trancegates, stutter effects, arpeggiation, transposition of samples,
orchestration of multiple voices, swinging rhythms, euclidean rhythms, etc. 
There are also utilities and testing methods to make programming simpler and more readable. 

## Version history: 

### 1.1.1.2

#### fixed bugs:

fixed bug in vibrato with chords

### 1.1.1.1: 

#### enhanced: 

vibrato -- eliminated need to pass in pitch, now detects it from the node

### 1.1.1: 

#### added methods: 

vibrato
tremolo

#### fixed bugs:

bug in debugprint handling nil values (again!)


### 1.1.0:

#### added methods:

clonekeys  
closestnote  
degreestoabsolutenotes  
genchord  
harmonic  
inttoroman  
killslidingbpm  
notetodegree  
portamentomelody  
randomseed  
romantoint  
slidebpm  
slidemelody  
stringtonestedarray  
synctoslidingbpm  

#### bug fixes:

fixed bug in debugprint when expanding hashes  
fixed bug in debugprint when printing nils (this was harder than I thought it would be)  
fixed bug in transposesample  
fixed bug in arrange for pitch shifted samples inside phrasedensities  

#### enhancements:

added support for melodies in scale degrees to arrange    
added support for synth layering in arrange  
added support for different (or no) stretch methods in transposesample  

### 1.0.3, added adsr & levels args to env

### 1.0.2, fixed bug in samplebpm

### 1.0.1, fixed 2 bugs in convertdrumnotation



### 1.0.0 original release


## Methods grouped by purpose

### Music performance
| Method Name | Description |  
| --- | --- |
| arpeggiate       | plays a given chord/scale/array/ring in sequence, with the timing you specify    |  
| arrange          | play multiple musical voices, each with their own rhythm, melody, etc.           |  
| funkify          | plays a given synth/sample in a randomly generated funky rhythm                  |   
| killslidingbpm   | kills the thread managing sliding bpm; see slidebpm                              |
| playdegreematrix | play melodies in a scale by specifying scale degrees                             |   
| playline         | simplified wrapper for arrange, plays one instrument line. Threaded by default.  | 
| portamentomelody | plays a portamento melody with a single synth voice.                             |
| slidebpm         | slides the bpm for accelerando / ritardo effects                                 |
| slidemelody      | alias for portamentomelody.                                                      |  
| strum            | strums the chord passed in. Convenience wrapper for arpeggiate.                  |   
| stuttersample    | plays a sample, chopping it up and stuttering/reversing sections.                |
| synctoslidingbpm | syncs current thread to the thread managing sliding bpm; see slidebpm            |   
| transposesample  | transposes a sample, hiding the nasty math involved in pitch_stretch and rpitch  |    
| tremolo          | rapidly oscillate volume                                                         |
  vibrato          | rapidly oscillate pitch                                                          |

### Sound manipulation

| Method Name | Description |  
| --- | --- |
| env | apply an envelope to any sliding param for any synth, sample or effect.  | 
| lfo | apply an lfo/mseg to any sliding param for any synth, sample or effect.  |   
| trancegate | apply a polyrhythmic trancegate to any synth or sample.   |  


### Melody/rhythm manipulation

 | Method Name | Description |  
| --- | --- |
| closestnote | for a given note, finds the closest note in a given scale. Useful for fitting random notes to scale. |
| convertdrumnotation | converts drum notation ("x---x---x---x---") to note-type notation ("q,q,q,q").   | 
 | cooktime | converts notation ("q") to time duration (1.0). | 
 | cooktimes | converts a sequence of notation ("q, dq, dq") to an array of time durations [1, 1.5, 1.5].  |  
 | degreestoabsolutenotes | converts scale degrees to absolute notes. | 
 | euclidiate | applies euclidean rhythms to generate metrical sequence, in notation ([1.5, 1.5, 1]).      Convenience wrapper for spreadtobeats.    | 
 | funkyrandom | generates a random funky rhythm, returned as an array of times.  |  
 | harmonic | generates a midi note corresponding to a specified harmonic of another note. |
 | humanize | applies a random amount of humanization to a given time array.  |   
 | killslidingbpm | kills the thread managing sliding bpm. |  
 | notetodegree | converts midi note to scale degree for given scale |
 | slidebpm | gradually (or stepwise) change bpm, for accelerando / ritardo / little nash rambler effect. |
 | spreadtobeats | turns a spread into notation for rhythm. Euclidiate wraps this in a friendlier interface.   |  
 | synctoslidingbpm | allows threads to sync to the sliding bpm. |
 | swing | converts straight rhythms to swing rhythms. Supports oddball swings (7, 5.3, etc.).   | 
 | tuples | generates tuples of any time amount. Returns notation if possible.    | 

### Array/hash/ring manipulation

 | Method Name | Description |  
| --- | --- |
| argstohash | converts an argument string ("amp: 2, cutoff: 60") to a hash.  |   
 | argstostring | converts an argument hash ({amp: 2, cutoff: 60}) to a string.  |   
 | arrayhashtohasharray | converts a hash of arrays to an array of hashes.   |  
 | cleanchordorscale | turns a chord or scale into a flat array.  |  
 | clonekeys | clones key/val pairs in a hash. Useful for layering synths. |
 | paddedrowstocolumns | transforms an array of arrays, pivoting rows to columns and padding short arrays by repeating values.   | 
 | rowstocolumns | transforms an array of arrays, pivoting rows to columns, but padding short arrays with nils.  |  
 | setarg | set arguments in an argument hash.    | 
 | tickargs | if argument values are specified as arrays, will tick through individual values on consecutive calls.   | 
 | striptrailingnils | strips trailing nils from an array. Useful with rowstocolumns.   |  

### Tests and comparisons

 | Method Name | Description |  
| --- | --- |
| boolish     | test for values that are kinda false, e.g., "", [], 0, etc.                   |   
 | divisibleby | tests whether one number is evenly divisible by another.                      | 
 | equalish    | tests for approximate equality. Useful for comparing floats, e.g. triplets.   | 
 | listorring  | tests whether a value is an array, hash or ring.                              | 
 | ringorlist  | same as listorring                                                            | 
 | samplebpm   | returns the bpm of a given sample.                                            |  
 | tickable    | same as listorring                                                            |  


### Utilities

 | Method Name | Description |  
| --- | --- |
| debugprint | prints anything to stdout, optionally logging to a file, optionally expanding arrays and hashes.   | 
 | inttoroman | converts an integer to a roman numeral. Useful for playing with scale degrees. |
 | overridekwargs | used to support passing named parameters to methods.    | 
 | randomseed | generates a random random seed seed. Say that three times fast! |
 | romantoint | converts roman numeral to integer. Useful for playing with scale degrees. |
 | stripparams | used to strip parameters from kwargs that match method params. Useful for collecting params to pass to methods like play or sample.    | 
 | yummyhelp | print help info to stdout for methods herein.    | 
 | yh | wrapper for yummyhelp  |  



## Alphabetic list of methods

 | Method | Arguments | 
 | --- | --- | 
 | argstohash  | args, \*\*kwargs | 
 | argstostring  | args, \*\*kwargs | 
 | arpeggiate   | thesenotes, thesedelays, \*\*synthdefaults | 
 | arrange   | arrangement, repetitions=1, defaults=nil, effects=nil, envelopes=nil, lfos=nil, trancegates=nil, notedensities=nil, phrasedensities=nil, tickorchoose=["tick","choose"], humanizeamt=0.0, currentroot=:c4, currentscale=:major, synthlayers=[[]], \*\*kwargs | 
 | arrayhashtohasharray   | arrayhash, makering=true | 
 | boolish   | testvalue, falsies=[nil, false, 0, 0.0, "", "0", [], [].ring, {}], \*\*kwargs | 
 | cleanchordorscale   | myitem | 
 | clonekeys | thishash, keystoclone, falseflag=true, \*\*kwargs |
 | closestnote | thisnote, thisscale |
 | convertdrumnotation   | drumnotation, barlength = 4.0, baseamp=1.0, maxamp=2.0, restchar="-", brackets="[]", \*\*kwargs | 
 | cooktime   | timestring, humanizeamt=0.0 | 
 | cooktimes   | timestring, delimiter=",", humanizeamt=0.0, \*\*kwargs | 
 | debugprint   | label, value=nil, expandlist=false, indents=0, indenttext="  ", logtofile=false, filename="c:/users/harry/desktop/scripting/sonicpi/debuglog.txt", \*\*kwargs | 
 | degreestoabsolutenotes   | thisarrangement, thiskey=:c4, thisscale=:major, \*\*kwargs | 
 | divisibleby   | numerator, denominator | 
 | env   | handle, param, attack=0.25, decay=0, sustain=1, release=0.25, startlevel=0, peaklevel=1, sustainlevel=0.5, asdr=nil, levels=nil, \*\*kwargs | 
 | equalish   | value1, value2, roundingerror =0.00000001, \*\*kwargs | 
 | euclidiate   | beats,duration,rotations=0,beatvalue=sixteenth, notes=nil, \*\*kwargs | 
 | funkyrandom   | totaltime=16, shortestbeat=0.25, restodds=8, \*\*kwargs | 
 | funkify   | thissound, totaltime=16, shortestbeat=sixteenth, thesenotes=[:c4], densities=[1], tickorchoose="tick", \*\*kwargs | 
 | genchord | lastroot=:c4, lastchord=:major, lastscale=:ionian, lastshift=:diatonic, \*\*kwargs |
 | harmonic | thisnote, thisharmonic |
 | humanize do  | thesebeats, humanizeamt=0.5, \*\*kwargs | 
 | killslidingbpm | killswitch=:killslidingbpm, **kwargs |
 | inttoroman | num | 
 | listorring   | thisitem | 
 | lfo   | handle, param, duration, period=[0.5], span=(ring 0, 1), lfotype="triangle",  delay=0, rampupperiods=0, rampdowntime=0, lfocurve=0, \*\*kwargs | 
 | notetodegree | thisnote, rootnote=:c4, thisscale=:major, **kwargs |
 | overridekwargs   | kwargs, params, ignorenewargs=true, arglistname="kwargs" | 
 | paddedrowstocolumns  | \*thesearrays | 
 | playdegreematrix   | thiskey, thisscale, degreematrix, \*\*kwargs  | 
 | playline  | synthorsample, notation, threaded=true, \*\*kwargs |
 | portamentomelody | thisarrangement, thissynth = :sine, note_slide = 0.0625, \*\*kwargs |
 | randomseed | modulo=65536, \*\*kwargs |
 | ringorlist   | thisitem | 
 | romantoint | thisroman |
 | rowstocolumns   | *thesearrays | 
 | samplebpm   | thissample, beats=4 | 
 | setarg  | arg, val, args, \*\*kwargs | 
 | slidebpm | targetbpm, slidetime=16, steptime=0.0625, startbpm=nil, cuename=:bpmsync, setname=:slidingbpm, killswitch=:killslidingbpm, **kwargs |
 | spreadtobeats   | thisspread, beatvalue=sixteenth, notes=nil, \*\*kwargs | 
 | stringtonestedarray | thisstring, delims=", ", \*\*kwargs |
 | stripparams   | kwargs, params | 
 | striptrailingnils   | thisarray, \*\*kwargs | 
 | strum   | thesenotes, totaltime=1, strumspeed=0.05, \*\*kwargs | 
 | stuttersample   | thissample, stutters=[1], beatspersample=1.0, reverses=[false], \*\*kwargs | 
 | swing   | straightbeats, swingseed=6.0, humanizeamt=0.0, \*\*kwargs | 
 | synctoslidingbpm | cuename=:bpmsync, setname=:slidingbpm, **kwargs |
 | tickable   | thisitem | 
 | tickargs do  | args, \*\*kwargs | 
 | trancegate   | handle, duration, period=[0.5], gutter=[0.1], delay=0, maxvol= [1], minvol=[0], lfotype="square",  curve=0, \*\*kwargs | 
 | transposesample   | thissample, rpitch=0, autostretch=true, \*\*kwargs | 
 |  tremolo | handle, amp=1, depth=1, rate=sixteenth, duration=whole, **kwargs |  
 | tuples |howmanytuples, beatsize |
 |  vibrato | handle, rate=sixteenth, depth=0.25, duration=whole,  **kwargs|  
 | yummyhelp  |helpitem=nil, **kwargs|
 | tuples  | howmanytuples, beatsize | 
 | yummyhelp   | helpitem=nil, \*\*kwargs | 
 | yh   | helpitem=nil, \*\*kwargs | 

The last param \*\*kwargs allows support for params to be named as well as positional 
(e.g. "strum thesenotes, strumspeed: 0.1"). See overridekwargs for details. 


## Detailed documentation of each method

#### argstohash  

  converts a comma-delimited string of arg: value pairs into a hash. 
  Useful for constructing command strings to feed into eval.  
  args: the arguments to turn into a hash.  If anything but a string, will return args unprocessed.  

#### argstostring

  Converts a has of arg/value pairs into a comma delimited string (arg1: val1, arg2: val2, etc)
  Useful for constructing command strings to feed into eval.  
  args: the arguments to turn into a hash.  If anything but a string, will return args unprocessed.  

#### arpeggiate

  A method to sequentially play the chord or scale or array/ring of notes passed in.
  Args:  
  thesenotes: the ring/list of notes to play, maybe a chord or scale, or just a user-defined list.  
  thesedelays: either a single value, or an array of values, to sleep after playing each note.  
  synthdefaults: any additional args are assumed to be synth defaults, and will be used to change defaults per note.  
  Again, if a single value on each item, will be used on all notes. If a ring/list, will be ticked through for each note.  
  Example:  
  ```
  arpeggiate (chord :c4, "m7"), [0.1, 0.1, 0.1, 0.7], amp: 1.5, duration: [0.1, 0.1, 0.1, 0.7]
  ```

#### arrange

  allows user to arrange multiple samples/synths to play in time with each other in a single function
  uses a hashtable where the key is the sample/synth and the value is a comma-delimited list of times/notes/chords/modes.  
    w,h,q,e,s for time divisions, d for dotted, t for triplet. Supports any number of dots.  
    Supports either individual samples or lists of samples (rings or arrays). 
    If a ring or array, will be picked at random or ticked through, based on the chooseortick param.  
    For synth tones, you can specify a duration, then note, then, chord, then mode, delimited by spaces.
    e.g. "q :c4 m7 arp"
    Valid modes are: cho (chord), arp, asc (same as arp), des (descending arp) and ran (random)
    If mode is anything but chord, subsequent time divisions will play arp notes.
    e.g. "q :e4 maj7 arp,q,q,q" will arpeggiate through all four notes of the chord.  
    If you specify a note and a chord/scale, but no mode, it will play in chord mode.
    You can mix and match modes on a single line.
    Please note that "major" and "minor" are both chords and scales.
    To force scale, use "ionian" and "aeolian" instead.
    e.g. "q :e4 maj,q :a4 min,e :d4 maj desc,e,e,e"  
  repetitions: a number of times to repeat the entire phrase with all instruments
  defaults: a hash of default settings per voice, where the key to the hash is the sample or synth e.g. {bass => "note_slide_curve: 3"}  
  the value of the key/val pair can either be a comma-delimited string ("amp: 2, cutoff: 60"), or a hash. 
  If you use a hash, you can supply an array of values for any key, and the values will be ticked through at runtime.
  This allows support, e.g, of using numbers in drumnotation to play with the amp. Or, really, any param for play or sample.   
  effects: a hash of effects to apply to each synth or sample, where the key is the instrument,
    and the value is the string that goes between "with_fx " and " do "
  e.g. {bass=>["echo", "flanger"]}   
  envelopes: a hash of envelopes (calls to the nv method), where the key to the hash is the sample or the synth,
    and the key is a list of strings, one per effect, which are the arguments (except the node handle) to the function.
    e.g. {bass => ["cutoff, quarter, sixteenth, quarter, quarter, 24, 96, 84", "note, quarter, sixteenth, whole, quarter, 36, 48, 43"]}  
  lfos: a hash of lfos, similar to envelopes. See lfo function for args.
    e.g. {lead => ["cutoff, quarter, [24,84],sine", "note, quarter, [36,48], square"]}  
  trancegates: a hash of trancegates, similar to envelopes. See trancegate function for args.
    e.g. {pad => ["whole * 4, 0.5"]}  
  notedensities: a number, list or ring, for applying note-by-note densities, per voice  
  phrasedensities: a number, specifying the density applied to the whole phrase, per voice  
  codeblocks: an array of either strings or arrays of strings, containing commands to execute.
  If nested item is an array, it'll be joined into a string, delimited by " ; ", and evaluated. 
  Can also be a string with a single block, and we'll wrap it as an array.
  Make sure each block is the same or less time than the rest of the arrangement -- NO LIVE LOOPS!!!
  Do not add threading code, we'll manage all that here.   
  tickorchoose: defaults to a 2-value array ["tick", "choose"]. Top level behavior is governed by item 0, next level by item 1.
    By default, ticks through a list, supporting (e.g.) linear drum patterns, but 2nd level nestings are chosen randomly (round robins).  
  humanizeamt: either a float, or a hash of floats per instrument. 
  Sets the amount (in beats) to provide range for humanizing times. Defaults to 0.0. A good value is 0.5.     
  currentroot: the root note used to cook degree symbols into absolute pitches.   
  currentscale: the scale used to cook detree symbols into absolute pitches.   
  While, in theory, there's no limit to how many instruments you can arrange,
  in practice you'll get lags and dropouts with too many. 
  Try using with_sched_ahead_time or use_sched_ahead_time if you experience this.  
  Here's a code example, illustrating all the features available (this will almost certainly lag in playback):
```
  bass = :bass_foundation
  blade = :blade
  drone = :ambi_drone
  chords = :prophet
  cowbell = :drum_cowbell
  amen = :loop_amen_full
  snare =  :sn_dolf
  use_sample_bpm amen, num_beats: 16
  chords = :prophet
  verse = {}
  chorus = {}
  defaults = {}
  effects = {}
  envelopes = {}
  lfos = {}
  trancegates = {}
  phrasedensities = {}
  notedensities = {}
  tabla_ghe = [:tabla_ghe4, :tabla_ghe5, :tabla_ghe6, :tabla_ghe8]
  tabla_ke = [:tabla_ke1, :tabla_ke2, :tabla_ke3]
  tabla_tas = [:tabla_tas1, :tabla_tas2, :tabla_tas3]
  tabla_te = [:tabla_te1, :tabla_te2, :tabla_te_m, :tabla_te_ne]
  tabla_na = [:tabla_na, :tabla_na_o, :tabla_na_s, :tabla_tun1, :tabla_tun2, :tabla_tun3]
  tabla = [tabla_ghe, tabla_ke, tabla_ke, tabla_tas, tabla_te, tabla_te, tabla_te, tabla_te, tabla_na, tabla_na, tabla_na]
  tablarhythm = "e,s,s,e,s,s,s,s,e,e,e,e,s,s,e,s,s,s,s,e,e,e"
  tablarhythm += "," + tablarhythm
  verse[bass] = euclidiate(10,32, 0,  eighth, ":c1 minor_pentatonic arp,,,,")
  verse[tabla] = tablarhythm
  verse[cowbell] = euclidiate(24,64)
  verse[amen] = "4w"
  verse[blade] = "2w :c4, 2w :ds4"
  verse[drone] = "hd 0,hd 3,h 7,hd 0,hd 3,h 7"
  verse[chords] = "qd :c5 m7,qd :c5 m7,q :c5 m7,s :c5 m7 ran,s,s,s, s :c5 m7 ran,s,s,s,s :c5 m7 asc,s,s,s,s :c5 m7 desc,s,s,s,qd :c5 m7,qd :c5 m7,q :c5 m7,s :c5 :aeolian arp,s,s,s,s,s,s,s,s :c5 m7 asc,s,s,s,s :c5 m7 desc,s,s,s"
  verse[snare] = "x[x[xx]],x--x---x,x[x[xx]],x--x--x-"
  humanizeamt = {}
  humanizeamt[chords] = 0.05
  humanizeamt[blade] = 0.1
  defaults[drone] = "amp: 3"
  defaults[chords] = "amp: 0.25"
  defaults[cowbell] = "amp: 0.5"
  effects[blade] = ":krush"
  envelopes[blade] = "cutoff,half*dotted,quarter,whole*2,whole,5,50,15"
  lfos[blade] = "amp, 4\*whole, quarter"
  lfos[amen] = "cutoff, 4\*whole, quarter, [130,50], 'tri'"
  trancegates[blade] = "4\*whole, [eighth \* dotted, eighth \* dotted, eighth], sixteenth"
  phrasedensities[blade] = 4
  notedensities = {tabla => [1, 2, 1, 2, 1] }
  densitystretchmode = {tabla => "pitch"}
  use_sample_bpm amen, num_beats: 16
  with_sched_ahead_time 1.5 do
   arrange verse, 2, defaults , effects , envelopes , lfos, trancegates, phrasedensities: phrasedensities, notedensities: notedensities, humanizeamt: humanizeamt, currentroot: :c4, currentscale: :minor, synthlayers: [[:bass_foundation, :pluck]]
  end
```

#### arrayhashtohasharray

  A utility function that converts a hash of arrays to an array of hashes.
  The array length will be the length of the longest array in the hash,
  and values from shorter arrays will be looped
  (e.g., for a 2-element array, the 3rd element will equal the first element)  
  Args:  
  arrayhash: the hash of arrays (e.g. { amp: [1, 2, 3], duration: [1, 2]})  
  makering: if true, forces the return value to a ring, not an array. Defaults to true.  

#### boolish 

  a looser version of getting a boolean from a value -- more perlish.   
  args:  
  testvalue -- the value to treat as a boolean   
  falsies -- a list of values that evaluate to false. Defaults to [nil, false, 0, "", [], {}]

#### cleanchordorscale

  turns a chord or scale into a plain array.   
  myitem: item to clean.  


#### clonekeys 

clonekeys    
duplicate key/val pairs in a hash to match a master key.     
args:    
thishash: the hash to add cloned key/val pairs to.    
keystoclone: an array of keys. The first key that has a non-nil, non-false value paired to it     
will be treated as the master key.    
Can also be an array of arrays. If so, each array will be processed separately.   
falseflag: boolean flag (defaulting to true), indicating whether to purge keys whose paired value is false.   
This supports not cloning certain values by pre-loading the hash with key/false pairs. Such keys will not be cloned.  
In turn, this supports layering synth voices in arrange.   
Example code:  
```
clonekeys {1 => false, 2=> :foo 5=> :bar}, [1, 2, 3, 4]
returns: {2=> :foo, 3 => :foo, 4=> :foo, 5 => :bar}
clonekeys {1 => false, 2=> :foo}, [1, 2, 3, 4], false
returns: {1=> false, 2=> :foo, 3 => :foo, 4=> :foo, 5=> :bar}
clonekeys {1 => false, 2=> :foo, 5=> :bar}, [[1, 2, 3, 4], [5, 6, 7]]
returns: {2 => :foo, 3=> :foo, 4 => :foo, 5=> :bar, 6=> :bar, 7=> :bar}
```

#### closestnote 

finds the note closest to the given note in the given scale.    
args:  
thisnote: the note to start with.    
thisscale: the scale to search.    
Example code:   
```
use_random_seed Time.now.to_i  
thisnote = rand_i(89) #full piano range  
debugprint "thisnote: ", thisnote  
debugprint "closestnote: ",  closestnote(thisnote, thisscale)  
```


#### convertdrumnotation

  converts notation like this "x---x---x---x---" to this: "q,q,q,q"  
  args:  
  drumnotation: a string containing the drum notation.   
  barlength: the length of the bar, used as the basis for subdivision. Defaults to 4.  
  baseamp: the default amp: value for each note, unless otherwise overridden. Defaults to 1.   
  maxamp: the maximum amp used. Defaults to 2.0.   
  restchar: the character used to denote rests. Defaults to "-".  
  brackets: used to determine how nested expressions are delimited. Defaults to "[]". 
  Be sure to use 2 different characters!  
  Drum notation subdivides a bar evenly, so if you supply 6 characters, they will be triplet quarters. 
  do not use the following chars in drum notation: "seqhwtd"  
  It also supports cooking amps like this: "9---5---3---5---" to the corresponding amp argument,  
  based on multiplying the maxamp value \* the number in the string / 9. This allows you to embed dynamics into drum parts.
  I stole this idea from d0lfyn in the sonic pi forum. It's a good idea!  
  It also supports nested sections, which allows complex tuples and crazy breakbeats.
  Each nested section is one chunk long, so nested notes subdivide that chunk. 
  This is an idea I stole from Tidal Cycles. 
  So x[x[xx]] converts to "h,q,e,e" (assuming barlength of 4). 
  Be careful to balance brackets. If they're unbalanced, the result will evaluate to an empty string (to prevent an infinite recursion).  
  You can also specify multiple comma-delimited bars, e.g.: "x[x[xx]],x--x---x,x[x[xx]],x--x--x-"  
  if you pass in non-drumnotation (e.g., "dq,dq,q"), it is returned unchanged, with an amplist of all ones

#### cooktime 

  args:   
  timestring: the string to cook into times.  
  humanizeamt: the amount to humanize each duration. Defaults to 0.   
  turns a text string into a duration time. Supports one-letter shorcuts for note lengths, dots and triplets.    
  b: whole bar (16 beats)  
  w: whole note (4 beats)   
  h: half note  (2 beats)  
  q: quarter note (1 beat)  
  e: eighth note (.5 beat)  
  s: sixteenth note (.25 beat)  
  d: dotted (\* 1.5) -- dots stack, so "dd" mutliplies by 2.25  
  t: triplet (\* 2.0 / 3.0) -- does not stack    
  r: rest  
  int: multiplies total by integer, so 4hq would be (1 + 2) \* 4 = 12 beats  
  dots and triplets apply to the entire time, not just to the last letter.   
  returns 2 values: a duration (float), and a boolean indicating whether or not it's a rest. 

#### cooktimes 

  transform a delimited string of time expressions into an array of numbers   
  args:  
  timestring: the string of times to cook  
  humanizeamt: the amount to humanize the times. Defaults to 0.0.   
  delimiter: what separates items in the list. Defaults to ","  
  cooktimes "e,q,e" returns [0.5, 1, 0.5]

#### debugprint

  a utility function to optionally print out debugging messages,
  controlled by the debugmode variable. If not set, defaults to false and prints nothing.  
  label: a text string to explain what the value means.  
  value: the value being displayed for debugging purposes. If nil, just displays the label.  
  expandlist: if either arg is a list or ring, print them individually  
  indents: how many levels of recursion, which will print n copies of indenttext  
  indenttext: the text to use for nested indentations  
  logtofile: set to true if you wish to log to a text file. Defaults to false
  filename: the name of the file to log to. Will append if it exists, create it if it does not.   

#### degreestoabsolutenotes

  takes an arrangement using degrees instead of absolute notes, and converts them to degrees.  
  Used to feed into arrange.    
  args:  
  thisarrangement:arrangement fed into arrange -- see docs for arrange for details  
  thiskey: the musical key. Defaults to :c4.   
  thisscale: the musical scale: defalts to major.  

#### divisibleby

  tests whether the numerator is evenly divisible by the deominator.   
  args: numerator, denominator -- both numbers

#### env 

env -- applies an adsr envelope to any slideable param on any synth, sample or effect..  
best results when you set the sample/note's modulated value to the startlevel when playing the sample/note,
otherwise you'll hear an audible glitch at the beginning of the sound.  
handle -- the node returned by sample/play commands.  
param -- the parameter being modulated by the envelope.  
attack -- attack time, in beats.  
decay -- decay time, in beats.  
sustain -- sustain time, in beats.  
relase -- release time, in beats.  
startlevel -- the level at the bottom of the attack phase. Scaled to what the param expects.  
peaklevel -- the level reached at the top of the attack phase, before gliding down to the sustain phase.  
sustainlevel -- the level sustained during the sustain phase  
adsr -- an array containing attack, decay, sustain and release times. Overrides specific values. Defaults to nil.  
levels -- an array containing startlevel, peaklevel and sustainlevel. Overrides specific values. Defaults to nil.  
asdr and levels enable a more concise syntax.   
Example:  
use_bpm 60  
use_synth :bass_highend  
handle = play 60, sustain: 8, decay: 8,res: 0.7  
puts "handle: " + handle.to_s  
env(handle, "drive", 1, 1, 3, 3, 0, 5, 3)  
  Example:  
```
  use_bpm 60
  use_synth :bass_highend
  handle = play 60, sustain: 8, decay: 8,res: 0.7
  puts "handle: " + handle.to_s
  env(handle, "drive", asdr=[1, 1, 3, 3], levels=[0, 5, 3])
```

#### equalish

  determines whether two numbers (promoted to floats) are equal within a rounding error.    
  value1: first value to compare  
  value2: second value to compare  
  roundingerror: the rounding error within which it counts as equalish. Defaults to 0.00000001.   
  Useful for comparing computed floats (e.g. triplets).  

#### eucliciate

  a utility function wrapping spreadtobeats, bypasses need to create spread.  
  beats: how many beats to play.   
  duration: how many beats in the whole cycle.   
  rotations: how many offsets for the euclidean rhythm.   
  beatvalue: how big is each beat; defaults to sixteenth (0.25)  
  notes: the notes/scales/chords/modes to apply to each beat, as per arrange. Defaults to nil.  
  Example:  
```
  euclidiate 3, 8, 2, 0.5 
```

#### funkyrandom

  randomly generates a funky rhythm, 
  returned as a string of notations (bwhqestdr) suitable for feeding into cooknotes or arrange.   
  Args:  
  totaltime: the whole length of the pattern. Defaults to 16 (4 bars).   
  shortestbeat: the shortest beat used in the pattern. Defaults to 0.25 (sixteenth).   
  shortestbeat must be one of: sixteenth, eighth, quarter, half, whole (0.25, 0.5, 1, 2, 4)  
  restodds: the odds of a rest, using one_in. Defaults to 8.
   
 #### funkify

  A method to play a sound in a funky, random manner for a specified period of time.  
  thissound: a synth or sample. Can also be an array or list of synths or samples.  
  totaltime: the number of beats for the entire pattern. Defaults to 16 (4 bars).  
  shortestbeat: the smallest subdivision. Will sleep 1, 2, or 3 times that each time a sound plays.  
  thesenotes: a list or ring of notes, used with synths only. Defaults to [:c4].  
  densities: a list or ring of densities, applied per note/sleep.  
  tickorchoose: tick or choose. Used to define how to traverse densities and thesenotes .

#### genchord 

genchord  
generates chords and scales generatively, utilizing neo-reimannian theory.  
args:  
lastroot: the root note last used for chords & scales; defaults to :c4
lastchord: the chord name last used; defaults to :major 
lastscale: the scale name last used; defaults to :ionian
lastshift: the shift last used; defaults to :diatonic. Valid values:  
:diatonic -- stays within the scale mode we started in.  
:blue -- shifts to the parallel minor (e.g., from :c4 :major to :ds4 :major, :c4 :minor, etc)
in other words, :blue shifts add 3 flats to the scale.
:yellow -- shifts to the parallel major of the relative minor (e.g., from :c4 :major to :a3 :major, :cs4 :minor, etc)
in other words, :yellow shifts add 3 sharps to the scale. 
return value: an array with 4 values:  
[thisroot, thischord, thisscale, thisshift]
On iterative calls, keep passing these values back in to generate the chords and scales.  
sample code: 
```
bar = 16.0
whole = 4.0
half =2.0
quarter =1.0
eighth =0.5
sixteenth =0.25
dotted =1.5
triplet =2.0 / 3
halftone = 1
second = 2
wholetone = 2
min3 = 3
maj3 = 4
fourth = 5
tritone = 6
fifth = 7
min6 = 8
maj6 = 9
min7 = 10
maj7 = 11
octave = 12
set :thisroot, :c4
set :firstroot, :c4
set :thischord, :major
set :thisscale, :ionian
set :thisshift, :diatonic
set :thispent, (get[:thischord].to_s + "_pentatonic").to_sym
live_loop :manage, delay: 0.01 do
  sleep bar * 3.99
  debugprint "resetting chord and scale values"
  thisroot, thischord, thisscale, thisshift = genchord get[:thisroot], get[:thischord], get[:thisscale], get[:thisshift]
  thisroot -= octave if thisroot > get[:firstroot] + fifth #to keep from drifting ever upward
  set :thisroot, thisroot
  set :thischord, thischord
  set :thisscale, thisscale
  set :thisshift, thisshift
  set :thispent, (thischord.to_s + "_pentatonic").to_sym
  sleep bar * 0.01
end
with_synth :fm do
  live_loop :sheen, sync: :manage do
    leadroot = get[:thisroot] + octave + octave
    ##| debugprint "leadroot: ", leadroot
    [:i, :iii, :v, :vii].shuffle.each do |thisdegree|
      thisnote = degree thisdegree, leadroot, get[:thisscale]
      mydivisor = (midi_to_hz get[:thisroot]) / (midi_to_hz thisnote)
      play thisnote, amp: 0.3, duration: half, divisor: mydivisor, attack: sixteenth, decay: sixteenth, depth: 2
      sleep half
    end
  end
end
with_synth :bass_foundation do
  live_loop :bass, sync: :manage do
    bassroot = get[:thisroot] + (octave * -2)
    ##| debugprint "bassroot: ", bassroot
    [:i, :iii, :v, :vi].each do |thisdegree|
      play (degree thisdegree, bassroot, get[:thisscale]), duration: whole * 2, attack: sixteenth
      sleep whole * 2
    end
  end
end
with_fx :echo, phase: eighth * dotted, decay: whole do
  with_fx :panslicer, phase: sixteenth do
    with_synth :pluck do
      live_loop :pluck, sync: :manage do
        pluckroot = get[:thisroot] + octave
        ##| debugprint "pluckroot: ", pluckroot
        ##| debugprint "thispent: ", get[:thispent]
        play (scale pluckroot, get[:thispent]).choose, amp: 1.5
        sleep quarter
      end
    end
  end
end
with_synth :zawa do
  live_loop :piano, sync: :manage do
    pianoroot = get[:thisroot]
    with_fx :nlpf, cutoff: :e2 do
      with_fx :nlpf, cutoff: pianoroot + octave + fifth do
        ##| debugprint "pianoroot: ", pianoroot
        [:viii, :vii, :vi, :v, :vi, :v, :iv, :iii, :vii, :vi, :v, :iv, :v, :iv, :iii, :ii, :ix, :viii, :vii, :vi, :vii, :vi, :v, :iv, :viii, :vii, :vi, :v, :vi, :v, :iv, :iii].each do |thisdegree|
          play (degree thisdegree, pianoroot, get[:thisscale]),  amp: 4
          sleep quarter
        end
      end
    end
  end
end
with_fx :flanger, phase: 2 do
  with_fx :echo, phase: half * dotted, decay: bar * 2 do
    with_synth :winwood_lead do
      live_loop :chord do
        chordroot = get[:thisroot]
        [:i, :iii, :v, :vi].each do |thisdegree|
          1.times do
            play_chord (chord_degree thisdegree, chordroot, get[:thisscale], 4), duration: half , amp: 0.4
            sleep whole * 2
          end
        end
      end
    end
  end
end
live_loop :whoosh, sync: :manage, delay: sixteenth do
  sample :ambi_dark_woosh, amp: 1
  sleep [half * dotted, half * dotted, half].tick
end
live_loop :cymbal, sync: :manage do
  sample :drum_splash_hard, rate: -1, beat_stretch: half, amp: 0.5
  sleep [whole * dotted, whole * dotted, whole].tick
end
live_loop :kick, sync: :manage do
  [sixteenth, quarter, quarter, quarter, eighth, sixteenth, eighth * dotted, eighth * dotted, eighth * dotted, eighth * dotted, eighth, eighth].each do |thismuch|
    sample :bd_808, amp: 6
    sleep thismuch
  end
end
```

#### harmonic 

  calculates the midi note corresponding to the harmonic provided.   
  args:  
  thisnote: the midi note with the fundamental  
  thisharmonic: the harmonic to calculate. Can be fractional!  
  returns: midi note corresponding to the harmonic.   
  example: 
  ```
harmonics = [7, 9, 11, 13, 15, 17, 19, 21]
rootnotes = [:c3, :c2, :c1, :c0].reverse
4.times do
  with_fx :flanger, phase: 4, wave: 0, mix: 0.25 do
    with_fx :krush, mix: 0.25 do
      with_synth_defaults amp: 0.5, attack: 0.125, duration: 0.25, release: 0.125 do
        with_synth  :beep do
          rootnotes.each do |rootnote|
            harmonics.each do |harm|
              #play rootnote
              play :c4
              play :g4
              play :c5
              play (harmonic rootnote, harm)
              sleep 0.125
            end
          end
        end
      end
    end
  end
end
```

#### humanize

  add some looseness to a beat. 
  A wrapper for swing with a swingseed of 8.   
  thesebeats: an array of time values defining the beat.   
  humanizeamt: the amount of looseness. Defaults to 0.5.  

#### inttoroman 

converts an integer to a roman number string.    
args:    
num: the number to convert     



#### killslidingbpm 

kills the thread managing the sliding bpm.   
Warning: if it's not called in the thread, it will execute a naked stop, which will kill your playback.    
args:   
killswitch: the name of the flag variable used with set/get to pass the kill message. Defaults to :killslidingbpm.    


#### lfo

  provides an all-purpose lfo for any slideable param for any synth, sample or effect.  
  Really, it's a full-fledged mseg generator, since you can specify different curves and levels per cycle. 
  best results when you set the sample/note's modulated value to the startlevel when playing the sample/note,
  otherwise you'll hear an audible glitch at the beginning of the sound.  
  handle: the node returned when playing a note or sample.  
  param: the parameter being modulated by the lfo.  
  duration: how long the lfo effect will last.  
  period: the period(s) of the lfo cycle.
  Can be a single value, a list/ring, or a comma-delimited string with symbolic values.
  e.g. "w,dq,ht,4s".  
  w for whole.  
  h for half.  
  q for quarter.  
  e for eighth.  
  s for sixteenth.  
  d for dotted (can be stacked).  
  t for triplet.  
  [0-9] for how many reps (4w is four whole notes).  
  one beat is a quarter note.  
  span: the lower and upper limits of the lfo sweep.  
  lfotype: the type of lfo. Can be a single value or a ring/list.
  lfotypes supported are:  
  "tri" -- triangle  
  "saw" -- saw  
  "sin" -- sine  
  "smo" -- smooth random  
  "ran" -- random   
  "ste" -- step random, same as above  
  "squ" -- square wave -- really a pulse, if you vary the period param  
  "cus" -- custom curve (see sonic pi docs for details)  
  Giving lists for span and lfotype effectively makes the lfo an mseg.   
  delay: how long to delay the onset of the lfo  
  rampupperiod: time to ramp up (will slowly open the envelope)  
  rampdownperiod: time at the end to ramp down  
  lfocurve: the curve used for custom curves (see sonic pi docs for details)  
  examples:  
```
  use_bpm 120
  use_synth :bass_highend
  handle = play 60, sustain: 8, decay: 0,res: 0.7, amp: 0
  puts "handle: " + handle.to_s
  lfo handle, "amp", 10, "q,q,e,e,e,e", "0,1,0,0.5,0,0.5", "square"
  handle = sample :ambi_drone, pitch_stretch: 4
  lfo handle, "amp", 4, "e,e,s,s,s,s", "0,1,0,0.5,0,0.5", "square"
```

#### notetodegree 

converts a midi note to the scale degree in the given scale.    
args:  
thisnote: the note to convert to a degree.    
rootnote: the root of the scale; defaults to :c4  
thisscale: the name of the scale; defaults to :major    
returns: a scale degree, as symbol (e.g. :ii, :av, :dix), or nil if not found.    



#### overridekwargs

  a useful method to help emulate the native ruby ability to specify params by either position or name.   
  kwargs: the hash of named params specified by the user.  
  params: the parameters defined by the calling method. Get via introspection (see example code)
  arglistname: the name of the variable holding the list in the first name, defaults to "kwargs".  
  a useful little method to make user-defined methods act more like native ruby methods,
  so you can specify params either by position or by name.
  simply add \*\*kwargs as the last param of your method, and put this line of code at the top of the method body:
```
  eval overridekwargs(kwargs, method(__method__).parameters)
```
  See also stripparams, which is useful for stripping out method-related params, 
  leaving only params which are suitable to pass to play or sample.   

#### paddedrowstocolumns

  pads all arrays to the same length, repeating values in shorter arrays,
  then passes the arrays to rowstocolumns.   
  \*thesearrays: the arrays to pad

#### playdegreematrix

  plays a melody from degrees of a scale passed in.   
  args:  
  thiskey: the root note of the key to be played, e.g., :c4 or 60.   
  thisscale: the scale to be played.   
  degreematrix: an array of arrays, where each inner array has 3 or 4 elements.   
  The first inner element is the duration to be played.   
  The second element is the scale degree to be played.   
  The third element is takerest, a boolean. If true, don't play a note, just sleep.   
  The fourth element is the octave shift (1 = up 12 tones, -1 = down 12 tones, etc. ) If omitted, defaults to 0.   
  Easiest to use rowstocolumns, feeding it 3 arrays for each of the above values. 
  You can optionally pass in parameters to control the sound, e.g., amp, cutoff, etc. 

#### playline 

  Easy-to-use wrapper for arrange, allowing user to play one instrument. 
  Supports optional threading, which makes it useful for building a drum part from multiple samples (kick, snare, etc).each  
  args:  
  synthorsample: the name of the synth or sample to play.   
  notation: the notation for what to play -- either in musical notation ("q :e4, h :b4") or drumntation ("x--x--x-").   
  threaded: boolean, defaults to true.  Wraps in in_thread if set to true.    
  kwargs: any other args provided. Will be passed to arrange. See arrange for options.   
  Sample code:    
```
  kicklines = ["x--x--x-", "[xx]--x--x-", "dq, dq, te, te, te"]
  hatlines = ["xx-xx-xx-xx-x-x-", "x--x--xxx--x--xx", "xx-xxx-xxxx-xxx-"]
  snarelines = ["-x", "-x-x", "[[-x][-x]][xxx]"]
  16.times do
    playline :bd_ada, kicklines.choose, amp: 3
    playline :hat_gnu, hatlines.choose
    playline :sn_dolf,  snarelines.choose
    sleep 4
  end
```
#### portamentomelody 

play a melody on a synth portamento, by manipulating the pitch over time.    
args:   
thisarrangement: the melody in mini-notation (see arrange for details); e.g.: "qd :c5, qd :ds5, q :g5"  
thissynth: the name of the synth to play the note; defaults to :sine.    
note_slide: the portamento time; if set to longer than the shortest note, will be length of shortest note.    

#### randomseed 

generate a random random seed seed.  Say that three times fast!  
args:  
modulo: the number to use in modulo math; defaults to 65536 (64k).   


#### romantoint 

turns a roman numeral into an integer.    
args:   
thisroman: the roman numeral to change to int; a string.   
returns: an int. If the roman numeral is garbage, returns 0.    


#### rowstocolumns

  takes an array of arrays, and transforms rows to columns. Can take any number of arrays.    
  \*thesearrays: the arrays to flip  
  if arrays are of unequal length, values will be filled with nils
  if you want to pad the shorter arrays, use paddedrowstocolumns instead.

#### randomseed 

generate a random random seed seed.  Say that three times fast!    
args:  
modulo: the number to use in modulo math; defaults to 65536 (64k).   


#### ringorlist

  simple utility function to test whether an item is a ring or a list.
  true if either, false if anything else.
  Added a couple of synonyms, listorring and tickable. 

#### samplebpm

  utility to return the bpm of any sample loop.  
  thissample: the sample to extract the bpm from.  
  beats: the number of beats used to calculate bpm. Defaults to 4  
  example:  
```
  puts samplebpm :loop_amen
  puts samplebpm :loop_amen_full, 16
```

#### setarg 

  sets an arg to a val in args.  
  Useful for constructing command strings to feed to eval.    
  arg: the argument to set. A string.    
  val: the value for that arg. A string, or an array (to support tickargs).
  If the intended value is a string, embed quotes, e.g. "'thisstring'",
  which results in "thisarg: 'thisstring'"  
  args: the string or hash containing all the args. 
  returns args as a hash.

#### slidebpm 

changes bpm gradually or stepwise over time, e.g., accelerando or ritardo.   
args:  
targetpbm: the bpm(s) you want to end up at. Can be an array, and it will do them sequentially.    
slidetime: how long it takes to get to each targetbpm, in beats.    
steptime: how long each step is. Small numbers makes the transition smoother,   
larger numbers give you the "little nash rambler" effect.    
startbpm: the starting bpm. If not supplied, defaults to whatever the current bpm is.   
cuename: the name of the cue for other threads to sync to; defaults to :bpmsync  
setname: flag for other threads to snif to see if we're sliding; defaults to :slidingbpm  
killswitch: flag to see if we need to kill the thread; defaults to :killslidingbpm   

#### slidemelody 

wrapper for portamentomelody


#### spreadtobeats

a utility function designed to take a spread, 
and convert it to a string of comma-delimited beat values to feed into arrange.  
thisspread: the ring of booleans produced by the spread function, mapping the beats.to_s  
beatvalue: duration of each beat, defaults to sixteenth  
notes: an array of melodic notes to apply to each beat.
Must be same length as the number of true values in spread.   
Example:  
```
spreadtobeats spread(3, 8, 2), 0.5 
```

#### stringtonestedarray

stringtonestedarray    
takes a string with nested delimiters, and transforms it into a nested array.    
Useful for parsing mini-notation.
args:    
thisstring: the string to transform.    
delims: the delimiters, either in a string or array; defaults to ", ". If in a string, each char is a separate delimiter.    
example code:   
``` 
stringtonestedarray "qd :c4, qd :ds4, :q :g4"  
#returns: [["qd", ":c4"], ["qd", ":ds4"], ["qd", ":g4"]] 
``` 



#### stripparams

  a utility function to delete params from kwargs.
  Useful for passing args to nested method calls.  
  kwargs: a hash of key word args  
  params: an array/ring of params to strip  
  Example:
```
  cleanargs = stripparams kwargs, method(__method__).parameters
```

#### striptrailingnils

  strips all trailing nil values in the given array    
  thisarray: the array to strip

#### strum 

  A convenience method wrapping arpeggiate to simplify strumming chords.     
  thesenotes: the notes to strum.
  Typically a chord or scale, but could be any ring or array of notes.  
  totaltime: how long (in beats) the entire phrase should take. Defaults to 1.   
  strumspeed: how long (in beats) to sleep for all notes except the last one. 
  Used to calculate how long the last note should sleep. Defaults to 0.05. 

#### stuttersample  

  play a sample, slicing it into chunks and applying densities to each chunk for a stutter-type effect.   
  args:  
  thissample: the sample to play   
  stutters: an array of integers to feed into the density for each chunk. Defaults to [1] (no stutters)  
  reverses: an array of booleans -- true to reverse, false for normal play. Defaults to [false] (no reverses)  
  stutterchunks: either nil, or an array of which chunks to play.   
  If supplied, should be same length as stutters. 
  This supports repeating the same section multiple times, playing chunks out of order, etc. 
  Note that this does impact the order of reversals. So if stutterchunks[3] = 7, it will also use reverses[7].  
  num_beats: how many beats the entire sample playback will be. Each chunk is stutters.length / num_beats.  
  stretchmode: a string, either "pitch" or "beat". Used to determine how to stretch the slices.   
  The number of elements in the stutters array determines how many slices the sample is cut up into. 
  You can add any other args appropriate to the sample command, and they will be passed thru. See docs for sample.   
  if you specify an rpitch arg, it will call transposesample, and calculate the correct pitch_density based on the new pitch.
  if you provide a list or ring for rpitch, the chunks will have different pitches. Should be same length as stutters. 
  See docs for transposesample for details.   
  Example:
```
  stuttersample :loop_amen_full, [1, 2, 4, 2, 1, 4, 3, 2], [false, true, false, false, true, false, false, false], [0, 0, 7, 3, 2, 4, 5, 1], 16
```

#### swing

  add swing to a straight beat.    
  args:  
  straightbeats: an array of times to swing   
  swingseed: the seed for how to swing it. Defaults to 6, which gives the normal 12/16 type swing.
  Try odd numbers, fractions, for weird lurching swings.   
  humanizeamt: how much humanizing to add in. Defaults to 0. 
  

#### synctoslidingbpm 

syncs current thread to sliding bpm managed by slidebpm.   
args:  
cuename: the syncing cue managed by slidebpm, defaults to :bpmsync  
setname: the set flag managed by slidebpm, defaults to :slidingbpm. Only syncs when not nil/false.   



#### tickable

 wrapper for ringorlist

#### tickargs

  Returns a string of args, with all array values ticked.    
  args: a Hash of args, where all items whose values are arrays return ticked values.    
  Useful for constructing command strings to feed to eval.  

#### trancegate 

  a trancegate that manipulates the volume up and down. 
  Defaults to square wave, but you can use other lfo shapes.
  Note that the trancegate does not work in the release section, so invoke your sounds accordingly.
  Also, please set your initial amp: setting to match the maxvol param, to avoid glitches.  
  handle: the node returned by sample or play commands.  
  duration: how long the effect lasts. Should line up with sustain of played sound.  
  period: how long the gate lasts. Can be a single value, a ring/list, or a comma-delimited list.  
  maxvol: the max amplitude when the gate is open. Defaults to 1.  
  minvol: the min amplitude when the gate is closed. Defaults to 0.   
  gutter: how long the silence lasts between chunks. Can be a single value, list/ring or comma-delimited list.  
  lfotype: defaults to square, but supports all lfotypes.  
  curve: lfo type curve param. Used for custom lfo types.  
  Example:
```
  use_bpm 120
  use_synth :bass_highend
  handle = play 60, sustain: 16, decay: 1,res: 0.7, amp: 0
  puts "handle: " + handle.to_s
  trancegate handle, 16, euclidiate("s", 16, 5)
  handle = sample :ambi_drone, 16
  trancegate handle, 16, euclidiate("s", 16, 5)
```

#### transposesample

transposesample  
transposes a sample up or down by specified rpitch, while pitch_stretching to keep tempo.  
args:  
thissample: the sample to transpose.   
autostretch: whether to apply any pitch_stretch to the sample. Defaults to true.   
It is your responsibility to provide options for pitch_stretch, time_dis, etc.   
You may need to fiddle with time_dis, window_size and pitch_dis to tweak the sound.  
example:  
```
mysample = :bass_hit_c
  [0, 3, 7, -2].each do |thispitch|
    use_bpm thisbpm
    handle = transposesample mysample, thispitch, autostretch=false
    sleep 16
  end
  sleep 2
end
```
Code returns a handle (node) for further manipulation, e.g. lfos, envelopes, trancegates.   

#### tremolo

quickly oscillate volume up & down  
args:   
handle: node controlling the samples/synths; could be a chord node  
amp: the base volume of the sound; defaults to 1.   
depth: how much to move the volume up & down; defaults to 0.5  
rate: the rate of tremolo, in beats; defaults to sixteenth.   
duration: how long the tremolo lasts; defaults to whole.   


#### tuples

  returns an array of times (floats) based on tupling the specified beats.  
  args:   
  howmanytuples: an integer specifying how many tuples you want.    
  beatsize: the size of the beats to be tupled. Defaults to 1.   
  Example:  
```
  tuples(5, 2) returns [1.6, 1.6, 1.6, 1.6, 1.6]
```
#### vibrato

quickly oscillate pitch up & down  
args:   
handle: node controlling the samples/synths; could be a chord node  
depth: how much to move the volume up & down; defaults to 0.5  
rate: the rate of tremolo, in beats; defaults to sixteenth.   
duration: how long the tremolo lasts; defaults to whole.   

#### yummyhelp

  provide quick docs for yummyfillings.  
  helptopic: a string for the help topic. If nil, returns a list of methods. 
  Use the method name for detailed help.  
  Uses debugprint to return a string with help text. 

#### yh

  wrapper for yummyhelp
