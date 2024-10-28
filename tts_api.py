from flask import Flask, request, send_file, jsonify
import subprocess
import os
import uuid

app = Flask(__name__)

# Function to generate TTS audio
def generate_tts_audio(text, output_file):
    command = ["python", "synthesize.py", "--text", text, "--output", output_file]
    subprocess.run(command)

# Define the API endpoint
@app.route('/synthesize', methods=['POST'])
def synthesize():
    data = request.json
    text = data.get("text", "")

    if not text:
        return jsonify({"error": "No text provided"}), 400

    output_file = f"{uuid.uuid4()}.wav"
    generate_tts_audio(text, output_file)
    return send_file(output_file, mimetype="audio/wav", as_attachment=True)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
