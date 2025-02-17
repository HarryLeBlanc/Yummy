##| YummyFillings.rb
##| Useful methods for sonic pi
##| Harry LeBlanc 2024, gnu public license
##| HarryLeBlancLPCC@gmail.com
##| version 1.0.0, 12/12/24
##| 1.0.1, fixed 2 bugs in convertdrumnotation
##| 1.0.2, fixed bug in samplebpm
##| 1.0.3, added asdr & levels args to env
##| Use eval_file to load these method definitions, not load!




##| useful constants for specifying time intervals in notes
##| assumes one beat is a quarter note
##| allows combinations like dotted * eighth or quarter * triplet


whole = 4.0
half =2.0
quarter =1.0
eighth =0.5
sixteenth =0.25
dotted = 1.5
triplet =2.0 / 3


debugmode = true

#scrub
#small utility function to clean nils with the specified value (defaults to "")
define :scrub do |value, cleanvalue = ""|
  (value == nil ? cleanvalue : value )
end


##| ##debugprint
##|   a utility function to optionally print out debugging messages,
##|   controlled by the debugmode variable. If not set, defaults to false and prints nothing.
##|   label: a text string to explain what the value means.
##|   value: the value being displayed for debugging purposes. If nil, just displays the label.
##|   expandlist: if either arg is a list or ring, print them individually
##|   indents: how many levels of recursion, which will print n copies of indenttext
##|   indenttext: the text to use for nested indentations
##|   logtofile: set to true if you wish to log to a text file
##|   filename: the name of the file to log to. Will append if it exists, create it if it does not. 

define :debugprint do |label, value="tricksy hobbit!", expandlist=false, indents=0, indenttext="  ", logtofile=false, filename="e:/yummy/debuglog.txt", **kwargs|
 
  eval overridekwargs(kwargs, method(__method__).parameters) #if boolish kwargs
  fakenil = "tricksy hobbit!"
 
  #puts "got to ##debugprint"
  if current_debug
    # puts  "debugmode is active" + "\n"
    # puts  "label: " + label.to_s  + "\n"
    # puts  "value: " + scrub(value).to_s   + "\n"
    # puts  "label class: " + label.class.to_s   + "\n"
    # puts  "value class: " + scrub(value).class.to_s   + "\n"

    #stringify nils for pretty printing
    if value == "tricksy hobbit!" && label == nil  
      label = "nil " 
      value = nil
    elsif label == nil && value == nil  
      label = "nil "
    elsif value == nil  
      # puts "pretty nil value"
      value = "nil "
      # puts value  
    elsif value == "tricksy hobbit!" 
      value = nil
    end #if label == nil  
    # puts "label: "
    # puts label  
    # puts "value: "
    # puts value  

    if expandlist 
      # puts  "in expandlist mode"  + "\n"
      if label.is_a? Hash  
        # puts  "label is a hash" + "\n"
        ##debugprint "hash: ", nil, expandlist, indents, indenttext, logtofile, filename
        indents += 1
        label.each do |hkey, hval|
          ##debugprint "key: ", fakenil, expandlist, indents, indenttext, logtofile, filename
          ##debugprint hkey,  fakenil, expandlist, indents + 1, indenttext, logtofile, filename
          ##debugprint "value: ", fakenil, expandlist, indents, indenttext, logtofile, filename
          ##debugprint hval,  fakenil, expandlist, indents + 1, indenttext, logtofile, filename
        end
        # puts "after hash label"
        ##debugprint value, fakenil, expandlist, indents, indenttext, logtofile, filename  
      elsif ringorlist label 
        # puts  "ringorlist label"  + "\n"
        if label.is_a? Array
          ##debugprint "array: " 
        else  
          ##debugprint "ring: " 
        end #if array or ring
        # puts "after conditional print"
        label.each do |nestedlabel|
          ##debugprint nestedlabel, fakenil, expandlist, indents + 1, indenttext, logtofile, filename
        end #each label item
      elsif value.is_a? Hash  
        # puts  "value is a hash" + "\n"
        ##debugprint label if label != nil  
        ##debugprint "hash: "
        indents += 1
        value.each do |hkey, hval|
          ##debugprint "key: ", fakenil, expandlist, indents, indenttext, logtofile, filename
          ##debugprint hkey,  fakenil, expandlist, indents + 1, indenttext, logtofile, filename
          ##debugprint "value: ", fakenil, expandlist, indents, indenttext, logtofile, filename
          ##debugprint hval,  fakenil, expandlist, indents + 1, indenttext, logtofile, filename
        end
      elsif ringorlist value  
        # puts  "ringorlist value" + "\n"
        if label != nil  
          ##debugprint label, fakenil, expandlist, indents, indenttext, logtofile, filename
        end #if label not nil
        if value.is_a? Array
          ##debugprint "array: " 
        else  
          ##debugprint "ring: " 
        end #if array or ring

        value.each do |nestedvalue|
          ##debugprint nestedvalue, fakenil, expandlist, indents + 1, indenttext, logtofile, filename
        end #each label item
      else 
        # puts  "bottom of recursion" + "\n"
        #bottom of recursion, ready to actually print 
        outputstring = (indenttext * indents) + symbolwithcolon(label)  + symbolwithcolon(value) + "\n"
         puts outputstring
        if logtofile
          # puts "logging to file"
          File.write(filename, outputstring, mode: "a")
        end #if logging
      end #if got lists
    else 
      # puts  "no expandlist" + "\n"
      # puts "label: "
      # puts label  
      # puts "value: "
      # puts value  
      outputstring = (indenttext * indents) + symbolwithcolon(label)  + symbolwithcolon(value) + "\n"
       puts outputstring
      if logtofile
        # puts "logging to file"
        File.write(filename, outputstring, mode: "a")
      end #if logging
    end #if expandlist
  else 
    # puts "not debug mode"
  end #if debug
  # puts "end of ##debugprint"
end #define



# symbolcolon 
# provides conditional colon for pretty symbol printing.
# args:  
# thisvalue: the value to test.  
# returns: ":" if a symbol, "" if not.  

define  :symbolcolon do |thisvalue, **kwargs|
 if thisvalue == nil   
    return ""
  elsif thisvalue.is_a? Symbol  
    return ":"
  else
    return ""
  end #if
end #define symbolcolon


# symbolwithcolon
# wrapper to simplify. 

define  :symbolwithcolon do |thisvalue|
  thisvalue ||= ""
  thisvalue = symbolcolon(thisvalue) + thisvalue.to_s
  thisvalue #return value
end #define symbolwithcolon



# clonekeys  
# duplicate key/val pairs in a hash to match a master key.   
# args:  
# thishash: the hash to add cloned key/val pairs to.  
# keystoclone: an array of keys. The first key that has a non-nil, non-false value paired to it   
# will be treated as the master key.  
# Can also be an array of arrays. If so, each array will be processed separately. 
# falseflag: boolean flag (defaulting to true), indicating whether to purge keys whose paired value is false. 
# This supports not cloning certain values by pre-loading the hash with key/false pairs. Such keys will not be cloned.
# In turn, this supports layering synth voices in arrange. 
# Example code:  
# clonekeys {1 => false, 2=> :foo 5=> :bar}, [1, 2, 3, 4]
# returns: {2=> :foo, 3 => :foo, 4=> :foo, 5 => :bar}
# clonekeys {1 => false, 2=> :foo}, [1, 2, 3, 4], false
# returns: {1=> false, 2=> :foo, 3 => :foo, 4=> :foo, 5=> :bar}
# clonekeys {1 => false, 2=> :foo, 5=> :bar}, [[1, 2, 3, 4], [5, 6, 7]]
# returns: {2 => :foo, 3=> :foo, 4 => :foo, 5=> :bar, 6=> :bar, 7=> :bar}


define  :clonekeys do |thishash, keystoclone, falseflag=true, **kwargs|
  eval overridekwargs(kwargs, method(__method__).parameters)
  cleanargs = stripparams kwargs, method(__method__).parameters
  ##debugprint "top of clonekeys"
  ##debugprint "thishash: ", thishash
  ##debugprint "keystoclone: ", keystoclone
  ##debugprint "falseflag: ", falseflag

  if !keystoclone[0].is_a? Array  #no nested array
    ##debugprint "no nested array, wrapping keystoclone"
    keystoclone = [keystoclone]
  end #if need array wrapper

  keystoclone.each do |thislist|
    ##debugprint "thislist: ", thislist
    mainkey = nil  
    secondarykeys = []
    thislist.each do |thiskey|
      if !mainkey 
        ##debugprint "looking for main key"
        ##debugprint "thiskey: ", thiskey
        ##debugprint "thishash.keys: ", thishash.keys
        ##debugprint "thishash[thiskey]: ", thishash[thiskey]
        ##debugprint "thishash.keys.include? thiskey: ", (thishash.keys.include? thiskey)
        ##debugprint "thishash[thiskey] != false: ", (thishash[thiskey] != false)
        if (thishash.keys.include? thiskey) && (thishash[thiskey] != false) 
          ##debugprint "found mainkey: ", thiskey  
          mainkey = thiskey  
        elsif thishash[thiskey]
          ##debugprint "not a main key, adding to secondary keys: ", thiskey
          secondarykeys << thiskey
        else
          ##debugprint "thishash[thiskey] is false or nil"
        end #if got content for thiskey  
      else 
        ##debugprint "got a main key, looking for secondary keys"
        if !thishash.keys.include? thiskey 
          ##debugprint "adding to secondary keys: ", thiskey
          secondarykeys << thiskey  
        else 
          ##debugprint "already in thishash, skipping key ", thiskey 
        end #if don't already have key in hash
      end # if no mainkey
    end

    if mainkey 
      ##debugprint "got a mainkey: ", mainkey
      secondarykeys.each do |thiskey|
        ##debugprint "cloning thiskey: ", thiskey
        thishash[thiskey] = thishash[mainkey]
      end #each secondary key
    else
      ##debugprint "no mainkey, doing nothing"
    end #if got a main key
  end #each thislist

  if falseflag
    ##debugprint "got false flag, purging false keys"
    thishash.delete_if {|key, val| val == false}
  end #if falseflag


  ##debugprint "thishash: ", thishash
  thishash #return value
end #define clonekeys





# portamentomelody  
# play a melody on a synth portamento, by manipulating the pitch over time.  
# args: 
# thisarrangement: the melody in mini-notation (see arrange for details); e.g.: "qd :c5, qd :ds5, q :g5"
# thissynth: the name of the synth to play the note; defaults to :sine.  
# note_slide: the portamento time; if set to longer than the shortest note, will be length of shortest note.  

define  :portamentomelody do |thisarrangement, thissynth = :sine, note_slide = 0.0625, **kwargs|
  eval overridekwargs(kwargs, method(__method__).parameters)
  cleanargs = stripparams kwargs, method(__method__).parameters
  ##debugprint "top of portamentomelody"
  ##debugprint "thissynth: ", thissynth
  ##debugprint "thisarrangement: ", thisarrangement
  ##debugprint "note_slide: ", note_slide

  twoarrays = rowstocolumns (stringtonestedarray thisarrangement)
  ##debugprint "twoarrays: ", twoarrays
  timearray = rowstocolumns(cooktimes twoarrays[0].join(","))[0]
  notearray = []
  twoarrays[1].each do |thisnote|
    ##debugprint "thisnote: ", thisnote
    if thisnote.downcase =~ /[:abcdefg]/
      ##debugprint "note is a symbol"
      notearray << thisnote.delete_prefix(":").to_sym.to_i
    elsif thisnote =~ /^[\d\.\s]*$/ #digits and dots and whitespace
      ##debugprint "note is a number"
      notearray << thisnote.to_f 
    else 
      ##debugprint "note is garbage, skipping"
    end #if note is symbol or number
  end #each note
  ##debugprint "notearray: ", notearray
 totaltime = timearray.sum  
 ##debugprint "totaltime: ", totaltime
  if note_slide > timearray.min  
    ##debugprint "note_slide too long, adjusting"
    note_slide = timearray.min  
  end #if slide too long

  ##debugprint "note_slide: ", note_slide
  ##debugprint "timearray: ", timearray
  ##debugprint "notearray: ", notearray

  with_synth thissynth do 
    ##debugprint "playing note ", notearray[0]
    handle = play notearray.delete_at(0), sustain: totaltime, note_slide: note_slide, **cleanargs
    ##debugprint "sleeping:: ", timearray[0]
    sleep timearray.delete_at(0)
    ##debugprint "notearray: ", notearray
    ##debugprint "timearray: ", timearray
    notearray.length.times do  
      ##debugprint "playing note ", notearray[0]
      control handle, note: notearray.delete_at(0)
      ##debugprint "sleeping:: ", timearray[0]
      sleep timearray.delete_at(0)
      ##debugprint "notearray: ", notearray
      ##debugprint "timearray: ", timearray
    end #traversing notearray
  end #with thissynth

  nil #return value
end #define portamentomelody


# slidemelody: alias for portamentomelody  

define :slidemelody do |thisarrangement, thissynth = :sine, note_slide = 0.0625, **kwargs|
  portamentomelody thisarrangement, thissynth, note_slide, **kwargs  
end  






# vibrato
# quickly oscillate pitch up & down
# args: 
# handle: node controlling the samples/synths; could be a chord node
# range: how much to move the volume up & down; defaults to 0.5
# rate: the rate of tremolo, in beats; defaults to sixteenth. 
# duration: how long the tremolo lasts; defaults to whole. 

define  :vibrato do |handle, rate=sixteenth, depth=0.25, duration=whole,  **kwargs|
  eval overridekwargs(kwargs, method(__method__).parameters)
  cleanargs = stripparams kwargs, method(__method__).parameters
  ##debugprint "top of vibrato"
  ##debugprint "handle: ", handle
  ##debugprint "rate: ", rate
  ##debugprint "depth: ", depth
  ##debugprint "duration: ", duration
  halfrate = rate / 2.0  
  elapsedtime = 0
  ##debugprint "about to thread"
  direction = 1  
  pitch = handle.args["note"] unless handle.is_a? SonicPi::ChordGroup
  ##debugprint "pitch: ", pitch
  in_thread do 
    while elapsedtime < duration do  
      vtargs = ""

      ##debugprint "elapsedtime: ", elapsedtime
      if handle.is_a? SonicPi::ChordGroup  
        ##debugprint "got a chord group"
        pitch = pitch.to_a
        ##debugprint "pitch: ", pitch
        handle.sub_nodes.each do |subhandle|
          ##debugprint "subhandle: ", subhandle
          ##debugprint "subhandle methods: ", subhandle.class.instance_methods
          newpitch = subhandle.args["note"] + (depth * direction) 
          ##debugprint "newpitch: ", newpitch
          control subhandle, note: newpitch, note_slide: halfrate 
        end #each subhandle
      else 
        ##debugprint "got a single note"
        newpitch = pitch.to_i + (depth * direction)
        ##debugprint "newpitch: ", newpitch
        control handle , note: newpitch , note_slide: halfrate

      end #if chordgroup or single note

      sleep halfrate
      direction *= -1
      elapsedtime += halfrate 
    end #while elapsedtime < duration  
    ##debugprint "bottom of time loop"

    ##debugprint "elapsedtime: ", elapsedtime
    if handle.is_a? SonicPi::ChordGroup
      ##debugprint "got a chord group"
      pitch = pitch.to_a
      ##debugprint "pitch: ", pitch
      handle.sub_nodes.each do |subhandle|
        ##debugprint "subhandle: ", subhandle
        newpitch = subhandle.args["note"] 
        ##debugprint "newpitch: ", newpitch
        control subhandle, note: newpitch, note_slide: halfrate 
      end #each subhandle
    else 
      ##debugprint "got a single note"
      control handle, note: pitch, note_slide: halfrate
      ##debugprint "after control"

    end #if chordgroup or single note

    ##debugprint "after resetting tone and amp"

    stop 
  end #in_thread 

 handle #return value
end #define tremolo




# tremolo
# quickly oscillate volume up & down
# args: 
# handle: node controlling the samples/synths; could be a chord node
# amp: the base volume of the sound; defaults to 1. 
# depth: how much to move the volume up & down; defaults to 0.5
# rate: the rate of tremolo, in beats; defaults to sixteenth. 
# duration: how long the tremolo lasts; defaults to whole. 

define  :tremolo do |handle, amp=1, depth=1, rate=sixteenth, duration=whole, **kwargs|
  eval overridekwargs(kwargs, method(__method__).parameters)
  cleanargs = stripparams kwargs, method(__method__).parameters
  ##debugprint "top of tremolo"
  ##debugprint "handle: ", handle
  ##debugprint "amp: ", amp
  ##debugprint "depth: ", depth
  ##debugprint "rate: ", rate
  ##debugprint "duration: ", duration
  halfrate = rate / 2.0  
  elapsedtime = 0

  ##debugprint "about to thread"
  direction = 1  
  in_thread do 
    while elapsedtime < duration  do  

      ##debugprint "elapsedtime: ", elapsedtime
      if handle.is_a? SonicPi::ChordGroup  
        ##debugprint "got a chord group"
        subamp = amp / handle.sub_nodes.count.to_f
        subdepth = depth / handle.sub_nodes.count.to_f
        ##debugprint "subamp: ", subamp
        pitch = pitch.to_a
        ##debugprint "pitch: ", pitch
        handle.sub_nodes.each do |subhandle|
          ##debugprint "subhandle: ", subhandle
          control subhandle, amp: (subamp + (subdepth * direction)), amp_slide:  halfrate
        end #each subhandle
      else 
        ##debugprint "got a single note"
        control handle, amp: (amp + (depth * direction)), amp_slide:  halfrate
      end #if chordgroup or single note
      sleep halfrate 
      direction *= -1
      elapsedtime += halfrate 
    end #while elapsedtime < duration  
    ##debugprint "bottom of time loop"

    if handle.is_a? SonicPi::ChordGroup  
      ##debugprint "got a chord group"
      subamp = amp / handle.sub_nodes.count.to_f
      ##debugprint "subamp: ", subamp
      pitch = pitch.to_a
      ##debugprint "pitch: ", pitch
      handle.sub_nodes.each do |subhandle|
        ##debugprint "subhandle: ", subhandle
        control subhandle, amp: subamp, amp_slide:  halfrate
      end #each subhandle
    else 
      ##debugprint "got a single note"
      control handle, amp: amp, amp_slide:  halfrate
    end #if chordgroup or single note

    stop 
  end #in_thread 

 handle #return value
end #define tremolo




##| ringorlist -- simple utility function to test whether an item is a ring or a list.
##| arg: thisitem 
##|   true if either, false if anything else.
##| Added a couple of synonyms, listorring and tickable. 

define :ringorlist do |thisitem|
  thisitem.is_a? Enumerable or thisitem.is_a? SonicPi::Core::RingVector
end

define :listorring do |thisitem|
  ringorlist thisitem
end

define :tickable do |thisitem|
  ringorlist thisitem
end

##| overridekwargs
##| a useful method to help emulate the native ruby ability to specify params by either position or name. 
##| kwargs: the hash of named params specified by the user.
##| params: the parameters defined by the calling method. Get via introspection (see example code)
##| arglistname: the name of the variable holding the list in the first name, defaults to "kwargs".
##| a useful little method to make user-defined methods act more like native ruby methods,
##| so you can specify params either by position or by name.
##| simply add **kwargs as the last param of your method, and put this line of code at the top of the method body:
##| eval overridekwargs(kwargs, method(__method__).parameters)
##| See also stripparams, which is useful for stripping out method-related params, 
##| leaving only params which are suitable to pass to play or sample. 

define :overridekwargs do |kwargs, params, ignorenewargs=true, arglistname="kwargs"|

  # ##debugprint "kwargs before defaulting: "  + kwargs.to_s

  kwargs ||= {} 
  # ##debugprint "kwargs after defaulting: "  + kwargs.to_s
  params.collect! {|x| x=x[1]} #params is an array of arrays, with the name as the 2nd item in each nested array. This strips & flattens
  # ##debugprint "params: ", params

  kwargcmdlist = ""
  kwargs.each do |argname|
    # ##debugprint  "argname: " + argname[0].to_s
    # ##debugprint "params include argname? " + (params.include? argname[0]).to_s
    # ##debugprint "ignore new? " + ignorenewargs.to_s
    cleanname = argname[0]
    if argname[0] == nil  
      cleanname = "garbage"
    end #if nil argname[0]

    if params.include? cleanname or params.include? cleanname.to_s  or params.include? cleanname.to_sym or !ignorenewargs
      kwargcmdlist += cleanname.to_s + " = " + arglistname.to_s + "[:" + cleanname.to_s + "]\n" 
    else
      # ##debugprint argname[0].to_s + " is not a valid param -- did you make a typo?"
    end
    
  end
  # ##debugprint "kwargcmdlist", kwargcmdlist
  kwargcmdlist
end



##| stripparams: a utility function to delete params from kwargs.
##|   Useful for passing args to nested method calls.
##|   kwargs: a hash of key word args
##|   params: an array/ring of params to strip
##|   sample code:
##|   cleanargs = stripparams kwargs, method(__method__).parameters



define :stripparams do |kwargs, params|
  # ##debugprint "kwargs: ", kwargs
  # ##debugprint "params ", params
  tempargs = kwargs.clone
  params.each do |thisparam|
    # ##debugprint "about to delete thisparam[1]: ", thisparam[1]
    tempargs.delete(thisparam[1])
  end
  # ##debugprint "kwargs after stripping: ", kwargs
  tempargs #return value
end #define


# funkyrandom
# randomly generates a funky rhythm, 
# returned as a string of notations (bwhqestdr) suitable for feeding into cooknotes or arrange. 
# Args:
# totaltime: the whole length of the pattern. Defaults to 16 (4 bars). 
# shortestbeat: the shortest beat used in the pattern. Defaults to 0.25 (sixteenth). 
# shortestbeat must be one of: sixteenth, eighth, quarter, half, whole (0.25, 0.5, 1, 2, 4)
# restodds: the odds of a rest, using one_in. Defaults to 8. 

define  :funkyrandom do |totaltime=16, shortestbeat=0.25, restodds=8, **kwargs|
  eval overridekwargs(kwargs, method(__method__).parameters) if boolish kwargs
  cleanargs = stripparams kwargs, method(__method__).parameters
  ##debugprint "top of funkyrandom"

  randomfunk = []
  funkpatterns = {}
  thisbeat = ""
  funkpatterns[sixteenth] = ["s", "e", "es"]
  funkpatterns[eighth] = ["e", "q", "qe"]
  funkpatterns[quarter] = ["q", "h", "hq"]
  funkpatterns[half] = ["h", "w", "wh"]
  funkpatterns[whole] = ["w", "ww", "www"]
  thispattern = funkpatterns[shortestbeat]
  ##debugprint "thispattern: ", thispattern

  while totaltime > 0
    thisbeat = thispattern.choose 
    ##debugprint "thisbeat: ", thisbeat
    thistime = cooktime(thisbeat)[0] 
    ##debugprint "thistime: ", thistime
    if thistime > totaltime 
      ##debugprint "thistime > totaltime"
      thistime = totaltime 
      ##debugprint "thistime: ", thistime
      thisbeat = funkpatterns[thistime][0]
      ##debugprint "thisbeat: ", thisbeat
    end #if thistime > totaltime
    if one_in restodds
      ##debugprint "got a rest"
      thisbeat = "r" + thisbeat
      ##debugprint "thisbeat: ", thisbeat
    end #if got a rest
    randomfunk << thisbeat 
    ##debugprint "randomfunk: ", randomfunk

    totaltime -= thistime  
  end #while totaltime > 0
  randomfunk = randomfunk.join(",") #convert to comma-delimited string
  ##debugprint "randomfunk: ", randomfunk
  randomfunk #return value
end #define funkyrandom


##| funkify
##| A method to play a sound in a funky, random manner for a specified period of time.
##|   thissound: a synth or sample. Can also be an array or list of synths or samples.
##|   totaltime: the number of beats for the entire pattern. Defaults to 16 (4 bars).
##|   shortestbeat: the smallest subdivision. Will sleep 1, 2, or 3 times that each time a sound plays.
##|   thesenotes: a list or ring of notes, used with synths only. Defaults to [:c4].
##|   densities: a list or ring of densities, applied per note/sleep.
##|   tickorchoose: tick or choose. Used to define how to traverse densities and thesenotes .


