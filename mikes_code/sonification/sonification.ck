//sonification.ck by mike leisz
//requires imagemagick (https://www.imagemagick.org/script/index.php)
//you can install easily via homebrew (https://brew.sh/)

//must call from command line like so:
//chuck sonification.ck:imagewidth:imageheight --caution-to-the-wind --silent
//should probably also make input image an argument... :/

WvIn in;
WvOut out;
Bitcrusher bitcrush;
HPF hpf;

"data/cat" => string file;
file + ".raw" => string raw;
file + ".jpg" => string jpg;
file + ".raw" => string input;
"data/output.jpg" => string output;

string cmd;

Std.atoi(me.arg(0)) => int width;
Std.atoi(me.arg(1)) => int height;
width * height => int res;
res * .000034 => float secs;
secs::second => dur limit;

"convert " + jpg + " -depth 8 -size "+width+"x"+height+" rgb:" + raw @=> cmd; //convert jpg to raw
Std.system(cmd); //run command

in => bitcrush => hpf => out => dac;

in.path(me.dir() + input);
1.0 => in.rate;

out.rawFilename(me.dir() + file);

Math.random2(1, 16) => bitcrush.bits;
Math.random2(1, 100) => bitcrush.downsampleFactor;
<<<"bitcrusher:", "bits -", bitcrush.bits(), "downsample -", bitcrush.downsampleFactor()>>>;

Math.random2f(1.0, 10000.0) => hpf.freq;
Math.random2f(0.01, 2.0) => hpf.Q;
<<<"hpf:", "freq -", hpf.freq(), "q -", hpf.Q()>>>;

limit => now;

out.closeFile();

//convert raw to jpg
"convert -depth 8 -interlace none -size "+width+"x"+height+" rgb:" + raw + " " + output @=> cmd;
<<< cmd, "" >>>; // print command
Std.system(cmd); // run command

// delete local raw file
"rm " + raw @=> cmd;
<<< cmd, "" >>>; // print command
Std.system(cmd); // run command