function NowPlayingScreen() as Object
    audio = AudioPlayer()
    return TrackScreen(audio.correctIndex(), audio.getTracks())
end function