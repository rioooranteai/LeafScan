import os

from openai import OpenAI
from dotenv import load_dotenv

load_dotenv()

GPT_TOKEN = os.getenv("GPT_API_KEY")

client = OpenAI()

prompt_llm = """
Daun jagung terdeteksi memiliki penyakit {}. Tugas anda adalah membuat {} untuk konteks penyakit ini. 
Maksimal teks yang anda buat adalam 2 paragraf dan setiap paragraf berisi maksimal 5 kalimat.

"""


def create_text(penyakit, section):
    prompt = prompt_llm.format(penyakit, section)

    completion = client.chat.completions.create(
        model="gpt-3.5",
        messages=[
            {"role": "system", "content": "Kamu adalah seorang ahli dalam botani khususnya seorang ."},
            {
                "role": "user",
                "content": prompt
            }
        ],
        max_tokens=154,
    )

    response_text = completion['choices'][0]['message']['content']
    return response_text