define :funkify do |thissound, totaltime=16, shortestbeat=sixteenth, thesenotes=[:c4], densities=[1], tickorchoose="tick", **kwargs|
  eval overridekwargs(kwargs, method(__method__).parameters) if boolish kwargs
  cleanargs = stripparams kwargs, method(__method__).parameters
  
  
  ##debugprint "top of funkify"
  ##debugprint "thissound: ", thissound
  ##debugprint "totaltime: ", totaltime
  ##debugprint "shortestbeat: ", shortestbeat
  ##debugprint "thesenotes: ", thesenotes
  ##debugprint "densities: ", densities
  ##debugprint "tickorchoose: ", tickorchoose
  ##debugprint "kwargs: ", kwargs
  
  sleepytime = 0
  thisdensity = 1
  thisnote = 0
  cooktimes(funkyrandom totaltime, shortestbeat).each do |timeandrest|
    sleepytime = timeandrest[0]
    ##debugprint "sleepytime: ", sleepytime
    isarest = timeandrest[1]
    ##debugprint "isarest: ", isarest
    thisdensity = ( tickorchoose = "tick" ? densities.tick : densities.choose )
    ##debugprint "thisdensity: ", thisdensity
    
    thisnote = (tickorchoose == "tick" ? thesenotes.tick : thesenotes.choose )
    ##debugprint "thisnote: ", thisnote
    
    density thisdensity do
      if !isarest
        if synth_names.to_a.include? thissound
          with_synth thissound do
            ##debugprint "it's a synth: ", thissound
            play thisnote, **cleanargs
          end #with_synth
        else
          ##debugprint "it's a sample: ", thissound
          sample thissound, **cleanargs
        end #if synth or sample
      end #if not a rest
      sleep sleepytime
    end #each timeandrest
  end #with random seed
end #define funkify







##| samplebpm -- utility to return the bpm of any sample loop.
##|   thissample: the sample to extract the bpm from.
##|   num_beats: the number of beats used to calculate bpm. Defaults to 4
##| example:
##| puts samplebpm :loop_amen
##| puts samplebpm :loop_amen_full, 16



define :samplebpm do |thissample, beats=4.0, **kwargs|
  eval overridekwargs(kwargs, method(__method__).parameters, false) if boolish kwargs if boolish kwargs
  with_sample_bpm thissample, num_beats: beats do
    current_bpm
  end #with_sample_bpm
end #define :samplebpm

# formattedsamplename  
# Utility that provides either a leading colon or embedded quotes, depending on if it's a symbol or string (path). 
# Used for command string evaluation.

define  :formattedsamplename do |thissample|
  # ##debugprint "top of formattedsamplename"
  # ##debugprint "thissample: ", thissample
  cleanname = thissample.to_s  
  cleanname = cleanname.to_s.sub(":", "") if cleanname.to_s[0] != "["
  # ##debugprint "cleanname before: ", cleanname
  singlequote = '"'
  # ##debugprint "singlequote: ", singlequote

  if all_sample_names.to_a.include? cleanname.to_sym  
    # ##debugprint "got a sample from the list"
    cleanname.prepend( ":")
  elsif cleanname[0] == "["
    # ##debugprint "got a list, leaving bare: ", cleanname
  else
    # ##debugprint "not a sample in the list"
    cleanname = singlequote + thissample.to_s + singlequote  
    cleanname = cleanname.gsub('""', '"') #to clean up repeated quotes
  end
  # ##debugprint "cleanname after: ", cleanname
  return cleanname
end #define formattedsamplename









##| transposesample
##| transposes a sample up or down by specified rpitch, while pitch_stretching to keep tempo.
##| args:
##| thissample: the sample to transpose. 
##| autostretch: whether to apply any pitch_stretch to the sample. Defaults to true. 
##| It is your responsibility to provide options for pitch_stretch, time_dis, etc. 
##| You may need to fiddle with time_dis, window_size and pitch_dis to tweak the sound.
##| example:
##| mysample = :bass_hit_c
##|   [0, 3, 7, -2].each do |thispitch|
##|     use_bpm thisbpm
##|     handle = transposesample mysample, thispitch, autostretch=false
##|     sleep 16
##|   end
##|   sleep 2
##| end
##| Code returns a handle (node) for further manipulation, e.g. lfos, envelopes, trancegates. 


define :transposesample do |thissample, rpitch=0, autostretch=true, **kwargs|
  eval overridekwargs(kwargs, method(__method__).parameters, false) 
  cleanargs = stripparams kwargs, method(__method__).parameters
  autostretch = boolish autostretch #force boolean
  handle = nil  
  
  # ##debugprint "top of transposesample"
  # ##debugprint "thissample: ", thissample
  # ##debugprint "rpitch: ", rpitch
  # ##debugprint "autostretch: ", autostretch
  # ##debugprint "kwargs: ", kwargs
  # ##debugprint "cleanargs: ", cleanargs

  ratio = midi_to_hz(60 + rpitch) / midi_to_hz(60)
  # ##debugprint "ratio: ",  ratio


  cmd = "handle = sample " + formattedsamplename(thissample)
  # ##debugprint "cmd: ", cmd
  if rpitch != 0  
    # ##debugprint "got a nonzero rpitch"
    cmd += ", rpitch: " + rpitch.to_s  
    # ##debugprint "cmd: ", cmd
  end #if got an rpitch
  if autostretch   
    # ##debugprint "autostretch mode, defaulting pitch stretch"
    cleanargs[:pitch_stretch] ||= (sample_duration thissample) * ratio.to_f 
    cleanargs[:window_size] ||= 0.2  
    cleanargs[:pitch_dis] ||= 0.001  
    cleanargs[:time_dis] ||= 0.001  
  else 
    # ##debugprint "not in autostretch mode, deleting stretch-related settings"
    cleanargs.delete(:pitch_stretch)
    cleanargs.delete(:window_size) 
    cleanargs.delete(:pitch_dis) 
    cleanargs.delete(:time_dis)
  end #if not autostretch
  cmd += tickargs cleanargs 
  # ##debugprint "cmd: ", cmd
  eval cmd  
  # ##debugprint "handle: ", handle
  handle #return handle
end #transposesample

  


##| arrayhashtohasharray
##| A utility function that converts a hash of arrays to an array of hashes.
##| The array length will be the length of the longest array in the hash,
##| and values from shorter arrays will be looped
##| (e.g., for a 2-element array, the 3rd element will equal the first element)
##| Args:
##| arrayhash: the hash of arrays (e.g. { amp: [1, 2, 3], duration: [1, 2]})
##| makering: if true, forces the return value to a ring, not an array. Defaults to true.




define :arrayhashtohasharray do |arrayhash, makering=true|
  hasharray = []
  maxlength = 0
  arrayhash.each do |key, value|
    if !ringorlist value
      value = [value].ring
    else
      value = value.ring
    end
    maxlength = value.length if value.length > maxlength
    arrayhash[key] = value
  end #first iteration through hash
  arrayhash.each do |key, value|
    
    (0..maxlength-1).each do |i|
      if hasharray[i] == nil
        hasharray[i] = {}
      end
      hasharray[i][key] = arrayhash[key][i]
    end #each value item
  end #each hash element
  if makering
    hasharray = hasharray.ring
  end
  hasharray #return value
end #define




# cleanchordorscale
# turns a chord or scale into a plain array.  

define :cleanchordorscale do |myitem|
  # ##debugprint "top of cleanchordorscale"
  # ##debugprint "myitem: ", myitem
  # ##debugprint "myitem.class: ", myitem.class
  cleanitem = nil
  if myitem.is_a? SonicPi::Chord or myitem.is_a? SonicPi::Scale or ringorlist myitem
    # ##debugprint "got a scale or chord or ring"
    cleanitem = []
    myitem.each do |x| cleanitem << x end
  else 
    # ##debugprint "no scale or chord or ring"
    cleanitem = myitem
  end
  cleanitem ##return value
end

# closestnote
# finds the note closest to the given note in the given scale.  
# args:
# thisnote: the note to start with.  
# thisscale: the scale to search.  
# Example code: 
# use_random_seed Time.now.to_i
# thisnote = rand_i(89) #full piano range
# ##debugprint "thisnote: ", thisnote
# ##debugprint "closestnote: ",  closestnote(thisnote, thisscale)



define :closestnote do |thisnote, thisscale, **kwargs|
  eval overridekwargs(kwargs, method(__method__).parameters)  if boolish kwargs
  thisscale = cleanchordorscale thisscale
  ###debugprint thisscale
  foundnote = nil
  thisstep = 0
  thisneg = true
  while !foundnote
    thissign = (thisneg ? -1 : 1)
    ###debugprint "test value: ", thisnote + (thisstep * thissign)
    if thisscale.include? thisnote + (thisstep * thissign)
      ###debugprint "got a match!"
      foundnote = thisnote + (thisstep * thissign)
    elsif thisneg
      ###debugprint "got a negative, incrementing step"
      thisstep += 1
      ###debugprint "thisstep: :", thisstep
    end #if foundnote or thisneg
    thisneg = !thisneg
    ###debugprint "thisneg: ", thisneg
  end #while
  return foundnote
end #define closestnote


##| arpeggiate
##| A method to sequentially play the chord or scale or array/ring of notes passed in.
##|   Args:
##|   thesenotes: the ring/list of notes to play, maybe a chord or scale, or just a user-defined list.
##|   thesedelays: either a single value, or an array of values, to sleep after playing each note; defaults to [quarter]. 
##|   vibrato: either, false, true (which uses defaults for vibrato), 
##|   a hash of args to pass to vibrato, or a string containing args for vibrato.
##|   tremolo: either false, true (which uses defaults for tremolo) , 
##|   a hash of args to pass to tremolo, or a string containing args for tremolo.
##|   synthdefaults: any additional args are assumed to be synth defaults, and will be used to change defaults per note.
##|   Again, if a single value on each item, will be used on all notes. If a ring/list, will be ticked through for each note.
##|   Example:
##|   arpeggiate (chord :c4, "m7"), [0.1, 0.1, 0.1, 0.7], amp: 1.5, duration: [0.1, 0.1, 0.1, 0.7]



define :arpeggiate do |thesenotes, thesedelays=[quarter], vibrato=false, tremolo=false, **kwargs|
  eval overridekwargs(kwargs, method(__method__).parameters)  if boolish kwargs
  cleanargs = stripparams kwargs, method(__method__).parameters
  ##debugprint "top of arpeggiate"
  ##debugprint "thesenotes: ", thesenotes
  ##debugprint "thesedelays: ", thesedelays
  ##debugprint "vibrato: ", vibrato
  ##debugprint "tremolo: ", tremolo
  ##debugprint "remapping synth defaults"
  if !boolish cleanargs   
    ##debugprint "no cleanargs"
    synthdefaultarray = [nil].ring
  else
    ##debugprint "got cleanargs: ", cleanargs
    synthdefaultarray = arrayhashtohasharray cleanargs
  end
  ##debugprint "testing for singleton delays"
  if !ringorlist thesedelays
    thesedelays = [thesedelays].ring
  end

  handle = nil  
  
  ##debugprint "main loop"
  thesenotes.length.times do |i|
    ##debugprint "synthdefaultarray[i]: ", synthdefaultarray[i]
    ##debugprint "thesedelays.ring[i]: ", thesedelays.ring[i]
    if synthdefaultarray[i] == nil 
     ##debugprint "playing note raw"
      handle = play thesenotes.ring[i]
    else
      ##debugprint "playing note with synth defaults"
      with_synth_defaults synthdefaultarray[i] do
        ##debugprint "playing note"
        handle = play thesenotes.ring[i]
      end #synth defaults
    end #if got synth defaults

    if vibrato   
      ##debugprint "vibrato"
      if !vibrato.is_a? Hash  
        ##debugprint "setting vibrato empty hash"
        vibrato = {}
      else
        ##debugprint "vibrato already a hash"
      end #if vibrato not a hash
      ##debugprint "about to call vibrato"
      vibrato handle, **vibrato
    else 
      ##debugprint "no vibrato"
    end #if vibrato

     if tremolo   
      ##debugprint "tremolo"
      if !tremolo.is_a? Hash  
        ##debugprint "setting tremolo empty hash"
        tremolo = {}
      else 
        ##debugprint "tremolo already a hash"
      end #if tremolo not a hash
      ##debugprint "about to call tremolo"
      tremolo handle, **tremolo
    else
      ##debugprint "no tremolo"
    end #if tremolo
       

    ##debugprint "sleeping ", thesedelays[i]
    sleep thesedelays.ring[i]
  end #loop
end #define



# strum 
# A convenience method wrapping arpeggiate to simplify strumming chords.   
# thesenotes: the notes to strum. 
# Typically a chord or scale, but could be any ring or array of notes.
# strumspeed: how long (in beats) to sleep for all notes except the last one.  
# totaltime: how long (in beats) the entire phrase should take. Defaults to 1. 
# Used to calculate how long the last note should sleep. Defaults to 0.05. 



define :strum do |thesenotes, totaltime=1, strumspeed=0.05, vibrato=false, tremolo= false, **kwargs|
  eval overridekwargs(kwargs, method(__method__).parameters)  if boolish kwargs
  ##debugprint "top of strum"
  ##debugprint "strumspeed: ", strumspeed
  thesenotes = cleanchordorscale thesenotes
  ##debugprint "clean version of thesenotes: ", thesenotes
  ##debugprint "vibrato: ", vibrato
  ##debugprint "tremolo: ", tremolo
  thesedelays = []
  finaldelay = totaltime
  if !ringorlist strumspeed
    strumspeed = [strumspeed]
  end
  strumspeed = strumspeed.ring 
  ##debugprint "strumspeed: ", strumspeed
  
  thesenotes.each_index do |i|
    thesedelays[i] = strumspeed.tick
    finaldelay -= strumspeed.look
  end  
  thesedelays[-1] = finaldelay  
  ##debugprint "thesedelays: ", thesedelays
  
  ##debugprint "final version of thesedelays: ", thesedelays
  
  arpeggiate thesenotes, thesedelays, vibrato, tremolo, **kwargs
  sleep totaltime
end



##| env -- applies an adsr envelope to any slideable param on any synth note or sample.
##|   best results when you set the sample/note's modulated value to the startlevel when playing the sample/note,
##|   otherwise you'll hear an audible glitch at the beginning of the sound.
##|   handle -- the node returned by sample/play commands.
##|   param -- the parameter being modulated by the envelope.
##|   attack -- attack time, in beats.
##|   decay -- decay time, in beats.
##|   sustain -- sustain time, in beats.
##|   relase -- release time, in beats.
##|   startlevel -- the level at the bottom of the attack phase. Scaled to what the param expects.
##|   peaklevel -- the level reached at the top of the attack phase, before gliding down to the sustain phase.
##|   sustainlevel -- the level sustained during the sustain phase
##|   adsr -- an array containing attack, decay, sustain and release times. Overrides specific values. Defaults to nil.
##|   levels -- an array containing startlevel, peaklevel and sustainlevel. Overrides specific values. Defaults to nil.
##|   asdr and levels enable a more concise syntax. 
##| Example:
##| use_bpm 60
##| use_synth :bass_highend
##| handle = play 60, sustain: 8, decay: 8,res: 0.7
##| puts "handle: " + handle.to_s
##| env(handle, "drive", 1, 1, 3, 3, 0, 5, 3)




define :env do |handle, param, attack=0.25, decay=0, sustain=1, release=0.25, startlevel=0, peaklevel=1, sustainlevel=0.5, adsr=nil, levels=nil, **kwargs|
  eval overridekwargs(kwargs, method(__method__).parameters) if boolish kwargs

  ##debugprint ""
  ##debugprint ""
  ##debugprint "top of env"

  param = param.to_s
  param = param.gsub ":", ""
  param = param.gsub " ", ""
  if adsr 
    ##debugprint "got an adsr"
    attack = adsr[0]
    decay=adsr[1]
    sustain=adsr[2]
    release=adsr[3]
  else
    ##debugprint "no adsr"
  end

  ##debugprint "attack: ", attack
  ##debugprint "decay: ", decay
  ##debugprint "sustain: ", sustain
  ##debugprint "release: ", release
  ##debugprint "startlevel: ", startlevel
  ##debugprint "peaklevel: ", peaklevel
  ##debugprint "sustainlevel: ", sustainlevel



  if levels
    ##debugprint "got levels"
    startlevel = levels[0]
    peaklevel = levels[1]
    sustainlevel = levels[2]
  else 
    ##debugprint "no levels"
  end 

  ##debugprint "param: ", param

  slideparam = ", " + param + "_slide: "
  shapeparam = ", " + param + "_slide_shape: 1"
  param += ": " 
  ##debugprint "slideparam: ", slideparam
  ##debugprint "shapeparam: ", shapeparam
  ##debugprint "param: ", param




  in_thread do
    #attack phase
    ##debugprint "#attack phase"
    cmd = "control handle, " + param + peaklevel.to_s + slideparam + attack.to_s #+ shapeparam
    ##debugprint " "
    ##debugprint  cmd
    eval cmd
    ##debugprint "sleep ", attack
    sleep attack
    
    #decay phase
    ##debugprint "#decay phase"
    if decay > 0
      ##debugprint "#got decay time"
      
      cmd = "control handle, " + param + sustainlevel.to_s + slideparam + decay.to_s #+ shapeparam
      ##debugprint cmd
      eval cmd
      ##debugprint "sleep ", decay
      sleep decay
   end #if decay > 0
    
    #sustain phase
    ##debugprint "#sustain phase"
    cmd = "control handle, " + param + sustainlevel.to_s
    ##debugprint cmd
    eval cmd
    ##debugprint "sleep ", sustain
    sleep sustain

    
    #release phase
    ##debugprint "#decay phase"
    cmd = "control handle, " + param + sustainlevel.to_s + slideparam + release.to_s #+  shapeparam
    ##debugprint cmd
    eval cmd
    ##debugprint "sleep ", release
    sleep release

    
    #post-release phase
    ##debugprint "#post-decay phase"
    cmd = "control handle, " +  param + startlevel.to_s
    ##debugprint cmd
    eval cmd
    # sleep release
    # ##debugprint "sleep ", release
    
    stop 
  end #thread
  
  ##debugprint "bottom of env"
  ##debugprint ""
  ##debugprint ""


end #define envelope


##| lfo -- provides an all-purpose lfo for any slideable param for any synth note or sample.
##|   best results when you set the sample/note's modulated value to the startlevel when playing the sample/note,
##|   otherwise you'll hear an audible glitch at the beginning of the sound.
##|   handle: the node returned when playing a note or sample.
##|   param: the parameter being modulated by the lfo.
##|   duration: how long the lfo effect will last.
##|   period: the period(s) of the lfo cycle.
##|   Can be a single value, a list/ring, or a comma-delimited string with symbolic values.
##|   e.g. "w,dq,ht,4s".
##|   w for whole.
##|   h for half.
##|   q for quarter.
##|   e for eighth.
##|   s for sixteenth.
##|   d for dotted (can be stacked).
##|   t for triplet.
##|   [0-9]* for how many reps (4w is four whole notes).
##|   one beat is a quarter note.
##|   span: the lower and upper limits of the lfo sweep. 
##|   lfotype: the type of lfo. Can be a single value or a ring/list. 
##|   lfotypes supported are:
##|   "tri" -- triangle
##|   "saw" -- saw
##|   "sin" -- sine
##|   "smo" -- smooth random
##|   "ran" -- random 
##|   "ste" -- step random, same as above
##|   "squ" -- square wave -- really a pulse, if you vary the period param
##|   "cus" -- custom curve (see sonic pi docs for details)
##|   Giving lists for span and lfotype effectively makes the lfo an mseg. 
##|   Can be a pair of values, or a ring/list, or a comma-delimited list.
##|   delay: how long to delay the onset of the lfo
##|   rampupperiod: time to ramp up (will slowly open the envelope)
##|   rampdownperiod: time at the end to ramp down
##|   lfocurve: the curve used for custom curves (see sonic pi docs for details)
##|   examples:
##| use_bpm 120
##| use_synth :bass_highend
##| handle = play 60, sustain: 8, decay: 0,res: 0.7, amp: 0
##| puts "handle: " + handle.to_s
##| lfo handle, "amp", 10, "q,q,e,e,e,e", "0,1,0,0.5,0,0.5", "square"
##| handle = sample :ambi_drone, pitch_stretch: 4
##| lfo handle, "amp", 4, "e,e,s,s,s,s", "0,1,0,0.5,0,0.5", "square"




define :lfo do |handle, param, duration, period=[0.5], span=(ring 0, 1), lfotype="triangle",  delay=0, rampupperiods=0, rampdowntime=0, lfocurve=0, **kwargs|
  eval overridekwargs(kwargs, method(__method__).parameters) if boolish kwargs
  ##debugprint ""
  ##debugprint ""
  ##debugprint "top of lfo"
  #force args to rings
  lfotype = [lfotype].flatten.ring
  lfocurve = [lfocurve].flatten.ring
  ##debugprint "span: ",  span
  ##debugprint "lfotype: ",  lfotype 
  ##debugprint "lfocurve: ",  lfocurve
  
  slideparam = param + "_slide"
  shapeparam = slideparam + "_shape"
  curveparam = slideparam + "_curve"
  loops = 1
  downramp = 0.0
  rampratio = 1.0
  timetorampdown = duration
  lastspan = 0.0
  
  
  if period.is_a? String
    ##debugprint "period is a string"
    mylist = []
    period.split(",").each do |item|
      ##debugprint "item: ", item
      triplet = 1
      dots = 1
      thisnumber = ""
      notetime = 0
      restsign = 1
      item.chars.each do |letter|
        ##debugprint "letter: ", letter
        case letter
        when "r"
          restsign = -1
        when "w"
          notetime += 4.0
          ##debugprint "w ", notetime
        when "h"
          notetime += 2.0
          ##debugprint "h ", notetime
        when "q"
          notetime += 1.0
          ##debugprint "q ", notetime
        when "e"
          notetime += 0.5
          ##debugprint "e ", notetime
        when "s"
          notetime += 0.25
          ##debugprint "s ", notetime
        when "d"
          dots *= 1.5
          ##debugprint "d ", dots
        when "t"
          triplet = 2.0 / 3
          ##debugprint "t ", triplet
        when /\d/, "."
          thisnumber = thisnumber + letter
          ##debugprint "thisnumber: " + thisnumber
        else
          ##debugprint "garbage letter, ignoring"
        end #case letter
      end #each letter
      notetime *= restsign
      ##debugprint "notetime: " , notetime
      ##debugprint "thisnumber: " , thisnumber
      ##debugprint "triplet: " ,triplet
      ##debugprint "dots: ", dots
      thisnumber = ( thisnumber == "" ? 1 : thisnumber.to_f )
      notetime *= dots * triplet * thisnumber
      ##debugprint "final notetime: " , notetime
      mylist << notetime
      ##debugprint "mylist: ", mylist
      
    end #each item
    period = mylist.ring
    ##debugprint "period: ", period
    
  else
    ##debugprint "period is not a string"
    period = [period].flatten.ring
  end #if period is a string
  ##debugprint "period: ", period
  
  if span.is_a? String
    ##debugprint "span is a string"
    mylist = []
    span.split(",").each do |item|
      mylist << item.to_f
    end #each item
    span = mylist.ring
  else
    ##debugprint "gutter is not a string"
    span = [span].flatten.ring
  end #if span a string
  ##debugprint "span ", span
  
  
  if rampdowntime > 0
    ##debugprint "calculating ramp ratio"
    tempduration = duration
    tempperiod = period.to_a.ring #to force new object
    while tempduration > 0 do
      ##debugprint "tempduration: ",  tempduration
      if tempduration <= rampdowntime
        timetorampdown -= tempperiod.tick
        downramp += 1
      end #if
    end #while
    rampdownratio = 1 / rampdownloops
  end #if calc rampdowntime
  
  in_thread do
    
    #initialize param at first span
    ##| puts "initial setting of param"
    ##| shape = 1 #stub it out, makes no difference
    ##| cmd = "control handle, " + param + ": " + span.look.to_s + ", " + slideparam.to_s + ": " + period.look.to_s + ", " + shapeparam.to_s + ": " + shape.to_s + ", " + curveparam.to_s + ": " + lfocurve.look.to_s
    ##| puts cmd
    ##| eval cmd
    sleep delay
    
    duration -= delay
    while duration > 0 do
      print "loop " + loops.to_s
      ##debugprint "look: ", look
      
      case lfotype.look[0..2].downcase
      when "tri"
        ##debugprint "triangle"
        shape = 1 #linear
      when "saw"
        ##debugprint "saw"
        shape = 1 #linear
      when "sin"
        ##debugprint "sine"
        shape = 3 #sine
      when "smo"
        ##debugprint "smooth random"
        shape = 3 #sine
      when "ran"
        ##debugprint "random"
        shape = 3 #sine
      when "ste"
        ##debugprint "step random"
        shape = 0 #step
      when "squ"
        ##debugprint "square"
        shape = 0 #step
      when "cus"
        ##debugprint "custom"
        shape = 5 #custom
      else
        ##debugprint "garbage, defaulting to triangle"
        shape = 1 #for garbage
      end
      
      
      
      
      if rampupperiods > 0 and loops <= rampupperiods
        rampratio = loops  / rampupperiods
        rampup -= 1
      end #if rampup
      
      if duration <= rampdowntime
        ##debugprint "time to ramp down"
        rampratio = downramp * rampdownratio
        downramp -= 1
      end #if ramping down
      
      
      case lfotype.look[0..2].downcase
      when "ran", "smo", "ste"
        ##debugprint "random style lfo"
        thisvalue = rrand(lastspan, span.look)
      else
        ##debugprint "toggle style lfo"
        thisvalue = span.look
      end #case lfo type
      ##debugprint "thisvalue: ", thisvalue
      ##debugprint "rampratio: ", rampratio
      
      
      thisvalue *= rampratio
      ##debugprint "adjusted thisvalue: ", thisvalue
      ##debugprint "this period: ", period.look
      
      cmd = "control handle, " + slideparam + ": " + period.look.to_s + ", " + shapeparam + ": " + shape.to_s + ", " + param + ": " + thisvalue.to_s + ", " + curveparam + ": " + lfocurve.look.to_s
      ##debugprint cmd
      eval cmd
      
      if lfotype.look == "saw"
        ##debugprint "saw, jumping to next span"
        cmd = "control handle, " + slideparam + ": " + period.tick.to_s + ", " + shapeparam + ": 0, " + param + ": " + span.tick.to_s + ", " + curveparam + ": " + lfocurve.look.to_s
        ##debugprint cmd
        eval cmd
      else
        ##debugprint "not saw"
      end #if saw
      ##debugprint "about to sleep " + period.look.to_s
      sleep period[loops -3]
      
      
      lastspan = span.look
      duration -= period[loops -3]
      loops += 1
      tick
      ##debugprint "bottom of while loop"
    end #while

    stop
    
  end #thread

  ##debugprint "bottom of lfo"
  ##debugprint ""
  ##debugprint ""
  
