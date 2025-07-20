function extract-audio () {
    basename=$1:t:r
    audio_type=$(ffmpeg -i $1 2>&1 | grep Audio | awk '{print $4}' | sed 's/,//' ;)
    ffmpeg -i $1 -vn -acodec copy $basename.$audio_type ;
}
