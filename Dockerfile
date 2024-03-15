# app/Dockerfile

FROM python:3.10-slim

WORKDIR /app

RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    software-properties-common \
    git \
    && rm -rf /var/lib/apt/lists/*

COPY streamlit_app.py /app/streamlit_app.py
COPY requirements.txt /app/requirements.txt
COPY DataProcessor/ DataProcessor/

RUN pip3 install -r requirements.txt

EXPOSE 8504

# Disable Streamlit's usage stats
RUN mkdir -p /root/.streamlit
RUN echo "\
[browser]\n\
gatherUsageStats = false\n\
" > /root/.streamlit/config.toml

HEALTHCHECK CMD curl --fail http://localhost:8501/_stcore/health

ENTRYPOINT ["streamlit", "run", "streamlit_app.py", "--server.port=8501", "--server.address=0.0.0.0"]