end #define lfo



##| spreadtobeats -- a utility function designed to take a spread, 
##| and convert it to a string of comma-delimited beat values to feed into arrange.
##| thisspread: the ring of booleans produced by the spread function, mapping the beats.to_s
##| beatvalue: duration of each beat, defaults to sixteenth
##| notes: an array of melodic notes to apply to each beat. 
##| Must be same length as the number of true values in spread. 
##| Example:
##| spreadtobeats spread(3, 8, 2), 0.5 


define :spreadtobeats do |thisspread, beatvalue=sixteenth, notes=nil, **kwargs|
  eval overridekwargs(kwargs, method(__method__).parameters) if boolish kwargs
  ##debugprint ""
  ##debugprint ""
  ##debugprint "top of spreadtobeats"


  ##debugprint "thisspread: ", thisspread
  ##debugprint "beatvalue: ", beatvalue
  beats = ""
  isnote = false
  duration = 0
  comma=""
  ##debugprint "comma: ", comma
  notemode = false 
  if ! [nil, "", []].include? notes 
    notemode = true  
  end #if got no notes
  ##debugprint "notemode: ", notemode
  if notemode
    if notes.is_a? String 
      ##debugprint "notes is a comma-delimited string"
      notes = notes.split(",", -1).ring #-1 allows null strings after comma split
    else
      ##debugprint "notes is a list or ring"
      notes = notes.ring 
    end #if notes is a string
  end #if notemode
  ##debugprint "notes: ", notes

  
  #quadrupled values -- it's a hack to make modulo easier
  mywhole = 16.0 #to keep from stepping on wider-scoped vars
  myhalf = 8.0
  myquarter =4.0
  myeighth =2.0
  mysixteenth =1.0 
  firstrest = true
  ##debugprint "beatvalue: ", beatvalue
  ##debugprint "mysixteenth: ", sixteenth
  chunk = (beatvalue * 4.0 ).to_i
  ##debugprint"chunk: ", chunk
  
  
  thisspread.each do |thisoneisnote|
    ##debugprint "thisoneisnote: ", thisoneisnote
    if thisoneisnote #got a new note, finish old note
      ##debugprint "got a new note"
      duration *= chunk #in case overrode beatvalue
      ##debugprint "adjusted chunk: ", chunk
      if duration > 0
        ##debugprint "duration > 0"
        beats += comma
        comma = ","
        if firstrest
          ##debugprint "first rest"
          beats += "r"
        else
          ##debugprint "no first rest"
        end
        {mywhole=>"w", myhalf=>"h", myquarter=>"q", myeighth=>"e", mysixteenth=>"s"}.each do |size,code|
          ##debugprint "size: ",size
          ##debugprint "code: ",code
          ##debugprint "duration: ", duration
          (duration / size).times do #integer math
            beats += code
          end #looping on size
          duration = duration % size
          ##debugprint "beats: ", beats
        end #each beat size
        if notemode && !firstrest
          ##debugprint "note mode"
          thisnote = notes.tick
          if thisnote != ""
            ##debugprint "got note ", thisnote
            beats += " " + thisnote
          else
            ##debugprint "no note to add"
          end #if thisnote <> ""
          ##debugprint "beats: ", beats
          ##debugprint "clearing first rest"
          firstrest = false

        else
          ##debugprint "not note mode"
        end #if notemode


      end #if duration > 0
      ##debugprint "resetting duration"
      firstrest = false
      duration = 0
    else 
      ##debugprint "not a note, duration = 0"
    end #if got a new note
    
    duration += 1
    ##debugprint "bottom of each loop, duration: ", duration
  end #each note



  #now process leftovers of last beat
  ##debugprint "processing leftovers"
  if duration > 0
    ##debugprint "got leftovers: ", duration
    duration *= chunk #in case overrode beatvalue
    ##debugprint "adding comma"
    beats += comma
    ##debugprint "beats: ", beats
    # if firstrest
    #   ##debugprint "first rest"
    #   beats += "r"
    #   ##debugprint "beats: ", beats
    # end

    
    ##debugprint "duration: ", duration
    {mywhole=>"w", myhalf=>"h", myquarter=>"q", myeighth=>"e", mysixteenth=>"s"}.each do |size,code|
      ##debugprint "size: ",size
      ##debugprint "code: ",code
      ##debugprint "duration: ", duration
      (duration / size).times do
        beats += code
      end #looping on size
      duration = duration % size
      ##debugprint "beats: ", beats
    end #each beat size

    if notemode
      ##debugprint "note mode"
      thisnote = notes.tick
      if thisnote != ""
        ##debugprint "got note ", thisnote
        beats += " " + thisnote
      else
        ##debugprint "no note to add"
      end #if thisnote <> ""
      ##debugprint "beats: ", beats
    else
      ##debugprint "not note mode"
    end #if notemode

  end #if got a last note

  ##debugprint "bottom of spreadtobeats"
  ##debugprint ""
  ##debugprint ""

  beats

end #define


##| eucliciate: a utility function wrapping spreadtobeats, bypasses need to create spread.
##| beats: how many beats to play. 
##| duration: how many beats in the whole cycle. 
##| rotations: how many offsets for the euclidean rhythm. 
##| beatvalue: how big is each beat; defaults to sixteenth (0.25)
##| notes: the notes/scales/chords/modes to apply to each beat, as per arrange
##| Example:
##| euclidiate 3, 8, 2, 0.5 


define :euclidiate do |beats,duration,rotations=0,beatvalue=sixteenth, notes=nil, **kwargs|
  eval overridekwargs(kwargs, method(__method__).parameters) if boolish kwargs
  ##debugprint "top of euclidiate"
  ##debugprint "beats: ", beats  
  ##debugprint "duration: ", duration 
  ##debugprint "rotations: ", rotations
  ##debugprint "beatvalue: ", beatvalue 
  ##debugprint "notes: ", notes
  spreadtobeats spread(beats,duration).rotate(rotations), beatvalue, notes
end



##| trancegate -- a trancegate that manipulates the volume up and down. Defaults to square wave, but you can use other lfo shapes.
##| note that the trancegate does not work in the release section, so arrange your sounds accordingly.
##| also, please set your initial amp: setting to match the maxvol param, to avoid glitches.
##|   handle: the node returned by sample or play commands.
##|   duration: how long the effect lasts. Should line up with sustain of played sound.
##|   Please note that the effect does not work on the decay phase.
##|   period: how long the gate lasts. Can be a single value, a ring/list, or a comma-delimited list.
##|   maxvol: the max amplitude when the gate is open. Defaults to 1.
##|   minvol: the min amplitude when the gate is closed. Defaults to 0. 
##|   gutter: how long the silence lasts between chunks. Can be a single value, list/ring or comma-delimited list.
##|   lfotype: defaults to square, but supports all lfotypes.
##|   curve: lfo type curve param. Used for custom lfo types
##| Examples:
##| use_bpm 120
##| use_synth :bass_highend
##| handle = play 60, sustain: 16, decay: 1,res: 0.7, amp: 0
##| puts "handle: " + handle.to_s
##| trancegate handle, 16, euclidiate("s", 16, 5)
##| handle = sample :ambi_drone, 16
##| trancegate handle, 16, euclidiate("s", 16, 5)

define :trancegate do |handle, duration, period=[0.5], gutter=[0.1], delay=0, maxvol= [1], minvol=[0], lfotype="square",  curve=0, **kwargs|
  eval overridekwargs(kwargs, method(__method__).parameters) if boolish kwargs
   
  ##debugprint ""
  ##debugprint ""
  ##debugprint "top of trancegates"
 
  #cook args to rings
  
  ##debugprint "handle: ", handle
  ##debugprint " duration: " , duration
  ##debugprint "period: ", period
  ##debugprint "delay: ", delay
  ##debugprint "maxvol: ", maxvol
  ##debugprint "minvol: ", minvol
  ##debugprint "lfotype: " , lfotype
  ##debugprint "curve: " , curve
  
  ##debugprint "top of trancegate function, cooking args"
  debugmode = true
  ##debugprint "are we printing in debug?"
  if period.is_a? String
    ##debugprint "period is a string"
    mylist = []
    period.split(",").each do |item|
      ##debugprint "item: ", item
      triplet = 1
      dots = 1
      thisnumber = ""
      notetime = 0
      restsign = 1
      item.chars.each do |letter|
        ##debugprint "letter: ", letter
        case letter
        when "r"
          restsign = -1
        when "w"
          notetime += 4.0
          ##debugprint "w ", notetime
        when "h"
          notetime += 2.0
          ##debugprint "h ", notetim
        when "q"
          notetime += 1.0
          ##debugprint "q ", notetime
        when "e"
          notetime += 0.5
          ##debugprint "e ", notetime
        when "s"
          notetime += 0.25
          ##debugprint "s ", notetime
        when "d"
          dots *= 1.5
          ##debugprint "d ", dots
        when "t"
          triplet = 2.0 / 3
          ##debugprint "t ", triplet
        when /\d/, "."
          thisnumber = thisnumber + letter
          ##debugprint "thisnumber: " + thisnumber
        else
          ##debugprint "garbage letter, ignoring"
        end #case letter
      end #each letter
      notetime *= restsign
      ##debugprint "notetime: " , notetime
      ##debugprint "thisnumber: " , thisnumber
      ##debugprint "triplet: " ,triplet
      ##debugprint "dots: ", dots
      thisnumber = ( thisnumber == "" ? 1 : thisnumber.to_f )
      notetime *= dots * triplet * thisnumber
      ##debugprint "final notetime: " , notetime
      mylist << notetime
      ##debugprint "mylist: ", mylist
      
    end #each item
    period = mylist.ring
    ##debugprint "period: ", period
    
  else
    ##debugprint "period is not a string"
    period = [period].flatten.ring
  end #if period is a string
  ##debugprint "period: ", period
  
  if gutter.is_a? String
    ##debugprint "gutter is a string"
    mylist = []
    gutter.split(",").each do |item|
      mylist << item.to_f
    end #each item
    gutter = mylist.ring
  else
    ##debugprint "gutter is not a string"
    gutter = [gutter].flatten.ring
  end #if span a string
  ##debugprint "gutter ", gutter
  
  if maxvol.is_a? String
    ##debugprint "maxvol is string"
    maxvol = maxvol.split(",").map do |x| x.to_f end
  else
    ##debugprint "maxvol not a string"
    maxvol = maxvol.flatten.ring
  end #if maxvols is string
  ##debugprint "maxvol: ", maxvol
  
  if minvol.is_a? String
    ##debugprint "minvol is string"
    minvol = minvol.split(",").map do |x| x.to_f end
  else
    ##debugprint "minvol not a string"
    minvol = minvol.flatten.ring
  end #if maxvols is string
  ##debugprint "maxvol: ", maxvol
  
  
  if lfotype.is_a? String
    ##debugprint "lfotype is a string"
    lfotype = lfotype.split(",").ring
  else
    ##debugprint "lfotype not a string"
    lfotype = [lfotype].flatten.ring
  end #if lfotype a string
  ##debugprint "lfotype: ",lfotype
  
  if curve.is_a? String
    ##debugprint "curve is a string"
    curve = curve.split(",").ring
  else
    ##debugprint "curve not a string"
    curve = [curve].flatten.ring
  end #if lfocurve a string
  ##debugprint "curve ", curve
  slideparam = "amp_slide"
  shapeparam = "amp_shape"
  curveparam = "amp_curve"
  
  
  
  in_thread do
    
    
    sleep delay
    duration -= delay
    
    while duration > 0 do
      ##debugprint "top of while loop, duration ", duration
      tick
      
      if period.look > 0
        
        
        
        case lfotype.look[0..2].downcase
        when "tri"
          ##debugprint "triangle"
          shape = 1 #linear
        when "saw"
          ##debugprint "saw"
          shape = 1 #linear
        when "sin"
          ##debugprint "sine"
          shape = 3 #sine
        when "smo"
          ##debugprint "smooth random"
          shape = 3 #sine
        when "ran"
          ##debugprint "random"
          shape = 3 #sine
        when "ste"
          ##debugprint "step random"
          shape = 0 #step
        when "squ"
          ##debugprint "square"
          shape = 0 #step
        when "cus"
          puts "custom"
          shape = 5 #custom
        else
          ##debugprint "garbage, defaulting to square"
          shape = 0 #step
        end
        
        ##debugprint "maxvol: ", maxvol.look
        ##debugprint "period: ", period.look
        ##debugprint "gutter: ", gutter.look
        ##debugprint "shape: ", shape
        ##debugprint "curve: ", curve
        
        
        
        
        cmd = "control handle, amp: " + maxvol.look.to_s + ", amp_slide: " + (period.look - gutter.look).to_s + ", amp_slide_shape: " + shape.to_s +  ", amp_slide_curve: " + curve.look.to_s
        ##debugprint "up cmd: ", cmd
        eval cmd
        sleep period.look - (gutter.look)
        
        cmd = "control handle, amp: " + minvol.look.to_s + ", amp_slide: " + (gutter.look).to_s + ", amp_slide_shape: " + shape.to_s +  ", amp_slide_curve: " + curve.look.to_s
        ##debugprint "down cmd: ", cmd
        eval cmd
        sleep gutter.look
        
        
        
      else
        sleep period.look.abs
      end #if period is positive
      
      duration -= (period.look.abs + gutter.look)
      ##debugprint "bottom of while loop"
      ##debugprint "duration: ", duration
    end #while

    stop
    
  end #thread

  ##debugprint "bottom of trancegate"
  ##debugprint ""
  ##debugprint ""
  
end #define trancegate



# striptrailingnils
# strips all trailing nil values in the given array  
# thisarray: the array to strip


define  :striptrailingnils do |thisarray, **kwargs|
  eval overridekwargs(kwargs, method(__method__).parameters)  if boolish kwargs
  cleanargs = stripparams kwargs, method(__method__).parameters

  while thisarray[-1] == nil do 
    ##debugprint "deleting trailing nil"
    thisarray.delete_at(-1)
  end
  ##debugprint "clean array: ", thisarray
  thisarray #return value

end #define striptrailingnils

# degreestoabsolutenotes
# takes an arrangement using degrees instead of absolute notes, and converts them to degrees.  
# Used to feed into arrange.  
# args:
# thisarrangement: arrangement fed into arrange -- see docs for arrange for details
# thiskey: the musical key. Defaults to :c4. 
# thisscale: the musical scale: defalts to major.



define  :degreestoabsolutenotes do |thisarrangement, thiskey=:c4, thisscale=:major, **kwargs|
  eval overridekwargs(kwargs, method(__method__).parameters) if boolish kwargs
  cleanargs = stripparams kwargs, method(__method__).parameters

  thisarrangement = rowstocolumns thisarrangement.split(",").map {|x| x = x.split(" ")}
  ##debugprint "thisarrangement: ", thisarrangement

  thisarrangement[1].map do |thisdegree|
    thisdegree = degree thisdegree, thiskey, thisscale
  end #each thisdegree

  thisarrangement = rowstocolumns thisarrangement
  thisarrangement.each do |nestedarray|
    ##debugprint "nestedarray: ", nestedarray
    nestedarray = striptrailingnils thisarray
  
  end #each nestedarray

  thisarrangement #return value
end #define degreestoabsolutenotes


# swing: add swing to a straight beat.  
# args:
# straightbeats: an array of times to swing 
# swingseed: the seed for how to swing it. Defaults to 6, which gives the normal 12/16 type swing. 
# Try odd numbers, fractions, for weird lurching swings. 
# humanizeamt: how much humanizing to add in. Defaults to 0. 
# 0.5 is a good value to add a little humanizing you feel but don't hear. 



define  :swing do |straightbeats, swingseed=6.0, humanizeamt=0.0, **kwargs|
  eval overridekwargs(kwargs, method(__method__).parameters) if boolish kwargs

  swingseed = (swingseed ||= 6.0).to_f
  humanize = (humanize ||= 0.0).to_f

  ##debugprint "top of swing"
  ##debugprint "straightbeats: ", straightbeats
  swingbeats = []
  leftover = 0 
  addin = 0  
  straightbeats.each_with_index do |straightbeat, i|
    straightbeat += addin
    addin = 0
    humanseed = swingseed + rrand(-humanizeamt, humanizeamt)
    ##debugprint "straightbeat: ", straightbeat
    straightbeat -= leftover  
    ##debugprint "straightbeat - leftover: ", straightbeat
    ##debugprint "straightbeat * humanseed: ", straightbeat * humanseed
    swingbeat = (straightbeat * humanseed).round(0, half: :up) / humanseed  
    ##debugprint "swingbeat: ", swingbeat
    leftover = swingbeat - straightbeat  
    ##debugprint "leftover: ", leftover
    if i == straightbeats.length
      ##debugprint "last beat, adding leftovers"
      swingbeat += leftover 
    end #if last beat
    if swingbeat > 0  
      ##debugprint "writing swingbeat"
      swingbeats << swingbeat 
    else 
      ##debugprint "setting addin to swingbeat"
      addin = swingbeat
    end #if time to write beat
  end #each straightbeat
  ##debugprint "swingbeats: ", swingbeats
  swingbeats #return value
end #define swing



# humanize: add some looseness to a beat. 
# A wrapper for swing with a swingseed of 8. 
# thesebeats: an array of time values defining the beat. 
# humanizeamt: the amount of looseness. Defaults to 0.5.  

define  :humanize do |thesebeats, humanizeamt=0.5, **kwargs|
  eval overridekwargs(kwargs, method(__method__).parameters) if boolish kwargs
  ##debugprint "top of humanize"

  swing thesebeats, 8.0, humanizeamt #return value
end #define humanize

# harmonic
# calculate the midi note corresponding to the harmonic provided. 
# args:
# thisnote: the midi note with the fundamental
# thisharmonic: the harmonic to calculate. Can be fractional!
# returns: midi note corresponding to the harmonic. 
# example: 
# harmonics = [7, 9, 11, 13, 15, 17, 19, 21]
# rootnotes = [:c3, :c2, :c1, :c0].reverse
# 4.times do
#   with_fx :flanger, phase: 4, wave: 0, mix: 0.25 do
#     with_fx :krush, mix: 0.25 do
#       with_synth_defaults amp: 0.5, attack: 0.125, duration: 0.25, release: 0.125 do
#         with_synth  :beep do
#           rootnotes.each do |rootnote|
#             harmonics.each do |harm|
#               #play rootnote
#               play :c4
#               play :g4
#               play :c5
#               play (harmonic rootnote, harm)
#               sleep 0.125
#             end
#           end
#         end
#       end
#     end
#   end
# end


define  :harmonic do |thisnote, thisharmonic, **kwargs|
  eval overridekwargs(kwargs, method(__method__).parameters)
  cleanargs = stripparams kwargs, method(__method__).parameters
  ##debugprint "top of harmonic"
  ##debugprint "thisnote: ", thisnote
  ##debugprint "thisharmonic: ", thisharmonic

  harmonicnote = hz_to_midi ((midi_to_hz thisnote) * thisharmonic)

  ##debugprint "harmonicnote: ", harmonicnote

  harmonicnote #return value
end #define harmonic

# stringtonestedarray  
# takes a string with nested delimiters, and transforms it into a nested array.  
# Useful for parsing mini-notation,
# args:  
# thisstring: the string to transform.  
# delims: the delimiters, either in a string or array; defaults to ", ". If in a string, each char is a separate delimiter.  
# example code:  
# stringtonestedarray "qd :c4, qd :ds4, :q :g4"
# returns: [["qd", ":c4"], ["qd", ":ds4"], ["qd", ":g4"]]

define  :stringtonestedarray do |thisstring, delims=", ", **kwargs|
  eval overridekwargs(kwargs, method(__method__).parameters)
  cleanargs = stripparams kwargs, method(__method__).parameters
  ##debugprint "top of stringtonestedarrays"
  ##debugprint "thisstring: ", thisstring
  if delims.is_a? String  
    ##debugprint "delims is a string, splitting"
    delims = delims.split("") 
  end #if delims is a string
  ##debugprint "delims: ", delims

  resultarray = []

  ##debugprint "got delims ", delims  
  delim = delims.delete_at(0)
  ##debugprint "delim: ", delim
  ##debugprint "delims: ", delims
  workingarray = thisstring.split(delim)
  ##debugprint "workingarray: ", workingarray
  if boolish delims 
    ##debugprint "got another delim, recursing"
    workingarray.each  do |thisitem| 
      ##debugprint "thisitem: ", thisitem
      thisitem = stringtonestedarray thisitem, delims  
      ##debugprint "thisitem after processing: ", thisitem
      resultarray << thisitem
      ##debugprint "resultarray: ", resultarray
    end #each thisitem 
    ##debugprint "final resultarray: ", resultarray
  else
    ##debugprint "no more delims, using workingarray"
    resultarray = workingarray
  end #if boolish delims after initial split
  ##debugprint "returning resultarray: ", resultarray
  resultarray #return value
end #define stringtonestedarrays




define  :nestedarraytostring do |thisarray, delims = ", ", **kwargs|
  eval overridekwargs(kwargs, method(__method__).parameters)
  cleanargs = stripparams kwargs, method(__method__).parameters
  ##debugprint "top of nestedarraytostring"
  ##debugprint "thisarray: ", thisarray
  if delims.is_a? String 
    ##debugprint "delims is a string, splitting"
    delims = delims.split("")
  end #if delims is a string
  ##debugprint "delims: ", delims

  thisstring = ""

  if boolish delims 
    ##debugprint "got delims, processing"
    delim = delims.delete_at(0)
    ##debugprint "delim: ", delim
    ##debugprint "delims: ", delims

    thisarray.each do |thisitem|
      ##debugprint "thisitem: ", thisite
      if thisitem.is_a? Array  
        ##debugprint "thisitem is an array"
        thisitem = nestedarraytostring thisitem, delims  
      elsif thisitem.is_a? String  
        ##debugprint "thisitem is a string, leaving alone"
      else 
        ##debugprint "thisitem is garbage, forcing string"
        thisitem = (thisitem || "").to_s  
      end #if thisitem is array or string  

      thisstring += thisitem  
    end #each thisitem
  end #if boolish delims
  thisstring #return value
end #define nestedarraytostring





