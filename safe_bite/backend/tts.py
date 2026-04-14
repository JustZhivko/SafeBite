from gtts import gTTS
from flask import jsonify
import subprocess

def tts(text_response):
    filename = "response.mp3"
    output_file = "output_8bit_mono.wav"

    tts = gTTS(text=text_response, lang="bg")
    tts.save(filename)

    command = [
        "ffmpeg",
        "-y",
        "-i", filename,
        "-ac", "1",
        "-ar", "16000",
        "-acodec", "pcm_u8",
        output_file
    ]

    try:
        subprocess.run(command, check=True)
    except subprocess.CalledProcessError as e:
        return jsonify({"error": str(e)}), 500

    print(f"Converted file saved: {output_file}")

    return jsonify({
        "text": text_response,
        "audio_file": output_file
    })