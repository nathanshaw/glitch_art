console.log('Image Bot Starting')
// an import statement in node
var Twit = require('twit');
var config = require('./config.js');
var T = new Twit(config)
var exec = require('child_process').exec;
var fs = require('fs')

function tweetIt() {
    console.log('Tweeting it')
    var command = 'processing-java --sketch=`pwd`/image_host --run'
    exec(command, processing);
    function processing() {
        var filename = 'image_host/output.png'
        var params = {
            encoding: 'base64'
        }
        var content = fs.readFileSync(filename, params)
        // just uploads does not tweet
        T.post('media/upload',{media_data:content}, uploaded)
        function uploaded(err, data, response) {
            // where the tweet actually happens
            var id = data.media_id_string;
            var tweet = {
                status: '#CTSB',
                media_ids: [id]
            }
            T.post('statuses/update', tweet, tweeted);
        }
        function tweeted(err, data, response) {
            if (err) {
                console.log("Something went wrong");
            }else{
                console.log("It worked!");
            }
        }
        console.log("finished")
    }
    console.log('finished tweeting it')
}

tweetIt();