# => executecmdlist
# => internal function to generate command list to perform all or part of an arrangement.
# => not for general use
define :executecmdlist do |mytimeline, mymelody, myextraargs, thatphrasedensity=0, defaults=nil, effects=nil, envelopes=nil, lfos=nil, trancegates=nil, notedensities=nil, tickorchoose=["tick","choose"], currentroot=:c4, currentscale=:major, **kwargs|
  eval overridekwargs(kwargs, method(__method__).parameters) if boolish kwargs

  #now traverse keys of the timeline, which are times, in order, and play samples at that time_warp
  ##debugprint " "
  ##debugprint " "
  ##debugprint " "
  ##debugprint " "
  ##debugprint "top of executecmdlist"
  ##debugprint "mytimeline: ", mytimeline
  ##debugprint "mymelody: ", mymelody
  ##debugprint "myextraargs: ", myextraargs
  ##debugprint "thatphrasedensity: ", thatphrasedensity ||=  0
  ##debugprint "effects: ", effects
  ##debugprint "envelopes: ", envelopes
  ##debugprint "lfos: ", lfos
  ##debugprint "notedensities: ", notedensities ||=  {}
  ##debugprint "tickorchoose: ", tickorchoose

  defaults ||= {}
  # defaults.map do |key, value|
  #   if value[0] != ","
  #     ##debugprint "adding comma to ", value
  #     value = ", " + value
  #     defaults[key] = value
  #   else 
  #     ##debugprint "no comma needed for", value
  #   end #if
  # end #each default

  defaults.each do |key, val|
    ##debugprint "key: ", key
    ##debugprint "val: ", val
    if val.is_a? String  
      ##debugprint "defaults are string, converting to hash"
      defaults[key] = argstohash val  
    end #if val is a string
  end #each key, val for defaults
  ##debugprint "defaults: ", defaults






  cmd = ""
  thatcmdlist = ["synctoslidingbpm"]
  enchiladalist = []
  notedensitymode = false
  effectivesound = nil #dynamic expression for chosensound, e.g. "[:sound1, :sound2].choose"
 
  if thatphrasedensity > 1  
    ##debugprint "got a phrase density, setting up thread and opening density"
    thatcmdlist << "in_thread do"
    thatcmdlist << "density " + thatphrasedensity.to_s + " do "
  # elsif notedensities != nil
  #   ##debugprint "got note densities, setting up thread"
  #   thatcmdlist << "in_thread do"
  else
    ##debugprint "no density"
  end #if thatphrasedensity
  
  ##debugprint "mytimeline: ", mytimeline
  ##debugprint "timeline keys sorted: ", mytimeline.keys.sort
  ##debugprint "mymelody: ", mymelody
  nextloop = 0
  maxtime = 0
  ##debugprint "about to sleep ", mytimeline.keys.sort[0]
  sleep mytimeline.keys.sort[0] #in case first time > 0, to create initial rest
  mytimeline.keys.sort.each do |thatkey|
    ##debugprint "top of thatkey loop"
    ##debugprint "thatkey: ", thatkey.to_s
    nextloop = nextloop + 1
    ##debugprint "next loop: ", nextloop.to_s 
    ##debugprint "timeline length: ", mytimeline.length.to_s
    # needsleep = false
    sleepytime = 0
    if mytimeline.length > nextloop then
      sleepytime = mytimeline.keys.sort[nextloop] - thatkey
      ##debugprint "not last loop."
      ##debugprint "next key: ", mytimeline.keys.sort[nextloop]
      ##debugprint "sleepytime: ", sleepytime
      #the amount to rest is the duration between that time and next time
      #that even accounts for triplets vs 4s vs dots
    else
      ##debugprint "last loop"
    end #if
    
    
    thattime = mytimeline[thatkey]
    ##debugprint "processing time array, thattime: ", thattime
    maxtime = 0
    gotanonrest = false  
    thattime.each do |thatsound|

      ##debugprint "top of thatsound loop"
      ##debugprint  "thatsound: ", thatsound
      ##debugprint"thatsound[0]: ", thatsound[0]
      ##debugprint"notedensities: ", notedensities
      ##debugprint "notedensities[thatsound[0]]: ", notedensities[thatsound[0]]

      ##debugprint "traversing thattime list"
      ##debugprint "thatsound[0]: ", thatsound[0]
      chosensound = thatsound[0]
      ##debugprint "chosensound: ", chosensound
      effectivesound = formattedsamplename(chosensound)
      ##debugprint "effectivesound: ", effectivesound
      if ringorlist(chosensound)
        ##debugprint "it's a ring or list"
        if tickorchoose[0].downcase == "c" #choose
          ##debugprint "choose mode"
          chosensound = chosensound.choose
        else
          ##debugprint "tick mode"
          chosensound = chosensound.tick 
        end #if tick or choose top level
        effectivesound = formattedsamplename(chosensound)


        ##debugprint "chosensound: ", chosensound
        ##debugprint "tickorchoose: ", tickorchoose
        if ringorlist(chosensound)
          ##debugprint "still a ring or list"
          if tickorchoose[1][0].downcase == "c"
            ##debugprint "choose mode 2nd level"
            effectivesound = chosensound.to_s + ".choose"
            chosensound = chosensound.choose 
          else
            ##debugprint "tick mode 2nd level"
            effectivesound = chosensound.to_s + ".tick"
            chosensound = chosensound.tick 
          end #if tick or choose level 2
        end #if ring or array level 2
      else
        ##debugprint "not a ring or list"
      end #if ring or array
      ##debugprint "chosensound: ",chosensound
      ##debugprint "effectivesound: ", effectivesound

      duration = thatsound[1]
      ##debugprint "duration: ", duration
      
      handle = nil #init here so it's scoped to be visible where needed
      
      thatnote = mymelody[thatsound[0]]
      ##debugprint "thatnote before testing: ", thatnote

      if (thatnote || ["tricksy hobbit!"])[0] != :rest  #kludge to deal with nil thatnote
        ##debugprint "not a rest, playing the sound"
        gotanonrest = true  

        tempdensity = 0

        if synth_names.to_a.include? chosensound
          ##debugprint "synth mode, getting note to play"
          thatnote = mymelody[thatsound[0]]
          ##debugprint "thatnote: ", thatnote
          ##debugprint "mymelody[thatsound[0]]: ", mymelody[thatsound[0]]
          mymelody[thatsound[0]] = mymelody[thatsound[0]].rotate #rotate note just played
          ##debugprint "thatnote: ", thatnote
          ##debugprint "thatnote[0]: ", thatnote[0]
          if thatnote[0].is_a? String
            ##debugprint "thatnote[0] is a string"
            if thatnote[0] =~ /:.*/
              ##debugprint "got a colon, turning to symbol"
              if thatnote[0].downcase =~ /[ixv]/ #degree symbol, e.g. :iii, :ix, etc  
                ##debugprint "degree symbol processing"
                cooknote = degree thatnote[0].delete_prefix(":").to_sym, currentroot, currentscale
              else
                ##debugprint "normal note processing"
                cooknote = thatnote[0].delete_prefix(":").to_sym
              end #if degree or normal note
              ##debugprint "cooknote:", cooknote
            elsif thatnote[0].downcase =~ /[ixv]/ #degree symbol, e.g. :iii, :ix, etc
              ##debugprint "degree symbol processing, no colon"
              cooknote = degree thatnote[0].delete_prefix(":").to_sym, currentroot, currentscale
            else
              ##debugprint "no colon, turning to int"
              cooknote = thatnote[0]
              ##debugprint "cooknote: ", cooknote
            end
          elsif thatnote[0] == :rest  
            ##debugprint "got a rest"
            cooknote = ":rest"
          else
            ##debugprint "thatnote[0] is a list/ring"
            cooknote = thatnote[0]
          end #if thatnote[0] is a string
          
          ##debugprint "converted thatnote: ", thatnote
          ##debugprint "cooknote: ", cooknote

          cmd = "handle = play " + symbolwithcolon(cooknote) + ", duration: " + duration.to_s 
          cmd += tickargs defaults[thatsound[0]]
          cmd += (myextraargs[thatsound] || "")
          cmd = "with_synth " + effectivesound + " do " + cmd + " end "
          ##debugprint "cmd: ", cmd



          ##debugprint "testing for effects"
          if effects[thatsound[0]] != nil
            ##debugprint "got effects for ", thatsound[0]
            if !effects[thatsound[0]].is_a? String
              ##debugprint "effects are in a list or ring, converted to semicolon-delimited string"
              effects[thatsound[0]] = effects[thatsound[0]].join(";")
            end


            effects[thatsound[0]].split(";").each do |effect|
              ##debugprint "adding effect ", effect
              cmd = "with_fx " + effect + " do " + cmd + " end "
            end #each effect
          else
            ##debugprint "no effects"
          end #if effects

          ##debugprint "cmd: ", cmd
          #eval cmd
          
        else
          ##debugprint "sample mode"
          ##debugprint "mymelody: ", mymelody
          ##debugprint "thatsound: ", thatsound
          ##debugprint "mymelody[thatsound[0]]: ", mymelody[thatsound[0]]
          if mymelody[thatsound[0]] != nil
            # TODO: add logic to test for note 0
            ##debugprint "got a melody, picking thatnote"
            thatnote = mymelody[thatsound[0]]
            ##debugprint "thatnote: ", thatnote
            ##debugprint "mymelody[thatsound[0]]: ", mymelody[thatsound[0]]
            mymelody[thatsound[0]] = mymelody[thatsound[0]].rotate #rotate note just played
            #need to add smarts for rings with fewer entries than notes played
            ##debugprint "thatnote: ", thatnote
            ##debugprint "thatnote[0]: ", thatnote[0]
            
            
            if thatnote[0].is_a? String  
              ##debugprint "thatnote[0] is a string or symbol"
              thatnote[0] = thatnote[0].to_s #force to string  
              if thatnote[0] =~ /:.*/
                ##debugprint "got a colon, turning to symbol"
                thatnote = thatnote[0].delete_prefix(":").to_sym
              else
                ##debugprint "no colon, turning to int"
                thatnote = thatnote[0].to_i
              end
              
              ##debugprint "formattedsamplename(effectivesound): ", formattedsamplename(effectivesound)
              ##debugprint "thatsound[1]: ", thatsound[1]
              cmd = "handle = transposesample "+ formattedsamplename(effectivesound) + ", pitch_stretch: "  + thatsound[1].to_s + ", rpitch: " + thatnote.to_s + (mymelody[thatsound] || "")
              ##debugprint "defaults[thatsound[0]]: ", defaults[thatsound[0]]
              cmd += (tickargs defaults[thatsound[0]] || "")

              ##debugprint "cmd: ", cmd

              if effects[thatsound[0]] != nil
                effects[thatsound[0]].split(";").each do |effect|
                  ##debugprint "adding effect ", effect
                  cmd = "with_fx " + effect + " do " + cmd + " end "
                end #each effect
              else
                ##debugprint "no effects"
              end #if effects
              ##debugprint "cmd: ", cmd

              #eval cmd 

            elsif thatnote[0] == :rest  
              ##debugprint "got a rest, setting cmd to empty string"
              cmd = ""
              
            else
              ##debugprint "thatnote[0] is a list/ring"
              thatnote[0].each do |onenote|
                ##debugprint "onenote: ", onenote
                pitch_stretch_ratio = midi_to_hz(60 + onenote) / midi_to_hz(60)

                cmd = "handle = transposesample " + formattedsamplename(effectivesound) + ", pitch_stretch: " + thatsound[1].to_s + ", rpitch: " + onenote.to_s
                cmd += (tickargs defaults[thatsound[0]] || "")
                cmd += (extraargs[thatsound] || "")



                # don't think I need this any more, moved outside of note testing

                # if effects[thatsound[0]] != nil
                #   effects[thatsound[0]].split(";").each do |effect|
                #     ##debugprint "adding effect ", effect
                #     cmd = "with_fx " + effect + " do " + cmd + " end "
                #   end #each effect
                #   ##debugprint "cooked cmd with effects: ", cmd
                # else
                #   ##debugprint "no effects"
                # end #if effects
                # ##debugprint "cmd: ", cmd
                # #eval cmd 


              end #each note

              
            end #if thatnote[0] is a string
          
          else
            
            ##debugprint "no note, play sample stark naked"
            ##debugprint "thatsound: ", thatsound
            ##debugprint "thatsound[0]: ", thatsound[0]
            ##debugprint "myextraargs: ", myextraargs
            ##debugprint "mymelody[thatsound[0]]: ", mymelody[thatsound[0]]
            ##debugprint "defaults: ", defaults
            ##debugprint "thatphrasedensity: ", thatphrasedensity
            
            #need to add code for pitch shifting samples
            cmd = "handle = sample " + formattedsamplename(effectivesound)
            cmd += (tickargs defaults[thatsound[0]] || "")

            ##debugprint "cmd: ", cmd


          end #if got a note

          if effects[thatsound[0]] != nil
            effects[thatsound[0]].split(";").each do |effect|
              ##debugprint "adding effect ", effect
              cmd = "with_fx " + effect + " do " + cmd + " end "
            end #each effect
            ##debugprint "cooked cmd with effects: ", cmd
          end #if effects
          ##debugprint "cmd: ", cmd
          #eval cmd 

          if notedensities[thatsound[0]] != nil  
            # ##debugprint "got a notedensity"
            if tickorchoose[0] == "tick"
              tempdensity = notedensities[thatsound[0]].tick
            else 
              tempdensity = notedensities[thatsound[0]].choose 
            end #if tick or choose
            ##debugprint "tempdensity: ", tempdensity

            cmd =  "in_thread do ; density " + tempdensity.to_s + " do ; " + cmd   if tempdensity > 1  
          end #if got a notedensity
         
        end #if synth or sample
      else
        ##debugprint "got a rest, not playing sound"
        gotarest = true  
        mymelody[thatsound[0]] = mymelody[thatsound[0]].rotate #rotate note just played
      end #if not a rest

      if notedensities[thatsound[0]] || envelopes[thatsound[0]] || lfos[thatsound[0]] || trancegates[thatsound[0]]
        ##debugprint "got a wrapper, scoping handle"
        cmd = "handle = nil ; " + cmd
      else 
        ##debugprint "no wrapper"
      end #if got a wrapper
      ##debugprint "cmd: ", cmd


      ##debugprint "final cmd: ", cmd 
      thatcmdlist << cmd 
      ##debugprint "thatcmdlist: ", thatcmdlist 

      

      ##debugprint "testing for envelopes, lfos, trancegates"
      ##debugprint "thatsound: ", thatsound
      ##debugprint "chosensound: ", chosensound
      ##debugprint "envelopes[thatsound[0]]: ", envelopes[thatsound[0]]
      ##debugprint "lfos[thatsound[0]]: ", lfos[thatsound[0]]
      ##debugprint "trancegates[thatsound[0]]: ", trancegates[thatsound[0]]
      
      
      if envelopes[thatsound[0]] != nil
        ##debugprint "got at least one envelope for ", thatsound[0]
        envelopes[thatsound[0]].each do |envelope|
          ##debugprint "envelope: ", envelope
          cmd = "env handle ," + envelope
          ##debugprint "cmd: ", cmd
          thatcmdlist << cmd
        end #each envelope
      else
        ##debugprint "no envelopes"
      end #if there's an envelope
      
      if lfos[thatsound[0]] != nil
        ##debugprint "got at least one lfo for ", thatsound[0]
        lfos[thatsound[0]].each do |lfo|
          ##debugprint "lfo: ", lfo
          cmd = "lfo handle ," + lfo
          ##debugprint "cmd: ", cmd
          thatcmdlist << cmd
        end #each lfo
      else
        ##debugprint "no lfos"
      end #if there's an envelope
     
       if trancegates[thatsound[0]] != nil
        ##debugprint "got a trancegate for ", chosensound
        cmd =  "trancegate handle ," + trancegates[thatsound[0]]
        ##debugprint cmd
        thatcmdlist <<  cmd
      else 
        ##debugprint "no trancegates"
      end #if there's an envelope





      ##debugprint "notedensities[thatsound[0]]: ", notedensities[thatsound[0]]
      if notedensities[thatsound[0]] != nil && tempdensity > 1  
        ##debugprint "got a notedensity: ", notedensities[thatsound[0]]

        cmd = "sleep " + sleepytime.to_s  
        ##debugprint "cmd: ", cmd
        thatcmdlist << cmd  if (thatnote || ["tricksy hobbit!"])[0] != :rest  #kludge for nil thatnote
        cmd = "end #notedensity"
        ##debugprint "cmd: ", cmd
        thatcmdlist << cmd 
        cmd = "stop"
        ##debugprint "cmd: ", cmd
        thatcmdlist << cmd  
        cmd = "end #thread"
        ##debugprint "cmd: ", cmd
        thatcmdlist << cmd  
      else
        ##debugprint "no note density > 1"
      end #if got density


      ##debugprint "that sound time: ", thatsound[1]
      maxtime = [thatsound[1], maxtime].max
      ##debugprint "maxtime: ", maxtime
      sleepytime = maxtime if mytimeline.length == nextloop




      ##debugprint "bottom of thatsound loop"

    end #each thatsound

    ##debugprint "gotanonrest: ", gotanonrest

    ##debugprint "sleepytime: ", sleepytime
    cmd = "sleep " + sleepytime.to_s  
    thatcmdlist << cmd if gotanonrest



    #former spot for notedensity closure

    if thatphrasedensity < 2 #and notedensities[thattime[0][0]] != nil 
      ##debugprint "not in density mode, executing commands per time"
      ##debugprint "thatcmdlist: ", thatcmdlist
      #FOO
      ##debugprint "current_bpm: ", current_bpm
      eval thatcmdlist.join("\n")
      enchiladalist.append thatcmdlist
      thatcmdlist = ["synctoslidingbpm"]
    else 
      ##debugprint "density mode, not executing yet"
      thatcmdlist << "synctoslidingbpm"
    end #if not in phrasedensity mode

    ##debugprint "bottom of thattime/thatkey loop"

  end #thattime/thatkey

  ##debugprint "outside of thattime loop, about to test for thatphrasedensity"

  if thatphrasedensity > 1
    ##debugprint "got a phrasedensity: ", thatphrasedensity
    thatcmdlist << "end #phrasedensity"
    thatcmdlist << "stop"
    thatcmdlist << "end #in_thread"
    ##debugprint "about to execute phrasedentity commands"
    ##debugprint "thatcmdlist: ", thatcmdlist.join("\n")
    eval thatcmdlist.join("\n")
    enchiladalist.append thatcmdlist

    thatcmdlist = []
  # elsif notedensities != nil  
  #   ##debugprint "got a notedensity, closing thread"
  #   thatcmdlist << "stop"
  #   thatcmdlist << "end #in_thread"
  #   eval thatcmdlist.join("\n")
  #   thatcmdlist = []
  else
    ##debugprint "no phrasedensity, killing sliding bpm"
    killslidingbpm
  end #if thatphrasedensity or notedensities

  ##debugprint "after testing thatphrasedensity / notedensities"

  ##debugprint "thatcmdlist: ", thatcmdlist, expandlist: true

  enchiladalist #return value

end #define executecmdlist


# cooktime  
# args: 
# timestring: the string to cook into times.
# humanizeamt: the amount to humanize each duration. Defaults to 0. 
# turns a text string into a duration time. Supports one-letter shorcuts for note lengths, dots and triplets.  
# b: whole bar (16 beats)
# w: whole note (4 beats) 
# h: half note  (2 beats)
# q: quarter note (1 beat)
# e: eighth note (.5 beat)
# s: sixteenth note (.25 beat)
# d: dotted (* 1.5) -- dots stack, so "dd" mutliplies by 2.25
# t: triplet (* 2.0 / 3.0) -- does not stack  
# r: rest
# dots and triplets apply to the entire time, not just to the last letter. 
# int: multiplies total by integer, so 4hq would be (1 + 2) * 4 = 12 beats  
# returns 2 values: a duration (float), and a boolean indicating whether or not it's a rest. 


define :cooktime do |timestring, humanizeamt=0.0|
  ##debugprint "top of cooktime"
  ##debugprint "timestring: ", timestring
  ##debugprint "humanizeamt: ", humanizeamt
  timetillnext = 0
  duration = ""
  takerest = false
  triplets = 1
  dots = 0
  humanizeamt ||= 0.0  

  timestring = (convertdrumnotation timestring)[0]
  ##debugprint "timestring after converting drum notation: ", timestring

  timestring.each_char do |letter|
    ##debugprint "letter: ", letter
    case letter.downcase
    when " "
      ##debugprint "got a whitespace, breaking"
      break
    when "r"
      ##debugprint "r, rest"
      takerest = true
    when "b"
      ##debugprint "b, bar"
      timetillnext += 16.0  
    when "w"
      ##debugprint "w, whole note"
      timetillnext += 4.0
    when "h"
      ##debugprint "h, half note"
      timetillnext += 2.0
    when "q"
      ##debugprint "q, quarter note"
      timetillnext += 1.0
    when "e"
      ##debugprint "e, eighth note"
      timetillnext += 0.5
    when "s"
      ##debugprint "s, sixteenth note"
      timetillnext += 0.25
    when "d"
      ##debugprint "d, dotted"
      dots = dots + 1
    when "t"
      ##debugprint "t, triplet"
      triplets = 2.0 / 3
    when /\d/
      ##debugprint "duration digit"
      duration += letter
    else
      ##debugprint letter + " is garbage, ignored"
    end #case letter
  end #each letter
  
  
  ##debugprint "raw duration: ", duration.to_s
  if duration.length > 0
    duration = duration.to_i
  else
    duration = 1
  end #if duration length > 0
  ##debugprint "cooked duration: ", duration.to_s
  
  timetillnext = (timetillnext * duration * triplets * (2 - (0.5 ** dots))) + rrand(-humanizeamt, humanizeamt)
  [timetillnext, takerest] #return 2 values

end #define cooktime



# cooktimes 
# transform a delimited string of time expressions into an array of numbers 
# args:
# timestring: the string of times to cook
# humanizeamt: the amount to humanize the times. Defaults to 0.0. 
# delimiter: what separates items in the list. Defaults to ","
# timestring: a delimited string of time expressions (see cooktime for details)
# delimiter: defaults to ","
# e.g.: 
# cooktimes "e,q,e" returns [0.5, 1, 0.5]

define :cooktimes do |timestring, humanizeamt=0.0, delimiter=",", **kwargs|
  eval overridekwargs(kwargs, method(__method__).parameters) if boolish kwargs
  results = []
  timestring.split(delimiter).each do |thistime|
    ##debugprint "thistime: ", thistime
    results << cooktime(thistime, humanizeamt) 
  end #each thistime
  ##debugprint "results: ", results
  results #return value
end #define cooktimes  

# rowstocolumns
# takes an array of arrays, and transforms rows to columns. Can take any number of arrays.  
# *thesearrays: the arrays to flip
# if arrays are of unequal length, values will be filled with nils
# if you want to pad the shorter arrays, use paddedrowstocolumns instead

define :rowstocolumns do |*thesearrays|
  results = []
  if thesearrays.length == 1  
    thesearrays = thesearrays[0] #get rid of outer wrapping array
  end #if wrapped in an outer array
  thesearrays.each_with_index do |thisarray, j|
    thisarray.each_with_index do |thisitem, i|
      (results[i] ||= [])[j] = thisitem 
    end #each thisitem
  end #each thisarray
  results #return value
end #define rowstocolumns

# paddedrowstocolumns
# pads all arrays to the same length, repeating values in shorter arrays,
# then passes the arrays to rowstocolumns. 
# *thesearrays: the arrays to pad

define  :paddedrowstocolumns do |*thesearrays|

  ##debugprint "top of paddedrowstocolumns"
  if thesearrays.length == 1  
    thesearrays = thesearrays[0] #get rid of outer wrapping array
  end #if wrapped in an outer array

  maxlength = 0
  thesearrays.each do |thisarray|
    maxlength = thisarray.length if thisarray.length > maxlength 
  end #each thisarray
  thesearrays.each do |thisarray|
    if thisarray.length < maxlength
      originallength = thisarray.length  
      (0..maxlength-1).each do |i|
        thisarray[i] = thisarray[i % originallength]
      end #each i
    end #if thisarray.length < maxlength
  end #each thisarray


  rowstocolumns *thesearrays #return value
end #define paddedrowstocolumns



# playdegreematrix
# plays a melody from degrees of a scale passsed in. 
# args:
# thiskey: the root note of the key to be played, e.g., :c4 or 60. 
# thisscale: the scale to be played. 
# degreematrix: an array of arrays, where each inner array has 3 or 4 elements. 
# The first inner element is the duration to be played. 
# The second element is the scale degree to be played. 
# The third element is takerest, a boolean. If true, don't play a note, just sleep. 
# The fourth element is the octave shift (1 = up 12 tones, -1 = down 12 tones, etc. ) If omitted, defaults to 0. 
# Easiest to use rowstocolumns, feeding it 3 arrays for each of the above values. 
# You can optionally pass in parameters to control the sound, e.g., amp, cutoff, etc. 

define :playdegreematrix do |thiskey, thisscale, degreematrix, **kwargs |
  eval overridekwargs(kwargs, method(__method__).parameters) if boolish kwargs
  cleanargs = stripparams kwargs, method(__method__).parameters
  degreematrix.each do |matrixitem|
    thistime, thisdegree, takerest, shiftregister = matrixitem
    shiftregister = (shiftregister || 0) * 12
    if !takerest
      play degree(thisdegree, thiskey, thisscale) + shiftregister, **cleanargs
    end #if !takerest
    sleep matrixitem[0]
  end #each matrixitem
