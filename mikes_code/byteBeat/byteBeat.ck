int tick;

Impulse s => dac;

while (true){
    tick => int t;
    
    //your expression here
    t|(((t>>19)|(t>>4))|(123&(t>>1))) => t;
    
    t&255 => t;
    if (t > 127) t - 256 => t;
    
    t/128.0 => float f;
    f => s.next;
    
    samp => now;
    tick++;
}