end #define playdegreematrix


# divisibleby
# tests whether the numerator is evenly divisible by the deominator. 
# args: numerator, denominator -- both numbers


define :divisibleby do |numerator, denominator|
  numerator.to_f / denominator.to_f == numerator.to_i / denominator.to_i
end 



define  :findclosingbracket do |drumnotation, brackets="[]", **kwargs|
  eval overridekwargs(kwargs, method(__method__).parameters) if boolish kwargs
  cleanargs = stripparams kwargs, method(__method__).parameters
  # ##debugprint "top of findclosingbracket"
  # ##debugprint "drumnotation: ", drumnotation

  return nil if drumnotation[0] != brackets[0]

  position = 0
  bracketcount = 0
  openbracket = brackets[0]
  closebracket = brackets[1]

  #code assumes that string starts with open bracket
  drumnotation.chars.each_with_index do |thischar, i|
    # ##debugprint "thischar: ", thischar
    ##debugprint "i: ", i

    if thischar == openbracket
      # ##debugprint "got an open bracket"
      bracketcount += 1
    elsif thischar == closebracket 
      # ##debugprint "got a close bracket"
      bracketcount -= 1
    end #if got openbracket or closebracket
    position = i
    break if bracketcount == 0
  end #each thischar, position

  # ##debugprint "position: ", position
  position #return value
end #define findclosingbracket



define  :splitbracketchunks do |drumnotation, brackets="[]", **kwargs|
  eval overridekwargs(kwargs, method(__method__).parameters) if boolish kwargs
  ##debugprint "top of splitbracketchunks"
  ##debugprint "drumnotation: ", drumnotation
  openbracket = brackets[0]
  closebracket = brackets[1]

  return [] if !boolish drumnotation 

  if drumnotation.count(brackets[0]) != drumnotation.count(brackets[1])
    ##debugprint "ERROR: unbalanced brackets"
    return []
  end if #unbalanced brackets


  chunks  = []

  while drumnotation.include? openbracket
    ##debugprint "got an open bracket"
    bracketspot = drumnotation.index(openbracket)
    if bracketspot > 0
      ##debugprint "nonbracketed code in front of bracket"
      chunks << drumnotation.slice(0..(bracketspot - 1))
      ##debugprint "chunks: ", chunks
      drumnotation = drumnotation.slice(bracketspot, drumnotation.length + 1)
      ##debugprint "drumnotation: ", drumnotation
    end # if bracketspot > 0
    chunks << drumnotation.slice(0, findclosingbracket(drumnotation, brackets) + 1)
    drumnotation = drumnotation.slice(findclosingbracket(drumnotation, brackets) + 1, drumnotation.length + 1)
    ##debugprint "drumnotation: ", drumnotation
    ##debugprint "chunks: ", chunks
  end #while drumnotation.include? openbracket
  chunks << drumnotation  if boolish drumnotation  
  ##debugprint "chunks: ", chunks
  chunks #return value
end #define splitbracketchunks

define  :countchunks do |drumnotation, brackets="[]", **kwargs|  
  eval overridekwargs(kwargs, method(__method__).parameters) if boolish kwargs

  ##debugprint "top of countchunks"
  ##debugprint "drumnotation: ", drumnotation

  return 0 if !boolish drumnotation  
  chunkcount = 0
  chunks = splitbracketchunks drumnotation, brackets  
  ##debugprint "chunks: ", chunks
  chunks.each do |thischunk|
    ##debugprint "thischunk: ", thischunk
    if thischunk.include? brackets[0]
      ##debugprint "counting a bracket chunk, adding 1"
      chunkcount += 1
    else
      ##debugprint "thischunk.length: ", thischunk.length
      chunkcount += thischunk.length
    end #if chunk has bracket
  end #each thischunk

  ##debugprint "chunkcount: ", chunkcount

   chunkcount #return value
end #define countchunks



# equalish
# determines whether two numbers (promoted to floats) are equal within a rounding error.  
# value1: first value to compare
# value2: second value to compare
# roundingerror the rounding error within which it counts as equalish. Defaults to 0.00000001. 
# Useful for comparing computed floats.  


define  :equalish do |value1, value2, roundingerror =0.00000001, **kwargs|
  eval overridekwargs(kwargs, method(__method__).parameters) if boolish kwargs
  # ##debugprint "top of equalish"
  # ##debugprint "value1: ", value1
  # ##debugprint "value2: ", value2
  # ##debugprint "roundingerror: ", roundingerror
  # ##debugprint "(value1.to_f - value2.to_f).abs < roundingerror: ", (value1.to_f - value2.to_f).abs < roundingerror
  (value1.to_f - value2.to_f).abs < roundingerror #return value
end #define equalish

# convertdrumnotation
# converts notation like this "x---x---x---x---" to this: "q,q,q,q"
# args:
# drumnotation: a string containing the drum notation. 
# barlength: the length of the bar, used as the basis for subdivision. Defaults to 4.
# baseamp: the default amp: value for each note, unless otherwise overridden. Defaults to 1. 
# maxamp: the maximum amp used. Defaults to 2.0. 
# restchar: the character used to denote rests. Defaults to "-".
# brackets: used to determine how nested expressions are delimited. Defaults to "[]". 
# Be sure to use 2 different characters!
# Subdivides a bar evenly, so if you supply 6 characters, they will be triplet quarters. 
# do not use the following chars in drum notation: "seqhwtd"
# It also supports cooking amps like this: "9---5---3---5---" to the corresponding amp argument,  
# based on multiplying the maxamp value * the number in the string / 9. This allows you to embed dynamics into drum parts.
# I stole this idea from d0lfyn in the sonic pi forum. It's a good idea!
# It also supports nested sections, which allows complex tuples and crazy breakbeats.
# Each nested section is one chunk long, so nested notes subdivide that chunk. 
# This is an idea I stole from Tidal Cycles. 
# So x[x[xx]] converts to "h,q,e,e" (assuming barlength of 4). 
# Be careful to balance brackets. If they're unbalanced, the result will evaluate to an empty string (to prevent an infinite recursion).
# You can also specify multiple comma-delimited bars, e.g.: "x[x[xx]],x--x---x,x[x[xx]],x--x--x-"
# if you pass in non-drumnotation (e.g., "dq,dq,q"), it is returned unchanged, with an amplist of all ones

define :convertdrumnotation do |drumnotation, barlength = 4.0, baseamp=1.0, maxamp=2.0, restchar="-", brackets="[]", **kwargs|
  eval overridekwargs(kwargs, method(__method__).parameters) if boolish kwargs
  #TODO: smart calculation of basechunk with comma-delimited drum notation
  ##debugprint "top of convertdrumnotation"

  drumnotation ||= ""

  openbracket = brackets[0]
  closebracket = brackets[1]
  ##debugprint "drumnotation: ", drumnotation
  ##debugprint "barlength: ", barlength

  # barlength *= drumnotation.split(",").length
  # ##debugprint "barlength padded: ", barlength
  barlength = barlength.to_f
  beatlist=""
  amplist=[]
  thisamp = 0
  # restmode=false
  # repeats=0
  # prevchar=beatlist[0] 
  thisbeat=nil
  comma=""
  # conversionmap={"ssssssssssssssss" => "w", "ssssssss"=>"h", "ssss"=>"q", "ss"=>"e", "eeeeeeee"=>"w", "eeee"=>"h", "ee"=>"q", "qqqq"=>"w", "qq"=>"h", "hh"=>"w"}
  chunkmap = {0.25 => "s", 0.5 => "e", 0.75 => "se", 1.0 => "q", 1.25 => "qs", 1.5 => "qe", 1.75 => "qse", 2.0 => "h", 2.25 => "hs", 2.5 => "he", 2.75 => "hse", 3.0 => "hq", 3.25 => "hqs", 3.5 => "hqe", 3.75 => "hqse", 4.0 => "w", 4.5 => "we", 5 => "wq", 5.5 => "wqe", 6.0 => "wh", 7.0 => "whe"}
  chunkcount = nil 
  basechunk = nil  

  if /[seqhwdt]/.match(drumnotation)
    ##debugprint "not drum notation, returning unchanged"
    beatlist = drumnotation
    amplist = knit(baseamp, beatlist.split(",").length).to_a
  elsif drumnotation.include? ","
    #add commaprocessing here
    ##debugprint "comma-delimited list, processing individual bar groups"
    drumnotation.split(",").each do |bargroup|
      ##debugprint "bargroup: ", bargroup
      bgbeatlist, bgamplist = convertdrumnotation bargroup, barlength, baseamp, maxamp, restchar, brackets, **kwargs
      ##debugprint "bgbeatlist: ", bgbeatlist
      ##debugprint "bgamplist: ", bgamplist
      beatlist += comma + bgbeatlist
      comma = ","
      amplist.append bgamplist
      ##debugprint "bgbeatlist: ", bgbeatlist
      ##debugprint "bgamplist: ", bgamplist
    end #each bargroup

  else
    ##debugprint "got some kind of beat notation, computing chunksize" 
    chunkcount = countchunks drumnotation, brackets 
    ##debugprint "chunkcount: ", chunkcount
    ##debugprint "barlength: ", barlength
    basechunk = barlength.to_f / chunkcount.to_f 
    ##debugprint "basechunk: ", basechunk
    basechunksymbol = basechunk.to_s  
    chunkmatch = chunkmap.keys.select {|x| x if equalish x, basechunk}
    ##debugprint "chunkmatch: ", chunkmatch


    if boolish chunkmatch #not an empty set
      ##debugprint "got a chunkmatch"
      basechunksymbol = chunkmap[chunkmatch[0]]
    elsif divisibleby(chunkcount, 3)  ##found a triplet in chunk map
      ##debugprint "chunk length divisible by 3, searching for matching triplet chunk"
      chunkmatch = chunkmap.keys.select {|x| x if equalish x, basechunk * 3.0 / 2.0}
      ##debugprint "chunkmatch: ", chunkmatch
      if boolish chunkmatch #not an empty set
        ##debugprint "got a triplet chunkmatch"
        basechunksymbol = "t" + chunkmap[chunkmatch[0]]
      else 
        ##debugprint "no triplet chunkmatch"
      end #if boolish triplet chunkmatch 
    else
      ##debugprint "no chunkmatch, no triplet, leaving chunk alone"
      basechunksymbol = basechunk.to_s
    end #if found chunk in chunkmap, either plain or in triplets
    ##debugprint "basechunksymbol: ", basechunksymbol 


    ##debugprint "checking for brackets"
    if drumnotation.include? openbracket
      ##debugprint "got an openbracket, calling splitbracketchunks"
      chunks = splitbracketchunks(drumnotation, brackets)
      ##debugprint "chunks: ", chunks
      chunks.each do |thischunk|
        ##debugprint "thischunk: ", thischunk
        chunklength = thischunk.length  
        if thischunk.include? openbracket  
          ##debugprint "got an openbracket in thischunk"
          chunklength = 1
          thischunk = thischunk.chop.reverse.chop.reverse #trim leading and trailing brackets
        end #if thischunk.include? openbracket 
        conversionresult = convertdrumnotation(thischunk, basechunk * chunklength, baseamp, maxamp, restchar, brackets, **kwargs)
        nestedbeatlist = conversionresult[0]
        nestedamplist = conversionresult[1]
        beatlist += comma + nestedbeatlist 
        comma = ","
        amplist.append nestedamplist 
      end #each thischunk

    else
      ##debugprint "drum notation without brackets, processing"

      drumnotation.each_char do |thischar|
        ##debugprint "processing a character"
        ##debugprint "thischar: ", thischar

        if thischar == restchar  
          ##debugprint "got a rest"
          thisbeat = comma + "r" + basechunksymbol  
          thisamp = 0
        elsif "0123456789".include? thischar 
          ##debugprint "got a digit"
          thisbeat = comma + basechunksymbol 
          thisamp = maxamp * thischar.to_f  / 9.0 
        else
          ##debugprint "not a rest or a digit"
          thisbeat = comma + basechunksymbol  
          thisamp = baseamp
        end #if got a rest or a digit

        ##debugprint "thisbeat: ", thisbeat

        ##debugprint "about to add thisbeat to beatlist"
        beatlist +=  thisbeat
        ##debugprint "beatlist: ", beatlist
        amplist << thisamp
        ##debugprint "amplist: ", amplist

        comma=","


      end #each thischar
      ##debugprint "after processing each char"  
      ##debugprint "beatlist: ", beatlist
      ##debugprint "amplist: ", amplist
    end #if bracketed or raw drum notation 
  end #if actually got drum notation

  ##debugprint "after processing drumnotation"
  ##debugprint "beatlist: ", beatlist
  ##debugprint "amplist: ", amplist
  [beatlist, amplist.flatten] #return values
end #define convertdrumnotation


# tuples  
# returns an array of times based on tupling the specified beats .
# args: 
# howmanytuples: an integer specifying how many tuples you want.  
# beatsize: the size of the beats to be tupled. Defaults to quarter (1). 
# example code:  tuples(5, half) returns [1.6, 1.6, 1.6, 1.6, 1.6]


define  :tuples do |howmanytuples, beatsize=quarter, **kwargs|
  eval overridekwargs(kwargs, method(__method__).parameters) if boolish kwargs
  ##debugprint "top of tuples"
  howmanybeats = 64  
  while howmanybeats > howmanytuples
    howmanybeats /= 2 
  end #while
  convertdrumnotation("x" * howmanytuples, beatsize * howmanybeats)[0] #return value
end #define tuples

# boolish 
# a looser version of getting a boolean from a value -- more perlish. 
# args:
# testvalue -- the value to treat as a boolean 
# falsies -- a list of values that evaluate to false. Defaults to [nil, false, 0, "", [], {}]


define :boolish do |testvalue, falsies=[nil, false, 0, 0.0, "", "0", [], [].ring, [[]], {}], **kwargs|
  eval overridekwargs(kwargs, method(__method__).parameters)

  !falsies.include? testvalue 
end

# hidearraycommas
# Utility function to hide commas within arrays inside arg strings (e.g. "amp:2, cutoff: [20, 40, 60]")
# argstring: the string to manipulate 
# Returns a cooked string, e.g.: "amp:2, cutoff: [20| 40| 60]"
define  :hidearraycommas do |argstring|
  # ##debugprint "top of hidearraycommas"
  # ##debugprint "argstring: ", argstring


  workingstring = argstring 
  resultstring = ""
  if workingstring !~ /\[(.*?\,.*?)\]/
    # ##debugprint "no comma, passing string through"
    resultstring = argstring 
  end #if got a comma
  while workingstring =~ /\[(.*?\,.*?)\]/ #has [.*,.*]  somewhere in string (with lazy matching) 
    # ##debugprint "got a match"
    before = $`
    foundarray = $~.to_s  
    after = $' 
    # ##debugprint "before: ", before
    # ##debugprint "foundarray: ", foundarray
    # ##debugprint "after: ", after

    foundarray.gsub! ",", "|" 
    resultstring += before + foundarray
    workingstring  = after 
    # ##debugprint "resultstring: ", resultstring
    # ##debugprint "workingstring: ", workingstring
  end #while got an array with commas
  resultstring #return value
end #define hidearraycommas


# showarraycommas
# Utility function to show previously hidden commas within arrays inside arg strings (e.g. "amp:2, cutoff: [20| 40| 60]")
# argstring: the string to manipulate 
# Returns a cooked string, e.g.: "amp:2, cutoff: [20, 40, 60]"
define  :showarraycommas do |argstring|
  ##debugprint "top of hidearraycommas"
  # ##debugprint "argstring: ", argstring


  workingstring = argstring 
  resultstring = ""
  while workingstring =~ /\[(.*?|.*?)\]/ #has [.*,.*]  somewhere in string (with lazy matching) 
    # ##debugprint "got a match"
    before = $`
    foundarray = $~.to_s  
    after = $' 
    # ##debugprint "before: ", before
    # ##debugprint "foundarray: ", foundarray
    # ##debugprint "after: ", after

    foundarray.gsub! "|", "," 
    resultstring += before + foundarray
    workingstring  = after 
    # ##debugprint "resultstring: ", resultstring
    # ##debugprint "workingstring: ", workingstring
  end #while got an array with commas
  resultstring #return value
end #define hidearraycommas




# argstohash  
# converts a comma-delimited string of arg: value pairs into a hash. 
# Useful for constructing command strings to feed into eval.  
# args: the arguments to turn into a hash.  If anything but a string, will return args unprocessed.  


define  :argstohash do |args|
  # ##debugprint "top of argstohash"
  args ||= {}
  # ##debugprint "args: ", args

  if args.is_a? String  
    # ##debugprint "got a string"
    args = hidearraycommas args  
    # ##debugprint "args after hidearraycommas: ", args
    argsarray = args.split(",")
    argshash = {}
    argsarray.each do |item|
      if (item || "") != ""
        # ##debugprint "got an item: ", item  
        key, val = item.split(/\:\s*/)
        # ##debugprint "key: ", key
        # ##debugprint "val: ", val
        key.delete_prefix!(" ") while key[0] == " "
        val.delete_prefix!(" ") while val[0] == " "
        key = key.to_sym
        if val =~ /\[.*\]/
          # ##debugprint "val is an array, converting"
          val = showarraycommas val
          val = eval val  #converts string "[1, 2, 3]" to array [1, 2, 3]
        elsif ["true", "false"].include? val  
          # ##debugprint "got a boolean, cooking"
          val = eval val  
        elsif val =~ /^[\d\.\-\s]*$/
          # ##debugprint "got a number, cooking"
          val = eval val  
        else
          # ##debugprint "val is not an array"
        end #if val is an array
        argshash[key] = val  
      else
        # ##debugprint "skipping blank item"
      end #if got an item
    end #each item
    args = argshash  
  else 
    # ##debugprint "not a string, returning unchanged"
  end #case args

  # ##debugprint "final args: ", args
  args #return value
end #define argstohash


# argstostring
# Converts a has of arg/value pairs into a comma delimited string (arg1: val1, arg2: val2, etc)
# Useful for constructing command strings to feed into eval.  
# args: the arguments to turn into a hash.  If anything but a string, will return args unprocessed.  
 
define  :argstostring do |args, **kwargs|
  eval overridekwargs(kwargs, method(__method__).parameters) if boolish kwargs
  cleanargs = stripparams kwargs, method(__method__).parameters
  ##debugprint "top of argstostring"

  args ||= ""

  if args.is_a? Hash  
    ##debugprint "got a hash"
    argstring = ""
    args.each do |key, val|
      argstring += ", " + key.to_s + ": " + val.to_s  
    end #each key, val
    args = argstring  
  else 
    ##debugprint "not a hash, returning unchanged"
  end #case args

  args #return value
end #define argstostring


# setarg 
# sets an arg to a val in args.  
# Useful for constructing command strings to feed to eval.  
# arg: the argument to set. A string.  
# val: the value for that arg. A string, or an array (to support tickargs). 
# If the intended value is a string, embed quotes, e.g. "'thisstring'",
# which results in "thisarg: 'thisstring'"
# args: the string or hash containing all the args. 
# returns args as a hash.

define  :setarg do |arg, val, args, **kwargs|
  eval overridekwargs(kwargs, method(__method__).parameters) if boolish kwargs
  ##debugprint "top of setarg"
  ##debugprint "arg: ", arg
  ##debugprint "val: ", val
  ##debugprint "args: ", args
  args = argstohash args  
  ##debugprint "args after argstohash: ", args
  args[arg] = val   
  ##debugprint "args after assigning arg: ", args
  args #return value
end #define setarg

# tickargs
# Returns a string of args, with all array values ticked.  
# args: a Hash of args, where all items whose values are arrays return ticked values.  
# Useful for constructing command strings to feed to eval.  

define  :tickargs do |args|
  # ##debugprint "top of tickargs"
  argstring = ""

  args = argstohash args  
  # ##debugprint "args: ", args
  args.each do |key, val|
    # ##debugprint "key: ", key
    # ##debugprint "val: ", val
    if val.is_a? String 
      # ##debugprint "val is a string"
      val = '"' + val + '"'
      # ##debugprint "val: ", val
    end #if val is a string
    if listorring val  
      # ##debugprint "got an array, ticking"
      argstring += ", " + key.to_s + ": " + val.look.to_s  
      val.tick
    else
      # ##debugprint "not an array"
      argstring += ", " + key.to_s + ": " + val.to_s  
    end
  end #each key, val
  args = argstring  
  args #return value
end #define tickargs



# stuttersample  
# play a sample, slicing it into chunks and applying densities to each chunk for a stutter-type effect. 
# args:
# thissample: the sample to play 
# stutters: an array of integers to feed into the density for each chunk. Defaults to [1] (no stutters)
# reverses: an array of booleans -- true to reverse, false for normal play. Defaults to [false] (no reverses)
# stutterchunks: either nil, or an array of which chunks to play. 
# If supplied, should be same length as stutters. 
# This supports repeating the same section multiple times, playing chunks out of order, etc. 
# Note that this does impact the order of reversals. So if stutterchunks[3] = 7, it will also use reverses[7].
# num_beats: how many beats the entire sample playback will be. Each chunk is stutters.length / num_beats.
# stretchmode: a string, either "pitch" or "beat". Used to determine how to stretch the slices. 
# The number of elements in the stutters array determines how many slices the sample is cut up into. 
# You can add any other args appropriate to the sample command, and they will be passed thru. See docs for sample. 
# if you specify an rpitch arg, it will call transposesample, and calculate the correct pitch_density based on the new pitch.
# if you provide a list or ring for rpitch, the chunks will have different pitches. Should be same length as stutters. 
# See docs for transposesample for details. 
# example:
# stuttersample :loop_amen_full, [1, 2, 4, 2, 1, 4, 3, 2], [false, true, false, false, true, false, false, false], [0, 0, 7, 3, 2, 4, 5, 1], 16



define  :stuttersample do |thissample, stutters=[1], reverses=[false], stutterchunks=nil, num_beats=4.0, stretchmode="pitch", **kwargs|
  eval overridekwargs(kwargs, method(__method__).parameters) if boolish kwargs
  cleanargs = stripparams kwargs, method(__method__).parameters
  ##debugprint "top of stuttersample"
  ##debugprint "cleanargs: ", cleanargs

  if !["pitch", "beat"].include? stretchmode
    stretchmode = "pitch"
  end
  cleanargs = setarg stretchmode + "_stretch", num_beats, cleanargs
  ##debugprint "cleanargs: ", cleanargs
  # stretchmode = ", " + stretchmode + "_stretch: " + num_beats.to_s 
  # ##debugprint "stretchmode: ", stretchmode 

  stutterchunks = stutterchunks.ring if stutterchunks 

  cmd = ""

  thissamplename = formattedsamplename(thissample)
  ##debugprint "thissamplename: ", thissamplename

  chunksleepytime = num_beats / stutters.length.to_f 

  if !listorring (stutters ||= [1])
    ##debugprint "making stutters an array"
    stutters = [stutters]
  end


  stutters.each_with_index do |chunk, i|
    ##debugprint "chunk: ", chunk
    ##debugprint "i: ", i
    if stutterchunks
      ##debugprint "got stutterchunks"
      i = stutterchunks[i]   
    else
      ##debugprint "no stutterchunks"
    end #if stutterchunk
    ##debugprint "i: ", i
    thisrate = ( reverses[i] ? -1 : 1) #if true, reverse
    chunkargs = tickargs cleanargs
    if cleanargs.keys.include? :rpitch
      ##debugprint "transposing sample"
      cmd = "transposesample " + thissamplename + ", num_slices: " + stutters.length.to_s + ", slice: " + i.to_s + ", pitch_stretch: 1, rate: " + thisrate.to_s + (argstostring chunkargs)
      #transposesample thissamplename, num_slices: stutters.length, slice: i, pitch_stretch: 1, rate: thisrate, **chunkargs
    else
      ##debugprint "normal sample"
      cmd = "sample " + thissamplename + ", num_slices: " + stutters.length.to_s + ", slice: " + i.to_s + ", rate: " + thisrate.to_s + (argstostring chunkargs)
      # sample thissample, num_slices: stutters.length, slice: i, rate: thisrate, **chunkargs
    end #if got rpitch
    ##debugprint "chunksleepytime: ", chunksleepytime
    cmd += " ; sleep " + chunksleepytime.to_s
    cmd = "density " + chunk.to_s + " do " + cmd + " end"
    ##debugprint "cmd: ", cmd
    eval cmd
    #sleep chunksleepytime
    
  end #each chunk, i

  nil   #return value
end #define stuttersample













# slidebpm
# changes bpm gradually or stepwise over time, e.g., accelerando or ritardo. 
# args:
# targetpbm: the bpm(s) you want to end up at. Can be an array, and it will do them sequentially.  
# slidetime: how long it takes to get to each targetbpm, in beats.  
# steptime: how long each step is. Small numbers makes the transition smoother, 
# larger numbers give you the "little nash rambler" effect.  
# startbpm: the starting bpm. If not supplied, defaults to whatever the current bpm is. 
# cuename: the name of the cue for other threads to sync to; defaults to :bpmsync
# setname: flag for other threads to snif to see if we're sliding; defaults to :slidingbpm
# killswitch: flag to see if we need to kill the thread; defaults to :killslidingbpm 


define  :slidebpm do |targetbpm, slidetime=16, steptime=0.0625, startbpm=nil, cuename=:bpmsync, setname=:slidingbpm, killswitch=:killslidingbpm, **kwargs|
  eval overridekwargs(kwargs, method(__method__).parameters)
  cleanargs = stripparams kwargs, method(__method__).parameters
  ##debugprint "top of slidebpm"

  set setname,  true  
  set :killslidingbpm, false  

  steptime = steptime.to_f
  slidetime = slidetime.to_f  

  if !ringorlist  targetbpm 
    targetbpm = [targetbpm]
  end #if not ring or list already

  ##debugprint "targetbpm: ", targetbpm
  ##debugprint "slidetime: ", slidetime
  ##debugprint "steptime: ", steptime
  ##debugprint "startbpm: ", startbpm 

  thisbpm = startbpm || current_bpm
  ##debugprint "thisbpm: ", thisbpm


  targetbpm.each do |tbpm|
    ##debugprint "tbpm: ", tbpm
    killnow = get(killswitch)
    ##debugprint "killnow: ", killnow
     if killnow
      ##debugprint "killing now" 
      stop 
    else 
      ##debugprint "normal processing"
    end  

    stepsize = (tbpm - thisbpm) * steptime / slidetime 
    ##debugprint "stepsize: ", stepsize
    while !equalish(thisbpm, tbpm)  
      thisbpm += stepsize
      ##debugprint "thisbpm: ", thisbpm
      use_bpm thisbpm
      cue cuename
      sleep steptime
    end #while
  end #each tbpm

  set setname, nil  

  nil #return value
end #define slidebpm


# synctoslidingbpm: syncs current thread to sliding bpm managed by slidebpm. 
# args:
# cuename: the syncing cue managed by slidebpm, defaults to :bpmsync
# setname: the set flag managed by slidebpm, defaults to :slidingbpm. Only syncs when not nil/false. 

define  :synctoslidingbpm do |cuename=:bpmsync, setname=:slidingbpm, **kwargs|
  eval overridekwargs(kwargs, method(__method__).parameters)
  cleanargs = stripparams kwargs, method(__method__).parameters
  ##debugprint "top of bpmsync"
  setflag = get[setname]
  if setflag 
    sync_bpm cuename 
  end #if currently sliding

  nil #return value

end #define synctoslidingbpm



# killslidingbpm 
# kills the thread managing the sliding bpm. 
# Warning: if it's not called in the thread, it will execute a naked stop, which will kill your playback.  
# args: 
# killswitch: the name of the flag variable used with set/get to pass the kill message. Defaults to :killslidingbpm.  



define  :killslidingbpm do |killswitch=:killslidingbpm, **kwargs|
  eval overridekwargs(kwargs, method(__method__).parameters)
  ##debugprint "top of killslidingbpm"
  set killswitch, true   
  true #return value
end #define killslidingbpm

# inttoroman   
# converts an integer to a roman number string.  
# args:  
# num: the number to convert   


define :inttoroman do |num|
  romanarray = {
    1000 => "m",
    900 => "cm",
    500 => "d",
    400 => "cd",
    100 => "c",
    90 => "xc",
    50 => "l",
    40 => "xl",
    10 => "x",
    9 => "ix",
    5 => "v",
    4 => "iv",
    1 => "i"
  }
  result = ""
  romanarray.each do |arab, roman|
    whole_part, num = num.divmod(arab)
    result += (roman * whole_part)
  end #each arab, roma
  result #return value
end #define inttoroman

# romantoint 
# turns a roman numeral into an integer.  
# args: 
# thisroman: the roman numeral to change to int; a string. 
# returns: an int. If the roman numeral is garbage, returns 0.  


define :romantoint do |thisroman|
  ##debugprint "top of romantoint"
  ##debugprint "thisroman: ", thisroman
  thisroman = thisroman.downcase
  specials = {'iv' => 4, 'ix' => 9, 'xl' => 40, 'xc' => 90, 'cd' => 400, 'cm' => 900}
  normals = {'i' => 1, 'v' => 5, 'x' => 10, 'l' => 50, 'c' => 100, 'd' => 500, 'm' => 1000}
  result = 0
  specialhits = thisroman.scan(/iv|ix|xl|xc|cd|cm/)
  ##debugprint "specialhits: ", specialhits
  if boolish specialhits
    ##debugprint "got a special case"
    specialhits.each do |hit| 
      ##debugprint "hit: ", hit
      result += specials[hit]
      ##debugprint "result: ", result
      ##debugprint "whacking hit"
      thisroman.gsub! hit, ""
      ##debugprint "thisroman: ", thisroman
    end
  else
    ##debugprint "no special case"
  end #if got a special
  ##debugprint "processing normals"
  thisroman.each_char do |c| 
    result += normals[c] 
  end
  ##debugprint "result: ", result
  result #return value
end #define romantoint



# notetodegree
# converts a midi note to the scale degree in the given scale.  
# args:
# thisnote: the note to convert to a degree.  
# rootnote: the root of the scale; defaults to :c4
# thisscale: the name of the scale; defaults to :major  
# returns: a scale degree, as symbol (e.g. :ii, :av, :dix), or nil if not found.  

define  :notetodegree do |thisnote, rootnote=:c4, thisscale=:major, **kwargs|
  eval overridekwargs(kwargs, method(__method__).parameters)
  ##debugprint "top of notetodegree"
  thisdegree = nil  
  thisnote = thisnote.to_i  
  ##debugprint "thisnote: ", thisnote
  ##debugprint "rootnote: ", rootnote
  ##debugprint "thisscale: ", thisscale
  workingscale = cleanchordorscale(scale(rootnote, thisscale, 2))
  ##debugprint "workingscale: ", workingscale
  while thisnote > workingscale.max do 
    ##debugprint "note too high: ", thisnote
    thisnote -= 12
  end #while too high

  while thisnote < workingscale.min do  
   ##debugprint "note too low: ", thisnote
    thisnote += 12
  end #while too low

  ##debugprint "thisnote: ", thisnote

  if workingscale.include? thisnote  
    ##debugprint "thisnote in scale"
    thisdegree = inttoroman(workingscale.index(thisnote) + 1)
  elsif workingscale.include? (thisnote + 1)
    ##debugprint "thisnote diminshed in scale"
    thisdegree = "d" + inttoroman(workingscale.index(thisnote + 1) + 1)
  elsif workingscale.include? (thisnote - 1)
     ##debugprint "thisnote augmented in scale"
    thisdegree = "a" + inttoroman(workingscale.index(thisnote - 1) + 1)
   elsif workingscale.include? (thisnote + 2)
    ##debugprint "thisnote double diminshed in scale"
    thisdegree = "d" + inttoroman(workingscale.index(thisnote + 2) + 1)
  elsif workingscale.include? (thisnote - 2)
     ##debugprint "thisnote doubleaugmented in scale"
    thisdegree = "a" + inttoroman(workingscale.index(thisnote - 2) + 1)
   else
      ##debugprint "can't find thisnote anywhere in scale"
 end

  thisdegree = thisdegree.to_sym if thisdegree #convert to symbol unless nil  
  thisdegree #return value
end #define notetodegree



##| arrange
##| allows user to arrange multiple samples/synths to play in time with each other in a single function
##| uses a hashtable where the key is the sample/synth and the value is a comma-delimited list of times/notes/chords/modes.
##|   w,h,q,e,s for time divisions, d for dotted, t for triplet. Supports any number of dots.
##|   Supports either individual samples or lists of samples (rings or arrays). 
##|   If a ring or array, will be picked at random or ticked through, based on the chooseortick param.
##|   For synth tones, you can specify a duration, then note, then, chord, then mode, delimited by spaces.
##|   e.g. "q :c4 m7 arp"
##|   Valid modes are: cho (chord), arp, asc (same as arp), des (descending arp) and ran (random)
##|   If mode is anything but chord, subsequent time divisions will play arp notes.
##|   e.g. "q :e4 maj7 arp,q,q,q" will arpeggiate through all four notes of the chord.
##|   If you specify a note and a chord/scale, but no mode, it will play in chord mode.
##|   You can mix and match modes on a single line.
##|   Please note that "major" and "minor" are both chords and scales.
##|   To force scale, use "ionian" and "aeolian" instead.
##|   e.g. "q :e4 maj,q :a4 min,e :d4 maj desc,e,e,e"
##| repetitions: a number of times to repeat the entire phrase with all instruments
##| defaults: a hash of default settings per voice, where the key to the hash is the sample or synth e.g. {bass => "note_slide_curve: 3"}
##| the value of the key/val pair can either be a comma-delimited string ("amp: 2, cutoff: 60"), or a hash. 
##| If you use a hash, you can supply an array of values for any key, and the values will be ticked through at runtime.
##| This allows support, e.g, of using numbers in drumnotation to play with the amp. Or, really, any param for play or sample. 
##| effects: a hash of effects to apply to each synth or sample, where the key is the instrument,
##|   and the value is the string that goes between "with_fx " and " do "
##| e.g. {bass=>["echo", "flanger"]} 
##| envelopes: a hash of envelopes (calls to the nv method), where the key to the hash is the sample or the synth,
##|   and the key is a list of strings, one per effect, which are the arguments (except the node handle) to the function.
##|   e.g. {bass => ["cutoff, quarter, sixteenth, quarter, quarter, 24, 96, 84", "note, quarter, sixteenth, whole, quarter, 36, 48, 43"]}
##| lfos: a hash of lfos, similar to envelopes. See lfo function for args.
##|   e.g. {lead => ["cutoff, quarter, [24,84],sine", "note, quarter, [36,48], square"]}
##| trancegates: a hash of trancegates, similar to envelopes. See trancegate function for args.
##|   e.g. {pad => ["whole * 4, 0.5"]}
##| notedensities: a number, list or ring, for applying note-by-note densities, per voice
##| phrasedensities: a number, specifying the density applied to the whole phrase, per voice
##| codeblocks: an array of either strings or arrays of strings, containing commands to execute.
##| If nested item is an array, it'll be joined into a string, delimited by " ; ", and evaluated. 
##| Can also be a string with a single block, and we'll wrap it as an array.
##| Make sure each block is the same or less time than the rest of the arrangement -- NO LIVE LOOPS!!!
##| Do not add threading code, we'll manage all that here. 
##| tickorchoose: defaults to a 2-value array ["tick", "choose"]. Top level behavior is governed by item 0, next level by item 1.
##|   By default, ticks through a list, supporting (e.g.) linear drum patterns, but 2nd level nestings are chosen randomly (round robins).
##| humanizeamt: either a float, or a hash of floats per instrument. 
##| Sets the amount (in beats) to provide range for humanizing times. Defaults to 0.0. A good value is 0.5.   
##| currentroot: the root note used to cook degree symbols into absolute pitches. 
##| currentscale: the scale used to cook detree symbols into absolute pitches. 
##| synthlayers: an array of arrays; each nested array is a group of synth names to clone. 
##| Cloning includes arrangement, defaults, effects, envelopes, lfos, trancegates, notedensities, phrasedensities. 
##| If you wish to apply variations for any of these, provide an explicit value for that synth; it will not be overridden.
##| To have no effect on a synth voice where the other voices have an effect, give it a key matching the synth name with a value of false,
##| e.g. lfos[:blade] = false
##|   While, in theory, there's no limit to how many instruments you can arrange,
##|   in practice you'll get lags and dropouts with too many. 
##|   Try using with_sched_ahead_time or use_sched_ahead_time if you experience this.
##|   Here's a code example, illustrating all the features available (this will almost certainly lag in playback):
# bass = :bass_foundation
# blade = :blade
# drone = :ambi_drone
# chords = :prophet
# cowbell = :drum_cowbell
# amen = :loop_amen_full
# snare =  :sn_dolf
# use_sample_bpm amen, num_beats: 16
# chords = :prophet
# verse = {}
# chorus = {}
# defaults = {}
# effects = {}
# envelopes = {}
# lfos = {}
# trancegates = {}
# phrasedensities = {}
# notedensities = {}
# tabla_ghe = [:tabla_ghe4, :tabla_ghe5, :tabla_ghe6, :tabla_ghe8]
# tabla_ke = [:tabla_ke1, :tabla_ke2, :tabla_ke3]
# tabla_tas = [:tabla_tas1, :tabla_tas2, :tabla_tas3]
# tabla_te = [:tabla_te1, :tabla_te2, :tabla_te_m, :tabla_te_ne]
# tabla_na = [:tabla_na, :tabla_na_o, :tabla_na_s, :tabla_tun1, :tabla_tun2, :tabla_tun3]
# tabla = [tabla_ghe, tabla_ke, tabla_ke, tabla_tas, tabla_te, tabla_te, tabla_te, tabla_te, tabla_na, tabla_na, tabla_na]
# tablarhythm = "e,s,s,e,s,s,s,s,e,e,e,e,s,s,e,s,s,s,s,e,e,e"
# tablarhythm += "," + tablarhythm
# verse[bass] = euclidiate(10,32, 0,  eighth, ":c1 minor_pentatonic arp,,,,")
# verse[tabla] = tablarhythm
# verse[cowbell] = euclidiate(24,64)
# verse[amen] = "4w"
# verse[blade] = "2w :c4, 2w :ds4"
# verse[drone] = "hd 0,hd 3,h 7,hd 0,hd 3,h 7"
# verse[chords] = "qd :c5 m7,qd :c5 m7,q :c5 m7,s :c5 m7 ran,s,s,s, s :c5 m7 ran,s,s,s,s :c5 m7 asc,s,s,s,s :c5 m7 desc,s,s,s,qd :c5 m7,qd :c5 m7,q :c5 m7,s :c5 :aeolian arp,s,s,s,s,s,s,s,s :c5 m7 asc,s,s,s,s :c5 m7 desc,s,s,s"
# verse[snare] = "x[x[xx]],x--x---x,x[x[xx]],x--x--x-"
# humanizeamt = {}
# humanizeamt[chords] = 0.05
# humanizeamt[blade] = 0.1
# defaults[drone] = "amp: 3"
# defaults[chords] = "amp: 0.25"
# defaults[cowbell] = "amp: 0.5"
# effects[blade] = ":krush"
# envelopes[blade] = "cutoff,half*dotted,quarter,whole*2,whole,5,50,15"
# lfos[blade] = "amp, 4*whole, quarter"
# lfos[amen] = "cutoff, 4*whole, quarter, [130,50], 'tri'"
# trancegates[blade] = "4*whole, [eighth * dotted, eighth * dotted, eighth], sixteenth"
# phrasedensities[blade] = 4
# notedensities = {tabla => [1, 2, 1, 2, 1] }
# densitystretchmode = {tabla => "pitch"}
# use_sample_bpm amen, num_beats: 16
# with_sched_ahead_time 1.5 do
#  arrange verse, 2, defaults , effects , envelopes , lfos, trancegates, phrasedensities: phrasedensities, notedensities: notedensities, humanizeamt: humanizeamt, currentroot: :c4, currentscale: :minor, synthlayers: [[:bass_foundation, :pluck]]
# end


define :arrange do |arrangement, repetitions=1, defaults=nil, effects=nil, envelopes=nil, lfos=nil, trancegates=nil, notedensities=nil, phrasedensities=nil, codeblocks=nil, tickorchoose=["tick","choose"], humanizeamt=0.0, currentroot=:c4, currentscale=:major, synthlayers=[[]], **kwargs|
  eval overridekwargs(kwargs, method(__method__).parameters) if boolish kwargs

  
  ##debugprint ""
  ##debugprint ""
  ##debugprint "top of arrange"

  timeline = {} #for the timing of notes
  melody = {} #for specified notes
  extraargs = {} #for initial values to match envelopes, lfos and trancegates
  # melody[nil] = nil #initialize with stub to simplify code
  defaults ||= {}
  effects ||= {}
  envelopes  ||=  {}
  lfos  ||= {}
  trancegates  ||=  {}
  notedensities ||= {}
  phrasedensities ||= {}
  codeblocks ||= []
  codeblocks = [codeblocks] if !listorring codeblocks #wrap naked strings in array
  repetitions  ||= 1
  currentroot ||= :c4  
  currentscale ||= :major 
  synthlayers ||= [[]]

  if !ringorlist synthlayers[0]
    ##debugprint "wrappying synthlayers"
    synthlayers = [synthlayers]
  else
    ##debugprint "synthlayers already wrapped"
  end #if synthlayers not wrapped

  cmd = ""
  thissleepytime = 0
  maxsleepytime = 0

  ##debugprint "arrangement: ", arrangement
  ##debugprint "repetitions: ", repetitions
  ##debugprint "defaults: ", defaults
  ##debugprint "effects: ", effects
  ##debugprint "envelopes: ", envelopes
  ##debugprint "lfos: ", lfos
  ##debugprint "trancegates: ", trancegates
  ##debugprint "notedensities: ", notedensities
  ##debugprint "phrasedensities: ", phrasedensities
  ##debugprint "tickorchoose: ", tickorchoose
  ##debugprint "currentroot: ", currentroot
  ##debugprint "currentscale: ", currentscale
  ##debugprint "synthlayers: ", synthlayers

  if boolish synthlayers  
    ##debugprint "got synthlayers, cloning"
    [arrangement, defaults, effects, envelopes, lfos, trancegates, notedensities, phrasedensities].each do |thishash|
      ##debugprint "thishash: ", thishash
      thishash = clonekeys thishash, synthlayers
      ##debugprint "thishash after cloning: ", thishash
    end #each thishash
  end #if boolish synthlayers




  if humanizeamt.is_a? Numeric
    ##debugprint "humanizeamt is a number"
    globalhumanizeamt = humanizeamt
    humanizeamt = {nil => humanizeamt}
  elsif humanizeamt.is_a? Hash 
    ##debugprint "humanize is a hash"
    globalhumanizeamt = humanizeamt[nil] || 0.0 
  else 
    ##debugprint "humanize is garbage"
    globalhumanizeamt = 0.0  
    humanizeamt = {nil => globalhumanizeamt}
  end #if humanize is number or hash
  ##debugprint "humanizeamt: ", humanizeamt
  ##debugprint "globalhumanizeamt: ", globalhumanizeamt
  



  ##debugprint "quoting first args in envelopes, initializing extra args for envelopes"
  envelopes.each do |key, valuelist|
    ##debugprint "key: ", key
    ##debugprint "valuelist: ", valuelist
    valuelist = [valuelist] if valuelist.is_a? String
    scrubbedlist = []
    valuelist.each do |value|
      ##debugprint "value: ", value 
      mylist = value.split(",")
      ##debugprint "mylist: ", mylist
      bareparam = mylist[0].gsub('"', '').gsub("'", '') #strip out quotes
      ##debugprint "mylist[0]", mylist[0]
      if mylist[0] !~ /["'].*["']/
        ##debugprint "no quotes"
        mylist[0] = '"' + mylist[0] + '"'
      end #if no quote
      cleanlist = mylist.join(",")
      ##debugprint "cleanlist: ", cleanlist
      scrubbedlist << cleanlist
      ##debugprint "scrubbedlist: ", scrubbedlist
      startvalue = ( mylist.length > 5 ? mylist[5] : "0")
      ##debugprint "startvalue: ", startvalue
      ##debugprint "bareparam: ", bareparam
      extraargs[key] = "" if extraargs[key] == nil
      extraargs[key] += ", " + bareparam + ": " + startvalue + ", " + bareparam + "_slide_shape: 3"
      ##debugprint "extraargs: ", extraargs
    end #each value
    ##debugprint "about to update scrubbedlist"
    envelopes[key] = scrubbedlist
    ##debugprint "scrubbedlist: ", scrubbedlist
  end #each key value pair
  ##debugprint "envelopes: ", envelopes



  ##debugprint "quoting first args in lfos, initializing extra args for lfos"
  lfos.each do |key, valuelist|
    ##debugprint "key: ", key 
    valuelist = [valuelist] if valuelist.is_a? String
    ##debugprint "valuelist: ", valuelist  
    scrubbedlist = []
    valuelist.each do |value|
      ##debugprint "value: ", value
      mylist = value.split(",")
      bareparam = mylist[0].gsub('"', '').gsub("'", '') #strip out quotes
      ##debugprint "mylist[0]: ", mylist[0]
      if mylist[0] !~ /["'].*["']/
        ##debugprint "no quotes"
        mylist[0].prepend('"').concat('"')
        ##debugprint "quoted mylist[0]: ", mylist[0]
      end #if no quote
      scrubbedlist << mylist.join(",")
      startvalue = ( mylist.length > 3 ? mylist[3] : "0")
      ##debugprint "startvalue: ", startvalue
      ##debugprint "ringorlist startvalue: ", ringorlist(startvalue)
      if ringorlist startvalue
        #could either be array literal [0,1] or ring literal (ring 0,1) or a variable
        #in any case, we want first value, so we'll play a game w/eval
        cmd = "startvalue = " + startvalue + "[0]"
        ##debugprint "cmd: ", cmd
        eval cmd 
      end #if
      extraargs[key] = "" if extraargs[key] == nil
      extraargs[key] += ", " + bareparam + ": " + startvalue + ", " + bareparam + "_slide_shape: 3"
    end #each value
    ##debugprint " final scrubbed list: ", scrubbedlist
    lfos[key]  = scrubbedlist
  end #each valuelist
  ##debugprint "lfos: ", lfos


  ##debugprint "initializing extra args for trancegates"
  trancegates.each do |key, value|
    #can't have multiple trancegates per voice, not an array
    mylist = value.split(",")
    startvalue = ( mylist.length > 4 ? mylist[1] : "1")
    extraargs[key] = "" if extraargs[key] == nil
    extraargs[key] += ", amp: " + startvalue 
  end #each
  ##debugprint "trancegates: ", trancegates.to_s
  

  ##debugprint "processing notedensities"
  notetimelines = {}
  notedensities.each do |key, value|
    ##debugprint "key: ", key 
    ##debugprint "value: ", value 
    if ringorlist (value)
      ##debugprint "already a ring or list"
      value = value.flatten.ring 
    elsif value.is_a? Number 
      ##debugprint "value is a single number"
      value = [value].ring 
    elsif value.is_a? String 
      ##debugprint "value is a comma-delimited string"
      value = value.split(",").ring 
    else
      ##debugprint "value is unsupported garbage, setting to one"
      value = [1].ring 
    end #if value is varous types
    ##debugprint "cooked value: ", value
    notedensities[key] = value 
  end #each notedensity key value



  ##debugprint "processing phrasedensities"
  phrasetimelines = {}
  phrasedensities.each do |key, value|
    ##debugprint "key: ", key 
    ##debugprint "value: ", value 
    if ringorlist (value)
      ##debugprint "ring or list, picking first value"
      value = value[0]
    elsif value.is_a? Numeric 
      ##debugprint "value is a single number, leaving untouched"
    else
      ##debugprint "value is unsupported garbage, setting to one"
      value = 1 
    end #if value is varous types
    ##debugprint "cooked value: ", value
    phrasedensities[key] = value 
    phrasetimelines[key] = {}
  end #each phrasedensities key value



  ##debugprint "defaults: ", defaults
  ##debugprint "effects: ", effects
  ##debugprint "envelopes: ", envelopes
  ##debugprint "lfos: ", lfos
  ##debugprint "trancegates: ", trancegates
  ##debugprint "notedensities: ", notedensities
  ##debugprint "phrasedensities: ", phrasedensities
  ##debugprint "extraargs: ", extraargs



  
  ##debugprint "arrangement: ", arrangement
  
  instruments = nil
  arrangement.each do |synthorsample, instr_times|
    thissleepytime = 0
    instr_times = instr_times.downcase
    ##debugprint " "
    ##debugprint " "
    ##debugprint "synthorsample ", synthorsample.to_s
    ##debugprint "instr_times before: ", instr_times.to_s
    instr_times, instr_amps = convertdrumnotation instr_times
    instr_amps = instr_amps.delete_if do |item| item == 0 end  
    ##debugprint "instr_times after: ", instr_times
    ##debugprint "instr_amps: ", instr_amps
    ##debugprint "defaults[synthorsample] before: ", defaults[synthorsample]
    defaults[synthorsample] = setarg "amp", instr_amps, defaults[synthorsample]
    ##debugprint "defaults[synthorsample] after: ", defaults[synthorsample]



    timetillnext = 0
    thistime = 0
    dots = 0
    triplets = 1
    takerest = false
    tonelist = Array.new
    
    
    thistone = nil
    thischord = nil
    thismode = nil
    oldtone = nil
    oldchord = nil
    oldmode = nil
    chordtone = nil
    chordcounter = 0

    forcetonemode = (instr_times =~ /\s/) #if there's a space anywhere in the string, force notes
                                      #this avoids the problem where some have notes but others don't
    ##debugprint "forcetonemode: ", forcetonemode

    instr_times.split(",").each_with_index do |thisnote, howmanytimes| 
      duration = ""
      ##debugprint "thisnote: ", thisnote.to_s
      ##debugprint "howmanytimes: ", howmanytimes
      ##debugprint "thistime: ", thistime.to_s
      oldtone = thistone
      oldchord = thischord
      oldmode = thismode
      ##debugprint "splitting thisnote"
      thisdur, thistone, thischord, thismode = thisnote.split(" ")
      ##debugprint "thisdur: ", thisdur
      ##debugprint "thistone: ", thistone
      ##debugprint "thischord: ", thischord
      ##debugprint "thismode: ", thismode
      if forcetonemode 
        ##debugprint "forcing default tone 0"
        thistone ||= "0"
      end #if forcetonemode && !thistone
      if thischord == nil and oldmode != nil and ["arp", "asc", "des", "ran"].include? oldmode[0..2].downcase
        ##debugprint "grabbing old tone, chord, mode"
        thistone = oldtone
        thischord = oldchord
        thismode = oldmode
      else
        ##debugprint "new mode, initializing chordcounter"
        chordcounter = howmanytimes
      end #if subbing in old chord and mode
      
      tonemode = thistone != nil
      chordmode = thischord != nil
      modemode = thismode != nil
      firsttone = nil
      
      ##debugprint "thisdur: ", thisdur.to_s
      ##debugprint "thistone: ", thistone.to_s
      ##debugprint "thischord: ", thischord.to_s
      ##debugprint "thismode: ", thismode.to_s
      ##debugprint "tonemode: ", tonemode.to_s
      ##debugprint "chordmode: ", chordmode.to_s
      ##debugprint "modemode: ", modemode.to_s

      ##debugprint "about to call cooktime"
      ##debugprint "synthorsample: ", synthorsample
      #TODO: add logic to pass amp param to sample/play commands
      timetillnext, takerest = cooktime thisdur, humanizeamt[synthorsample] || globalhumanizeamt
      ##debugprint "timetillnext: ", timetillnext
      ##debugprint "takerest: ", takerest
      if takerest
        ##debugprint "got a rest, forcing note to :rest"
        thistone = :rest 
      end #if takerest

      
      ##debugprint "timetillnext: ", timetillnext.to_s
      thissleepytime += timetillnext 
      ##debugprint "thissleepytime: ", thissleepytime 


      if chordmode and !takerest
        ##debugprint "chordmode"
        ##debugprint "thistone: ", thistone.to_s
        if chordtone == nil
          ##debugprint "first tone!"
          chordtone = thistone
        end #if firsttone nil
        
        chordtone = ( chordtone[0] == ":" ? chordtone.delete_prefix(":").to_sym : chordtone.to_i )
        thischord.gsub!(":", "") #to strip out leading colons
        ##debugprint "chordtone: ", chordtone.to_s
        if chord_names.to_a.include? thischord
          ##debugprint "chord"
          thistone = cleanchordorscale(chord chordtone, thischord)
        else
          ##debugprint "scale"
          thistone = cleanchordorscale(scale chordtone, thischord)
        end #if chord or scale
        ##debugprint "thistone: ", thistone.to_s
        if modemode
          ##debugprint "modemode"
          ##debugprint "mode ", thismode[0..2]
          workingchord = thistone # to make chord persist across arpeggiation
          ##debugprint "workingchord: ", workingchord
          ##debugprint "howmanytimes: ", howmanytimes
          ##debugprint "chordcounter: ", chordcounter
          ##debugprint "howmanytimes - chordcounter: ", howmanytimes - chordcounter
          case thismode[0..2].downcase
          when "ran"
            ##debugprint "random"
            with_random_seed Time.now.to_i do
              workingchord = workingchord.to_a.shuffle 
            end
            ##debugprint "workingchord: ", workingchord
            thistone = workingchord[howmanytimes - chordcounter]
          when "asc"
            ##debugprint "ascending arpeggio"
            thistone = workingchord[howmanytimes - chordcounter]
          when "arp"
            ##debugprint "ascending arpeggio"
            thistone = workingchord[howmanytimes - chordcounter]
          when "des"
            ##debugprint "descending arpeggio"
            thistone = workingchord.to_a.reverse[howmanytimes - chordcounter]
          else
            ##debugprint "chord mode, leave chord intact"
          end #if in random mode
        end #if mode mode
        ##debugprint "thistone: ", thistone.to_s
      else
        ##debugprint "not chordmode or taking a rest"
      end #if chordmode or !takerest
      
      
      
      
      
      
      ##debugprint "scheduling note in appropriate timeline"
      ##debugprint "phrasedensities: ", phrasedensities
      ##debugprint "synthorsample: ", synthorsample
      ##debugprint "phrasedensities[synthorsample]: ", phrasedensities[synthorsample]
      workingtimeline = timeline
      if (phrasedensities[synthorsample] || 0) > 1  
        ##debugprint "got a phrase density, switching working timeline to phrase timeline"
        phrasetimelines[synthorsample] ||= {}
        workingtimeline = phrasetimelines[synthorsample]
      end #if got phrasedensity 
      ##debugprint "workingtimeline: ", workingtimeline
      ##debugprint "phrasetimelines: ", phrasetimelines

      (workingtimeline[thistime] ||= []) << [synthorsample, timetillnext]
      ##debugprint "workingtimeline: ", workingtimeline
      ##debugprint "workingtimeline[thistime]: ", workingtimeline[thistime]

      
      ##debugprint "timeline: ", timeline.to_s
      ##debugprint "thistone: ", thistone.to_s
      if tonemode
        tonelist  << thistone
        ##debugprint "tonelist: ", tonelist.to_s
        tonelist.each_with_index do |x, i|
          ##debugprint "tonelist[" + i.to_s + "]: ", x\
        end #each
      # else
      #   ##debugprint "this is a rest, carry thistime to next item in loop to delay start of note"
      end #if tonemode

      # else
      #   ##debugprint "taking a rest"
        
      # end #if !takerest
      
      
      
      
      thistime = thistime + timetillnext
      timetillnext = 0
      dots = 0
      triplets = 1
      takerest = false
    end #each note for this instrument



    if tonelist.length > 0
      ##debugprint "got tones, adding to melody hash"
      ##debugprint "melody: ", melody
      ##debugprint "synthorsample: ", synthorsample
      ##debugprint "tonelist: ", tonelist
      melody[synthorsample] = tonelist
      ##debugprint "melody: ", melody
    end
    
    if thissleepytime > maxsleepytime
      ##debugprint "thissleepytime > maxsleepytime"  
      maxsleepytime = thissleepytime  
    else
      ##debugprint"no need to update maxsleepytime"
    end
    ##debugprint "maxsleepytime: ", maxsleepytime

  end #each instrument
  




  #preload samples to hopefully improve performance
  arrangement.keys.each do |thisitem| 
  ##debugprint "testing for sample: ", thisitem
  if all_sample_names.to_a.include? thisitem
    ##debugprint  thisitem.to_s, " is a sample symbol, loading"
    load_sample thisitem
  elsif thisitem.is_a? String
    if File.exist? thisitem
      ##debugprint thisitem, " is a sample path, loading"
      load_sample thisitem
    else
      ##debugprint thisitem " is a string, but not a file"
    end #if file exists
  else
    ##debugprint thisitem.to_s, " is not a sample"
  end #if it's a sample


  # put in code to call executecmdlist

  grandenchiladalist = []
  ##debugprint "processing repetitions ", repetitions
  repetitions.times do
    ##debugprint "repetition: ", tick

    ##debugprint "executing codeblocks, if any"
    codeblocks.each do |thisblock|
      if listorring thisblock 
        thisblock = thisblock.join " ; "
      end #if listorring thisblock 
      thisblock = "in_thread do ; " + thisblock + " ; stop ; end"
      ##debugprint "thisblock: ", thisblock
      eval thisblock 
    end #each codeblock
    grandenchiladalist.append codeblocks  



    ##debugprint "executing phrase density commands if any"
    ##debugprint "phrasedensities: ", phrasedensities
    ##debugprint "phrasetimelines: ", phrasetimelines
    phrasedensities.each do |thissynthorsample, ignore|
      if boolish phrasetimelines[thissynthorsample]
        ##debugprint"executing phrase density commands for ", thissynthorsample
        ##debugprint "phrasetimelines[thissynthorsample]: ", phrasetimelines[thissynthorsample]
        scratchlist = executecmdlist phrasetimelines[thissynthorsample], melody, extraargs, (phrasedensities[thissynthorsample] || 0), defaults, effects, envelopes, lfos, trancegates, notedensities, tickorchoose, currentroot, currentscale
        grandenchiladalist.append scratchlist
        ##debugprint "after executing phrase density commands"
      else 
        ##debugprint "no timeline, orphan density"
      end 
    end #each phrase density


    end


    if boolish timeline
      ##debugprint "executing normal commands"
      scratchlist = executecmdlist timeline, melody, extraargs, 0, defaults, effects, envelopes, lfos, trancegates, notedensities, tickorchoose, currentroot, currentscale
      grandenchiladalist.append scratchlist
      ##debugprint "after executing normal commands"
    else 
      ##debugprint "no normal timeline, not executing"
    end #if boolish timeline


    ##debugprint "grandenchiladalist: ", grandenchiladalist, expandlist=true 

  end #repetitions

 
 



  ##debugprint "bottom of arrange"
  ##debugprint ""
  ##debugprint ""

end #define arrange






# playline 
# Easy-to-use wrapper for arrange, allowing user to play one instrument. 
# Supports optional threading, which makes it useful for building a drum part from multiple samples (kick, snare, etc).each
# args:
# synthorsample: the name of the synth or sample to play. 
# notation: the notation for what to play -- either in musical notation ("q :e4, h :b4") or drumntation ("x--x--x-"). 
# threaded: boolean, defaults to true.  Wraps in in_thread if set to true.  
# kwargs: any other args provided. Will be passed to arrange. See arrange for options. 
# Sample code:  
# playline :bd_808, "x--x--x-", true
# playline :hat_gnu, "xxxxxxxxxx-xx-x-", true 
# playline :sn_dolf, "-x", true

define  :playline do |synthorsample, notation, threaded=true, **kwargs|
  eval overridekwargs(kwargs, method(__method__).parameters) if boolish kwargs
  cleanargs = stripparams kwargs, method(__method__).parameters
  ##debugprint "top of playline"
  arrangement = {synthorsample => notation}
  if threaded
    in_thread do  
      arrange arrangement, **kwargs  
      stop
    end #in_thread
  else
    arrange arrangement, **kwargs  
  end #if threaded    
  true #return value
end #define playline





# randomseed  
# generate a random random seed seed.  Say that three times fast!  
# args:
# modulo: the number to use in modulo math; defaults to 65536 (64k). Sets the max number of possible seeds. 

define  :randomseed do |modulo = 65536, **kwargs|
  eval overridekwargs(kwargs, method(__method__).parameters)
  ##debugprint "top of genchord"
  return Time.now.to_i % modulo
end #define randomseed



# genchord  
# generates chords and scales generatively, utilizing neo-reimannian theory.  
# args:  
# lastroot: the root note last used for chords & scales; defaults to :c4
# lastchord: the chord name last used; defaults to :major 
# lastscale: the scale name last used; defaults to :ionian
# lastshift: the shift last used; defaults to :diatonic. Valid values:  
# :diatonic -- stays within the scale mode we started in.  
# :blue -- shifts to the parallel minor (e.g., from :c4 :major to :ds4 :major, :c4 :minor, etc)
# in other words, :blue shifts add 3 flats to the scale.
# :yellow -- shifts to the parallel major of the relative minor (e.g., from :c4 :major to :a3 :major, :cs4 :minor, etc)
# in other words, :yellow shifts add 3 sharps to the scale. 
# return value: an array with 4 values:  
# [thisroot, thischord, thisscale, thisshift]
# On iterative calls, keep passing these values back in to generate the chords and scales.  
# sample code: 
# bar = 16.0
# whole = 4.0
# half =2.0
# quarter =1.0
# eighth =0.5
# sixteenth =0.25
# dotted =1.5
# triplet =2.0 / 3
# halftone = 1
# second = 2
# wholetone = 2
# min3 = 3
# maj3 = 4
# fourth = 5
# tritone = 6
# fifth = 7
# min6 = 8
# maj6 = 9
# min7 = 10
# maj7 = 11
# octave = 12
# set :thisroot, :c4
# set :firstroot, :c4
# set :thischord, :major
# set :thisscale, :ionian
# set :thisshift, :diatonic
# set :thispent, (get[:thischord].to_s + "_pentatonic").to_sym
# live_loop :manage, delay: 0.01 do
#   sleep bar * 3.99
#   ##debugprint "resetting chord and scale values"
#   thisroot, thischord, thisscale, thisshift = genchord get[:thisroot], get[:thischord], get[:thisscale], get[:thisshift]
#   thisroot -= octave if thisroot > get[:firstroot] + fifth #to keep from drifting ever upward
#   set :thisroot, thisroot
#   set :thischord, thischord
#   set :thisscale, thisscale
#   set :thisshift, thisshift
#   set :thispent, (thischord.to_s + "_pentatonic").to_sym
#   sleep bar * 0.01
# end
# with_synth :fm do
#   live_loop :sheen, sync: :manage do
#     leadroot = get[:thisroot] + octave + octave
#     ##| ##debugprint "leadroot: ", leadroot
#     [:i, :iii, :v, :vii].shuffle.each do |thisdegree|
#       thisnote = degree thisdegree, leadroot, get[:thisscale]
#       mydivisor = (midi_to_hz get[:thisroot]) / (midi_to_hz thisnote)
#       play thisnote, amp: 0.3, duration: half, divisor: mydivisor, attack: sixteenth, decay: sixteenth, depth: 2
#       sleep half
#     end
#   end
# end
# with_synth :bass_foundation do
#   live_loop :bass, sync: :manage do
#     bassroot = get[:thisroot] + (octave * -2)
#     ##| ##debugprint "bassroot: ", bassroot
#     [:i, :iii, :v, :vi].each do |thisdegree|
#       play (degree thisdegree, bassroot, get[:thisscale]), duration: whole * 2, attack: sixteenth
#       sleep whole * 2
#     end
#   end
# end
# with_fx :echo, phase: eighth * dotted, decay: whole do
#   with_fx :panslicer, phase: sixteenth do
#     with_synth :pluck do
#       live_loop :pluck, sync: :manage do
#         pluckroot = get[:thisroot] + octave
#         ##| ##debugprint "pluckroot: ", pluckroot
#         ##| ##debugprint "thispent: ", get[:thispent]
#         play (scale pluckroot, get[:thispent]).choose, amp: 1.5
#         sleep quarter
#       end
#     end
#   end
# end
# with_synth :zawa do
#   live_loop :piano, sync: :manage do
#     pianoroot = get[:thisroot]
#     with_fx :nlpf, cutoff: :e2 do
#       with_fx :nlpf, cutoff: pianoroot + octave + fifth do
#         ##| ##debugprint "pianoroot: ", pianoroot
#         [:viii, :vii, :vi, :v, :vi, :v, :iv, :iii, :vii, :vi, :v, :iv, :v, :iv, :iii, :ii, :ix, :viii, :vii, :vi, :vii, :vi, :v, :iv, :viii, :vii, :vi, :v, :vi, :v, :iv, :iii].each do |thisdegree|
#           play (degree thisdegree, pianoroot, get[:thisscale]),  amp: 4
#           sleep quarter
#         end
#       end
#     end
#   end
# end
# with_fx :flanger, phase: 2 do
#   with_fx :echo, phase: half * dotted, decay: bar * 2 do
#     with_synth :winwood_lead do
#       live_loop :chord do
#         chordroot = get[:thisroot]
#         [:i, :iii, :v, :vi].each do |thisdegree|
#           1.times do
#             play_chord (chord_degree thisdegree, chordroot, get[:thisscale], 4), duration: half , amp: 0.4
#             sleep whole * 2
#           end
#         end
#       end
#     end
#   end
# end
# live_loop :whoosh, sync: :manage, delay: sixteenth do
#   sample :ambi_dark_woosh, amp: 1
#   sleep [half * dotted, half * dotted, half].tick
# end
# live_loop :cymbal, sync: :manage do
#   sample :drum_splash_hard, rate: -1, beat_stretch: half, amp: 0.5
#   sleep [whole * dotted, whole * dotted, whole].tick
# end
# live_loop :kick, sync: :manage do
#   [sixteenth, quarter, quarter, quarter, eighth, sixteenth, eighth * dotted, eighth * dotted, eighth * dotted, eighth * dotted, eighth, eighth].each do |thismuch|
#     sample :bd_808, amp: 6
#     sleep thismuch
#   end
# end



define  :genchord do |lastroot=:c4, lastchord=:major, lastscale=:ionian, lastshift=:diatonic, **kwargs|
  eval overridekwargs(kwargs, method(__method__).parameters)
  cleanargs = stripparams kwargs, method(__method__).parameters
  ##debugprint "top of genchord"
  #defend against nil params
  ##debugprint "lastroot: ", lastroot ||= :c4
  ##debugprint "lastchord: ", lastchord ||= :major
  ##debugprint "lastscale: ", lastscale ||= :ionian  
  ##debugprint "lastshift: ", lastshift ||= :diatonic

  never = 0
  rare = 1
  slim = 3 
  middlin = 5
  likely = 8
  favorite = 10

  shifts = {:diatonic => 0, :blue => 3, :yellow => -3}
  shiftodds={
    :diatonic => 
      {:diatonic => likely, :blue => middlin, :yellow => middlin}, 
    :blue=> 
      {:diatonic => likely, :blue => slim, :yellow => middlin}, 
    :yellow=> 
      {:diatonic => likely, :blue => likely, :yellow => slim}
  }[lastshift]
  shiftpicks = []
  shiftodds.each do |key, val|
    ##debugprint "key: ", key
    ##debugprint "val: ", val
    shiftpicks.concat(knit(key, val).to_a) 
  end  
  ##debugprint "shiftpicks: ", shiftpicks
  thisshift = nil  
  with_random_seed randomseed do  
    thisshift = shiftpicks.choose  
  end
  ##debugprint "thisshift: ", thisshift

  thisroot = lastroot + shifts[thisshift]
  ##debugprint "thisroot: ", thisroot

  
  degreeodds = {
    :diatonic => {:ii => rare, :iii => rare, :iv => middlin, :v => likely, :vi => favorite}, 
    :blue => {:i => favorite, :ii => middlin, :iii => middlin, :iv => likely, :v => favorite}, 
    :yellow => {:i => 2, :ii => 1, :iii => 5, :iv => 3, :v => 4}
    }[thisshift]

  degrees = []
  degreeodds.each do |key, val|
    ##debugprint "key: ", key
    ##debugprint "val: ", val
    degrees.concat(knit(key, val).to_a)     
  end #each key, val
  thisdegree = nil  
  with_random_seed randomseed do  
    thisdegree = degrees.choose
  end  
  ##debugprint "thisdegree: ", thisdegree
  thisroot = degree thisdegree, thisroot, :ionian 
  ##debugprint "thisroot after degree shift: ", thisroot

  if [:i, :iv, :v].include? thisdegree  
    ##debugprint "got a major"
    thischord = :major   
  else
    ##debugprint "got a minor"
    thischord = :minor  
  end #if got a major
  ##debugprint "thischord: ", thischord

  scaleodds = {
      :major => {
        :diatonic => {
          :ionian => favorite, :lydian => slim, :mixolydian => likely
        }, #major/diatonic
        :blue => {
          :ionian => middlin, :lydian => favorite, :mixolydian => slim
        }, #major/blue
        :yellow => {
          :ionian => middlin, :lydian => slim, :mixolydian => favorite
        }#major/yellow
      }, #end of major choices
      :minor => {
        :diatonic => {
          :aeolian => favorite, :dorian => likely, :phrygian => slim
        }, #minor/diatonic
        :blue => {
          :aeolian => middlin, :dorian => favorite, :phrygian => slim
        }, #minor/blue
        :yellow => {
          :aeolian => middlin, :dorian => slim, :phrygian => likely
        }#minor/yellow
      }# end of minor choices
    }[thischord][thisshift]  #end of scale odds
    ##debugprint "scaleodds: ", scaleodds

    scales = []

    scaleodds.each do |key, val|
      ##debugprint "key: ", key
      ##debugprint "val: ", val
      scales.concat(knit(key, val).to_a)        
    end #each key, val
    ##debugprint "scales: ", scales
    thisscale = nil  
    with_random_seed randomseed do  
      thisscale = scales.choose  
    end
    ##debugprint "thisscale: ", thisscale
  
  [thisroot, thischord, thisscale, thisshift] #return value
end #define genchord







define  :yummyhelp do |helptopic=nil|
  ##debugprint "top of yummyhelp"
 
    helplist = {}
    helplist[nil] = %q(
  argstohash |args, **kwargs|
  argstostring |args, **kwargs|
  arpeggiate  |thesenotes, thesedelays, **synthdefaults|
  arrange  |arrangement, repetitions=1, defaults=nil, effects=nil, envelopes=nil, lfos=nil, trancegates=nil, notedensities=nil, phrasedensities=nil, tickorchoose=["tick","choose"], humanizeamt=0.0, **kwargs|
  arrayhashtohasharray  |arrayhash, makering=true|
  boolish  |testvalue, falsies=[nil, false, 0, 0.0, "", "0", [], [].ring, {}], **kwargs|
  cleanchordorscale  |myitem|
  clonekeys |thishash, keystoclone, falseflag=true, **kwargs|
  closestnote |thisnote, thisscale, **kwargs|  convertdrumnotation  |drumnotation, barlength = 4.0, baseamp=1.0, maxamp=2.0, restchar="-", brackets="[]", **kwargs|
  cooktime  |timestring, humanizeamt=0.0|
  cooktimes  |timestring, delimiter=",", humanizeamt=0.0, **kwargs|
  ##debugprint  |label, value=nil, expandlist=false, indents=0, indenttext="  ", logtofile=true, filename="c:/users/harry/desktop/scripting/sonicpi/debuglog.txt", **kwargs|
  degreestoabsolutenotes  |thisarrangement, thiskey=:c4, thisscale=:major, **kwargs|
  divisibleby  |numerator, denominator|
  env  |handle, param, attack=0.25, decay=0, sustain=1, release=0.25, startlevel=0, peaklevel=1, sustainlevel=0.5, **kwargs|
  equalish  |value1, value2, roundingerror =0.00000001, **kwargs|
  euclidiate  |beats,duration,rotations=0,beatvalue=sixteenth, notes=nil, **kwargs|
  funkyrandom  |totaltime=16, shortestbeat=0.25, restodds=8, **kwargs|
  funkify  |thissound, totaltime=16, shortestbeat=sixteenth, thesenotes=[:c4], densities=[1], tickorchoose="tick", **kwargs|
  genchord |lastroot=:c4, lastchord=:major, lastscale=:ionian, lastshift=:diatonic, **kwargs|
  harmonic |thisnote, thisharmonic|
  humanize |thesebeats, humanizeamt=0.5, **kwargs|
  inttoroman |num|
  killslidingbpm |killswitch=:killslidingbpm, **kwargs|
  listorring  |thisitem|
  lfo  |handle, param, duration, period=[0.5], span=(ring 0, 1), lfotype="triangle",  delay=0, rampupperiods=0, rampdowntime=0, lfocurve=0, **kwargs|
  notetodegree |thisnote, rootnote=:c4, thisscale=:major, **kwargs|
  overridekwargs  |kwargs, params, ignorenewargs=true, arglistname="kwargs"|
  paddedrowstocolumns |*thesearrays|
  playdegreematrix  |thiskey, thisscale, degreematrix, **kwargs |
  playline |synthorsample, notation, threaded=true, **kwargs|
  portamentomelody |thisarrangement, thissynth = :sine, note_slide = 0.0625, **kwargs|
  randomseed |modulo = 65536, **kwargs|
  ringorlist  |thisitem|
  romantoint |thisroman|
  rowstocolumns  |*thesearrays|
  samplebpm  |thissample, beats=4|
  setarg |arg, val, args, **kwargs|
  slidebpm |targetbpm, slidetime=16, steptime=0.0625, startbpm=nil, cuename=:bpmsync, setname=:slidingbpm, killswitch=:killslidingbpm, **kwargs|
  slidemelody |thisarrangement, thissynth = :sine, note_slide = 0.0625, **kwargs|
  spreadtobeats  |thisspread, beatvalue=sixteenth, notes=nil, **kwargs|
  stringtonestedarray |thisstring, delims=", ", **kwargs|
  stripparams  |kwargs, params|
  striptrailingnils  |thisarray, **kwargs|
  strum  |thesenotes, totaltime=1, strumspeed=0.05, **kwargs|
  stuttersample  |thissample, stutters=[1], beatspersample=1.0, reverses=[false], **kwargs|
  swing  |straightbeats, swingseed=6.0, humanizeamt=0.0, **kwargs|
  synctoslidingbpm |cuename=:bpmsync, setname=:slidingbpm, **kwargs|
  tickable  |thisitem|
  tickargs |args, **kwargs|
  trancegate  |handle, duration, period=[0.5], gutter=[0.1], delay=0, maxvol= [1], minvol=[0], lfotype="square",  curve=0, **kwargs|
  transposesample  |thissample, pitch_stretch=16, rpitch=0, time_dis=0.01, window_size=0.1, pitch_dis=0.01, **kwargs|
  tremolo |handle, amp=1, depth=1, rate=sixteenth, duration=whole, **kwargs|  tuples |howmanytuples, beatsize|
  vibrato |handle, pitch=0.25, rate=sixteenth, depth=0.25, duration=whole,  **kwargs|  yummyhelp  |helpitem=nil, **kwargs|
  yh  |helpitem=nil, **kwargs|
)

  helplist["argstohash"] = %q(
argstohash  
converts a comma-delimited string of arg: value pairs into a hash. 
Useful for constructing command strings to feed into eval.  
args: the arguments to turn into a hash.  If anything but a string, will return args unprocessed.  
)

  helplist["argstostring"] = %q(
argstostring
Converts a has of arg/value pairs into a comma delimited string (arg1: val1, arg2: val2, etc)
Useful for constructing command strings to feed into eval.  
args: the arguments to turn into a hash.  If anything but a string, will return args unprocessed.  
)

  helplist["arpeggiate"] = %q(
arpeggiate
A method to sequentially play the chord or scale or array/ring of notes passed in.
Args:
thesenotes: the ring/list of notes to play, maybe a chord or scale, or just a user-defined list.
thesedelays: either a single value, or an array of values, to sleep after playing each note.
synthdefaults: any additional args are assumed to be synth defaults, and will be used to change defaults per note.
Again, if a single value on each item, will be used on all notes. If a ring/list, will be ticked through for each note.
Example:
arpeggiate (chord :c4, "m7"), [0.1, 0.1, 0.1, 0.7], amp: 1.5, duration: [0.1, 0.1, 0.1, 0.7]
  )
    helplist["arrange"] = %q(
arrange
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
lfos[blade] = "amp, 4*whole, quarter"
lfos[amen] = "cutoff, 4*whole, quarter, [130,50], 'tri'"
trancegates[blade] = "4*whole, [eighth * dotted, eighth * dotted, eighth], sixteenth"
phrasedensities[blade] = 4
notedensities = {tabla => [1, 2, 1, 2, 1] }
densitystretchmode = {tabla => "pitch"}
use_sample_bpm amen, num_beats: 16
with_sched_ahead_time 1.5 do
  arrange verse, 2, defaults , effects , envelopes , lfos, trancegates, phrasedensities: phrasedensities, notedensities: notedensities, humanizeamt: humanizeamt, currentroot: :c4, currentscale: :minor, synthlayers: [[:bass_foundation, :pluck]]
end
)
    helplist["arrayhashtohasharray"] = %q(
  arrayhashtohasharray
  A utility function that converts a hash of arrays to an array of hashes.
  The array length will be the length of the longest array in the hash,
  and values from shorter arrays will be looped
  (e.g., for a 2-element array, the 3rd element will equal the first element)
  Args:
  arrayhash: the hash of arrays (e.g. { amp: [1, 2, 3], duration: [1, 2]})
  makering: if true, forces the return value to a ring, not an array. Defaults to true.

  )
    helplist["boolish"] = %q(
  boolish 
  a looser version of getting a boolean from a value -- more perlish. 
  args:
  testvalue -- the value to treat as a boolean 
  falsies -- a list of values that evaluate to false. Defaults to [nil, false, 0, "", [], {}]
  )
    helplist["cleanchordorscale"] = %q(
  cleanchordorscale
  turns a chord or scale into a plain array.  
  myitem: item to clean.  
  )
    helplist["clonekeys"] = %q(
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
clonekeys {1 => false, 2=> :foo 5=> :bar}, [1, 2, 3, 4]
returns: {2=> :foo, 3 => :foo, 4=> :foo, 5 => :bar}
clonekeys {1 => false, 2=> :foo}, [1, 2, 3, 4], false
returns: {1=> false, 2=> :foo, 3 => :foo, 4=> :foo, 5=> :bar}
clonekeys {1 => false, 2=> :foo, 5=> :bar}, [[1, 2, 3, 4], [5, 6, 7]]
returns: {2 => :foo, 3=> :foo, 4 => :foo, 5=> :bar, 6=> :bar, 7=> :bar}
)
    helplist["closestnote"] = %q(
closestnote
finds the note closest to the given note in the given scale.  
args:
thisnote: the note to start with.  
thisscale: the scale to search.  
Example code: 
use_random_seed Time.now.to_i
thisnote = rand_i(89) #full piano range
##debugprint "thisnote: ", thisnote
##debugprint "closestnote: ",  closestnote(thisnote, thisscale)
  )
    helplist["convertdrumnotation"] = %q(
convertdrumnotation
converts notation like this "x---x---x---x---" to this: "q,q,q,q"
args:
drumnotation: a string containing the drum notation. 
barlength: the length of the bar, used as the basis for subdivision. Defaults to 4.
baseamp: the default amp: value for each note, unless otherwise overridden. Defaults to 1. 
maxamp: the maximum amp used. Defaults to 2.0. 
restchar: the character used to denote rests. Defaults to "-".
brackets: used to determine how nested expressions are delimited. Defaults to "[]". 
Be sure to use 2 different characters!
Subdivides a bar evenly, so if you supply 6 characters, they will be triplet quarters. 
do not use the following chars in drum notation: "seqhwtd"
It also supports cooking amps like this: "9---5---3---5---" to the corresponding amp argument,  
based on multiplying the maxamp value * the number in the string / 9. This allows you to embed dynamics into drum parts.
I stole this idea from d0lfyn in the sonic pi forum. It's a good idea!
It also supports nested sections, which allows complex tuples and crazy breakbeats.
Each nested section is one chunk long, so nested notes subdivide that chunk. 
This is an idea I stole from Tidal Cycles. 
So x[x[xx]] converts to "h,q,e,e" (assuming barlength of 4). 
Be careful to balance brackets. If they're unbalanced, the result will evaluate to an empty string (to prevent an infinite recursion).
You can also specify multiple comma-delimited bars, e.g.: "x[x[xx]],x--x---x,x[x[xx]],x--x--x-"
if you pass in non-drumnotation (e.g., "dq,dq,q"), it is returned unchanged, with an amplist of all ones
  )
    helplist["cooktime"] = %q(
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
  d: dotted (* 1.5) -- dots stack, so "dd" mutliplies by 2.25
  t: triplet (* 2.0 / 3.0) -- does not stack  
  r: rest
  dots and triplets apply to the entire time, not just to the last letter. 
  int: multiplies total by integer, so 4hq would be (1 + 2) * 4 = 12 beats  
  returns 2 values: a duration (float), and a boolean indicating whether or not it's a rest. 
  )
    helplist["cooktimes"] = %q(
cooktimes 
transform a delimited string of time expressions into an array of numbers 
args:
timestring: the string of times to cook
humanizeamt: the amount to humanize the times. Defaults to 0.0. 
delimiter: what separates items in the list. Defaults to ","
timestring: a delimited string of time expressions (see cooktime for details)
delimiter: defaults to ","
e.g.: 
cooktimes "e,q,e" returns [0.5, 1, 0.5]
  )
    helplist["debugprint"] = %q(
##debugprint
  a utility function to optionally print out debugging messages,
  controlled by the debugmode variable. If not set, defaults to false and prints nothing.
  label: a text string to explain what the value means.
  value: the value being displayed for debugging purposes. If nil, just displays the label.
  expandlist: if either arg is a list or ring, print them individually
  indents: how many levels of recursion, which will print n copies of indenttext
  indenttext: the text to use for nested indentations
  logtofile: set to true if you wish to log to a text file
  filename: the name of the file to log to. Will append if it exists, create it if it does not. 
  )
    helplist["degreestoabsolutenotes"] = %q(
takes an arrangement using degrees instead of absolute notes, and converts them to degrees.  
Used to feed into arrange.  
args:
thisarrangement: arrangement fed into arrange -- see docs for arrange for details
thiskey: the musical key. Defaults to :c4. 
thisscale: the musical scale: defalts to major.
  )
    helplist["divisibleby"] = %q(
  divisibleby
  tests whether the numerator is evenly divisible by the deominator.
  args: numerator, denominator -- both numbers 
  )
    helplist["env"] = %q(
env -- applies an adsr envelope to any slideable param on any synth note or sample.
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
  )
    helplist["equalish"] = %q(
equalish
determines whether two numbers (promoted to floats) are equal within a rounding error.  
value1: first value to compare
value2: second value to compare
roundingerror the rounding error within which it counts as equalish. Defaults to 0.00000001. 
Useful for comparing computed floats.  
  )
    helplist["euclidiate"] = %q(
eucliciate: a utility function wrapping spreadtobeats, bypasses need to create spread.
beats: how many beats to play. 
duration: how many beats in the whole cycle. 
rotations: how many offsets for the euclidean rhythm. 
beatvalue: how big is each beat; defaults to sixteenth (0.25)
notes: the notes/scales/chords/modes to apply to each beat, as per arrange
Example:
euclidiate 3, 8, 2, 0.5 
  )
    helplist["funkyrandom"] = %q(
funkyrandom
randomly generates a funky rhythm, 
returned as a string of notations (bwhqestdr) suitable for feeding into cooknotes or arrange. 
Args:
totaltime: the whole length of the pattern. Defaults to 16 (4 bars). 
shortestbeat: the shortest beat used in the pattern. Defaults to 0.25 (sixteenth). 
shortestbeat must be one of: sixteenth, eighth, quarter, half, whole (0.25, 0.5, 1, 2, 4)
restodds: the odds of a rest, using one_in. Defaults to 8. 
  )
    helplist["funkify"] = %q(
funkify
A method to play a sound in a funky, random manner for a specified period of time.
thissound: a synth or sample. Can also be an array or list of synths or samples.
totaltime: the number of beats for the entire pattern. Defaults to 16 (4 bars).
shortestbeat: the smallest subdivision. Will sleep 1, 2, or 3 times that each time a sound plays.
thesenotes: a list or ring of notes, used with synths only. Defaults to [:c4].
densities: a list or ring of densities, applied per note/sleep.
tickorchoose: tick or choose. Used to define how to traverse densities and thesenotes .
  )
    helplist["genchord"] = %q(
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
  ##debugprint "resetting chord and scale values"
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
    ##| ##debugprint "leadroot: ", leadroot
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
    ##| ##debugprint "bassroot: ", bassroot
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
        ##| ##debugprint "pluckroot: ", pluckroot
        ##| ##debugprint "thispent: ", get[:thispent]
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
        ##| ##debugprint "pianoroot: ", pianoroot
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
)
    helplist["harmonic"] = %q(
harmonic
calculate the midi note corresponding to the harmonic provided. 
args:
thisnote: the midi note with the fundamental
thisharmonic: the harmonic to calculate. Can be fractional!
returns: midi note corresponding to the harmonic. 
example:
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
)
    helplist["humanize"] = %q(
humanize: add some looseness to a beat. 
A wrapper for swing with a swingseed of 8. 
thesebeats: an array of time values defining the beat. 
humanizeamt: the amount of looseness. Defaults to 0.5.  
  )
    helplist["inttoroman"] = %q(
inttoroman   
converts an integer to a roman number string.  
args:  
num: the number to convert   
)
    helplist["killslidingbpm"] = %q(
killslidingbpm 
kills the thread managing the sliding bpm. 
Warning: if it's not called in the thread, it will execute a naked stop, which will kill your playback.  
args: 
killswitch: the name of the flag variable used with set/get to pass the kill message. Defaults to :killslidingbpm.  
)
    helplist["listorring"] = %q(
listorring: wrapper for ringorlist
)
    helplist["lfo"] = %q(
lfo -- provides an all-purpose lfo for any slideable param for any synth note or sample.
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
[0-9]* for how many reps (4w is four whole notes).
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
Can be a pair of values, or a ring/list, or a comma-delimited list.
delay: how long to delay the onset of the lfo
rampupperiod: time to ramp up (will slowly open the envelope)
rampdownperiod: time at the end to ramp down
lfocurve: the curve used for custom curves (see sonic pi docs for details)
examples:
use_bpm 120
use_synth :bass_highend
handle = play 60, sustain: 8, decay: 0,res: 0.7, amp: 0
puts "handle: " + handle.to_s
lfo handle, "amp", 10, "q,q,e,e,e,e", "0,1,0,0.5,0,0.5", "square"
handle = sample :ambi_drone, pitch_stretch: 4
lfo handle, "amp", 4, "e,e,s,s,s,s", "0,1,0,0.5,0,0.5", "square"
  )
    helplist["notetodegree"] = %q(
notetodegre  
converts a midi note to the scale degree in the given scale.  
args:
thisnote: the note to convert to a degree.  
rootnote: the root of the scale; defaults to :c4
thisscale: the name of the scale; defaults to :major  
returns: a scale degree, as symbol (e.g. :ii, :av, :dix), or nil if not found.  
)
    helplist["overridekwargs"] = %q(
overridekwargs
a useful method to help emulate the native ruby ability to specify params by either position or name. 
kwargs: the hash of named params specified by the user.
params: the parameters defined by the calling method. Get via introspection (see example code)
arglistname: the name of the variable holding the list in the first name, defaults to "kwargs".
a useful little method to make user-defined methods act more like native ruby methods,
so you can specify params either by position or by name.
simply add **kwargs as the last param of your method, and put this line of code at the top of the method body:
eval overridekwargs(kwargs, method(__method__).parameters)
See also stripparams, which is useful for stripping out method-related params, 
leaving only params which are suitable to pass to play or sample.   )
  helplist["paddedrowstocolumns"] = %q(
paddedrowstocolumns
pads all arrays to the same length, repeating values in shorter arrays,
then passes the arrays to rowstocolumns. 
*thesearrays: the arrays to pad
  )
    helplist["playdegreematrix"] = %q(
playdegreematrix
plays a melody from degrees of a scale passsed in. 
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
)
    helplist["playline"] = %q(
playline 
Easy-to-use wrapper for arrange, allowing user to play one instrument. 
Supports optional threading, which makes it useful for building a drum part from multiple samples (kick, snare, etc).each
args:
synthorsample: the name of the synth or sample to play. 
notation: the notation for what to play -- either in musical notation ("q :e4, h :b4") or drumntation ("x--x--x-"). 
threaded: boolean, defaults to true.  Wraps in in_thread if set to true.  
kwargs: any other args provided. Will be passed to arrange. See arrange for options. 
Sample code:  
kicklines = ["x--x--x-", "[xx]--x--x-", "dq, dq, te, te, te"]
hatlines = ["xx-xx-xx-xx-x-x-", "x--x--xxx--x--xx", "xx-xxx-xxxx-xxx-"]
snarelines = ["-x", "-x-x", "[[-x][-x]][xxx]"]
16.times do
  playline :bd_ada, kicklines.choose, amp: 3
  playline :hat_gnu, hatlines.choose
  playline :sn_dolf,  snarelines.choose
  sleep 4
end
)
    helplist["portamentomelody"] = %q(
portamentomelody  
play a melody on a synth portamento, by manipulating the pitch over time.  
args: 
thisarrangement: the melody in mini-notation (see arrange for details); e.g.: "qd :c5, qd :ds5, q :g5"
thissynth: the name of the synth to play the note; defaults to :sine.  
note_slide: the portamento time; if set to longer than the shortest note, will be length of shortest note.  
)
    helplist["randomseed"] = %q(
generate a random random seed seed.  Say that three times fast!  
args:
modulo: the number to use in modulo math; defaults to 65536 (64k). 
)
    helplist["ringorlist"] = %q(
ringorlist -- simple utility function to test whether an item is a ring or a list.
arg: thisitem
true if either, false if anything else.
Added a couple of synonyms, listorring and tickable. 
  )
    helplist["romantoint"] = %q(
turns a roman numeral into an integer.  
args: 
thisroman: the roman numeral to change to int; a string. 
returns: an int. If the roman numeral is garbage, returns 0.  
)
    helplist["rowstocolumns"] = %q(
rowstocolumns
takes an array of arrays, and transforms rows to columns. Can take any number of arrays.  
*thesearrays: the arrays to flip
if arrays are of unequal length, values will be filled with nils
if you want to pad the shorter arrays, use paddedrowstocolumns instead
)
    helplist["samplebpm"] = %q(
samplebpm -- utility to return the bpm of any sample loop.
thissample: the sample to extract the bpm from.
beats: the number of beats used to calculate bpm. Defaults to 4
example:
puts samplebpm :loop_amen
puts samplebpm :loop_amen_full, 16
)
    helplist["setarg"] = %q(
setarg 
sets an arg to a val in args.  
Useful for constructing command strings to feed to eval.  
arg: the argument to set. A string.  
val: the value for that arg. A string, or an array (to support tickargs). 
If the intended value is a string, embed quotes, e.g. "'thisstring'",
which results in "thisarg: 'thisstring'"
args: the string or hash containing all the args. 
returns args as a hash.
  )
    helplist["slidebpm"] = %q(
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
)
    helplist["slidemelody"] = %q(
wrapper for portamentomelody
)
    helplist["spreadtobeats"] = %q(
spreadtobeats -- a utility function designed to take a spread, 
and convert it to a string of comma-delimited beat values to feed into arrange.
thisspread: the ring of booleans produced by the spread function, mapping the beats.to_s
beatvalue: duration of each beat, defaults to sixteenth
notes: an array of melodic notes to apply to each beat. 
Must be same length as the number of true values in spread. 
Example:
spreadtobeats spread(3, 8, 2), 0.5 
  )
    helplist["stringtonestedarray"] = %q(
stringtonestedarray  
takes a string with nested delimiters, and transforms it into a nested array.  
Useful for parsing mini-notation,
args:  
thisstring: the string to transform.  
delims: the delimiters, either in a string or array; defaults to ", ". If in a string, each char is a separate delimiter.  
example code:  
stringtonestedarray "qd :c4, qd :ds4, :q :g4"
returns: [["qd", ":c4"], ["qd", ":ds4"], ["qd", ":g4"]]
)
    helplist["stripparams"] = %q(
stripparams
a utility function to delete params from kwargs.
Useful for passing args to nested method calls.
kwargs: a hash of key word args
params: an array/ring of params to strip
sample code:
cleanargs = stripparams kwargs, method(__method__).parameters
  )
    helplist["striptrailingnils"] = %q(
striptrailingnils
strips all trailing nil values in the given array  
thisarray: the array to strip
)
    helplist["strum"] = %q(
strum 
A convenience method wrapping arpeggiate to simplify strumming chords.   
thesenotes: the notes to strum. 
Typically a chord or scale, but could be any ring or array of notes.
strumspeed: how long (in beats) to sleep for all notes except the last one.  
totaltime: how long (in beats) the entire phrase should take. Defaults to 1. 
Used to calculate how long the last note should sleep. Defaults to 0.05. 
  )
    helplist["stuttersample"] = %q(
stuttersample  
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
example:
stuttersample :loop_amen_full, [1, 2, 4, 2, 1, 4, 3, 2], [false, true, false, false, true, false, false, false], [0, 0, 7, 3, 2, 4, 5, 1], 16
  )
    helplist["swing"] = %q(
swing: add swing to a straight beat.  
args:
straightbeats: an array of times to swing 
swingseed: the seed for how to swing it. Defaults to 6, which gives the normal 12/16 type swing. 
Try odd numbers, fractions, for weird lurching swings. 
humanizeamt: how much humanizing to add in. Defaults to 0. 
0.5 is a good value to add a little humanizing you feel but don't hear. 
  )
    helplist["synctoslidingbpm"] = %q(
synctoslidingbpm: syncs current thread to sliding bpm managed by slidebpm. 
args:
cuename: the syncing cue managed by slidebpm, defaults to :bpmsync
setname: the set flag managed by slidebpm, defaults to :slidingbpm. Only syncs when not nil/false. 
)
    helplist["tickable"] = %q(
tickable: wrapper for ringorlist
)
    helplist["tickargs"] = %q(
tickargs
Returns a string of args, with all array values ticked.  
args: a Hash of args, where all items whose values are arrays return ticked values.  
Useful for constructing command strings to feed to eval.  
  )
    helplist["trancegate"] = %q(
trancegate -- a trancegate that manipulates the volume up and down. Defaults to square wave, but you can use other lfo shapes.
note that the trancegate does not work in the release section, so arrange your sounds accordingly.
also, please set your initial amp: setting to match the maxvol param, to avoid glitches.
handle: the node returned by sample or play commands.
duration: how long the effect lasts. Should line up with sustain of played sound.
Please note that the effect does not work on the decay phase.
period: how long the gate lasts. Can be a single value, a ring/list, or a comma-delimited list.
maxvol: the max amplitude when the gate is open. Defaults to 1.
minvol: the min amplitude when the gate is closed. Defaults to 0. 
gutter: how long the silence lasts between chunks. Can be a single value, list/ring or comma-delimited list.
lfotype: defaults to square, but supports all lfotypes.
curve: lfo type curve param. Used for custom lfo types
Examples:
use_bpm 120
use_synth :bass_highend
handle = play 60, sustain: 16, decay: 1,res: 0.7, amp: 0
puts "handle: " + handle.to_s
trancegate handle, 16, euclidiate("s", 16, 5)
handle = sample :ambi_drone, 16
trancegate handle, 16, euclidiate("s", 16, 5)
  )
    helplist["transposesample"] = %q(
transposesample
transposes a sample up or down by specified rpitch, while pitch_stretching to keep tempo.
args:
thissample: the sample to transpose. 
autostretch: whether to apply any pitch_stretch to the sample. Defaults to true. 
It is your responsibility to provide options for pitch_stretch, time_dis, etc. 
You may need to fiddle with time_dis, window_size and pitch_dis to tweak the sound.
example:
mysample = :bass_hit_c
  [0, 3, 7, -2].each do |thispitch|
    use_bpm thisbpm
    handle = transposesample mysample, thispitch, autostretch=false
    sleep 16
  end
  sleep 2
end
Code returns a handle (node) for further manipulation, e.g. lfos, envelopes, trancegates. 
)
  helplist["tremolo"] = %q(
tremolo
quickly oscillate volume up & down
args: 
handle: node controlling the samples/synths; could be a chord node
amp: the base volume of the sound; defaults to 1. 
depth: how much to move the volume up & down; defaults to 0.5
rate: the rate of tremolo, in beats; defaults to sixteenth. 
duration: how long the tremolo lasts; defaults to whole. 
)
  helplist["tuples"] = %q(
tuples  
returns an array of times based on tupling the specified beats .
args: 
howmanytuples: an integer specifying how many tuples you want.  
beatsize: the size of the beats to be tupled. Defaults to quarter (1). 
example code:  tuples(5, half) returns [1.6, 1.6, 1.6, 1.6, 1.6]
  )
  helplist["vibrato"] = %q(
vibrato
quickly oscillate pitch up & down
args: 
handle: node controlling the samples/synths; could be a chord node
depth: how much to move the volume up & down; defaults to 0.5
rate: the rate of tremolo, in beats; defaults to sixteenth. 
duration: how long the tremolo lasts; defaults to whole. 
)
  helplist["yummyhelp"] = %q(
yummyhelp: provide quick docs for yummyfillings.
Without args, it lists every method with args.
Use the method name for detailed help.
  )
    helplist["yh"] = %q(
yh: wrapper for yummyhelp
)
  ##debugprint helplist[helptopic] #return value
end #define yummyhelp


#end of YummyFillings.rb




define  :yh do |helptopic, **kwargs|
  eval overridekwargs(kwargs, method(__method__).parameters) if boolish kwargs
  yummyhelp helptopic, **kwargs
   #return value
end #define yh